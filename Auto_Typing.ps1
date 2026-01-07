Add-Type -AssemblyName System.Windows.Forms

while ($true) {
    # Send a harmless keystroke (Shift) to keep session active
    $now = (Get-Date).ToString("HH:mm:ss")
    [System.Windows.Forms.SendKeys]::SendWait("$now")  

    # Wait 10 seconds before repeating
    Start-Sleep -Seconds 5
}
