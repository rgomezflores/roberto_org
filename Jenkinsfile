#!groovy

import groovy.json.JsonSlurperClassic

node {

    def SF_CONSUMER_KEY=env.SF_CONSUMER_KEY
    def SF_USERNAME=env.SF_USERNAME
    def SF_PASSWORD=env.SF_PASSWORD
    def SERVER_KEY_CREDENTALS_ID=env.SERVER_KEY_CREDENTALS_ID
    def SF_INSTANCE_URL = env.SF_INSTANCE_URL ?: "https://login.salesforce.com"

    // -------------------------------------------------------------------------
    // Connect Slaesforce ORG
    // -------------------------------------------------------------------------

  stages {
    stage('Connect to Salesforce Org') {
      steps {
        withCredentials([[
          $class: 'UsernamePasswordMultiBinding',
          credentialsId: 'salesforce-creds',
          usernameVariable: 'SF_USERNAME',
          passwordVariable: 'SF_PASSWORD'
        ]]) {
          sh "sfdx force:auth:web:login -u $SF_USERNAME -p $SF_PASSWORD -r $SF_INSTANCE_URL"
        }
      }
    }

    // -------------------------------------------------------------------------
    // Install Slaesforce CLI
    // -------------------------------------------------------------------------

    stage('Install Salesforce CLI') {
      steps {
        sh 'sfdx plugins:install salesforcedx@latest'
      }
    }

    // -------------------------------------------------------------------------
    // Install sfdx-git-delta plugin
    // -------------------------------------------------------------------------

    stage('Install SGD PLugin') {
      steps {
        script {
          bat 'echo y | sfdx plugins:install sfdx-git-delta'
        }
      }
    }

    // -------------------------------------------------------------------------
    // Clone Git Repository
    // -------------------------------------------------------------------------

    stage('Clone Git Repository') {
      steps {
        git branch: 'master', url: 'https://github.com/rgomezflores/roberto_org.git'
      }
    }
