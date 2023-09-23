function Format-KPI {
  <#
  .SYNOPSIS
    This script formats a kpi based on its configuration

  .NOTES
    Name: Format-KPI
    Author: JL
    Version: 1.0
    LastUpdated: 2022-May-23

  .EXAMPLE

  #>

  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [object]  $KPI
  )

  BEGIN {
    $kpiName = $kpi.name
    Write-Host "`nProcessing $kpiName data..."
  }

  PROCESS {
    # Get ADRetreiver results relative to the current KPI
    [object[]]$leads = $adRetreiver | foreach-object {
      if ($kpi.leads.name.Contains($_.Name)) {
        $_
      }
    }

    Write-Host "$kpiName is based on $($leads.count) ADRetreiver lead(s) and $($soups.count) soup(s)"

    # Handle preprocessing
    $leads = Initialize-KPIPreprocessing -KPI $kpi

    # Initialize custom kpi variables
    if ($kpi.kpivariables) {
      Write-Host "Setting up variables for the KPI..."
      . $kpi.kpivariables
    }

    # Post processing : first defined lead is considered as base for final result
    [pscustomobject]$mainLead = $leads.Where({ $_.name -eq "$($kpi.leads[0].name)" })[0]
    $finalRes = Initialize-KPIPostprocessing -Base $mainLead -KPI $kpi
  }

  END { return $finalRes }
}