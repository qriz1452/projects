New services replacing AWS IAAC with AWS PAAS :


![image](https://github.com/qriz1452/projects/assets/112246222/395edb4d-0f5d-4c54-8868-6fe4a68de441)

![image](https://github.com/qriz1452/projects/assets/112246222/5e816e0d-e529-46a3-9a79-b319b8ac37d1)


![image](https://github.com/qriz1452/projects/assets/112246222/d2886e5d-1110-4be3-8315-de9814f946d3)


Architecture :
![image](https://github.com/qriz1452/projects/assets/112246222/26dc2cce-1aa8-47cd-bf4a-4ac5e3876959)
![image](https://github.com/qriz1452/projects/assets/112246222/141202fd-2b83-4f0c-9718-e7104ef53258)


Flow of execution : 
![image](https://github.com/qriz1452/projects/assets/112246222/88e8d385-aed7-4475-9654-6841a62c1f07)
![image](https://github.com/qriz1452/projects/assets/112246222/3ca4d4b6-1bbc-4253-bb09-e8ca3bf2dd54)


-----------------------
STEPS :


Security group : 
- SG for backend , allow all inabound traffic from the same SG so each backend can communicate each other
- allow SSH 22 port from My IP

Keypair:
- KP for backend Managed services


----------------------------------------

Backend :
RDS : 
- Create subnet group.
- create parameter group.
  - ( select database aurora mysql 8 version and family )
  -  after creating click the created group and here you can change the parameters if you need.
- Create Aurora MySQL 8 DB
   - DB Cluster Identifier : vprofile-rds-mysql
   - Username : admin 
   - DB subnet group : select previously created
   - Initial database name : accounts
   - DB parameter group : select previously created
   - Create
   - Copy and save creds :     Username : admin  ,   password created : YPOsCIQBNGKJwkW5J1MM , endpoint : vprofile-rds-mysql.cluster-c1irfbbojeqk.us-east-1.rds.amazonaws.com 

 
- Elastic cache cluster :
   -  create subnet group
   -  craete parameter group
      - family : memcached 1.6
      - Engine version 1.6, select subnet and parameter group
      -  ( endpoint will get after deploymenet , endpoint  URI is :  vprofile-elasticcache-svc.wtnrjp.cfg.use1.cache.amazonaws.com  )
    
-Amazon MQ :
 - Broker engine : rabbit mq
 - username : rabbit , password : Blue7890bunny    ( endpoint will get after deploymenet , endpoint  URI is :  b-222ac70b-084b-4cd3-9eea-ba9f53b98cf2.mq.us-east-1.amazonaws.com  )
 - engine version : 3.10.20


-----------------------

DB Initialization :
- launch ubuntu 22 vm in  backend SG
- run install mysql-client
- connect to DB ` mysql -h <endpoint> -u <username> -p<password> <tablename>` for example `mysql -h vprofile-rds-mysql.cluster-c1irfbbojeqk.us-east-1.rds.amazonaws.com -u admin -pYPOsCIQBNGKJwkW5J1MM accounts`
- check any tables `show tables;` then `exit`
- `git clone https://github.com/hkhcoder/vprofile-project.git`
- import sql db from backup `mysql -h vprofile-rds-mysql.cluster-c1irfbbojeqk.us-east-1.rds.amazonaws.com -u admin -pYPOsCIQBNGKJwkW5J1MM accounts < vprofile-project/src/main/resources/db_backup.sql  `
- now you can delete VM

------------------

Elastic beanstalk :
- create beanstalk role by delecting correct policies
-  platform : tomcat
-  branch : tomcat 8.5 with coretto 11
-  preset : custom configuration
-  select correct role and keypair
-  check public ip
-  select all default values then create ... we will change these later


--------------------------------------------

SG and ELB update :
- S3 : select beanstalk created bk and change object AC to Object Ownership --> Object writer
-  Beanstalk : goto configuration and make changes --
   - health check : /login , rnable session stickiness , add 443 listener if SSL configures  in ACM ,
- SG : copy SG id created by E.Beanstalk and add in SG of backend so backend and EBS can communicate each other


------------------------------

Artifact :
- `git clone -b aws-refactor https://github.com/hkhcoder/vprofile-project.git`
- update the  host with endpoints , port , username and passwords in APPLICATION>PROPERTIES FILE
- `mvn install `
- Now upload the artifact at elastic bean stalk portal

--------------------------------

Amazon CloudFront:
- create and configure cdn
  
