# Setup CI/CD envoirnment locally
# Requirements
  * Docker 
  * Docker-compose
  
  
# Setup on linux
  * Install Docker and Docker-compose
# Setup on windows
  * This setup will not work on Docker Desktop .
  * We will need wsl installed on Windows OS to install Docker and Docker-compose
  * Install Windows Terminal - Optional(Recommended)
  
# Installation
  ## WSL (for Windows OS)
  https://learn.microsoft.com/en-us/windows/wsl/install
  ## Windows Terminal (for Windows OS)
  https://learn.microsoft.com/en-us/windows/terminal/install
  * Before installing any software on Windows(wsl) you will need to convert distro(linux) to wsl2 using command <br />
    Check all Distro <br />
    wsl -l -v <br />
    Convert Distro to WSl2 <br />
    wsl --set-version <Distro-name> 2 <br />
    eg. wsl --set-version Ubuntu-22.04 2
  
  ## Docker
  Execute command to install docker 
  ## Docker compose
