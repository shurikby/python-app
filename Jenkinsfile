pipeline {
    agent any
    environment { 
        repository = "shurikby.jfrog.io/final-docker/python-app" 
        registryCredential = 'artifactory' 
        dockerImage = '' 
    }
    stages {
        stage('Build docker image') {
            steps {
                dockerImage = docker.build repository + ":$BUILD_NUMBER" 
            }
        }
        stage('Store image on artifactory') {
            steps {
                docker.withRegistry( 'https://shurikby.jfrog.io/final-docker/', registryCredential ) { 
                    dockerImage.push() 
                }
            }
        }
        stage('Deploy into k8s') {
            steps {
                 echo "Coming soon"
            }
        }
    }
	post{
		success {
			echo "Success"
		}
		failure {
			echo "There was some error"
		} 
		cleanup {
			deleteDir() // cleaning up working directory
		} 
    }
}