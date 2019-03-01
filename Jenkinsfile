pipeline {
  agent none
  stages{
    stage('Build Jar'){
        agent {
          docker {
            image 'maven:3-alpine'
            args '-v /root/.m2:/root/.m2'
          }
        }
        steps {
            sh 'mvn package'
            stash includes: 'target/*.jar', name: 'targetfiles'
        }
    }
    stage('Deploy') {
        agent {
            node {
                label 'DockerDefault'
            }
         }

      steps {
            script{
                unstash 'targetfiles'
                sh 'ls -l -R'
                def image = docker.build("image-name:test", ' .')
            }
      }
    }
  }
}
