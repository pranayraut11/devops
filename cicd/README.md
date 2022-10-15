## To run CICD setup 
   Clone project from repo 
   ```bash
   git clone https://github.com/pranayraut11/devops.git
   ```
   Goto folder cicd
   ```bash
   cd /devops/cicd
   ```
   Run command
   ```bash
   sudo docker compose up -d
   ```
   Check all container status
   ```bash
   sudo docker ps 
   ```
   Check logs for all container
   ```bash
   sudo docker logs -f containe_name
   ```

> **Note** </br>
>  If you see following error in sonar container logs.
   ```
   max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
   ```
   To resolve this problem execute following command in WSL linux distribution
   ```bash
   sudo sysctl -w vm.max_map_count=262144
   ```
> **Warning**
> This is temporary solution , If you reboot your system then you will have to re-run above command

## For Gitlab UI
```
http://localhost:8080
```
Get password from terminal
```
sudo nano gitlab/config/initial_root_password
```
> Username : root 

## For Sonar Qube
```
http://localhost:9000/
```
>Username : admin <br>
>Password : admin

## For Nexus Repository
```
http://localhost:8081/
```
Get password from terminal 
```
sudo docker exec -it nexus3  cat /nexus-data/admin.password
```
> Username : admin <br>

## Register gitlab-runner
```
 sudo docker exec -it gitlab-runner gitlab-runner register --docker-privileged
```
#### Enter following details 
```
Enter the GitLab instance URL : http://gitlab-ce/
Enter the registration token: Get it from Gitlab UI -> Goto Hamburger menu - Admin -> Runners -> Register an instance runner(Copy token)
Enter a description for the runner: Enter any relevant description
Enter tags for the runner (comma-separated): any tag name
Enter optional maintenance note for the runner: can be blank
Enter an executor: docker
Enter the default Docker image : maven:3.8-openjdk-11
```




