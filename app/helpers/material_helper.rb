module MaterialHelper
  def material_icon(icon)
    content_tag :i, icon, class: 'material-icons'
  end
end
