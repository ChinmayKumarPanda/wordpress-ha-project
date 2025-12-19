pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = "ap-south-1"
  }

  stages {

    stage('Checkout Code') {
      steps {
        git branch: 'main',
            url: 'https://github.com/ChinmayKumarPanda/wordpress-ha-project.git'
      }
    }

    stage('Terraform Init') {
      steps {
        sh 'terraform init -input=false'
      }
    }

    stage('Terraform Validate') {
      steps {
        sh 'terraform validate'
      }
    }

    stage('Terraform Plan') {
      steps {
        sh 'terraform plan -out=tfplan'
      }
    }

    stage('Terraform Apply') {
      steps {
        sh 'terraform destroy -auto-approve tfplan'
      }
    }
  }
}
