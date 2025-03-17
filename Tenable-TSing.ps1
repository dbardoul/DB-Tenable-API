#Begin Function file explorer pop-up selection
Function Get-OpenFile($initialDirectory) { 
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
     Out-Null

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "Text files (*.txt)|*.txt|CSV files (*.csv)|*.csv"
    $OpenFileDialog.title = "### Please select text or csv file with list of hostnames ###"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
    $OpenFileDialog.ShowHelp = $true
    }
#End Funtion file explorer pop-up selection

$InputFile = Get-OpenFile
$computers = Get-Content $InputFile

$outarray = @()
$count = $computers.count
$i = 1

ForEach ($c in $computers) {

    Write-Progress -PercentComplete (($i / $count) * 100) -Status "Processing Items" -Activity "Item $i of $count"
    $anon = net use \\$c\ipc$ 2>&1
    net use \\$c\ipc$ /delete
    $ipc = net use \\$c\ipc$ /user:"<redacted>" "<redacted>" 2>&1
    net use \\$c\ipc$ /delete
    $admin = net use \\$c\admin$ /user:"<redacted>" "<redacted>" 2>&1
    net use \\$c\admin$ /delete
    $reg = reg query \\$c\hklm 2>&1
    $nslookup = nslookup $c 2>&1
    $ping = Test-Connection $c -Count 1 2>&1

    $outarray += New-Object PsObject -property @{
        
        'Hostname' = $c
        'Anonymous IPC$ login test' = [string]$anon
        'SMB Log on Test ipc' = [string]$ipc
        'SMB Log on Test admin' = [string]$admin
        'Remote Registry Test' = [string]$reg
        'Nslookup' = [string]$nslookup
        'Ping' = [string]$ping
        }
    $i++
}
    
$outarray | Export-Csv -Path "C:\Users\<redacted>\Documents\<redacted>_troubleshooting.csv" -NoTypeInformation