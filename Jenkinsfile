pipeline {
    agent any
    environment { 
        repository = "shurikby.jfrog.io/final-docker/python-app/$BRANCH_NAME" 
        dockerImage = '' 
    }
    stages {
        stage('Configure app') {
            steps {
                sh 'sed -i -e "s/{{BUILD_NUMBER}}/${BUILD_NUMBER:=1}/g" application/demo/views.py'
                sh 'sed -i -e "s/{{BRANCH_NAME}}/${BRANCH_NAME}/g" application/demo/views.py'
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
                    docker.withRegistry('https://shurikby.jfrog.io', 'artifactory' ) { 
                        dockerImage.push("$BUILD_NUMBER") 
                        dockerImage.push("latest") 
                    }
                }
            }
        }
        stage('Prepare cluster enviroment') {
            steps {
                script {
                    withKubeConfig([credentialsId: 'kubectl', serverUrl: 'https://192.168.1.16:6443']) {
                        sh 'kubectl apply -f k8s/env-prep.yaml'
                    }
                }
            }
        }
        stage('Deploy application') {
            steps {
                script {
                    withKubeConfig([credentialsId: 'kubectl', serverUrl: 'https://192.168.1.16:6443']) {
                        sh 'envsubst < k8s/deploy.yaml | kubectl apply -f -'
                    }
                }
            }
        }
        stage('Configure ingress') {
            steps {
                script {
                    withKubeConfig([credentialsId: 'kubectl', serverUrl: 'https://192.168.1.16:6443']) {
                        sh '''
                            if [ "$BRANCH_NAME" == "canary" ]; then export WEIGHT=20
                            else WEIGHT=0 fi
                            envsubst < k8s/ingress.yaml | kubectl apply -f -  
                            fi
                        '''
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
