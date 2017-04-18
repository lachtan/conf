# user profile

function dirs()
{
	Get-Location -Stack
}

function nslook
{
    param
    (
        [Parameter(
            Position = 0, 
            Mandatory = $true, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)
        ]
        [Alias('Host')]
        [String[]] $hostNames
    ) 

    process
    {
        foreach($hostName in $hostNames)
        {
            $addr = [System.Net.Dns]::GetHostByName($hostName)
            $addr.HostName
        }
    }
}

function nslook-old([string] $alias)
{
	$addr = [System.Net.Dns]::GetHostByName($alias)
	$addr.HostName
}

function cred([string] $userName)
{
	$password = Read-Host "Enter the password" -AsSecureString
	return New-Object System.Management.Automation.PSCredential $userName,$password 
}

filter head([int] $count = 10)
{
    if ($counter -lt $count)
    {
        $counter++
        $_
    }
}

function find($path, $filter)
{
    ls -Path $path -Filter $filter -Recurse
}

filter FullName()
{
    $_.FullName
}

function Get-WorkDays([DateTime] $fromDate, [DateTime] $toDate)
{
    for ($currentDay = (Get-Date $fromDate).Date; $currentDay -le (Get-date $toDate).Date; $currentDay = $currentDay.AddDays(1))
    {
        if ($currentDay.DayOfWeek -ne [System.DayOfWeek]::Saturday -and $currentDay.DayOfWeek -ne [System.DayOfWeek]::Sunday)
        {
            $currentDay
        }
    }
}

function Get-Env($name)
{
    (ls env:$name).Value
}

function Check-Command($cmdName)
{
    return [bool](Get-Command -Name $cmdName -ErrorAction SilentlyContinue)
}

function Get-UpTime()
{
    $operatingSystem = Get-WmiObject Win32_OperatingSystem                
    $lastBootUpTime = [Management.ManagementDateTimeConverter]::ToDateTime($operatingSystem.LastBootUpTime)
    $upTime = (Get-Date) - $lastBootUpTime
    return @{'Uptime' = $upTime; 'LastBootUpTime' = $lastBootUpTime}
}

function ToHash([ScriptBlock] $scriptBlock)
{
    # example
    # ps | ToHash { $_.Id, $_.Name }

    BEGIN
    {
        $hash = @{}
    }
    
    PROCESS
    {
        $keyValue = &$ScriptBlock $_
        $key = $keyValue[0]
        $value = $keyValue[1]
        $hash[$key] = $value
    }
    
    END
    {
        $hash
    }
}

Set-Alias grep C:\cygwin64\bin\grep
Set-Alias less C:\cygwin64\bin\less
Set-Alias awk C:\cygwin64\bin\awk
Set-Alias more less
Set-Alias wc C:\cygwin64\bin\wc
Set-Alias exec Invoke-Expression
Set-Alias which Get-Command
Set-Alias uniq Get-Unique
Set-Alias csi "C:\Program Files (x86)\MSBuild\14.0\Bin\csi.exe"

# PSReadline
Set-PSReadlineOption -EditMode Emacs -HistoryNoDuplicates -HistorySaveStyle SaveAtExit
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile))
{
    Import-Module "$ChocolateyProfile"
}
