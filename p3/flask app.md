* can do network isolation using `--network ` flag .

* to show layers : `export showLayers='{{ range .RootFS.Layers }}{{ println . }}{{end}}'`  then `docker inspect -f "$showLayers" widgetfactory:0.1`


* to show size : `export showSize='{{ .Size }}'	`  then `docker inspect -f "$showSize" widgetfactory:0.1`


* always remove extra files you have added in container so that image size and layers can be less.


* `docker inspect db1 -f '{{ json .Mounts }}' | python -m json.tool`

------------------------------------------------------------------------

************************PROJECT 3****************************
===============================================================

Project Brief: Dockerizing a Flask Application

PART 1 :

Introduction:
In this project, the goal is to dockerize a Flask application named "Notes" which is a dynamic web application built using the Flask framework in Python. Dockerization involves encapsulating the application and its dependencies in a Docker container, making it portable and easy to deploy across different environments. The Flask application provides functionality to create, edit, and manage notes.

Technologies Used:
* Python: Programming language used for developing the Flask application.
* Flask: A lightweight Python web framework used to build the dynamic web application.
* Docker: Containerization platform used to package the Flask application and its dependencies.
* PostgreSQL: Open-source relational database used to store application data.
* Gunicorn: Python WSGI HTTP server used to serve the Flask application in production.
* Git: Version control system used for managing the project's source code.
* AWS CloudFormation: Used to provision and configure the server environment.
* Vim: Text editor used to edit configuration files within the container.
* Bulma: CSS framework for styling the web application.



-------------------

BACKEND CONFIGURATION :

Here's a brief breakdown of the commands used in the provided shell script for setting up the backend of the project:

1. Export Path and Python Path:
```bash
export PATH=/bin:/usr/bin:/opt/aws/bin:$PATH
export PYTHONPATH="${PYTHONPATH}:/usr/local/lib/python2.7/site-packages/"
```
- Exporting paths and python paths for proper execution of subsequent commands.

2. Change User Password:
```bash
echo '4pcQ%-_M' | passwd cloud_user --stdin
```
- Changing the password of the user `cloud_user`.

3. Installing Dependencies:
```bash
yum install -y epel-release wget
yum install -y /tmp/aws-cfn-bootstrap-latest.amzn1.noarch.rpm
yum update -y
yum install -y yum-utils device-mapper-persistent-data lvm2
```
- Installing necessary packages, updates, and utilities.

4. Adding Docker Repository and Installing Docker:
```bash
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y git docker-ce
```
- Configuring Docker repository and installing Docker and Git.

5. Adding User to Docker Group and Enabling Docker:
```bash
usermod -aG docker cloud_user
systemctl enable --now docker
```
- Adding the user to the Docker group and enabling Docker service.

6. Pulling PostgreSQL Docker Image and Cloning Repository:
```bash
docker pull postgres:12.1-alpine
git clone https://github.com/linuxacademy/content-intro-to-python-development/ /tmp/python
```
- Pulling the PostgreSQL 12.1-alpine Docker image and cloning the repository.

7. Changing to Repository Directory and Copying Notes App:
```bash
cd /tmp/python
git checkout remotes/origin/use-case-web-app
cp -r notes /home/cloud_user/notes
```
- Navigating to the repository directory, checking out the specific branch, and copying the "notes" application.

8. Creating Environment Variables for Notes App:
```bash
cat > /home/cloud_user/notes/.env <<EOF
export DB_HOST='notesdb'
export DB_PORT='5432'
export DB_NAME='notes'
export DB_USERNAME='demo'
export DB_PASSWORD='secure_password'
export FLASK_ENV='development'
export FLASK_APP='.'
EOF
source /home/cloud_user/notes/.env
```
- Creating an environment file for the application with database and Flask settings.

9. Creating Docker Network and Running PostgreSQL Container:
```bash
docker network create notes
docker run -d --name notesdb --network notes -p $DB_PORT:5432 -e POSTGRES_USER=$DB_USERNAME -e POSTGRES_PASSWORD=$DB_PASSWORD --restart always postgres:12.1-alpine
```
- Creating a Docker network for communication, and running a PostgreSQL container named "notesdb" with specified settings.

10. Modifying Pipfile and Configurations:
```bash
sed -ri '/python_version/d' /home/cloud_user/notes/Pipfile*
sed -i 's/postgres/postgresql/g' /home/cloud_user/notes/config.py
```
- Removing specific lines related to Python version and modifying the database configuration.

11. Removing Migrations, Setting Permissions, and Pulling Python 3 Image:
```bash
rm -rf /home/cloud_user/notes/migrations
chown -R cloud_user: /home/cloud_user/notes
docker pull python:3
```
- Removing migration files, adjusting permissions, and pulling the Python 3 Docker image.

