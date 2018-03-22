import groovy.json.JsonOutput

def slackNotificationChannel = 'builds'

def notifySlack(text, channel, attachments) {
    def slackURL = 'https://hooks.slack.com/services/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'
    def jenkinsIcon = 'https://wiki.jenkins-ci.org/download/attachments/2916393/logo.png'

    def payload = JsonOutput.toJson([text: text,
        channel: channel,
        username: "Jenkins",
        icon_url: jenkinsIcon,
        attachments: attachments
    ])

    sh "curl -X POST --data-urlencode \'payload=${payload}\' ${slackURL}"
}

def appImg = null

pipeline {
  agent any

  stages {
      stage('Build Images') {
        steps {
          script{
            appImg = docker.build('robsdudeson/blog-nginx:latest')
          }
        }
      }
      stage('Publish Image To Registry'){
        steps {
          script{
            docker.withRegistry('https://registry.hub.docker.com','hub.docker.com - credentials'){
              appImg.push(env.BRANCH_NAME)

              switch (env.BRANCH_NAME){
                case "master":
                  appImg.push('latest')
                break
                case "develop":
                  appImg.push('latest-develop')
                break
              }
            }
          }
        }
      }
  }
  post {
    success{
      notifySlack("SUCCESS: Job ${env.JOB_NAME} [${env.BUILD_NUMBER}] ${env.BUILD_URL}", slackNotificationChannel, [])
    }
    failure{
      notifySlack("FAILED: Job ${env.JOB_NAME} [${env.BUILD_NUMBER}] ${env.BUILD_URL}", slackNotificationChannel, [])
    }
  }
}
