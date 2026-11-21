
$ErrorActionPreference = "Stop"

$sdk = if ($env:ANDROID_HOME) {
    $env:ANDROID_HOME
} elseif ($env:ANDROID_SDK_ROOT) {
    $env:ANDROID_SDK_ROOT
} else {
    "D:\Android\SDK"
}

$adb = Join-Path $sdk "platform-tools\adb.exe"
$emulator = Join-Path $sdk "emulator\emulator.exe"
$avd = "Pixel_5"

if (!(Test-Path $adb) -or !(Test-Path $emulator)) {
    throw "No se encontro Android SDK en $sdk"
}

function Get-Pixel5Serial {
    $lines = & $adb devices

    foreach ($line in $lines) {
        if ($line -match '^(emulator-\d+)\s+device') {
            $serial = $Matches[1]
            $name = & $adb -s $serial emu avd name 2>$null

            if (($name -join "`n") -match '(?m)^Pixel_5\s*$') {
                return $serial
            }
        }
    }

    return $null
}

$serial = Get-Pixel5Serial

if (-not $serial) {
    Write-Host "Iniciando Pixel 5..."
    Start-Process -FilePath $emulator -ArgumentList @(
        "-avd", $avd
    )
}

$ready = $false

for ($i = 0; $i -lt 120; $i++) {
    $serial = Get-Pixel5Serial

    if ($serial) {
        $boot = & $adb -s $serial shell getprop sys.boot_completed 2>$null

        if (($boot -join "").Trim() -eq "1") {
            $ready = $true
            break
        }
    }

    Start-Sleep -Seconds 2
}

if (-not $ready) {
    throw "Pixel 5 no inicio correctamente en 240 segundos."
}

# Mover la ventana a una posicion visible
try {
    if (-not ("PixelWindow" -as [type])) {
        Add-Type @'
using System;
using System.Runtime.InteropServices;

public class PixelWindow {
    [DllImport("user32.dll")]
    public static extern bool SetWindowPos(
        IntPtr hWnd, IntPtr after,
        int x, int y, int width, int height, uint flags);
}
'@
    }

    $window = Get-Process qemu-system-x86_64 -ErrorAction SilentlyContinue |
        Where-Object {
            $_.MainWindowHandle -ne 0 -and
            $_.MainWindowTitle -like "*Pixel_5*"
        } |
        Select-Object -First 1

    if ($window) {
        [PixelWindow]::SetWindowPos(
            $window.MainWindowHandle,
            [IntPtr]::Zero,
            80, 120, 0, 0, 5
        ) | Out-Null
    }
} catch {
    Write-Host "No se pudo ajustar la ventana; continuando..."
}

Write-Host "Pixel 5 listo: $serial"
exit 0
