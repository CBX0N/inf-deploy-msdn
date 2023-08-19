#### Installing Git ####
try{
  $gitUrl = "https://github.com/git-for-windows/git/releases/download/v2.41.0.windows.3/Git-2.41.0.3-64-bit.exe"
  Write-Output "Pulling Git Installer....."
  Invoke-WebRequest $gitUrl -OutFile C:\Temp\git_x64.exe
  Write-Output "*** DONE ***"

  $gitProcessOptions = @{
    FilePath         = "git_x64.exe"
    WorkingDirectory = "C:\Temp"
    ArgumentList     = '/VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh"'
  }

  Write-Output "Running Git Installer....."
  Start-Process @gitProcessOptions -wait
  $gitInstall = Get-Package -ProviderName "Programs" -Name "Git" 
  if($null -ne $gitInstall){
    Write-Output "*** Installed ***"
  }
  else{
    throw "Cannot find installed git package"
  }
}
catch{
  Write-Error "Failed to Install Git"
  exit 1
}

#### Cloning Git Repo ####
try{
  $cloneProcessOptions = @{
    FilePath         = 'C:\Program Files\Git\cmd\git.exe' 
    ArgumentList     = "clone https://github.com/CBX0N/htm-file.git" 
    WorkingDirectory = "C:\Temp"
  }

  Write-Output "Cloning Git Repo....."
  Start-Process @cloneProcessOptions -wait

  if((Test-path C:\Temp\htm-file\iisstart.htm) -eq 'True'){
    Write-Output "*** Repo Cloned ***"
  }
  else{
    throw "Cannot find cloned repo"
  }
}
catch{
  Write-Error "Failed to Clone Repo"
  exit 1
}

#### Moving App Files ####
try {
  Write-Output "Moving App Files....."
  Get-ChildItem C:\Temp\htm-file -Depth 1 | ForEach-Object  { 
    Move-Item -Path C:\Temp\htm-file\$_ -Destination C:\inetpub\wwwroot\$_ -Force
  } 
  $appFiles = Get-ChildItem C:\inetpub\wwwroot -Depth 1
  if($null -ne $appFiles){
    Write-Output "*** Files Moved ***"
  }
  else {
    throw "Cannot find files in C:\inetpub\wwwroot"
  }
}
catch {
  Write-Error "Failed to Copy Files"
  exit 1
}