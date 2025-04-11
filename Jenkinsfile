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
        stage('Terraform Outputs') {
            steps {
                sh 'terraform output'
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
                    cd modules/keypair
                    chmod 400 my-ec2-key.pem
        
                    ssh -o StrictHostKeyChecking=no -i my-ec2-key.pem ubuntu@${env.INSTANCE_IP} << EOF
                        sudo apt update -y
                        sudo apt install -y git openjdk-17-jdk maven
        
                        git clone -b spring --single-branch ${APP_REPO}
                        cd mine   # <-- Replace with the actual folder name
        
                        mvn clean package
        
                        nohup java -jar target/*.jar --server.port=9090 > app.log 2>&1 &
                        echo \$! > app.pid
        
                        exit
                    EOF
                """
            }
        }

    }
}
