function Get-TimeDiff ([datetime]$t1, [datetime]$t2) {
  $rawDiff = $t2 - $t1

  $timeProps = @(
    [pscustomobject]@{ name = 'Days'        ; abr = 'd'  },
    [pscustomobject]@{ name = 'Hours'       ; abr = 'h'  },
    [pscustomobject]@{ name = 'Minutes'     ; abr = 'm'  },
    [pscustomobject]@{ name = 'Seconds'     ; abr = 's'  },
    [pscustomobject]@{ name = 'Milliseconds'; abr = 'ms' }
  )

  $diff = @()
  foreach ($p in $timeProps) {
    $pName, $pAbr = $p.name, $p.abr
    if ($rawDiff.$pName -gt 0) { $diff += "$($rawDiff.$pName)$pAbr" }
  }

  return ($diff -join ', ')
}