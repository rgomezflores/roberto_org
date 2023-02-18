pipeline {

  environment {
    SF_USERNAME = "rgomezflores@deloite.com"
    SERVER_KEY_CREDENTALS_ID = "c3fc289a-7184-482a-aa29-be9d34d6a272"
    SF_PASSWORD = "Abcd3gh!.00"
    SF_INSTANCE_URL = "https://login.salesforce.com"
  }

  agent any

  stages {

    // -------------------------------------------------------------------------
    // Connect Slaesforce ORG
    // -------------------------------------------------------------------------

    stage('Connect to Salesforce Org') {
      steps {
        withCredentials([[
          $class: 'UsernamePasswordMultiBinding',
          credentialsId: 'SERVER_KEY_CREDENTALS_ID',
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
  }
}