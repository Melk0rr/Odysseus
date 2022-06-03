function Import-Json ([string] $Path) {
  if (!(Test-Path $Path)) { throw "Invalid path $Path provided !" }
  else { return Get-Content $Path | ConvertFrom-Json }
}