set :slackistrano,   channel: '#jupiter-notify',
                     webhook: ENV['DEPLOY_SLACK_WEBHOOK'],
                     klass: Capistrano::DeployMessaging
