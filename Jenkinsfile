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
                echo '> Checking out the Git version control ...'
                bat 'make checkout'
            }
        }

        stage('Install Salesforce CLI') {
            steps {
                echo '> Installing Salesforce CLI ...'
                bat 'make install-sfdxcli'
            }
        }

        stage('Check Salesforce CLI Installation') {
            steps {
                echo '> Checking and Updating Salesforce CLI ...'
                bat 'make check-sfdx'
            }
        }

        stage('Install SGD Plugin') {
            steps {
                echo '> Installing SGD Plugin ...'
                bat 'make install-sgd-plugin'
            }
        }

        stage('Create Delta Packages') {
            steps {
                echo '> Create Delta PAckages ...'
                bat 'make create-deltaPackage'
            }
        }

        stage('Conditionals') {
            steps {
                echo '> Executing the Conditionals ...'
                bat 'make validation1'
            }
        }

        stage('Execute Deployment in QA') {
            steps {
                echo '> Executing the Deployment ...'
                bat 'make validation1'
                bat 'make sfdx-deliver'
            }
        }
    }
}