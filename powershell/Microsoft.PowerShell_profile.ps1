Set-PSReadLineOption -EditMode Vi
#Set-PSReadLineKeyHandler -Chord Tab -Function Complete
Set-PSReadLineKeyHandler -Chord Ctrl-r -Function ReverseSearchHistory -ViMode Insert
Set-PSReadLineKeyHandler -Chord Ctrl-r -Function ReverseSearchHistory -ViMode Command

$mod = Get-Module -Name PSWriteColor -ListAvailable
If ($null -eq $mod) {
  Write-Host "Install PS Write Color"
  Install-Module -Name PSWriteColor -Scope CurrentUser
  Import-Module PSWriteColor
}

$mod = Get-Module -Name PSScriptAnalyzer -ListAvailable
If ($null -eq $mod) {
  Write-Host "Install PS script analyzer"
  Install-Module -Name PSScriptAnalyzer -Scope CurrentUser
}
