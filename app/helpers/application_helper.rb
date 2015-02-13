module ApplicationHelper
  
  # method to create a customized form_for using my CustomFormBuilder class
  def custom_form_for(record, options = {}, &block)
    form_for(record, options.merge!({builder: CustomFormBuilder}), &block)
  end
  
end
