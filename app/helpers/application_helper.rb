module ApplicationHelper
  def alert(level_or_hash=:notice, message='')
    if level_or_hash.is_a? Hash
      message = level_or_hash.values.first
      level_or_hash = level_or_hash.keys.first
    end

    flash_map = {
        notice: 'success',
        info:   'info',
        warn:   'warning',
        error:  'danger'
    }

    klass = flash_map[level_or_hash.to_sym] || level_or_hash.to_s

    content_tag :div, message, class: 'alert alert-' + klass
  end
end
