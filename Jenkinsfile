pipeline {
    agent any
    
    parameters([
        string(
            description: 'Use the SHA considered the Start Commit for your Delta Package', 
            name: 'StartCommit'), 
        string(
            description: 'Use the SHA considered the End Commit for your Delta Package', 
            name: 'EndCommit'),
        extendedChoice(
            description: 'Select your best option',  
            multiSelectDelimiter: 'A,B,C,D', 
            name: 'Validation_Deployment', 
            quoteValue: true, 
            saveJSONParameterToFile: false, 
            type: 'PT_MULTI_SELECT', 
            value: '"ValueA","ValueB","ValueC","ValueD"', 
            visibleItemCount: 4
        )
    ])

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
                    bat 'echo y | "C:/Program Files/sfdx/bin/"sfdx plugins:install sfdx-git-delta@latest-rc'
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

        stage('Parameters Values') {
            echo "You defined this Start Commit: ${params.StartCommit}"
            echo "You defined this End Commit: ${params.EndCommit}"
            echo "You defined this Validation: ${params.Validation_Deployment}"
            }

        stage('Create Delta Packages') {
            steps {
                // Authenticate with the org
                bat '"C:/Program Files/sfdx/bin/"sfdx force:auth:jwt:grant --clientid 3MVG9ux34Ig8G5eqaSrg9EsUR6AjGT27GketsoLUx3Gt4lX2lMQuSRqVgdI_lN_8ljjohKh4Rl61wwY8IdXZk --jwtkeyfile C:/Users/rgomezflores/Documents/RGF/TMNA/JWT/server.key --username rgomezflores@deloitte.com --instanceurl https://login.salesforce.com --setdefaultdevhubusername'
                // Create the delta package
                // bat '"C:/Program Files/sfdx/bin/"sfdx sgd:source:delta --to "a6a3d70e5cfe800554b27b9aaf45b0dff72fdbe8" --from "587a48df7517a110cb4c382845859f9baaee6715" --output "C:/Users/rgomezflores/Documents/RGF/TMNA/repos/Roberto_ORG/roberto_org/DeltaPackage/" --generate-delta'
                bat '"C:/Program Files/sfdx/bin/"sfdx sgd:source:delta --to $(params.EndCommit) --from $(params.StartCommit) --output ""C:/Users/rgomezflores/Documents/RGF/TMNA/repos/Roberto_ORG/roberto_org/DeltaPackage/" --generate-delta'
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