12. Creating "notes" Database in PostgreSQL Container:
```bash
docker exec -i notesdb psql postgres -U $DB_USERNAME -c 'CREATE DATABASE notes;'
```
- Executing a PostgreSQL command to create the "notes" database.

This script sets up the backend environment for the Flask application, including Dockerizing PostgreSQL, cloning the application repository, configuring environment variables, creating the database, and adjusting configurations.

========================









**Frontend Configuration Brief: Dockerized Flask Application**

**Introduction:**
This section covers the frontend configuration for the Dockerized Flask application. It involves creating build files, setting up the Docker environment, running the application, evaluating its functionality, upgrading to Gunicorn for production, and building a production image.

**Commands Used:**

1. Log in to the Server:
   ```
   ssh cloud_user@<PUBLIC_IP_ADDRESS>
   ```

2. Create Build Files and Inspect Configuration:

   - Change to the notes directory:
     ```
     cd notes
     ```
   - List files:
     ```
     ls -la
     ```
   - Inspect `config.py`:
     ```
     cat config.py
     ```
   - Create `.dockerignore`:
     ```
     vim .dockerignore
     ```
   - Paste the following content and save the file:
     ```
     .dockerignore
     Dockerfile
     .gitignore
     Pipfile.lock
     migrations/
     ```

3. Create Dockerfile:

   - Create Dockerfile:
     ```
     vim Dockerfile
     ```
   - Paste the following content and save the file:
     ```Dockerfile
     FROM python:3
     ENV PYBASE /pybase
     ENV PYTHONUSERBASE $PYBASE
     ENV PATH $PYBASE/bin:$PATH
     RUN pip install pipenv

     WORKDIR /tmp
     COPY Pipfile .
     RUN pipenv lock
     RUN PIP_USER=1 PIP_IGNORE_INSTALLED=1 pipenv install -d --system --ignore-pipfile

     COPY . /app/notes
     WORKDIR /app/notes
     EXPOSE 80
     CMD ["flask", "run", "--port=80", "--host=0.0.0.0"]
     ```

4. Build and Setup Environment:

   - Build notesapp image:
     ```
     docker build -t notesapp:0.1 .
     ```
   - Check image status:
     ```
     docker images
     ```
   - List containers:
     ```
     docker ps -a
     ```
   - List Docker networks:
     ```
     docker network ls
     ```
   - Run container, enable SQLAlchemy, and perform migrations:
     ```
     docker run --rm -it --network notes -v /home/cloud_user/notes/migrations:/app/notes/migrations notesapp:0.1 bash
     flask db init
     flask db migrate
     flask db upgrade
     ```

5. Run, Evaluate, and Upgrade:

   - Run container and access the web application:
     ```
     docker run --rm -it --network notes -p 80:80 notesapp:0.1
     ```
   - Using a web browser, navigate to the public IP address and perform sign-up, log-in, note creation, and editing.

6. Upgrade to Gunicorn:

   - Check Pipfile and modify it:
     ```
     cat Pipfile
     docker run --rm -it -v /home/cloud_user/notes/Pipfile:/tmp/Pipfile notesapp:0.2 bash
     ```
   - Inside the container, add Gunicorn as a dependency:
     ```
     pipenv install gunicorn
     exit
     ```
   - Verify Gunicorn addition in Pipfile:
     ```
     cat Pipfile
     ```
   - Modify `__init__.py` script:
     ```
     vim __init__.py
     ```
   - Add line beneath the import section:
     ```python
     from dotenv import load_dotenv, find_dotenv
     load_dotenv(find_dotenv())
     ```
   - Open Dockerfile and make changes:
     ```
     vim Dockerfile
     ```
   - Add these lines at the bottom:
     ```Dockerfile
     COPY . /app/notes
     WORKDIR /app
     EXPOSE 80
     CMD ["gunicorn", "-b 0.0.0.0:80", "notes:create_app()"]
     ```

7. Build a Production Image:

   - Build the updated image:
     ```
     docker build -t notesapp:0.3 .
     ```
   - Run a detached container using the updated image:
     ```
     docker run -d --name notesapp --network notes -p 80:80 notesapp:0.3
     ```
   - Check the status of the container:
     ```
     docker ps -a
     ```
   - Access the web application and verify its functionality.

**Conclusion:**
This completes the frontend configuration for the Dockerized Flask application. The steps covered include creating build files, setting up the Docker environment, running the application, upgrading to Gunicorn for production, and building a production image.




=================================
PART 2 :


