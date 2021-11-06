function Get-HtValidateString {
    
    [OutputType([bool], [PSCredential])]
    [CmdletBinding()]
    param (
        [uint16]$MaxTry = 3,
        [Parameter(Mandatory = $true)]
        [ValidateSet('Email', 'String')]
        [ValidateNotNullOrEmpty()]
        $Type,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        $HelpMessage
    )

    switch ($Type) {
        "Email" { 
            $Regex = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
        }
        "String" { 
            $Regex = "^[a-z]{2,}\d*$"
        }
        "Int" {
            $Regex = "[0-9]"
        }
        Default { return $false }
    }
    try {

        $Counter = 1
        do {
            if ($HelpMessage) {
                $UserPrincipalName = Read-Host "$($HelpMessage) [$($Type)]: "
            }
            else {
                $UserPrincipalName = Read-Host "Enter a $($Type): "
            }
        
            
            if ($UserPrincipalName -match $Regex) {
                
                Write-Verbose -Message "$($Type) match the regex."
                $UserPrincipalName
                break
            }
            if ($Counter -lt $MaxTry) {
        
                Write-Warning -Message "$($Type) does not match a valid input, please provide a corrent $($Type)."
                Write-Warning -Message ("Try {0} of {1}" -f ($Counter + 1), $MaxTry)
            }
            elseif ($Counter -ge $MaxTry) {
                
                Write-Error -Message "$($Type) does not match the regex" -Exception "System.Management.Automation.SetValueException" -Category InvalidResult -ErrorAction Stop
                return $false
            }

            $Counter++
        }
        while ($UserPrincipalName -notmatch $Regex)
    }
    catch {
        Write-Verbose -Message ("Problem with $($Type) - {0}" -f $_.Exception.Message)
        return $false
    }
}
