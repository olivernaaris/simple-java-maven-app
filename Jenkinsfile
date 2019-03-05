pipeline {
  agent none
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
    stage('Docker Build and Push') {
      agent any
      steps {
        script{
          unstash 'targetfiles'
          sh 'ls -l -R'
          GIT_COMMIT_HASH = sh (script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
          def image = docker.build("artifactory.corp.planetway.com:443/docker-virtual/my-app:${GIT_COMMIT_HASH}", ' .')
          image.push()
        }
      }
    }
  }
}