class CustomFormBuilder < ActionView::Helpers::FormBuilder
  
  # field_helpers contains the names of all helper methods and I'm setting rules for the ones I need
  # define_method is used to dynamically create the helper methods I need
  # see my jQuery to handle .stop-autofill which stops browser autofilling text field for the email_address
  # .text-field-error is defined in css to add red border when there are errors
  field_helpers.each do |name|
    case name
    when :text_field, :password_field
      define_method(name) do |method, options = {}|
        #strip .stop-autofill html class to stop email_address being cleared by my jQuery if it is valid but there are other errors present
        if method == :email_address && object.errors.present? && object.errors.messages[:email_address].blank?
          options = { class: "form-control" }
        end
        errors = object.errors[method.to_sym]
        # add red border to error fields by adding .text-field-error
        if errors.present?
          if method == :email_address && object.errors.messages[:email_address].present?
            options = { placeholder: "#{errors.first}", class: "form-control text-field-error stop-autofill" }
          else
            options = { placeholder: "#{errors.first}", class: "form-control text-field-error" }
          end
        end
        super(method, options)
      end
    end
  end

end