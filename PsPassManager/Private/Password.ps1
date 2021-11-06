function Set-PsctCryptKey {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $KeyPath
    )

    $Key = New-Object Byte[] 32
    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
    $Key | out-file $KeyPath
    
    return $KeyPath
}

function Get-PsctCredential {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $User,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        $InClear = $false
    )

    if (!(Join-Path $env:LOCALAPPDATA ( "Hitea\Ppm\Profil\" + $User + ".json"))) {
        return $false
    }
    else {
        $PsctCred = (Get-Content (Join-Path $env:LOCALAPPDATA ( "Hitea\Ppm\Profil\" + $User + ".json")) | Out-String | ConvertFrom-Json)
        $Password = $PsctCred.("password") | ConvertTo-SecureString -Key (Get-Content (Join-Path $env:LOCALAPPDATA ( "Hitea\Ppm\Config\Ppm.key")))
        if ($InClear -eq $true) {
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
            $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
            $Credential = New-Object -TypeName psobject
            $Credential | Add-Member -MemberType NoteProperty -Name Username -Value $PsctCred.Username
            $Credential | Add-Member -MemberType NoteProperty -Name Password -Value $Password
        }
        else {
            $Credential = New-Object System.Management.Automation.PsCredential($PsctCred.Username, $Password)
        }
        return $Credential
    }
}

function Get-PsctCompanies {
    
    $PsctProfils = Get-ChildItem -Path (Join-Path $env:LOCALAPPDATA ("Hitea\Ppm\Profil\*.json"))
    $Profils = @()
    $Num = 0

    foreach ($item in $PsctProfils) {
        $Num = $Num + 1
        $Config = Import-PsctProfile -ProfilePath $item
        $Config | Add-Member Id $Num
        $Profils += $Config
    }

    Return $Profils
}

function Test-CompnaieName {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )
    
    $Result = $false

    $Companies = Get-PsctCompanies
    foreach ($Companie in $Companies) {
        if ($Companie.Name -like $Name) {
            $Result = $true
        }
    }

    Return $Result
}