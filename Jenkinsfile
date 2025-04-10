pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-access-key')
        AWS_DEFAULT_REGION = 'us-west-2'
        APP_REPO = 'https://github.com/aslindhurai-cs/mine.git'   // Replace with your GitHub repo
    }

    stages {
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Approve to apply?"
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Fetch IP') {
            steps {
                script {
                    env.INSTANCE_IP = sh(script: "terraform output -raw instance_ip", returnStdout: true).trim()
                    echo "Fetched Instance IP: ${env.INSTANCE_IP}"
                }
            }
        }

        stage('Access EC2 and Deploy App') {
            steps {
                sh """
                    chmod 400 my-ec2-key.pem

                    ssh -o StrictHostKeyChecking=no -i my-ec2-key.pem ubuntu@${INSTANCE_IP} << EOF
                      # Update packages
                      sudo apt update -y
                      sudo apt install -y git openjdk-17-jdk maven

                      # Clone the app repo
                      git clone -b spring --single-branch ${APP_REPO}
                      cd mine   # <-- Replace with your real project folder name

                      # Build the application
                      mvn clean package

                      # Run the JAR on port 9090 in background
                      nohup java -jar target/*.jar --server.port=9090 > app.log 2>&1 &

                      # Save process ID (optional but good)
                      echo $! > app.pid
                      exit
                    EOF
                """
            }
        }
    }
}
