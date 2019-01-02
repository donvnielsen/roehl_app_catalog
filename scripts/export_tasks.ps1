$LogFile = "c:\users\niedo\documents\services_and_tasks\ExportScheduledTasks.log"
$BackupPath = "c:\users\niedo\documents\services_and_tasks\tasks"
$TaskFolders = (Get-ScheduledTask).TaskPath `
    | Where { ($_ -notmatch "Microsoft") -and ($_ -notmatch "OfficeSoftware") } `
    | Select -Unique

Start-Transcript -Path $LogFile
Write-Output "Start exporting of scheduled tasks"

If(Test-Path -Path $BackupPath)
{
    Remove-Item -Path $BackupPath -Recurse -Force
}
mkdir $BackupPath <# | Out-Null #>

Foreach ($TaskFolder in $TaskFolders)
{
    Write-Output "Task folder: $TaskFolder"
    If($TaskFolder -ne "\") { mkdir $BackupPath$TaskFolder | Out-Null }
    $Tasks = Get-ScheduledTask -TaskPath $TaskFolder -ErrorAction SilentlyContinue
    Foreach ($Task in $Tasks)
    {
        $TaskName = $Task.TaskName
        $TaskInfo = Export-ScheduledTask -TaskName $TaskName -TaskPath $TaskFolder
        $TaskInfo | Out-File "$BackupPath$TaskFolder$TaskName.xml"
        Write-Output "Saved file $BackupPath$TaskFolder$TaskName.xml"
    }
    break
}

Write-Output "Exporting of scheduled tasks finished."
Stop-Transcript
