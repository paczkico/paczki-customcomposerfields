# frozen_string_literal: true

# name: topic-custom-fields
# about: Topic Custom Fields
# version: 0.1
# author: Discourse

enabled_site_setting :topic_custom_fields_enabled
register_asset "stylesheets/common.scss"
# require_dependency 'topic'

after_initialize do
  
  require_relative 'lib/validators/topic_custom_fields_validator'
 
  module ::TopicCustomFieldsPlugin
    FIELD_PRICE = SiteSetting.topic_custom_field_price
    FIELD_LINK = SiteSetting.topic_custom_field_link
    FIELD_CATEGORIES = SiteSetting.topic_custom_field_categories
    FIELD_GROUPS = SiteSetting.topic_custom_field_groups
  end
  
  fields = [
    { name: TopicCustomFieldsPlugin::FIELD_PRICE.to_s, type: 'string' },
    { name: TopicCustomFieldsPlugin::FIELD_LINK.to_s, type: 'string' },
  ]

  fields.each do |field|

    register_topic_custom_field_type(field[:name], field[:type].to_sym)

    # get
    add_to_class(:topic, field[:name].to_sym) do
      if !custom_fields[field[:name]].nil?
        custom_fields[field[:name]]
      else
        nil
      end
    end

    # set
    add_to_class(:topic, "#{field[:name]}=") do |value|
      custom_fields[field[:name]] = value
    end

    on(:topic_created) do |topic, opts, user|
      topic.send("#{field[:name]}=".to_sym, opts[field[:name].to_sym])
      topic.save!
    end

    # update
    PostRevisor.track_topic_field(field[:name].to_sym) do |tc, value|
      tc.record_change(field[:name], tc.topic.send(field[:name]), value)
      tc.topic.send("#{field[:name]}=".to_sym, value.present? ? value : nil)
    end

    add_to_serializer(:topic_view, field[:name].to_sym) do
      object.topic.send(field[:name])
    end

    add_preloaded_topic_list_custom_field(field[:name])

    # Serialize to the topic list
    add_to_serializer(:topic_list_item, field[:name].to_sym) do
      object.send(field[:name])
    end

  end

  # Topic.prepend(TopicCustomFieldsPlugin::TopicCustomFieldsValidatorMixin)

end
