<#
Written for PowerShell 5.1 compatibility, where there's no native get-uptime cmdlet
#>

function Get-ComputerUptime {
  [cmdletbinding()]
  param (
    [alias('name')]
    [Parameter(
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [string[]]$computername = 'localhost',
    [pscredential]$credential
  )

  BEGIN {
    if (-not $credential) {
      $credential = Get-Credential
    }
  }

  PROCESS {

    try {
      invoke-command -computername $computername -credential $credential -scriptblock {
        $os = get-ciminstance win32_operatingsystem
        $uptime = (get-date) - (get-date $os.lastbootuptime)
        [pscustomobject]@{
          ComputerName = $env:computername
          OS           = $os.caption
          Uptime       = "$($uptime.days) Days, $($uptime.Hours) Hours, $($uptime.Minutes) Minutes"
        }
      } -ErrorAction stop

    }
    catch {
      Write-Error "Error occurred from $computername : $($_.Exception.Message)"
    }

  } # PROCESS

  END {}

} # function