**Building Smaller Images with Multi-Stage Builds**

**Introduction:**
In this project, you will learn about multi-stage builds in Docker, a technique that allows you to create smaller and more efficient container images by optimizing the layers used during the image creation process. This approach is particularly useful for reducing the size of container images and improving resource utilization.

**Commands Used:**

1. Log in to the Server:
   ```
   ssh cloud_user@<PUBLIC_IP_ADDRESS>
   ```

2. Do Prep Work in the Image:

   - Change to the notes directory:
     ```
     cd notes
     ```
   - Check the existing Dockerfile:
     ```
     cat Dockerfile
     ```
   - Build an image using the Dockerfile:
     ```
     docker build -t notesapp:default .
     ```
   - Set variables to view image layers and size:
     ```
     export showLayers='{{ range .RootFS.Layers }}{{ println . }}{{end}}'
     export showSize='{{ .Size }}'
   - Show image layers:
     ```
     docker inspect -f "$showLayers" notesapp:default
     ```
   - Count the number of layers:
     ```
     docker inspect -f "$showLayers" notesapp:default | wc -l
     ```
   - Show the size of the image:
     ```
     docker inspect -f "$showSize" notesapp:default | numfmt --to=iec
     ```

3. Add a Build Stage:

   - Open the Dockerfile for editing:
     ```
     vim Dockerfile
     ```
   - Add the following build stage to the Dockerfile:
     ```Dockerfile
     FROM python:3 AS base
     ENV PYBASE /pybase
     ENV PYTHONUSERBASE $PYBASE
     ENV PATH $PYBASE/bin:$PATH

     FROM base AS builder
     RUN pip install pipenv
     WORKDIR /tmp
     COPY Pipfile .
     RUN pipenv lock
     RUN PIP_USER=1 PIP_IGNORE_INSTALLED=1 pipenv install -d --system --ignore-pipfile

     FROM base
     COPY --from=builder /pybase /pybase
     COPY . /app/notes
     WORKDIR /app/notes
     EXPOSE 80
     CMD ["flask", "run", "--port=80", "--host=0.0.0.0"]
     ```
   - Save the file and exit.

4. Create a Smaller Image:

   - Build the image using the multi-stage Dockerfile:
     ```
     docker build -t notesapp:multistage .
     ```
   - Show the layers of the multistage image:
     ```
     docker inspect -f "$showLayers" notesapp:multistage
     ```
   - Count the layers:
     ```
     docker inspect -f "$showLayers" notesapp:multistage | wc -l
     ```
   - Show the size of the image:
     ```
     docker inspect -f "$showSize" notesapp:multistage | numfmt --to=iec
     ```

**Conclusion:**
You have successfully learned about multi-stage builds in Docker and applied them to reduce the size of a container image. By optimizing the layers used during image creation, you can create more efficient and smaller images, which can lead to resource savings and improved performance.


==================================




==============================


FILE STRUCTURE :

```
.
├── config.py             # Configuration settings for the Flask app, e.g., database configurations.
├── __init__.py           # Initialization script that sets up the Flask app.
├── models.py             # Defines the data models for your application (e.g., database models).
├── Pipfile               # Specifies the Python packages required by your app (dependencies).
├── Pipfile.lock          # Generated lock file that ensures consistent dependency versions.
├── static                # Directory for static files (CSS, JavaScript, etc.) used by the app.
│   ├── app.js             # JavaScript code for the app's front-end functionality.
│   ├── bulma.min.css      # Minified CSS framework (Bulma) for styling the app.
│   ├── highlight.min.css  # Minified CSS for syntax highlighting.
│   ├── highlight.min.js   # Minified JavaScript for syntax highlighting.
│   └── styles.css         # Additional CSS styles for the app.
└── templates             # Directory for HTML templates used to render web pages.
    ├── 404.html           # Template for a "Page Not Found" error page.
    ├── base.html          # Base template containing common structure for other templates.
    ├── log_in.html        # Template for the login page.
    ├── note_create.html   # Template for creating a new note.
    ├── note_index.html    # Template for displaying a list of notes.
    ├── note_update.html   # Template for updating an existing note.
    └── sign_up.html       # Template for user registration.
