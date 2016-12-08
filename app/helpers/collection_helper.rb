module CollectionHelper
  # @example
  #   filter_menu('roles.role', admin: 'Admin', root: 'Root')
  #
  def filter_menu(param_name, options={})
    options = options.with_indifferent_access
    params  = sanitary_params

    capture do
      content_tag :div, class: 'filter-control-item btn-group' do
        concat content_tag(:div, class: 'btn btn-primary') {
          concat icon 'filter'
          if options[:display_text]
            concat ' '
            concat content_tag(:span, options.delete(:display_text), class: 'filter-label')
          end
        }

        concat content_tag(:button, class: 'btn btn-default dropdown-toggle', type: 'button', data: { toggle: 'dropdown' }) {
          concat options[params[param_name]].presence || 'All'
          concat ' '
          concat content_tag(:span, '', class: 'caret')
        }

        concat content_tag(:ul, class: 'dropdown-menu') {
          options.each do |key, value|
            concat content_tag(:li) { concat link_to value, url_for(params.merge(param_name => key, page: nil)) }
          end
          concat content_tag :li, '', class: 'divider'
          concat content_tag(:li) { concat link_to 'All', url_for(params.merge(param_name => nil, page: nil)) }
        }
      end
    end
  end

  # @example
  #   sort_menu(name: 'Name', 'user.email' => 'Email')
  #
  def sort_menu(options={})
    options = options.with_indifferent_access
    params  = sanitary_params

    capture do
      content_tag(:div, class: 'input-field') {
        if params[:order] == 'desc'
          concat content_tag(:a, class: 'prefix', href: url_for(params.merge(order: 'asc'))) { material_icon 'sort' }
        else
          concat content_tag(:a, class: 'prefix', href: url_for(params.merge(order: 'desc'))) { material_icon 'sort' }
        end

        concat content_tag(:select) {
          options.each do |key, value|
            concat content_tag(:option, value, value: key) # { concat link_to value, url_for(params.merge(sort: key, order: nil, page: nil)) }
          end
        }
      }
    end
  end

  # @example
  #   search_form('Search Users')
  #
  def search_form(placeholder='Search...', url=url_for)
    capture do
      form_tag(url, method: :get, html: { class: 'search' }) {
        concat content_tag(:div, class: 'input-field search') {
          concat search_field_tag :q, params[:q], placeholder: placeholder, class: 'form-control'
          concat label_tag :q, material_icon('search', class: 'prefix')
          concat material_icon :close
        }
      }
    end
  end

  # This does a shitload of magic. It handles sort, order, filter, page and search.
  #
  def filter_scope(scope)
    unpermitted_params = []
    params = sanitary_params.with_indifferent_access

    params[:sort]  ||= 'id'
    params[:order] ||= 'asc'

    params.keys.each do |key|
      relation, column = key.to_s.split('.')
      value = params[key].dup
      negate = value[0] == '!'
      value.slice!(0) if negate
      value = [nil, ''] if value.blank? || value == '!'

      if column.nil?
        column   = relation
        relation = scope.table_name
      end

      table = relation.pluralize

      if scope.connection.table_exists?(table) && scope.connection.column_exists?(table, column)
        if table != scope.table_name
          if scope.reflect_on_association(relation)
            scope = scope.joins(relation.to_sym)
          else
            unpermitted_params << key
          end
        end

        if negate
          scope = scope.where.not("#{table}.#{column}" => value)
        else
          scope = scope.where("#{table}.#{column}" => value)
        end
      end
    end

    if params.include?(:q) or params.include?(:sort)
      sort = params[:sort] ? "#{params[:sort].try(:downcase)} #{params[:order].try(:downcase)}".strip : ''

      if scope.respond_to?(:search_for) && params[:q]
        scope = scope.search_for(params[:q])
      else
        unpermitted_params << 'q' if params[:q]
      end

      scope = scope.order(sort)
    end

    unless params[:page] == 'all' || !scope.respond_to?(:page)
      scope = scope.page(params[:page] || 1)
    end

    raise ActionController::UnpermittedParameters.new(unpermitted_params) if unpermitted_params.any?

    scope
  rescue ScopedSearch::QueryNotSupported => e
    raise ActionController::RoutingError.new(e.message)
  end

  def sanitary_params
    request.params.except(:anchor, :only_path, :trailing_slash, :host, :protocol, :user, :password)
  end
end
