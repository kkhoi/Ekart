pipeline {
    agent any
    tools{
        maven 'maven3'
        jdk 'jdk17'
    }
    environment{
        SCANNER_HOME = tool 'sonar-scanner'
    }
    stages {
        stage('Git checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/kkhoi/Ekart.git'
            }
        }
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        stage('Unit test') {
            steps {
                echo 'mvn test -DskipTests=true'
            }
        }
        stage('Sonar Ana') {
            steps {
                withSonarQubeEnv('sonarserver') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=EKART -Dsonar.projectName=EKART \
                    -Dsonar.java.binaries=. '''
                }
            }
        }
        stage('OWASP CD') {
            steps {
                dependencyCheck additionalArguments: ' --scan ./', odcInstallation: 'DC'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn package -DskipTests=true'
            }
        }
        stage('Deploy to Nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'global-maven', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                    sh 'mvn deploy -DskipTests=true'
                }
            }
        }
        stage('Build and Tag docker image') {
            steps {
                script {
                withDockerRegistry(credentialsId: 'dockerhub-cred', toolName: 'docker') {
                    sh "docker build -t khoi2010/ekarrt:latest -f docker/Dockerfile ."
                    }                
                }
            }
            
        }
        stage('Trivy scan') {
            steps {
                sh "trivy image khoi2010/ekarrt:latest > tryvi-report.txt"                
            }
        }
        stage('Push docker image') {
            steps {
                script {
                withDockerRegistry(credentialsId: 'dockerhub-cred', toolName: 'docker') {
                    sh "docker push khoi2010/ekarrt:latest"
                    }                
                }
            }
            
        }
        stage('Kube deploy') {
            steps {
                withKubeConfig(credentialsId: 'k8s-cred', namespace:'webapp', restrictKubeConfigAccess: false, serverUrl: 'https://172.31.32.96:6443') {
                    sh "kubectl apply -f deploymentservice.yml -n webapp"
                    sh "kubectl get svc -n webapp"
            }
        }
    }
}
}
