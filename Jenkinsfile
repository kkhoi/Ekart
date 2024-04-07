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
                withDockerRegistry(credentialsId: 'dockerhub-cred', toolNamw: 'docker') {
                    sh "docker build -t kkhoi/ekarrt:lastest -f docker/Dockerfile ."
                }                
            }
        }
    }
}
