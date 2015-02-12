class CustomFormBuilder < ActionView::Helpers::FormBuilder
  
  # field_helpers contains the names of all helper methods and I'm setting rules for the ones I need
  # define_method is used to dynamically create the helper methods I need
  field_helpers.each do |name|
    case name
    when :text_field, :email_field, :password_field
      define_method(name) do |method, options = {}|
        errors = object.errors[method.to_sym]
        if errors.present?
          options = { placeholder: "#{errors.first}", value: '', class: "form-control text-field-error" }
        end
        super(method, options)
      end
    end
  end

end
