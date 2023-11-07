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
    Invoke-KPIRetreiver -Path "C:\User\r.baty\Documents"
  #>

  [CmdletBinding()]
  param(

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [array[]]  $Extracts = $null,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [switch]  $Help,

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
    [string[]]  $Server = $env:USERDNSDOMAIN,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNull()]
    [PSCredential]$Credential,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [switch]  $TestMode,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [switch]  $Version
  )

  BEGIN {

    # If using help or version options, just write and exit
    if ($Help.IsPresent) {
      Write-Host $docString
      continue
    }

    if ($Version.IsPresent) {
      Write-Host (Get-ModuleVersion)
      continue
    }

    if (!$Server) {
      throw "No domain found !"
    }

    Write-Host $banner -f Cyan

    $startTime = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    $day = ($startTime -split " ")[0].Replace('-', '')

    # Handle output type : 1. CSV, 2. default
    $defaultOut = $false
    if ($Output) {
      if (!(Test-Path $Output -PathType Container)) { throw "$Output is not a valid directory path !" }
    }
    else { [array]$outBuffer = @(); $defaultOut = $true }

    # Import configuration files
    $confPath = "$PSScriptRoot\conf"
    $soupPath = "$PSScriptRoot\soup"
    $confFile = Get-Item -Path "$confPath\kpis.conf.ps1"

    # Sourcing kpis configuration file
    try {
      . $confFile.FullName
    }
    catch {
      Write-Error -Message "Failed to import configuration file $($_.FullName): $_"
    }

    [array]$kpis = $configuration.KPIs
    if ($kpis) { Write-Host "KPI Configuration file...OK !" -f Green } else { throw "Invalid configuration file !" }

    # Importing soup files
    [array]$soups = foreach ($soup in $configuration.Soups) {
      try {
        $import = import-csv "$soupPath\$($soup.name).csv" -Delimiter ($soup.delimiter ?? ',')
        $soup | add-member -MemberType NoteProperty -Name 'import' -Value $import
      }
      catch {
        Write-Error -Message "Failed to import soup $($soup.name)"
      }
      $soup
    }

    if ($soups) { Write-Host "$($soups.count) soups were imported !" -f Green } else { Write-Host "No soup imported !" }

    # Exporting params
    $exportParams = @{ Delimiter = '|'; Encoding = "utf8" }
  }

  PROCESS {

    # Extract ActiveDirectory data via ADRetreiver
    $adRetreiver = Resolve-Leads -Extracts $Extracts -TestMode:($TestMode.IsPresent)

    if ($adRetreiver) {
      Write-Host "`nThanks to my loyal Argos, I have all the informations required !" -f Cyan
      Write-Host "Processing $($kpis.length) KPIs..."

      $kpiIndex = 0
      $done = $false
      foreach ($kpi in $kpis) {
        # If kpi name is not provided : make one based on index
        $kpi.name = $kpi.name ?? "kpi_$kpiIndex"
        $completedKPI = Format-KPI -KPI $kpi

        if (!$defaultOut) { $completedKPI | export-csv "$Output/$($kpi.name)_$day.csv" @exportParams }
        else { $outBuffer += $completedKPI }

        $kpiIndex++
      }

      $done = $true
      if (!$defaultOut) { Write-Host "`nKPIs exported to $Output !" -f Green }

    }
    else { Write-Host "Oh no... It seems no information could be found" -f Red }

    $endTime = Get-Date
  }

  END {
    $closingParams = @{ char = " "; length = 85 }
    Write-Host $bannerClose -f Cyan
    Write-Host (Invoke-PadCenter "KPI generation took $(Get-TimeDiff $startTime $endTime)" @closingParams) -f Cyan
    if ($defaultOut) { return $outBuffer }
  }
}