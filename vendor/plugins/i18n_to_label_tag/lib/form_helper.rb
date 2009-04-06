module ActionView
  module Helpers
    class InstanceTag
      def to_label_tag_with_i18n(text = nil, options = {})
        if text.blank?
          return to_label_tag_without_i18n(object.class.respond_to?(:human_attribute_name) ? object.class.human_attribute_name(method_name) : method_name.humanize, options)
        else
          return to_label_tag_without_i18n(text, options)
        end
      end
      alias_method_chain :to_label_tag, :i18n
    end
  end
end