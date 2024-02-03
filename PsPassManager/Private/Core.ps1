function Import-PsctProfile() {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    Param(
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [string]$ProfilePath
    )

    if (Test-Path $ProfilePath -ErrorAction SilentlyContinue) {
        $Configuration = (Get-Content $ProfilePath | Out-String | ConvertFrom-Json)
    }
    else {
        Read-Host "Profile error, exit..."
        exit
    }
    $Configuration | Add-Member Filename $ProfilePath
    return $Configuration
}

function Save-PsctProfile() {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    Param(
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        $Profil
    )
    $Path = Join-Path $env:LOCALAPPDATA ( "Hitea\Ppm\profil\" + $Profil.Name + ".json")
    $Excluded = @('Filename')
    $Profil | Select-Object -Property * -ExcludeProperty $Excluded | ConvertTo-Json | Set-Content -Encoding UTF8 -Path $Path
    Write-Verbose -Message "Config file saved !"
}

function Show-PsctNotification {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    Param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Info", "Warning", "Error", "None")]
        [string]$Type,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Title,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Text,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]$Timeout = 10
    )      
            
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $notify = new-object system.windows.forms.notifyicon
    if($PSVersionTable.PSVersion.Major -eq 5) {
        $notify.icon = [system.drawing.icon]::ExtractAssociatedIcon((join-path $pshome powershell.exe))
    }
    elseif($PSVersionTable.PSVersion.Major -eq 7) {
        $notify.icon = [system.drawing.icon]::ExtractAssociatedIcon((join-path $pshome pwsh.exe))
    }

    $notify.visible = $True

    $notify.showballoontip($Timeout, $title, $text, $type)

    switch ($Host.Runspace.ApartmentState) {
        STA {
            $null = Register-ObjectEvent -InputObject $notify -EventName BalloonTipClosed -Action {
                $Sender.Dispose()
                Unregister-Event $EventSubscriber.SourceIdentifier
                Remove-Job $EventSubscriber.Action
            }
        }
        default {
            continue
        }
    }

}