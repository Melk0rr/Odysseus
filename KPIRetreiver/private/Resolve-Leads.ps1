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
    [object[]]  $Extracts,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [switch]  $TestMode
  )

  BEGIN {

    $leadConf = Get-Item -Path "$confPath\leads.conf.ps1"
    # Sourcing leads configuration file
    try {
      . $leadConf.FullName
    }
    catch {
      Write-Error -Message "Failed to import configuration file $($_.FullName): $_"
    }

    if ($adRetreiverLeads) {
      Write-Host "Leads configuration...OK !`n" -f Green
    }
    else {
      throw "Invalid leads configuration !"
    }
  }

  PROCESS {
    # Check if extract is provided
    if ($Extracts) {
      Write-Host "Extract provided. Checking validity..."

      # Check extract validity by comparing leads used in kpi configuration and leads provided in the extract
      $usedLeads = $kpis.leads.name | select-object -unique
      $checkLeads = $true

      if (!$TestMode.IsPresent) {
        foreach ($l in $usedLeads) {
          if ($Extracts.name -notcontains $l) {
            $checkLeads = $false
          }
        }
      }

      if ($checkLeads) {
        $adRetreiver = $Extracts
      } 
      else {
        throw "Extract does not match kpi configuration! Check the leads used by each kpi"
      }
    }
    else {
      Write-Host "No extract provided"

      # Check if all leads have a name
      [bool]$hasNames = ($adRetreiverLeads.name.count -eq $adRetreiverLeads.count)
      if (!$hasNames) {
        throw "Each lead must have a name !"
      }

      Write-Host "We have to explore $($adRetreiverLeads.count) leads in $($Server.count) domains... I need the help of my faithful companion !" -f Cyan
      Write-Host "`n<Snif> <Snif>...`n"

      # Calling ADRetreiver with the leads specified in configuration
      $credsParams = @{}
      if ($Credential) {
        $credsParams.Credential = $Credential
      }
      $adRetreiver = Invoke-ADRetreiver -Leads $adRetreiverLeads -Server $Server -MinBanner @credsParams

      # Check if there is a result and if so : showing a short report
      if ($adRetreiver) {
        Write-Host "`nLet's see what my friend have found..." -f Cyan

        foreach ($l in $adRetreiver) {
          Write-Host "$($l.name): $($l.result.count) elements"
        }
      }
      else {
        throw "Something went wrong with ADRetreiver !"
      }
    }
  }

  END { return $adRetreiver }
}