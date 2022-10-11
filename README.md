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
  Reference links 
  * https://learn.microsoft.com/en-us/windows/wsl/install
  * https://tjisblogging.blogspot.com/2022/05/install-docker-on-windows-11-with-wsl.html (Including Docker and Docker-compose installation)
  ## Windows Terminal (for Windows OS)
  https://learn.microsoft.com/en-us/windows/terminal/install
  * Before installing any software on Windows(wsl) you will need to convert distro(linux) to wsl2 using command <br />
    List all Distro <br />
    Command : wsl -l -v <br />
    Convert Distro to WSl2 <br />
    Command : wsl --set-version "Distro-name" 2 <br />
    eg. wsl --set-version Ubuntu-22.04 2
  
  ## Docker and Docker-compose (WSL Ubuntu)
  Execute following commands to install docker
  * Run the apt update command to get the updated and install some required packages.
    sudo apt-get update <br>
    sudo apt-get install ca-certificates curl gnupg lsb-release <br>
    
  * Add CPG keys for the official docker repository.
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
  * Add Docker repository to APT.
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs)     stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null <br>
  
  * Install Docker and Docker-compose
    sudo apt-get update <br>
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin <br>
  
  * Start the docker service
    sudo service docker start
  
  * Check the docker service status
    sudo service docker status
   
  Note : If it is Ubuntu 22.04, then it might have an issue with the iptables version. When you are checking the status, it might still show up not running. If that is          the case, make sure to switch the iptables to legacy. 
  * Run the below command to change the default iptables version.
    sudo update-alternatives --config iptables <br>
    ### Select the iptables-legacy by entering option 1. Then hit enter.
    Then start the docker service again <br>
    sudo service docker start
    
    ## To avoid use of sudo for docker command we can add user as super user(Optional)
     * Add the user to the docker user group.
       sudo usermod -aG docker ${USER}
       su - ${USER}
       
    ## List down running docker containers
       docker ps
    
    
