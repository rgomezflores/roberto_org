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
                bat '"%SFDX%"/sfdx plugins'
            }
        }

        stage('Install SGD Plugin') {
            steps {
                script {
                    bat 'echo y | "C:/Program Files/sfdx/bin/"sfdx plugins:install sfdx-git-delta -v'
                }
                bat '"%SFDX%"/sfdx plugins'
            }
        }

        stage('Create Directory') {
            steps {
                bat 'cd C:/Users/rgomezflores/Documents/RGF/TMNA/repos/Roberto_ORG/roberto_org/'
                dir ('C:/Users/rgomezflores/Documents/RGF/TMNA/repos/Roberto_ORG/roberto_org/DeltaPackage') {
                    writeFile file:'.ignore', text:''
                }
            }
        }

        stage('Create Delta Packages') {
            steps {
                // Authenticate with the org
                bat '"C:/Program Files/sfdx/bin/"sfdx force:auth:jwt:grant -u rgomezflores@deloitte.com -f C:/Users/rgomezflores/Documents/RGF/.ssh/ -i id_rsa  --setdefaultdevhubusername'
                // Create the delta package
                bat '"C:/Program Files/sfdx/bin/"sfdx sgd:source:delta --to "a6a3d70e5cfe800554b27b9aaf45b0dff72fdbe8" --from "587a48df7517a110cb4c382845859f9baaee6715" --output "C:/Users/rgomezflores/Documents/RGF/TMNA/repos/Roberto_ORG/roberto_org/DeltaPackage/" --generate-delta'

                // bat '"C:/Program Files/sfdx/bin/"sfdx sgd:source:delta --to $(params.EndCommit) --from $(params.StartCommit) --output "./DeltaPackage" --generate-delta'
            }
        }


        // stage('Authenticate to Salesforce') {
        //     steps {
        //         bat '"%SFDX%"/sfdx force:auth:web:login -r https://login.salesforce.com -a roberto_org'
        //     }
        // }
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
