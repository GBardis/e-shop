module ApplicationHelper
  def page_header(text)
    content_for(:page_header) { text.to_s }
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, params.merge(sort: column, direction: direction).permit!, class: css_class
  end
end
def meta_og_tags(properties = {})
  return unless properties.is_a? Hash

  tags = []

  properties.each do |property, value|
    tags << tag(:meta, property: "og:#{property}", content: value)
  end

  tags.join.html_safe  # Remember in Ruby the last line is returned
end
