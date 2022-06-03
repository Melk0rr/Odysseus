function Initialize-KPIPreprocessing {
  <#
  .SYNOPSIS
    This script will transform given leads based on kpi preprocess instructions provided in the configuration

  .NOTES
    Name: Initialize-KPIPreprocessing
    Author: JL
    Version: 1.0
    LastUpdated: 2022-May-25

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
    [object]  $KPI,

    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [object[]]  $Leads
  )

  BEGIN { Write-Host "Initializing preprocessing for $($kpi.name)..." -f Yellow }

  PROCESS {
    # Execute any preprocessing instruction specified in the configuration file
    $preProcLeads = foreach ($lead in $leads) {
      $kpiLead = $kpi.leads.Where({ $_.name -eq $lead.name })
      if ($kpiLead.preprocess) { $lead.result = invoke-expression $kpiLead.preprocess }
      $lead
    }
  }

  END {
    Write-Host "Preprocessing is done !" -f Green
    return $preProcLeads
  }
}