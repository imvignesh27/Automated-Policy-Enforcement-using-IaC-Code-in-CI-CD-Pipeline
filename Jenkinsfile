pipeline {
 agent any
   environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
   }
 stages {

  stage('Checkout') {
   steps {
    git 'https://github.com/imvignesh27/Automated-Policy-Enforcement-using-IaC-Code-in-CI-CD-Pipeline.git'
   }
  }

  stage('Terraform Init') {
   steps {
    sh 'terraform init'
   }
  }

  stage('Terraform Apply') {
   steps {
    sh 'terraform apply -auto-approve'
   }
  }

  stage('CIS Scan') {
   steps {
    sh 'checkov -d .'
   }
  }

  stage('Remediation') {
   steps {
    sh 'terraform apply -auto-approve'
   }
  }

 }
}
