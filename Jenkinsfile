pipeline {
    agent any

    environment {
        // Replace with your actual DockerHub username
        DOCKER_IMAGE = 'kousickd/trend-store-app'
        DOCKER_CRED_ID = 'dockerhub-credentials'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Fetching source code from Git repository...'
                git branch: 'main', url: 'https://github.com/kousick-devaraj/trend-store-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker Image from pre-built dist folder...'
                    // Builds container exposing Nginx default port 80 internally
                    dockerImage = docker.build("${DOCKER_IMAGE}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                script {
                    echo 'Publishing image to DockerHub...'
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_CRED_ID}") {
                        dockerImage.push("${BUILD_NUMBER}")
                        dockerImage.push("latest")
                    }
                }
            }
        }

        stage('Deploy to AWS EKS') {
            steps {
                script {
                    echo 'Updating K8s deployment file with new image tag...'
                    // Replace image placeholder with actual build number
                    sh "sed -i 's|kousickd/trend-store-app:BUILD_NUMBER|${DOCKER_IMAGE}:${BUILD_NUMBER}|g' k8s/deployment.yaml"
                    
                    echo 'Applying Kubernetes Manifests...'
                    sh "kubectl apply -f k8s/deployment.yaml"
                    sh "kubectl apply -f k8s/service.yaml"
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully and application deployed to EKS!'
        }
        failure {
            echo 'Pipeline failed. Check build logs for details.'
        }
    }
}
