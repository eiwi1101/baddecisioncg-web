module ApplicationHelper
  def toast(level_or_hash=:notice, message='', options={})
    if level_or_hash.is_a? Hash
      message = level_or_hash.values.first
      level_or_hash = level_or_hash.keys.first
    end

    flash_map = {
        notice: 'green',
        info:   'blue',
        warn:   'yellow',
        error:  'red'
    }

    klass = flash_map[level_or_hash.to_sym] || level_or_hash.to_s

    if options[:no_wrapper]
      <<-JAVASCRIPT.html_safe
        Materialize.toast("#{escape_javascript message}", 5000, "#{klass}")
      JAVASCRIPT
    else
      <<-HTML.html_safe
        <script type="text/javascript">
            Materialize.toast("#{escape_javascript message}", 5000, "#{klass}")
        </script>
      HTML
    end
  end

  def body_class(klass)
    content_for(:body_class, klass)
  end

  def no_side_nav
    content_for(:no_side_nav, true)
  end
end
