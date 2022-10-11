## To run CICD setup clone project 
   ```
   git clone https://github.com/pranayraut11/devops.git
   ```
   Goto folder cicd
   ```
   cd cicd
   ```
   Run command
   ```
   sudo docker compose up -d
   ```


> **Note** </br>
>  If you see following error in sonar container logs.
   ```
   max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
   ```
   To resolve this problem execute following command in WSL linux distribution
   ```
   sudo sysctl -w vm.max_map_count=262144
   ```
> **Warning**
> This is temporary solution

