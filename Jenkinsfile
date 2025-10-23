pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-access-key')
        AWS_DEFAULT_REGION    = 'us-west-2'
        APP_REPO              = 'https://github.com/aslindhurai-cs/mine.git'
        GITHUB_USERNAME       = 'aslindhurai-cs'
        GITHUB_TOKEN          = credentials('github-pat-token-id')
        TF_IN_AUTOMATION      = '1'
        TF_INPUT              = '0'
    }

    options {
        timestamps()
        ansiColor('xterm')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Fmt (check)') {
            steps {
                sh 'terraform fmt -check -recursive'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh '''
                  terraform init
                  terraform validate
                '''
            }
        }

        stage('Lint and Security') {
            steps {
                sh '''
                  if command -v tflint >/dev/null 2>&1; then
                    tflint --init
                    tflint
                  else
                    echo "TFLint not installed; skipping."
                  fi

                  if command -v tfsec >/dev/null 2>&1; then
                    tfsec --soft-fail
                  else
                    echo "tfsec not installed; skipping."
                  fi
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan.binary'
                sh 'terraform show -no-color tfplan.binary > tfplan.txt'
                archiveArtifacts artifacts: 'tfplan.txt', fingerprint: true
            }
        }

        stage('Manual Approval') {
            steps {
                input message: "Review tfplan.txt artifact. Approve to apply?"
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan.binary'
            }
        }

        stage('Terraform Outputs') {
            steps {
                sh 'terraform output'
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

                    ssh -o StrictHostKeyChecking=no -i my-ec2-key.pem ubuntu@${env.INSTANCE_IP} << 'EOF'
                        set -euo pipefail
                        sudo apt update -y
                        sudo apt install -y git openjdk-17-jdk maven

                        git clone -b spring --single-branch https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@github.com/aslindhurai-cs/mine.git

                        cd mine
                        mvn -B -DskipTests=false clean package

                        # Stop any existing instance
                        if [ -f app.pid ] && kill -0 \$(cat app.pid) 2>/dev/null; then
                          kill \$(cat app.pid) || true
                          sleep 2
                        fi

                        nohup java -jar target/*.jar --server.port=9090 > app.log 2>&1 &
                        echo \$! > app.pid
                    EOF
                """
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'tfplan.txt, app.log', allowEmptyArchive: true
        }
    }
}
