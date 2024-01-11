# Deploying on premise 

( section 1 to 5 udemy )
------------------------------


## SETUP :

Local setup :
Tools installation via Choco in windows :
- download choco ( Pkg manager for windows )
- now download intellij, sublime text editor , virtualbox, vagrant, git, corretto11jdk, maven , awscli, vscode,

Accounts needed :
- Github
- Domain name
- Dockerhub
- sonarcloud
- AWS


AWS account setup :
- ACM Configuration ( SSL / TLS certificate ) and do domain validation via dns ( CNAME) or email.

-------------------------

## PROJECT 1 and 2 ( Manual and automated ) :



Multi tier webapp :

- Local setup using virtualbox,vagrant, git bash, ide
- Architecture : Nginx, tomcat, rabbitmq, memcached, mysql

- OS :CentOS 9
- multi tier webapp - vagrantfile ( with virtualbox and hostmanager plugin ) for automated vm provisioning and configuration.
- vagrantfile contains : server name, vm type, network details , memory and cpu , path of script to run
- script files :contains setup configguration of all tools , rabbitmq.sh , memcache.sh, backend.sh , mysql.sh, nginx.sh , tomcat.sh   , etc
- application.properties : host ip and port number , username , password , db conf ,jdbc conf for db,  etc

multi tier webapp - vagrantfile ( with virtualbox and hostmanager plugin ) for automated vm provisioning and configuration.

https://github.com/devopshydclub/vprofile-project/tree/local-setup/vagrant/Automated_provisioning


==================================

Architecture :
![image](https://github.com/qriz1452/projects/assets/112246222/f12d1e2c-2ca9-4fed-9546-0ae0dfb60db1)


Deployed using :
![image](https://github.com/qriz1452/projects/assets/112246222/e9764bc2-9904-4d95-87b9-c753a3c2fd8a)

Flow execution :
![image](https://github.com/qriz1452/projects/assets/112246222/36d3a87a-d4c6-4f4c-acbe-1bea6c398714)



-------------------


* Manual provisioning setup : https://github.com/hkhcoder/vprofile-project/blob/main/vagrant/Manual_provisioning_WinMacIntel/VprofileProjectSetupWindowsAndMacIntel.pdf
