function Ppm {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (        
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet('new', 'get')]
        [Alias('A')]
        [string]
        $Action
    )
    dynamicparam {
        
        $ParamUser = New-Object -TypeName System.Management.Automation.ParameterAttribute
        $ParamUser.Position = 1
        $ParamUser.Mandatory = $false            
        $ParamUser.HelpMessage = "Entrez un nom d'utilisateur"

        $ParamUserColec = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute]
                       
        $ParamUserColec.Add($ParamUser)
            
        $SPParamUser = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList ('Profil', [string], $ParamUserColec)

        $ParamPassword = New-Object -TypeName System.Management.Automation.ParameterAttribute
        $ParamPassword.Position = 2
        $ParamPassword.Mandatory = $false            
        $ParamPassword.HelpMessage = "Entrez un mot de passe"

        $ParamPasswordColec = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute]
                       
        $ParamPasswordColec.Add($ParamPassword)
            
        $SPParamPassword = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList ('Password', [string], $ParamPasswordColec)

        $SPParamDictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
        $SPParamDictionary.Add('Profil', $SPParamUser)
        $SPParamDictionary.Add('Password', $SPParamPassword)

        return $SPParamDictionary

    }
    begin {
        $InstallPath = Join-Path $env:LOCALAPPDATA "Hitea\Ppm"
        if ((!(Test-Path("$($InstallPath)/Installed.txt")))) {
            ForEach ($Folder in @('Profil', 'Config')) {
                New-Item -Path (Join-Path $InstallPath $Folder) -ItemType Directory | Out-Null
            } 
            Get-Date | Out-File -Encoding UTF8 -FilePath "$($InstallPath)/Installed.txt"
        }
        if (!(Test-Path("$($Path)/Config/Ppm.key"))) {
            Set-PsctCryptKey -KeyPath (Join-Path $InstallPath "Config\Ppm.key")
        }
        if ($PSBoundParameters['Profil']) {
            $User = $PSBoundParameters['Profil']
            if ($PSBoundParameters['Password'] -and ($Action -eq "new")) {
                $Password = ConvertTo-SecureString $PSBoundParameters['Password'] -AsPlainText -Force
                $Interact = $false
            }
            elseif (!($PSBoundParameters['Password']) -and ($Action -eq "get")) {
                $Interact = $false
            }
            else {
                $Interact = $true
            }
        }
        else {
            $Interact = $true
        }
    }
    process {
        switch ($Action.ToLowerInvariant()) {
            'new' {
                if (($Interact = $true)) {
                    if (!($User)) {
                        $User = Read-Host "Enter Name: "
                    }
                    if (!($Password)) {
                        $Password = Read-Host -AsSecureString "Enter Password: "
                    }
                }
                $HtCred = New-Object -TypeName psobject
                $HtCred | Add-Member -MemberType NoteProperty -Name Name -Value $User
                $HtCred | Add-Member -MemberType NoteProperty -Name Username -Value $User
                $Pass = $Password | ConvertFrom-SecureString -key (Get-Content (Join-Path $InstallPath ( "/Config/Ppm.key")))
                $HtCred | Add-Member -MemberType NoteProperty -Name Password -Value $Pass

                Save-PsctProfile -Profil $HtCred
                Show-PsctNotification -Type "Info" -Title "Profil sauvegardé" -Text "les profil $($User) est sauvegardé"
            }
            'get' {
                if (($Interact -eq $true)) {
                    $Profils = Get-PsctCompanies
                    $Profils | Select-Object -Property Id, Name | Format-Table
                    $Id = Read-Host "Id du profil: "
                    foreach ($Profil in $Profils) { 
                        if ($Profil.id -eq $Id) {
                            $User = $Profil.Name
                        }
                    }
                    if (!($User)) {
                        Write-Host "ID invalide"
                        Return
                    }
                    Return Get-PsctCredential $User -InClear $true
                }
                if (Test-CompnaieName $User) {
                    Return Get-PsctCredential $User
                }
                else {
                    Write-Host "Profil non trouvé"
                }
            }
        }
    }
}