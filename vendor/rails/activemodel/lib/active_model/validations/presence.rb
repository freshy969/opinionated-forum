module ActiveModel
  module Validations
    module ClassMethods
      # Validates that the specified attributes are not blank (as defined by Object#blank?). Happens by default on save. Example:
      #
      #   class Person < ActiveRecord::Base
      #     validates_presence_of :first_name
      #   end
      #
      # The +first_name+ attribute must be in the object and it cannot be blank.
      #
      # If you want to validate the presence of a boolean field (where the real values are +true+ and +false+),
      # you will want to use
      #
      #   validates_inclusion_of :field_name, :in => [true, false]
      #
      # This is due to the way Object#blank? handles boolean values:
      #
      #   false.blank? # => true
      #
      # Configuration options:
      # * <tt>:message</tt> - A custom error message (default is: "can't be blank")
      # * <tt>:on</tt> - Specifies when this validation is active (default is <tt>:save</tt>, other options <tt>:create</tt>, <tt>:update</tt>)
      # * <tt>:if</tt> - Specifies a method, proc or string to call to determine if the validation should
      #   occur (e.g. <tt>:if => :allow_validation</tt>, or <tt>:if => Proc.new { |user| user.signup_step > 2 }</tt>).  The
      #   method, proc or string should return or evaluate to a true or false value.
      # * <tt>:unless</tt> - Specifies a method, proc or string to call to determine if the validation should
      #   not occur (e.g. <tt>:unless => :skip_validation</tt>, or <tt>:unless => Proc.new { |user| user.signup_step <= 2 }</tt>).  The
      #   method, proc or string should return or evaluate to a true or false value.
      def validates_presence_of(*attr_names)
        configuration = { :message => ActiveRecord::Errors.default_error_messages[:blank], :on => :save }
        configuration.update(attr_names.extract_options!)

        # can't use validates_each here, because it cannot cope with nonexistent attributes,
        # while errors.add_on_empty can
        send(validation_method(configuration[:on]), configuration) do |record|
          record.errors.add_on_blank(attr_names, configuration[:message])
        end
      end
    end
  end
end