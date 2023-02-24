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
            description: '''Validation Only?
NOTE: If you do not select this option, the deployment will be executed.
'''
        )
        booleanParam(name: 'TestClasses',
        description: 'Do you need to run the test classes?'
        )
        string(name: 'TestClasses_definition',
            description: '''Define the list of test classes to be run.
- Multiple test classes must be seperated by commas.
- Do not use spaces.
Ex:testclass1,testclass2
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

        stage('Execute Deployment in QA') {
            steps {
                echo '> Executing the Deployment ...'
                bat 'make sfdx-deliver'
            }
        }
    }
}