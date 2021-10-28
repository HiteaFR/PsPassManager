$BaseFolder = Split-Path -Parent -Path $MyInvocation.MyCommand.Path

Get-ChildItem "$($BaseFolder)/Private/*.ps1" | Resolve-Path | ForEach-Object { . $_ }

Get-ChildItem "$($BaseFolder)/Public/*.ps1" | Resolve-Path | ForEach-Object { . $_ }
