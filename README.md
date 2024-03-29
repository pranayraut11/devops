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
  ## Windows Terminal (for Windows OS) - Optional
  https://learn.microsoft.com/en-us/windows/terminal/install
  
  > **Note** <br>
  >  Before installing any software on WSL-linux you will need to convert linux distributions to WSL2.
   
   #### To find out specific linux distribution. 
   ### List all Distro <br>
    
   ```bash 
   wsl -l -v
   ```
   
   ### Convert distribution to WSl2 
    
   ```bash
   wsl --set-version "Distro-name" 2
   ```
    
    eg. wsl --set-version Ubuntu-22.04 2
  
  ## Docker and Docker-compose (WSL Ubuntu)
  Execute following commands to install docker
  * Run the apt update command to get the updated and install some required packages.
    ```
    sudo apt-get update
    ```
    ```
    sudo apt-get install ca-certificates curl gnupg lsb-release
    ```
    
  * Add CPG keys for the official docker repository.
    ```
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    ```
  * Add Docker repository to APT.
    ```
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs)     stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    ```
  
  * Update the packges again
    ```
    sudo apt-get update
    ```
    If you see errors like 
    ```
     Temporary failure resolving 'download.docker.com'
     Ign:2 http://archive.ubuntu.com/ubuntu jammy InRelease
     Err:3 http://security.ubuntu.com/ubuntu jammy-security InRelease
     Temporary failure resolving 'security.ubuntu.com
    ```
    Update the file /etc/resolv.conf Add following content
     ```
      nameserver 8.8.8.8
      nameserver 8.8.4.4
     ```
  * Install docker and docker compose
    ```
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    ```
  
  * Start the docker service
    ```
    sudo service docker start
    ```
  * Check the docker service status
    ```
    sudo service docker status
    ```
  > **Warning** <br>
  > If it is Ubuntu 22.04, then it might have an issue with the iptables version. When you are checking the status, it might still show up not running. If that is          the case, make sure to switch the iptables to legacy.
  * Run the below command to change the default iptables version.
    ```
    sudo update-alternatives --config iptables
    ```
    ### Select the iptables-legacy by entering option 1. Then hit enter.
    Then start the docker service again <br>
    ```
    sudo service docker start
    ```
    ## To avoid use of sudo for docker command we can add user as super user(Optional)
     * Add the user to the docker user group.
    ```
    sudo usermod -aG docker ${USER}
    ```
    ```
    su - ${USER}
    ```
       
    ## List down running docker containers
    ```
    docker ps
    ```
    
    
