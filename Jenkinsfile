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
        stage('Deploy into canary') {
            when { branch 'canary'}
            steps {
                script {
                    withKubeConfig([credentialsId: 'kubectl', serverUrl: 'https://192.168.1.16:6443']) {
                        sh '''
                            envsubst < k8s/deploy.yaml | kubectl apply -f -
                            export WEIGHT_CANARY=100
                            export WEIGHT_MAIN=0
                            envsubst < k8s/ingress.yaml | kubectl apply -f - 
                        '''
                    }
                }
            }
        }
        stage('Deploy into production') {
            when { branch 'main'}
            steps {
                script {
                    withKubeConfig([credentialsId: 'kubectl', serverUrl: 'https://192.168.1.16:6443']) {
                        sh '''
                            envsubst < k8s/deploy.yaml | kubectl apply -f -
                            export WEIGHT_CANARY=100
                            export WEIGHT_MAIN=0
                            envsubst < k8s/ingress.yaml | kubectl apply -f -  
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