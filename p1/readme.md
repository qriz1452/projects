
https://www.youtube.com/watch?v=adG0vq5boL8

# Launching instances in AWS : 
- T3 medium , 8 instance , ubuntu 20 LTS , memory 10 gb
    * Jenkins -master , node
    * docker - master , node
    *  k8 - master , node
    *  nexus server
    *  sonar server


# Installing tools :

## Jenkins - 

 ### installation in Master node :
 
``` sudo apt update
sudo apt install openjdk-11-jre
java -version
```

 
` curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null  
  `
  
` echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
  `
  
```
sudo apt-get update
sudo apt-get install jenkins 
```


```
sudo systemctl enable jenkins

sudo systemctl start jenkins

sudo systemctl status jenkins
  
sudo cat /var/lib/jenkins/secrets/initialAdminPassword 
```



* for firewall :

```
sudo ufw allow 8080

sudo ufw allow OpenSSH

sudo ufw enable

sudo ufw status
```

login to jenkins and install suggested plugins and set user

----------------- working perfect till here ------------------------
