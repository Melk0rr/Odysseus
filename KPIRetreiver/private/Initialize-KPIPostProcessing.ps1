function Initialize-KPIPostprocessing {
  <#
  .SYNOPSIS
    This script will transform given Base by applying the post processing provided by configuration

  .NOTES
    Name: Initialize-KPIPostprocessing
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
    [object[]]  $Base
  )

  BEGIN {
    Write-Host "Initializing post processing for $($kpi.name)"

    # Progress related variables 
    $i = 0; $mainLeadSize = $base.result.length
  }

  PROCESS {
    # Post processing : creating new fields
    $processed = foreach ($rock in $base.result) {

      # Initialize custom rock variables
      if ($kpi.rock_variables.length -gt 0) { invoke-expression ($kpi.rock_variables -join ';') }

      # Progress
      $percent = [math]::Round($i / $mainLeadSize * 100, 2)
      Write-Progress -Activity "Post processing $($kpi.name) data..." -Status "$percent% completed..." -PercentComplete $percent

      # Creating new fields specified in configuration
      foreach ($field in $kpi.fields) {
        $fieldValue = invoke-expression $field.value
        $rock | add-member -MemberType NoteProperty -Name $field.name -Value $fieldValue
      }

      $i++; $rock
    }
    
    Write-Progress -Activity "Post processing $($kpi.name) data..." -Status "100% completed !" -Completed
  }

  END {
    Write-Host "Done Formating $($kpi.name): $($processed.length) elements processed !" -f Green
    return $processed
  }
}