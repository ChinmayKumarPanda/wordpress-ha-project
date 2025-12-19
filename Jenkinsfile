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
        sh '''
        cd terraform
        terraform init -input=false
        '''
      }
    }

    stage('Terraform Validate') {
      steps {
        sh '''
        cd terraform
        terraform validate
        '''
      }
    }

    stage('Terraform Plan') {
      steps {
        sh '''
        cd terraform
        terraform plan -out=tfplan
        '''
      }
    }

    stage('Terraform Apply') {
      steps {
        sh '''
        cd terraform
        terraform apply -auto-approve tfplan
        '''
      }
    }
  }
}
