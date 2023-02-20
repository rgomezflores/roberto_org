pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'master']],
                    userRemoteConfigs: [[url: 'https://github.com/rgomezflores/roberto_org.git']]
                ])
            }
        }
        stage('Install Salesforce CLI') {
            steps {
                bat '''
                    @echo off
                    echo Installing Salesforce CLI...
                    curl https://developer.salesforce.com/media/salesforce-cli/sfdx-windows-latest.zip --output sfdx.zip
                    powershell Expand-Archive -Path sfdx.zip -DestinationPath "%ProgramFiles%\sfdx"
                    setx PATH "%PATH%;%ProgramFiles%/sfdx/bin"
                    echo Salesforce CLI installed successfully.
                '''
            }
        }

        stage('Check Salesforce CLI Installation') {
            steps {
                bat 'sfdx --version'
            }
        }

        stage('Authenticate to Salesforce') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'c3fc289a-7184-482a-aa29-be9d34d6a272')]) {
                    sh 'sfdx force:auth:web:login -u rgomezflores@deloitte.com -p Abcd3fgh!.00'
                }
            }
        }
        // stage('Deploy') {
        //     steps {
        //         sh 'sfdx force:source:deploy -p force-app'
        //     }
        // }
        // stage('Run Tests') {
        //     steps {
        //         sh 'sfdx force:apex:test:run'
        //     }
        // }
    }
}
