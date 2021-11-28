pipeline {
    agent any
    environment { 
        repository = "shurikby.jfrog.io/final-docker/python-app" 
        dockerImage = '' 
    }
    stages {
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
                    withCredentials([usernamePassword( credentialsId: 'artifactory', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        docker.withRegistry('https://shurikby.jfrog.io', 'artifactory' ) { 
                            sh "docker login https://shurikby.jfrog.io -u ${USERNAME} -p ${PASSWORD}"
                            dockerImage.push() 
                        }
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