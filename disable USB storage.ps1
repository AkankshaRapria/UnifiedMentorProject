# Disable USB Storage

Set-ItemProperty `
Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" `
Name "Start" `
Value 4

Write-Host "USB Storage Disabled. Restart system."