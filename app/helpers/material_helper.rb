module MaterialHelper
  def material_icon(icon, options={})
    content_tag :i, icon, class: ['material-icons', options[:class]].flatten.join(' ')
  end
end
