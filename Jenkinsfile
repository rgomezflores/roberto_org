#!groovy

import groovy.json.JsonSlurperClassic

node {

    def SF_CONSUMER_KEY=env.SF_CONSUMER_KEY
    def SF_USERNAME=env.SF_USERNAME
    def SERVER_KEY_CREDENTALS_ID=env.SERVER_KEY_CREDENTALS_ID
    def TEST_LEVEL='RunLocalTests'
    def PACKAGE_NAME='MyPackage'
    def PACKAGE_VERSION
    def SF_INSTANCE_URL = env.SF_INSTANCE_URL ?: "https://login.salesforce.com"

    def toolbelt = tool 'toolbelt'

    // -------------------------------------------------------------------------
    // Parameters
    // -------------------------------------------------------------------------

    parameters {
        string(
            name: 'StartCommit', 
            description: 'Use the SHA considered the Start Commit for your Delta Package'
        )
            string(
            name: 'EndCommit', 
            description: 'Use the SHA considered the End Commit for your Delta Package'
        )
    }
    
    properties([
        parameters([
            string(
                description: 'Use the SHA considered the Start Commit for your Delta Package', 
                name: 'StartCommit'), 
            string(
                description: 'Use the SHA considered the End Commit for your Delta Package', 
                name: 'EndCommit')
            ]
        )
    ])

    // -------------------------------------------------------------------------
    // Check out code from source control.
    // -------------------------------------------------------------------------

    stage('checkout source') {
        checkout scm
    }


    // -------------------------------------------------------------------------
    // Run all the enclosed stages with access to the Salesforce
    // JWT key credentials.
    // -------------------------------------------------------------------------
    
    withEnv(["HOME=${env.WORKSPACE}"]) {
        
        withCredentials([file(credentialsId: SERVER_KEY_CREDENTALS_ID, variable: 'server_key_file')]) {

            // -------------------------------------------------------------------------
            // Authorize the Dev Hub org with JWT key and give it an alias.
            // -------------------------------------------------------------------------

            stage('Authorize DevHub') {
                rc = command "${toolbelt}/sfdx force:auth:jwt:grant --instanceurl ${SF_INSTANCE_URL} --clientid ${SF_CONSUMER_KEY} --username ${SF_USERNAME} --jwtkeyfile ${server_key_file} --setdefaultdevhubusername --setalias HubOrg"
                if (rc != 0) {
                    error 'Salesforce dev hub org authorization failed.'
                }
            }


            // -------------------------------------------------------------------------
            // Install Salesforce CLI
            // -------------------------------------------------------------------------

            stage('Install Salesforce CLI') {
                script {
                    bat 'echo y | npm install sfdx-cli --global'
                }
            }

            // -------------------------------------------------------------------------
            // Verify Salesforce CLI
            // -------------------------------------------------------------------------

            stage('Verify SFDX CLI Installation') {
                rc = command "${toolbelt}/sfdx version"
                if (rc != 0) {
                    error 'Salesforce check version failed.'
                }
            }

            // -------------------------------------------------------------------------
            // Update Salesforce CLI
            // -------------------------------------------------------------------------

            stage('Update SFDX CLI') {
                rc = command "${toolbelt}/sfdx update"
                if (rc != 0) {
                    error 'Salesforce update version failed.'
                }

                rc = command "${toolbelt}/sfdx version"
                if (rc != 0) {
                    error 'Salesforce check version failed.'
                }
            }

            // -------------------------------------------------------------------------
            // Install sfdx-git-delta plugin
            // -------------------------------------------------------------------------

            stage('Install SGD Plugin') {
                script {
                    bat 'echo y | npm install sfdx-git-delta@latest-rc'
                }
            }

            // -------------------------------------------------------------------------
            // Clone Git Repository
            // -------------------------------------------------------------------------

            stage('Clone Git Repository') {
                git branch: 'master', url: 'https://github.com/rgomezflores/roberto_org.git'
            }

            // -------------------------------------------------------------------------
            // Define SHA's
            // -------------------------------------------------------------------------

            stage('Defining SHA') {
                echo "You defined this Start Commit: ${params.StartCommit}"
                echo "You defined this End Commit: ${params.EndCommit}"
            }
        }
    }
}

def command(script) {
    if (isUnix()) {
        return sh(returnStatus: true, script: script);
    } else {
        return bat(returnStatus: true, script: script);
    }
}
