function Invoke-KPIRetreiver {
  <#
  .SYNOPSIS
    This script will retreive various informations and generate csv files in order to produce security KPIs

  .NOTES
    Name: Invoke-KPIRetreiver
    Author: JL
    Version: 1.2
    LastUpdated: 2022-Apr-13

  .EXAMPLE
    Invoke-KPIRetreiver -Path "C:\User\RoyBatty\Documents"
  #>

  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [string]  $Output,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [array[]]  $Extracts = $null
  )

  BEGIN {
    Write-Host $banner -f Cyan

    # Handle output type : 1. CSV, 2. default
    $defaultOut = $false
    if ($Output) {
      if (!(Test-Path $Output -PathType Container)) { throw "$Output is not a valid directory path !" }
    } else { [array]$outBuffer = @(); $defaultOut = $true }

    # Format date
    $day, $time = ((Get-Date -format 'u') -split ' '); $day = $day.Replace('-', '')

    # Import configuration files
    $publicPath = "$PSScriptRoot"
    $confPath = "$publicPath\conf"
    [array]$kpis = Import-Json "$confPath\kpis.conf.json"

    if ($kpis) { Write-Host "KPI Configuration file...OK !" -f Green } else { throw "Invalid configuraiton file !" }

    # Exporting params
    $exportParams = @{ Delimiter = '|'; Encoding = "Unicode" }
  }

  PROCESS {

    # Extract ActiveDirectory data via ADRetreiver
    $adRetreiver = Resolve-Leads -Extracts $Extracts

    if ($adRetreiver) {
      Write-Host "`nThanks to my loyal Argos, I have all the informations required !" -f Cyan
      Write-Host "Processing $($kpis.length) KPIs..." -f Yellow

      $kpiIndex = 0; $done = $false
      foreach ($kpi in $kpis) {
        # If kpi name is not provided : make one based on index
        $kpi.name = $kpi.name ?? "kpi_$kpiIndex"
        $completedKPI = Format-KPI -KPI $kpi

        if (!$defaultOut) { $completedKPI.result | export-csv "$Output/$($kpi.name)_$day.csv" @exportParams }
        else { $outBuffer += $completedKPI }

        $kpiIndex++
      }

      $done = $true
      if (!$defaultOut) { Write-Host "`nKPIs exported to $Output !" -f Green }

    } else { Write-Host "Oh no... It seems no information could be found" -f Red }
  }

  END {
    Write-Host $bannerClose -f Cyan
    if ($done) {
      Write-Host "                                  I CAN SEE ITHACA !" -f Cyan
      if ($defaultOut) { return $outBuffer }
    } else { Write-Host "                    Maybe Aeolus will be more lenient next time !" -f Cyan }
  }
}