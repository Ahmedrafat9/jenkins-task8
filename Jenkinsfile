pipeline {
  agent any

  environment {
    AWS_REGION = "us-east-1"
    TF_DIR = "terraform"
    ANSIBLE_DIR = "ansible"
    SSH_PRIVATE_KEY = credentials('blogkey')  // your SSH private key credential ID
    ANSIBLE_HOST_KEY_CHECKING = 'False'
  }

  stages {
    stage('Terraform Apply') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          dir("${TF_DIR}") {
            sh '''
              export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
              export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
              export AWS_REGION=${AWS_REGION}

              terraform init
              terraform apply -auto-approve
            '''
          }
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
        sh 'ansible-playbook -i ansible/inventory.ini ansible/playbook.yml'
      }
    }
  }

  post {
    always {
      echo 'Pipeline finished.'
    }
  }
}
