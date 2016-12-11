module SlackHelper
  def slack_message(message, fields={})
    color = fields.delete(:color) || '#CCC'
    fallback = fields.delete(:fallback) || message

    msg = {
        attachments: [
            {
                fallback: fallback,
                pretext:  message,
                color:    color,
                fields: fields.collect { |k,value| { title: k.humanize, value: slack_escape(value), short: (value.length < 25) } }
            }
        ]
    }

    $slack.ping msg
    msg
  end

  def slackify_exception(e, user=nil, request=nil)
    msg = {
        icon_emoji: ':hankey:',
        attachments: [
            {
                fallback: "#{e.class.name} raised in #{Rails.env}",
                pretext:  "Unhandled exception in #{Rails.env}!",
                color:    '#D92626',
                fields: [
                    {
                        title: 'User',
                        value: slack_escape(user.try(:name) || 'none'),
                        short: true
                    },
                    {
                        title: 'Request IP',
                        value: slack_escape(request.try(:ip) || 'none'),
                        short: true
                    },
                    {
                        title: 'Request URL',
                        value: slack_escape(request.try(:original_url) || 'none'),
                        short: true
                    },
                    {
                        title: slack_escape(e.class.name),
                        value: slack_escape(e.message),
                        short: false
                    },
                    {
                        title: 'Backtrace (top 5 items)',
                        value: slack_escape(e.backtrace.first(5).join("\n")),
                        short: false
                    }
                ]
            }
        ]
    }

    $slack.ping msg
    msg
  end

  def slack_escape(string)
    $slack.escape(string)
  end
end
