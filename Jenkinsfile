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
                    setx PATH "%PATH%;C:\\Program Files\\sfdx\\bin"
                    "%SFDX%"/sfdx --version
                '''
            }
        }

        stage('Check Salesforce CLI Installation') {
            steps {
                bat '"%SFDX%"/sfdx --version'
            }
        }

        stage('Install SGD Plugin') {
            echo "y"
            "%SFDX%"/echo y | sfdx plugins:install sfdx-git-delta
        }


        stage('Authenticate to Salesforce') {
            steps {
                bat '"%SFDX%"/sfdx force:auth:web:login -r https://login.salesforce.com -a roberto_org'
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
