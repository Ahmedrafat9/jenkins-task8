pipeline {
  agent any

  environment {
    AWS_REGION = "us-east-1"
    TF_DIR = "terraform"
    ANSIBLE_DIR = "ansible"
    SSH_PRIVATE_KEY = credentials('jenkins-ssh-key') // stored in Jenkins credentials
  }

  stages {
    stage('Checkout') {
      steps {
        git ''
      }
    }

    stage('Terraform Init & Apply') {
      steps {
        dir("${TF_DIR}") {
          sh 'terraform init'
          sh 'terraform apply -auto-approve'
        }
      }
    }

    stage('Get EC2 IP') {
      steps {
        script {
          def output = sh(script: "cd ${TF_DIR} && terraform output -raw instance_ip", returnStdout: true).trim()
          env.EC2_IP = output
        }
      }
    }

    stage('Create Ansible Inventory') {
      steps {
        writeFile file: "${ANSIBLE_DIR}/inventory.ini", text: """
[ec2]
${env.EC2_IP} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/id_rsa
"""
      }
    }

    stage('Run Ansible Playbook') {
      steps {
        sh """
          ansible-playbook -i ${ANSIBLE_DIR}/inventory.ini ${ANSIBLE_DIR}/playbook.yml
        """
      }
    }
  }

  post {
    always {
      echo 'Pipeline finished.'
    }
  }
}
