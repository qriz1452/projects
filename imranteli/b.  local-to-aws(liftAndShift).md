using few Managed services :
![image](https://github.com/qriz1452/projects/assets/112246222/3fffd75f-df7f-42fc-82d8-585fdeeeceb6)

INfra architect :
![image](https://github.com/qriz1452/projects/assets/112246222/8c587dfd-7291-4a86-801b-5e255a04f2cd)


AWS Architect :
![image](https://github.com/qriz1452/projects/assets/112246222/ea5cf240-1c9e-4036-8cea-1b219420999c)

Flow of execution :
![image](https://github.com/qriz1452/projects/assets/112246222/0275d130-f53f-474c-a5c3-baec52e43423)


--------------------------------------


LB- security group :
-allow  inbound http / https traffic from ipv4 and ipv6

Frontend - security group:
- allow inbound traffic at 8080 port from LB-security group.

Backend-securitygroup:
- allow inbound traffic from frontend sg. at mysql 3306 , memcache 11211 , rabbitmq 5672
- allow self traffic 
- we can check port numbers from application.properties file

-----------------------------------

Create keypair for VMS 

-----------------------------------

LAUNCH VM using userdata :
select respective SG and keypairs,
https://github.com/hkhcoder/vprofile-project/tree/aws-LiftAndShift/userdata
- backend : Mysql ,  OS : Centos stream 9 
- backend : Memcahced , OS : Centos stream 9
- backend : rabbitmq , OS : CentOS stream 9
- frontend : tomcat , OS : Ubuntu 20

ogin to all vm and check whether services are running are not using systemctl .
check user data : `curl http://169.254.169.254/latest/user-data`

for mysql check db :
`musql -u admin -padmin123 accounts`
`show tables;`

check services unning on port :
`ss -tunlp | grep  11211`



--------------------------------------

Route53 for internal communication of hosts :

- create private hosted zone
- create simple routing record
- add A record map private ip to name , eg.: db01.mydomain.com --> 10.12.13.15
- make sure the hostname db01.mydomain.com ARE as per application.properties file if file is not updated update it.


------------------------------------


create artifact and upload to s3:
Requirements :
- mvn v 3.9.2 requires
- aws cli
- java version 11.0.19

Build :
- goto directory ( or clone code https://github.com/hkhcoder/vprofile-project/tree/aws-LiftAndShift )
- mvn install
- it will create war file in target directory

Upload to S3 :
- create iam user give full access to s3
- attach to our building machine
- configure user n our machinne using   `aws configure`
- upload artifact using aws cli to s3
- `aws s3 mb s3://bkname`
- `aws s3 cp target/ourwarfile.war s3://bkname/`

Add war in tomcat:
- create iam role for ec2 and attach s3 policy.
- attach role to vm
- login to vm and install aws cli
-  `aws s3 ls`
-  `aws s3 cp s3://mybkname/mywarfile.war /tmp`
-  `systemctl stop tomcat9`
-  `rm -rf /var/lib/tomcat9/webapps/ROOT`
-  `cp /tmp/mywarfile.war /var/lib/tomcat9/webapps/ROOT.war`
-  `systemctl start tomcat9`
-  verify going to war path and folders

----------------------------------------------------------

setup LOAD BALANCER :

Create Target group:
- select instances
- protocol : 8080 (for tomcat)
- healthcheck :/login at port 8080.
- select vm and port 8080

LB:
- Application LB
- internetfacing
- listener : http and https and select target group
- for https we need to select certificate from ACM
- map LB dns as cname in domain provider

-------------------------------

Autoscale :
- create image of tomcat vm
- craete launch confg.
- create autoscale grp

------------------DONE---------------------------
