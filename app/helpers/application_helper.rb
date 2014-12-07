module ApplicationHelper
	def nav_link(link_text, link_path, params={})
		if link_text=='My Lists' && ['todos','lists'].include?(controller.controller_name)
			current_page = true 
		else
			current_page = current_page?(link_path)
		end
		
		li_class = ((params[:li_class] || '') + (current_page ? ' active' : '')).squish
		a_class = params[:a_class]
		method = params[:method]

	  content_tag(:li, :class => li_class) do
	  	link_to link_text, link_path, class: a_class, method: method
	  end
	end

  def glyph(*names)
    content_tag :i, nil, :class => names.map{|name| "glyphicon glyphicon-#{name.to_s.gsub('_','-')}" }
  end
end
