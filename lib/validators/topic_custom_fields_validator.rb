module TopicCustomFieldsPlugin
  module TopicCustomFieldsValidatorMixin
    def validate_custom_fields
      super if defined?(super)
      Validators::TopicCustomFieldsValidator.validate(self)
    end
  end

  module Validators
    class TopicCustomFieldsValidator
      def self.validate(topic)
        validate_price(topic)
        validate_url(topic)
      end

      private_class_method def self.validate_price(topic)
        price = topic.custom_fields[TopicCustomFieldsPlugin::FIELD_PRICE]
        unless price.to_f.positive?
          topic.errors.add(:base, I18n.t('topic_custom_field_price.invalid'))
        end
      end

      private_class_method def self.validate_url(topic)
        url = topic.custom_fields[TopicCustomFieldsPlugin::FIELD_LINK]
        unless url =~ URI::DEFAULT_PARSER.make_regexp
          topic.errors.add(:base, I18n.t('topic_custom_field_link.invalid'))
        end
      end
    end
  end
end