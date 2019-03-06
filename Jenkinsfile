pipeline {
  agent none

  environment {
    imageName = "artifactory.corp.planetway.com:443/docker-virtual/my-app"
    registryCredential = 'svc.artifactory_deploy'
  }

  stages {
    stage('Maven Test') {
      agent {
        docker {
          image 'maven:3-alpine'
          args '-v /root/.m2:/root/.m2'
        }
      }
      steps {
        sh 'mvn test'
      }
        post {
            always {
                junit 'target/surefire-reports/*.xml'
            }
        }
    }
    stage('Maven Install') {
      agent {
        docker {
          image 'maven:3-alpine'
          args '-v /root/.m2:/root/.m2'
        }
      }
      steps {
        sh 'mvn clean install'
        stash includes: 'target/*.jar', name: 'targetfiles'
      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build(imageName + ":${git log -n 1 --pretty=format:'%h'}")
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry('https://' + imageName, registryCredential) {
            dockerImage.push()
          }
        }
      }
    }
  }
}