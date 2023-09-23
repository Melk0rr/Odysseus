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
    [object]  $KPI
  )

  BEGIN {
    Write-Host "`nInitializing pre-processing for $($kpi.name)..."
  }

  PROCESS {
    # Execute any preprocessing instruction specified in the configuration file if any
    $preProcLeads = foreach ($lead in $leads) {
      [pscustomobject]$kpiLead = $kpi.leads.Where({ $_.name -eq $lead.name })[0]

      if ($kpiLead.preprocess) {
        $catchedPreprocess = . $kpiLead.preprocess
      }

      $lead
    }
  }

  END {
    Write-Host "Preprocessing is done !" -f Green
    return $preProcLeads
  }
}