```


Refrence :
*  https://github.com/qriz1452/ACG/blob/main/learn%20docker%20by%20doing/4%20Automating%20and%20Connecting%20Docker%20Containers/Dockerize%20a%20Flask%20Application.md


* https://github.com/qriz1452/ACG/blob/main/learn%20docker%20by%20doing/4%20Automating%20and%20Connecting%20Docker%20Containers/4%20Building%20Smaller%20Images%20with%20Multi-Stage%20Builds.md

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=========================================================
=========================================================



**Candidate's Response for the Interview: Dockerizing a Flask Application**

**Introduction and Background:**
During my three years of professional experience, I had the opportunity to work on a diverse range of projects that spanned various aspects of software development. One of the notable projects I was involved in was the Dockerization of a Flask application called "Notes." This project aimed to address a specific need within the organization—providing a secure, cost-effective, and privacy-respecting platform for creating and managing notes, thereby replacing the use of third-party applications like Confluence, Quip, or MS Word. The decision to build and deploy our own application was driven by the need for data sovereignty, cost savings, and data privacy concerns.

**Project Overview and Goals:**
The "Notes" project involved the development of a dynamic web application using the Flask framework in Python. The application's primary purpose was to allow users to create, edit, and manage notes in a collaborative and user-friendly environment. To ensure the application's seamless deployment and portability across different environments, we leveraged Docker technology to containerize the entire application along with its dependencies. This approach not only streamlined the deployment process but also enhanced resource utilization and minimized potential compatibility issues.

**Technologies and Tools Used:**
Throughout the project, I utilized a variety of technologies, tools, and platforms to achieve the desired outcomes. Some of the key technologies and tools include:

- **Python and Flask:** The Flask framework in Python was chosen as the foundation for building the dynamic web application due to its simplicity, flexibility, and compatibility with various libraries and extensions.

- **Docker:** Docker played a pivotal role in the project by enabling us to encapsulate the application and its dependencies in lightweight, isolated containers. This approach ensured consistent behavior across development, testing, and production environments.

- **PostgreSQL:** As the chosen database solution, PostgreSQL was used to store and manage the application's data securely.

- **Gunicorn:** To ensure optimal performance in production, we incorporated Gunicorn—a Python WSGI HTTP server—as a way to serve the Flask application.

- **Git:** Throughout the project's lifecycle, Git was instrumental in facilitating version control and collaboration among team members.

- **Amazon Web Services (AWS) CloudFormation:** Another team within the organization handled the deployment aspects using AWS CloudFormation. This orchestration service allowed us to provision and manage the resources required for hosting the application on Amazon Web Services.

- **Vim and Text Editors:** For editing configuration files and scripts within the Docker containers, I utilized text editors like Vim, ensuring efficient development and configuration management.

- **Bulma CSS Framework:** To enhance the application's user interface, I integrated the Bulma CSS framework for responsive and appealing styling.

**Key Commands and Steps:**
Throughout the project, I executed several critical commands and followed specific steps to achieve successful Dockerization and deployment. Here are some key commands and steps I undertook:

1. Cloning the Repository and Environment Setup:
   - Cloned the application repository using Git.
   - Configured environment variables in a `.env` file for database connection and Flask settings.

2. Dockerization and Dockerfile Creation:
   - Created a Dockerfile specifying the base image and dependencies required for the application.
   - Leveraged multi-stage builds to optimize image size and layers.
   - Managed the build context using `.dockerignore` to exclude unnecessary files from the image.

3. PostgreSQL and Docker Networking:
   - Used Docker to pull the PostgreSQL Docker image for the database backend.
   - Created a custom Docker network to facilitate communication between application and database containers.

4. Database Initialization and Migration:
   - Executed SQL commands within the PostgreSQL container to create the necessary database schema.
   - Leveraged Flask-Migrate to manage database migrations and upgrades.

5. Flask Application Deployment:
   - Built the Docker image for the Flask application using `docker build` and tagged versions.
   - Created containers using the built images, configured networking, and exposed the necessary ports.

6. Gunicorn Integration:
   - Upgraded the application to use Gunicorn for production deployment.
   - Modified the Dockerfile to include Gunicorn as the application server.

7. AWS CloudFormation and Deployment:
   - Collaborated with the deployment team to integrate the Dockerized Flask application into the AWS infrastructure using CloudFormation templates.
   - Managed resources such as EC2 instances, security groups, and networking components.

**Project Impact and Learning:**
The Dockerization of the Flask application had a positive impact on the organization by providing an efficient, secure, and cost-effective solution for note management. By successfully encapsulating the application and its dependencies within Docker containers, we achieved consistency across environments and reduced the potential for compatibility issues. Additionally, the utilization of multi-stage builds and proper Dockerfile management led to smaller and optimized container images, enhancing resource efficiency.

Overall, this project highlighted the importance of leveraging containerization technologies like Docker to streamline deployment processes, improve resource utilization, and maintain a consistent development-to-production pipeline. It also emphasized the significance of collaborating with cross-functional teams to ensure successful deployment in cloud environments like AWS.
