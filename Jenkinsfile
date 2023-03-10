node {

    stage('Code Checkout') {
        git branch: 'main', url: 'https://github.com/Zabii-Shaik/CI-CD-using-K8s.git'
    }
    stage('Sending Dockerfile to Ansible Server over SSH') {
        sshagent(['Jenkins-Ansible_ssh']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.32.50'
            sh 'scp /var/lib/jenkins/workspace/ci_cd/* ubuntu@172.31.32.50:/home/ubuntu'
        } 
    }
    stage('Building the Docker Image') {
        sshagent(['Jenkins-Ansible_ssh']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.32.50 cd /home/ubuntu'
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.32.50 docker image build -t $JOB_NAME:v1.$BUILD_ID .'
        }
    }
    stage('Docker Image Tagging') {
        sshagent(['Jenkins-Ansible_ssh']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.32.50 cd /home/ubuntu'
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.32.50 docker image tag $JOB_NAME:v1.$BUILD_ID c5b782b0f4c5/$JOB_NAME:v1.$BUILD_ID'
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.32.50 docker image tag $JOB_NAME:v1.$BUILD_ID c5b782b0f4c5/$JOB_NAME:latest'
        }
    }
    stage('Push Docker Images to DockerHub') {
        sshagent(['Jenkins-Ansible_ssh']) {
            withCredentials([string(credentialsId: 'DokcerHub_Login_Creds', variable: 'DokcerHub_Login_Creds')]) {
                sh "ssh -o StrictHostKeyChecking=no ubuntu@172.31.32.50 docker login -u c5b782b0f4c5 -p ${DokcerHub_Login_Creds}"
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.32.50 docker image push c5b782b0f4c5/$JOB_NAME:v1.$BUILD_ID'
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.32.50 docker image push c5b782b0f4c5/$JOB_NAME:latest'
            }
        }
    }
    stage('Copying files from Ansible to K8s') {
        sshagent(['Jenkins-Ansible_ssh']) {
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.11.14'
                sh 'scp /var/lib/jenkins/workspace/ci_cd/* ubuntu@172.31.11.14:/home/ubuntu'
            }
    }
    stage('K8s Deployment using Ansible') {
        sshagent(['Jenkins-Ansible_ssh']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.32.50'
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.32.50 ansible-playbook Ansible_Playbook.yml'
        }
    
    }
}
