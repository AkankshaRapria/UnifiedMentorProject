# USB Monitoring Script
# Author: Internship Project
# Description: Monitors USB device connection and logs activity

$LogFile = "C:\USB_Monitoring_Report.csv"

# Create CSV file if not exists
if (!(Test-Path $LogFile)) {
    "Timestamp,DeviceName,DeviceID,Action" | Out-File $LogFile
}

Register-WmiEvent -Class Win32_DeviceChangeEvent -SourceIdentifier USBMonitor -Action {

    $devices = Get-WmiObject Win32_PnPEntity | Where-Object {
        $_.PNPDeviceID -match "USB"
    }

    foreach ($device in $devices) {

        $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $name = $device.Name
        $id = $device.PNPDeviceID

        $entry = "$time,$name,$id,Connected"

        Add-Content -Path "C:\USB_Monitoring_Report.csv" -Value $entry
    }

}
Write-Host "USB Monitoring Started..."