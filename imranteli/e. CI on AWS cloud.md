AWS Service : 

![image](https://github.com/qriz1452/projects/assets/112246222/05145449-967d-4282-b0f2-4be7c59bdcb1)
![image](https://github.com/qriz1452/projects/assets/112246222/bf143189-1cf0-4a5e-9ecf-dad54ea1dad4)


Architecture :
![image](https://github.com/qriz1452/projects/assets/112246222/b23ea522-2c10-40e1-964d-b1d43de4e752)


Flow of execution:
![image](https://github.com/qriz1452/projects/assets/112246222/c3e2b534-8beb-4aab-b052-e907d6f4e84f)
![image](https://github.com/qriz1452/projects/assets/112246222/85f5f300-3a5f-4415-9a11-6e53f8a65b8d)
![image](https://github.com/qriz1452/projects/assets/112246222/4cf2770f-ede9-4b5c-bcd0-f2464f9d6c64)


--------------------

AWS Code ommmit :
- create user for code repo
- clone and  migrate to codecommit repo `https://github.com/devopshydclub/vprofile-project.git`
- steps may involve such as create repo , clone into system, authorize system using PAT/SSH ,   change  origin , push all branches

All steps :
- create codecommit user
- generte ssh keypair from your laptop
- Upload pub key to IA user
- edit /.ssh/config
    - and add :
```
Host git-codecommit.*.amazonaws.com
	User APKAW3LBI4JR2A5U3O2B
	IdentityFile ~/.ssh/id_rsa

```      

-  next authenticate from laptop ` ssh git-codecommit.us-east-1.amazonaws.com`
-  clone aws codecommit repo :`git clone ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/vprofile-code-repo`
-  clone git repo `https://github.com/devopshydclub/vprofile-project.git`
-  cd to git repo
-  check branches `git branch -a`  then ` git checkout master`
-  ` git branch -a | grep -v HEAD | cut -d '/' -f3 | grep -v master > /tmp/branches`
-  ` for i in `cat /tmp/branches` ; do git checkout $i ; done`
-   `git fetch --tags`
-  `git remote rm origin`
-  ` git remote add origin ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/vprofile-code-repo  `
-  `cat .git/config`
-  `git push origin --all`
-  `git push --tags`

---------------------------------

Artifact Repository :
- name :vprofile-maven-repo
- Public upstream repositories : maven-central-store
- give any domain name
-  create iam user for codeartiact
.
.
- select maven central repo
-  view connection instructions ,  Choose a package manager clien : mvn
- will show auth token command , run  this in you laptop
-  `echo $CODEARTIFACT_AUTH_TOKEN`
- `git checkout ci-aws`
- `vi settings.xml`
- change domain name and repository URL to new codeartifact maven centrl store url  ( steps will be available in connec instructions page)
-  update the same in pom.xml
-  update commit and push
-  ` git push --set-upstream origin ci-aws`


--------------------------------

System Manager :
- goto parameter store and add parameters
   - Name : Organization ,  string : devopshydclub
   -  Name : HOST , string : https://sonarcloud.io
   -  Name : Project , string : vprofile-repo
   -  Nme : sonartoken ,  securestring : addyour token
   -  Name : codeartifact-token , securestring : add your token 

---------------

Codebuild :
- create build , branch : ci-aws
- add VM ubuntu
- copy buildspec file from aws-files/sonar_buildspec.yml and insert the file by switching to editor

--------
DONT KNOW BUILD SPEC FILE HOW IT IS CREATED
------------------------
HENCE DROPIING THE PROJECT
------------------

------------------


