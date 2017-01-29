# =======================================================
# NAME: rsync.ps1
# AUTHOR: Frey Lionel, Quonex
# DATE: 22/12/2016
#
# KEYWORDS: création et migration de fichier
# VERSION 3.1
# 01/01/2017 v3.1 Localise les fichiers vidéos/zip > 600MB // Execution en admin // ascii art
# 27/12/2016 v3.0 Optimisation du code
# 23/12/2016 v2.6 Release // suppresion de /ZB
# 23/12/2016 v2.0 Beta // ajout menu
# 22/12/2016 v1.0 Alpha
# COMMENTS: Copie des fichiers en utilisant robocopy
#
#Requires -Version 4.0
# =======================================================
#tips Set-ExecutionPolicy Unrestricted
#
#param([switch]$Elevated)
#function Check-Admin {
#$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
#$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
#}
#if ((Check-Admin) -eq $false)  {
#if ($elevated)
#{
## could not elevate, quit
#}
# 
#else {
# 
#Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
#}
#exit
#}

function question ()
{ 
$oui = New-Object System.Management.Automation.Host.ChoiceDescription "&Oui", `
    "$vOui"
$non = New-Object System.Management.Automation.Host.ChoiceDescription "&Non", `
    "$vNon"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($oui, $non)
$result = $host.ui.PromptForChoice($title, $msg, $options, 0)
if ($tempd -eq "1")
    {
    switch ($result)
        {
            0 {
                new-item -Name "Transfert de $env:USERNAME" -ItemType directory
              }
            1 {
                Write-Host ""
              }
        }
    }
elseif ($tempd -eq "2")
    {
    switch ($result)
        {
            0 {
                mode.com 300
                robocopy "$source" "$dest" /e /v /copy:DAT /ETA
              }
            1 {
                exit
              }
        }
    }
else
    {
        echo "Bug ligne 44 alors Lionel a mal codé =P"
    }
}

function f600 ()
{
Get-ChildItem -Hidden -File -Path C:\ -Include $extensions -Recurse
Get-ChildItem -Hidden -File -Path D:\ -Include $extensions -Recurse
Get-ChildItem -Force -File -Path C:\ -Include $extensions -Recurse | Where-Object -FilterScript {$_.Length -gt 600MB}
Get-ChildItem -Force -File -Path D:\ -Include $extensions -Recurse | Where-Object -FilterScript {$_.Length -gt 600MB}
Get-ChildItem -Path C:\ -Include $extensions -Recurse -ErrorVariable $errorsSearch | Where-Object -FilterScript {$_.Length -gt 600MB}
Get-ChildItem -Path D:\ -Include $extensions -Recurse -ErrorVariable $errorsSearch | Where-Object -FilterScript {$_.Length -gt 600MB}
Write-Host ""
}

$snowowerson = @”
                           $env:USERDOMAIN $env:USERNAME
, ,    ,      ,    ,     ,     ,   ,      ,     ,     ,      ,      ,     
,       ,     ,    ,       ,   .____. ,   ,     ,      ,       ,      ,     
 ,    ,   ,    ,     ,   ,   , |   :|         ,   , ,   ,   ,       , 
   ,        ,    ,     ,     __|====|__ ||||||  ,        ,      ,      ,    
 ,   ,    ,   ,     ,    , *  / o  o \  ||||||,   ,  ,        ,    ,
,   ,   ,         ,   ,     * | -=   |  \====/ ,       ,   ,    ,     ,    
   ,  ,    ,   ,           , U==\__//__. \\//    ,  ,        ,    , 
,   ,  ,    ,    ,    ,  ,   / \\==// \ \ ||  ,   ,      ,          ,  
 ,  ,    ,    ,     ,      ,|    o ||  | \||   ,      ,     ,   ,     ,     
,      ,    ,    ,      ,   |    o ""  |\_|B),    ,  ,    ,       , 
  ,  ,    ,   ,     ,      , \__  --__/   ||  ,        ,      ,     ,   
,  ,   ,       ,     ,   ,  /          \  ||,   ,   ,      ,    ,    ,
 ,      ,   ,     ,        | BONNE 2017 | ||      ,  ,   ,    ,   ,  
,    ,    ,   ,  ,    ,   ,|   ANNEE    | || ,  ,  ,   ,   ,     ,  ,   
 ------_____---------____---\__ --_  __/__LJ__---------________-----___

“@

Clear-Host
$snowowerson
$extensions = @("*.mkv", "*.avi", "*.mp4", "*.zip", "*.rar", "*.7z", "*.tar", "*.gz")
$ErrorActionPreference = "SilentlyContinue"
f600 | Tee "heavy $env:USERDOMAIN $env:USERNAME.log"
$ErrorActionPreference = "Continue"
$snowowerson

$tempd = "1"
$source = Read-Host "Merci de glisser le dossier source ?"
$dest = Read-Host "Merci de glisser le dossier de destination ?"
$realDir = echo £¤¤£$source£¤¤££§ù£ | % { $_ -replace '"','' } | % { $_ -replace '£¤¤£','"' } | % { $_ -replace '"£§ù£','\.."' } | % { $_ -replace '"','' }
cd $realDir

$screenDir = Get-Location | % { $_ -replace "Path","" }
$title = "Création de dossier"
$msg = "Créer Transfert dans $screenDir"
$vOui = "Création du dossier."
$vNon = "Omission & Etape suivante."
question

$title = "Robocopy"
$msg = "Migrer $source vers $dest"
$vOui = "Commencer."
$vNon = "Reporter."
$tempd = "2"
question

$byebye = Read-Host "Appuyer sur Enter pour quitter"