pipeline {
  agent none

   environment {
    image_name = "artifactory.corp.planetway.com:443/docker-virtual/my-app"
    registryCredential = 'svc.artifactory_deploy'
    GIT_COMMIT = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
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
          dockerImage = docker.build image_name + ":${GIT_COMMIT}"
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry('https://' + image_name, registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
  }
}