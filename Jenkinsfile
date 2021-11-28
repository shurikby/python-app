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
                    docker.withRegistry('https://shurikby.jfrog.io', 'artifactory' ) { 
                        dockerImage.push("$BUILD_NUMBER") 
                        dockerImage.push("latest") 
                    }
                }
            }
        }
        stage('Deploy into k8s') {
            steps {
                script {
                    withKubeConfig([credentialsId: 'kubectl', serverUrl: 'https://192.168.1.16:6443']) {
                        sh 'cat Deployment.yaml | sed "s/{{BUILD_NUMBER}}/${BUILD_NUMBER:=1}/g" | kubectl apply -f -'
                    }
                }
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