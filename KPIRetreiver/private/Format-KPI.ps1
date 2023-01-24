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
    [array]$leads = $adRetreiver.Where({ $kpi.leads.name.Contains($_.name) })

    Write-Host "$kpiName is based on $($leads.length) ADRetreiver leads and $($soups.length) soups"

    # Handle preprocessing
    [array]$leads = Initialize-KPIPreprocessing -KPI $kpi -Leads $leads

    # Initialize custom kpi variables
    if ($kpi.kpivariables.count -gt 0) {
      $kpi.kpivariables | foreach-object { New-Variable -Name $_ -Value $kpi.kpivariables[$_] }
    }

    # # Post processing : first defined lead is considered as base for final result
    $mainLead = $leads.Where({ $_.name -eq "$($kpi.leads[0].name)" })
    $finalRes = Initialize-KPIPostprocessing -Base $mainLead -KPI $kpi
    $mainLead | add-member -MemberType NoteProperty -Name 'result' -Value $finalRes -Force

    Write-Host "  --------------------------  " -f Cyan
  }

  END { return $mainLead }
}