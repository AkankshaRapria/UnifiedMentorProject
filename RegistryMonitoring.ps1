$LogFile = "C:\Registry_Detailed_Log.csv"
# Create log file with header if not exists
if (!(Test-Path $LogFile)) {
    "Timestamp,ValueName,OldValue,NewValue" | Out-File $LogFile
}
$RegPath = "HKCU:\Control Panel\Desktop"
# Screen saver related keys
$TargetKeys = @(
    "SCRNSAVE.EXE",
    "ScreenSaveActive",
    "ScreenSaveTimeOut",
    "ScreenSaverIsSecure"
)
# Function to safely get values (handles missing keys)
function Get-RegValues {
    param ($path, $keys)
    $result = @{}
    $item = Get-ItemProperty -Path $path -ErrorAction SilentlyContinue
    foreach ($key in $keys) {
        if ($item.PSObject.Properties.Name -contains $key) {
            $result[$key] = $item.$key
        } else {
            $result[$key] = "NULL"
        }
    }
    return $result
}


# Initial baseline
$baseline = Get-RegValues -path $RegPath -keys $TargetKeys
while ($true) {
    Start-Sleep -Seconds 5
    $current = Get-RegValues -path $RegPath -keys $TargetKeys
    foreach ($key in $TargetKeys) {
        $oldValue = $baseline[$key]
        $newValue = $current[$key]
        if ($oldValue -ne $newValue) {
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $log = "$timestamp,$key,$oldValue,$newValue"
            Add-Content $LogFile $log
            Write-Host "Changed: $key → $oldValue → $newValue"
        }
    }
    $baseline = $current
}
