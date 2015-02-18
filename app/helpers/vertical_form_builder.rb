class VerticalFormBuilder < ActionView::Helpers::FormBuilder
  
  def label(method, text = nil, options = {}, &block)
    binding.pry
    errors = object.errors[method.to_sym]
    if errors.present?
      text += " <span class=\"error\">#{errors.first}</span>"
    end
    super(method, text.html_safe, options, &block)
  end
  
end