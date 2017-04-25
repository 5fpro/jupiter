set :slackistrano,   channel: '#jupiter-notify',
                     webhook: 'https://hooks.slack.com/services/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',
                     klass: Capistrano::DeployMessaging
