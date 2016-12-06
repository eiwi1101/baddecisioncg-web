module SlackHelper
  def self.attachment(pretext, title, message, color='good')
    {
        fallback: pretext,
        pretext:  pretext,
        color:    color,
        fields: [{
            title: title,
            value: message,
            short: false
        }]
    }
  end

  def self.build_message(fallback, message=fallback, color='#070', fields={})
    {
        attachments: [
            {
                fallback: fallback,
                pretext:  message,
                color:    color,
                fields: fields.collect { |k,value| { title: k, value: escape(value), short: (value.length < 25) } }
            }
        ]
    }
  end

  def self.slackify_exception(e, user=nil, request=nil)
    {
        icon_emoji: ':hankey:',
        attachments: [
            {
                fallback: "#{e.class.name} raised in #{Rails.env}",
                pretext:  "Unhandled exception in #{Rails.env}!",
                color:    '#D92626',
                fields: [
                    {
                        title: 'User',
                        value: escape(user.try(:name) || 'none'),
                        short: true
                    },
                    {
                        title: 'Request IP',
                        value: escape(request.try(:ip) || 'none'),
                        short: true
                    },
                    {
                        title: 'Request URL',
                        value: escape(request.try(:original_url) || 'none'),
                        short: true
                    },
                    {
                        title: escape(e.class.name),
                        value: escape(e.message),
                        short: false
                    },
                    {
                        title: 'Backtrace (top 5 items)',
                        value: escape(e.backtrace.first(5).join("\n")),
                        short: false
                    }
                ]
            }
        ]
    }
  end

  def self.escape(string)
    $slack.escape(string)
  end
end
