## Sample gitlab script to deploy Java application
## Let's discuss script
```
stages:
  - compile
  - test
  - code-analysis
  - push-nexus
  - deploy
```
### Stage 1 - compile
In this stage we clone code from gitlab repository and compile it using maven commands.
  
### Stage 2 - test
Test stage is used to run unit test using maven command.

### Stage 3 - code-analysis
For this stage we have already setup sonar qube to analysis the code. So this stage uses sonar qube to analyses the code.

### Stage 4 - push-nexus
In this stage we will push our project jar file to nexus repository.

### Stage 5 - deploy
In this stage we will create docker image, and It's container and deploy it on docker locally.

```
image: maven:3.8-openjdk-11
```
#### Default docker image , which will be used in case we did not provide any image in stage script.

```
variables:
  MAVEN_OPTS: "-Dmaven.repo.local=.m2/repository"
```
#### This can be used to declare variables

```
cache:
  paths:
    - .m2/repository/
    - target/
```
#### This is used to store dependency and builds(.jar) files locally. This will increase script execution spreed.

```
maven-compile:
  stage: compile

  script:
    - mvn clean compile -s settings.xml -DskipTests=true
  tags:
    - volumns
```
>stage: compile
> 
This should be match with name given in declared stages 
>script: <br>- mvn clean compile -s settings.xml -DskipTests=true
> 
Script tag contains maven clean command with settings.xml file(which will be part of your project)
> tags: <br> - volumns
> 
Tags tag is used by gitlab runner to run job

```
maven-test:
  stage: test
  script: 
    - mvn test
  tags:
    - volumns
```
>script: <br>- mvn test
>
Script tag contains maven test command which run junit test

```
sonar-analysis:
  stage: code-analysis
  script:
    - mvn verify sonar:sonar -s settings.xml -Dsonar.projectKey=demo1  -Dsonar.host.url=http://sonarqube:9000  -Dsonar.login=bd39f24a8ee45bed5a9f3d4db13d9cda90d86e6b -Dsonar.branch.name="$CI_COMMIT_REF_NAME"
  variables:
    SONAR_USER_HOME: "${CI_PROJECT_DIR}/.sonar"
    GIT_DEPTH: "0"

  cache:
    key: "${CI_JOB_NAME}"
    paths:
      - .sonar/cache
  allow_failure: true
```

> script: <br> - mvn verify sonar:sonar -s settings.xml -Dsonar.projectKey=demo1  -Dsonar.host.url=http://sonarqube:9000  -Dsonar.login=bd39f24a8ee45bed5a9f3d4db13d9cda90d86e6b -Dsonar.branch.name="$CI_COMMIT_REF_NAME"
>
This will run code analysis on sonar qube for specific branch.
You will need to provide host url , token(take it from sonar qube ui) and branch name

```
push-nexus:
  stage: push-nexus
  script:
    - mvn -s settings.xml -DuniqueVersion=false -DskipsTest deploy
  artifacts:
    paths:
      - target/*.jar
```
>   script: <br> - mvn -s settings.xml -DuniqueVersion=false -DskipsTest deploy
> 
This will Upload jar file in nexus repository

```
docker-deploy:
  stage: deploy
  image: docker:latest
  script:
    - docker --version
    - docker stop firstappcontainer || true && docker rm firstappcontainer || true && docker rmi pranayraut11/gitlabdemo
    - docker build -t pranayraut11/gitlabdemo .
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD
    - docker push pranayraut11/gitlabdemo
    - docker stop firstappcontainer || true && docker rm firstappcontainer || true
    - docker run -d --name firstappcontainer -p 9090:8080 pranayraut11/gitlabdemo
  tags:
    - volumns
```
> Above script is used for following steps
> * Stop running container if any then remove existing docke image
> * build docker image for provides docker file
> * login to docker hub using username and password
> * push docker image to your docker hub repository
> * Stop running container and remove it
> * Last create and run container for new image

> **Note** <br>
> Create $CI_REGISTRY_USER and $CI_REGISTRY_PASSWORD variables in gitlab with your credentials 