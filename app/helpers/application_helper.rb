module ApplicationHelper
	def nav_link(link_text, link_path, params={})
		li_class = ((params[:li_class] || '') + (current_page?(link_path) ? ' active' : '')).squish
		a_class = params[:a_class]
		method = params[:method]

	  content_tag(:li, :class => li_class) do
	  	link_to link_text, link_path, class: a_class, method: method
	  end
	end
end
