module ApplicationHelper
  
  def custom_form_for(record, options = {}, &block)
    form_for(record, options.merge!({builder: CustomFormBuilder}), &block)
  end
  
end
