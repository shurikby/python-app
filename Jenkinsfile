pipeline {
    agent any
    environment { 
        repository = "shurikby.jfrog.io/final-docker/python-app" 
        registryCredential = 'artifactory' 
        dockerImage = '' 
    }
    stages {
        stage('Test network') {
            steps {
                 sh ("echo 'nameserver 8.8.8.8' > /etc/resolv.conf")
            }
        }
        stage('Build docker image') {
            steps {
                script {
                    dockerImage = docker.build repository + ":$BUILD_NUMBER" 
                }
            }
        }
        stage('Store image on artifactory') {
            steps {
                script {
                    docker.withRegistry( 'https://shurikby.jfrog.io/final-docker/', registryCredential ) { 
                        dockerImage.push() 
                    }
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