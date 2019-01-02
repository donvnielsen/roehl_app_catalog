$LogFile = "c:\users\niedo\documents\services_and_tasks\ExportServices.log"
$BackupPath = "c:\users\niedo\documents\services_and_tasks\services"

Start-Transcript -Path $LogFile
Write-Output "Start exporting of services"

If(Test-Path -Path $BackupPath)
{
    Remove-Item -Path $BackupPath -Recurse -Force
}
md $BackupPath <# | Out-Null #>

$Services = (Get-Service).Name | Select -Unique
Foreach ($Service in $Services)
{
    $export_fname = "$BackupPath\$Service.xml"
    $Wmi = Get-WmiObject win32_service | ?{$_.Name -eq $Service} | Export-Clixml -Path $export_fname
    Write-Output "Saved file $export_fname"
}

Write-Output "Exporting of services finished."
Stop-Transcript
