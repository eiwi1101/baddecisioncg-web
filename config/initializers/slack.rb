Rails.configuration.x.slack = YAML.load_file("#{Rails.root}/config/slack.yml")[Rails.env]

$slack = Slack::Notifier.new(Rails.configuration.x.slack['webhook_url'],
                             channel: Rails.configuration.x.slack['channel'],
                             username: Rails.configuration.x.slack['username'])
