Tools used : 


![image](https://github.com/qriz1452/projects/assets/112246222/2410b15f-0f66-42ac-be53-1245ea7d5c88)
![image](https://github.com/qriz1452/projects/assets/112246222/9c6cd012-d55d-4fc8-ae93-e7f1783196b3)


Architechtutr :
![image](https://github.com/qriz1452/projects/assets/112246222/9c021659-ad83-40b9-94da-1fc1b10af316)
![image](https://github.com/qriz1452/projects/assets/112246222/9257e59f-cedf-4320-adf9-fcb7a1585c73)


Flow of execution :
![image](https://github.com/qriz1452/projects/assets/112246222/da59ad01-d3a1-47f8-91a8-56c2ca0af87a)
![image](https://github.com/qriz1452/projects/assets/112246222/289f6a9e-24c9-45eb-8943-2fd89f8ba26f)



---------------------------------------------

SG and keypairs:
- create keypair.
- create Jenkins SG : allow 22 from myip , 8080 anywhere ipv4 and ipv6 ( will be used for github webhook )  .... 8080 from sonar sg 
- create Nexus SG : allow 22 , 8081 from myip , 8081 fron jenkins sg ( nexus runs on 8081 )
- create sonar SG : allow 22 , 80 from myip , 80 fron jenkins sg ( nexus runs on 8081 )


VM Setup :
- user data : https://github.com/devopshydclub/vprofile-project/tree/ci-jenkins
- Jenkins : ubuntu 20
- Nexus : Amazon Linux2 ( large should t3 + )
- Sonar : ubuntu 18 ( size t3 + )
  

Jenkins Setup :
- Install JDK8 and give jdk 8 path as JAVAHOME in jenkins ( name given OracleJDK8 ) ..... commands `apt install openjdk-8-jdk -y ` javahome to e add in jenkins ` /usr/lib/jvm/java-1.8.0-openjdk-amd64`
- INstall Maven from jenkins only ( name given MAVEN3 )
- Plugins : Pipeline utility steps , Pipeline maven integration ,  maven integration , github integration , nexus artifact uploader , sonarqube scanner , slack notification , build timestamp
- add nexus login details in jenkins creds (id given : nexuslogin)
- from manage tools add :  SonarQube Scanner installations  , name sonarscanner , version 4.7
- from system : select :  SonarQube servers   , check mark envt variables , name : sonarserver , add ip , Toekn generated from sonar server
- 

Sonatype Nexus :
- Create repo :
   - maven hosted (vprofile-release)
   - maven proxy (vpro-maven-central) , remote storage : https://repo1.maven.org/maven2/
   - maven hosted (vprofile-snapshot ) , version policy : snapshot
   - maven2 group ( vpro-group ) : group all repo - central , release , snapshot
 

sonarqube sonarscanner : just login ,
- create token for jenkins and 
- add webhook :http://172.31.52.9/8080/sonarqube-webhook/
- an also configure quality gates

--------------------------------

Github code migration :
- create repo in github.
- copy ssh public key and add in github account then confirm `ssh -T git@github.com`
- `git clone -b ci-jenkins https://github.com/devopshydclub/vprofile-project.git`
- `cat .git/config` replace remote origin url
- or ` git remote set-url origin <mynewgitrepourl>`
- push all branch ` git push --all origin`
- My forked repo ` https://github.com/qriz1452/Imranteli-vprofile-project/tree/ci-jenkins`


-------------------------------------

Slack notification can be done if necessary


write pipeline and build job ; https://github.com/qriz1452/Imranteli-vprofile-project/blob/ci-jenkins/Jenkinsfile

--------------------------------------











ISSUE : https://stackoverflow.com/questions/31316339/how-to-solve-maven-2-6-resource-plugin-dependency/76986625#76986625












