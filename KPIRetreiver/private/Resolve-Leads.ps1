function Resolve-Leads {
  <#
  .SYNOPSIS
    Script model

  .NOTES
    Name: Resolve-Leads
    Author: JL
    Version: 1.0
    LastUpdated: 2022-May-24

  .EXAMPLE

  #>

  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [object[]]  $Extracts
  )

  BEGIN {
    [array]$adRetreiverLeads = Import-Json "$confPath\leads.conf.json"
    if ($adRetreiverLeads) { Write-Host "Leads configuration...OK !`n" -f Green } else { throw "Invalid leads configuration !" }
  }

  PROCESS {
    # Check if extract is provided
    if ($Extracts) {
      Write-Host "Extract provided. Checking validity..."

      # Check extract validity by comparing leads used in kpi configuration and leads provided in the extract
      $usedLeads = $kpis.leads.name | select-object -unique
      $checkLeads = $true; foreach ($l in $usedLeads) { if ($Extracts.name -notcontains $l) { $checkLeads = $false } }

      if ($checkLeads) { $adRetreiver = $Extracts } 
      else { throw "Extract does not match kpi configuration! Check the leads used by each kpi" }

    }
    else {
      Write-Host "No extract provided"

      # Check if all leads have a name
      $hasNames = $adRetreiverLeads.name.length -eq $adRetreiverLeads.length
      if (!$hasNames) { throw "Each lead must have a name !" }

      Write-Host "We have to explore $($adRetreiverLeads.length) leads... I need the help of my faithful companion !" -f Cyan
      Write-Host "`n<Snif> <Snif>...`n"

      # Calling ADRetreiver with the leads specified in configuration
      $adRetreiver = Invoke-ADRetreiver -Leads $adRetreiverLeads -Timeout 1500 -MinBanner

      # Check if there is a result and if so : showing a short report
      if ($adRetreiver) {
        Write-Host "`nLet's see what my friend have found..." -f Cyan

        foreach ($l in $adRetreiver) { Write-Host "$($l.name): $($l.result.length) elements" }
      }
      else { throw "Something went with ADRetreiver !" }
    }
  }

  END { return $adRetreiver }
}