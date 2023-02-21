pipeline {
    agent any
    
    parameters {
        string(name: 'StartCommit', 
            description: 'Use the SHA considered the Start Commit for your Delta Package' 
        )
        string(name: 'EndCommit',
            description: 'Use the SHA considered the End Commit for your Delta Package', 
        )
        booleanParam(name: 'CheckOnly',
            description: '''Do you require to execute only validation?
            !!IMPORTANT NOTE!! 
            If you do not select this option, you are acceptin to execute the deployment!!
            '''
        )
        booleanParam(name: 'TestClasses',
        description: 'Do you require your execution includes Test Classes?'
        )
        string(name: 'TestClasses_definition',
            description: '''Define the Classes that you will be using in your deployment.
            - Multiple test classes must be seperated by commas.
            - Do not use spaces.
            ''' 
        )
    }

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
            steps {
                echo "You defined this Start Commit: ${params.StartCommit}"
                echo "You defined this End Commit: ${params.EndCommit}"
                echo "You defined this Validation: ${params.Validation_Deployment}"
                echo "You selected this option for Check: ${params.CheckOnly}"
                echo "You selected this option for TestClasses: ${params.TestClasses}"
            }
        }

        stage('Create Delta Packages') {
            steps {
                script {
                    // Authenticate with the org
                    bat '"C:/Program Files/sfdx/bin/"sfdx force:auth:jwt:grant --clientid 3MVG9ux34Ig8G5eqaSrg9EsUR6AjGT27GketsoLUx3Gt4lX2lMQuSRqVgdI_lN_8ljjohKh4Rl61wwY8IdXZk --jwtkeyfile C:/Users/rgomezflores/Documents/RGF/TMNA/JWT/server.key --username rgomezflores@deloitte.com --instanceurl https://login.salesforce.com --setdefaultdevhubusername'
                    // Create the delta package
                    bat '"C:/Program Files/sfdx/bin/"sfdx sgd:source:delta --to "a6a3d70e5cfe800554b27b9aaf45b0dff72fdbe8" --from "587a48df7517a110cb4c382845859f9baaee6715" --output "C:/Users/rgomezflores/Documents/RGF/TMNA/repos/Roberto_ORG/roberto_org/DeltaPackage/" --generate-delta'
                    // bat '"C:/Program Files/sfdx/bin/"sfdx sgd:source:delta --to ${params.EndCommit} --from ${params.StartCommit} --output "C:/Users/rgomezflores/Documents/RGF/TMNA/repos/Roberto_ORG/roberto_org/DeltaPackage/" --generate-delta'
                }
            }
        }

        stage('Execute Deployment in QA') {
            when {
                expression { params.CheckOnly == 'true'}
            }
            steps {
                echo 'You will execute a Validation without TestClasses'
            }
            
            // steps {
            //     script {
            //         if (params.CheckOnly == 'true') {
            //             echo 'You will execute a Validation without TestClasses'
            //         }   else if (params.TestClasses == 'true') {
            //                 echo 'You will execute a Deployment with TestClasses'
            //         }   else {
            //                 echo 'NAA You will execute a Deployment withoy TestClasses'
            //         }
            //     }
            // }
        }
    }
}
