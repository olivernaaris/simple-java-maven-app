pipeline {
  agent none

   environment {
    image_name = "artifactory.corp.planetway.com:443/docker-virtual/my-app"
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
        GIT_COMMIT_HASH = sh (script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
        dockerImage = docker.build registry + ":${GIT_COMMIT_HASH}"
      }
    }
    stage('Deploy Image') {
      steps{
        docker.withRegistry('https://' + registry, registryCredential ) {
          dockerImage.push()
        }
      }
    }
  }
}