
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


## Setting master and Node 

set user name for root in both master and node  for all users root , ubuntu , jenkins
install java in both java11

Log in to the Jenkins master server using the credentials provided:

ssh cloud_user@<MASTER_PUBLIC_IP_ADDRESS>

Become root:

sudo su

Configure the Slave Machine for Use with the Jenkins Master

Open the /etc/passwd file:

[root@master]$ vim /etc/passwd

In the last line in the file (beginning with jenkins), change /bin/false to /bin/bash to allow the jenkins user a shell login.

Save and exit the file by pressing Escape followed by :x.

Change the password for the jenkins user:

[root@master]$ passwd jenkins

Enter a password of your choice that you'll easily remember.

Switch to jenkins:

[root@master]$ su jenkins

Change directory:

[jenkins@master]$ cd ~

Generate a public/private RSA key pair:

[jenkins@master]$ ssh-keygen

Log in to the slave server:

[jenkins@master]$ ssh cloud_user@<SLAVE_PUBLIC_IP_ADDRESS>

Become root:

[cloud_user@slave]$ sudo su

Create a jenkins user:

[root@slave]$ useradd jenkins

Create a password:

[root@slave]$ passwd jenkins

Open the sudoers file:

[root@slave]$ visudo

In the Defaults section, beneath root, add:

jenkins ALL=(ALL) NOPASSWD: ALL

Save and exit the file by pressing Escape followed by :x.

Exit root:

[root@slave]$ exit

See who you're logged in as:

[cloud_user@slave]$ whoami

You should see you're cloud_user.

Switch to jenkins:

[cloud_user@slave]$ su jenkins

Enter the password you created.

Change directory:

[jenkins@slave]$ cd ~

Enter exit twice to exit back to the master server.

See who you're signed in as:

whoami

You should see you're jenkins.

As the jenkins user on the master server, copy the jenkins user's ssh keys to the slave server:

[jenkins@master]$ ssh-copy-id jenkins@<SLAVE_PUBLIC_IP_ADDRESS>

If getting this error :
unable to add jenkins slave :

bash-4.4$  ssh-copy-id jenkins@35.154.117.86

/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/var/lib/jenkins/.ssh/id_rsa.pub"

/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed

/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys

Password:

Could not chdir to home directory /home/jenkins: No such file or directory

sh: 1: cd: can't cd to /home/jenkins

mkdir: cannot create directory ‘.ssh’: Permission denied

ChatGPT

The error message suggests that the user "jenkins" does not have a home directory or does not have proper permissions to create the necessary directory and files.

To resolve this issue, you can follow these steps:

Log in to the remote machine using SSH as a user with administrative privileges.


Create a home directory for the "jenkins" user by running the following command:


shell
sudo mkdir /home/jenkins

Assign ownership of the directory to the "jenkins" user:

shell

sudo chown jenkins:jenkins /home/jenkins

Grant the necessary permissions to the directory:

shell

sudo chmod 700 /home/jenkins

Now, try running the ssh-copy-id command again:

shell

ssh-copy-id jenkins@35.154.117.86

You may be prompted for the password of the "jenkins" user. Enter the password to copy the SSH key to the remote machine.

Also install java in slave

If still getting error delete known host (masternode ) and authorized_keys (slave) and redo copy id …

Run the following:

cat ./.ssh/id_rsa

Keep the output listed, as we'll need it for a later step.

Run the Maven Build on the Remote Agent

In a new browser tab, navigate to http://<JENKINS_MASTER_SERVER_PUBLIC_IP>:8080.

Log in to Jenkins using the following credentials:

User: student

Password: OmgPassword!

Click Manage Jenkins in the left-hand menu.

Click Manage Nodes and Clouds.

Click New Node.

Give it a name of slave1.

Select Permanent Agent.

Click OK.

For Remote root directory, enter /home/jenkins.

For Labels, enter slave1.

For Host, enter the slave server's public IP address.

Next to Credentials, click Add > Jenkins.

Set the following values:

Kind: SSH Username with private key

Username: jenkins

Private Key: Enter directly

Copy the entire RSA key in the terminal (from dashes to dashes) and paste it into the Key window

ID: jkey

Description: jenkinsuser

Click Add.

Set Credentials to jenkins (jenkinsuser).

Click Save.
