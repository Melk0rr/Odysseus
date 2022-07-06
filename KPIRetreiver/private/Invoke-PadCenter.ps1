function Invoke-PadCenter ([string] $str, [char] $char, [int] $length) {
  $padLeft = ($length - $str.length) / 2 + $str.length
  return $str.PadLeft($padLeft, $char).PadRight($length, $char)
}