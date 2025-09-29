# java-deploy-automation

Java Build & Deployment Automation 🚀
This project automates the build and deployment of Java applications using Bash, Maven, and Apache Tomcat. It is designed as a DevOps mini-project to showcase automation, environment configuration, logging, and CI/CD integration.

Features
•	Automated build & deploy — packages Java applications with Maven and deploys them to Tomcat
•	Environment-aware configs — separate settings for Dev, Test, and Prod environments
•	Logging & error handling — all steps are timestamped and saved to log files
•	Cron integration — schedule automated deployments at specific times
•	Jenkins-ready — easily extendable into a CI/CD pipeline

Prerequisites
Make sure you have the following installed:
•	Linux (Ubuntu, CentOS, or Amazon Linux EC2)
•	Java 11+
•	Maven
•	Apache Tomcat
Example (Amazon Linux 2):
sudo yum install java-11-openjdk maven git -y

Download and extract Tomcat:
wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.91/bin/apache-tomcat-9.0.91.tar.gz
tar -xvzf apache-tomcat-9.0.91.tar.gz
sudo mv apache-tomcat-9.0.91 /opt/tomcat
chmod +x /opt/tomcat/bin/*.sh


Project Structure

java-deploy-automation/
│── deploy.sh             # Main Bash deployment script
│── configs/
│    ├── dev.env          # Dev environment config
│    ├── test.env         # Test environment config
│    └── prod.env         # Prod environment config
│── README.md             # Project documentation

Usage
1. Clone the Repo:
git clone https://github.com/danizzy/java-deploy-automation.git
cd java-deploy-automation

2. Run Deployment Script:
./deploy.sh dev   # For Dev
./deploy.sh test  # For Test
./deploy.sh prod  # For Prod

3. Access the Application:
http://<server-ip>:8080/<app-name>


Automating with Cron
Example: Run Test deployment daily at 1 AM:
0 1 * * * /home/ec2-user/java-deploy-automation/deploy.sh test >> /var/log/deploy_test_cron.log 2>&1

   
Jenkins Integration

Example Jenkins Pipeline (Jenkinsfile):

pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/danizzy/java-deploy-automation.git'
            }
        }
        stage('Deploy to Dev') {
            steps {
                sh './deploy.sh dev'
            }
        }
        stage('Deploy to Test') {
            steps {
                sh './deploy.sh test'
            }
        }
        stage('Deploy to Prod') {
            steps {
                input "Deploy to Production?"
                sh './deploy.sh prod'
            }
        }
    }
}

Future Improvements
•	Rollback support (restore last working WAR if deployment fails)
•	Dockerize Tomcat + Maven for container-based deployment
•	Extend pipeline with AWS services (EC2, S3, CodeDeploy)

Learning Outcomes
•	Bash scripting for automation
•	Maven build management
•	Tomcat application server deployment
•	Scheduling with cron
•	CI/CD concepts with Jenkins


Author
👨‍💻 Author: Your Name (https://github.com/danizzy)
