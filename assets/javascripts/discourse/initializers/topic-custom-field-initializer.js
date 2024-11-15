import { alias } from "@ember/object/computed";
import { withPluginApi } from "discourse/lib/plugin-api";
import discourseComputed from "discourse-common/utils/decorators";

export default {
  name: "topic-custom-field-intializer",
  initialize(container) {
    const siteSettings = container.lookup("site-settings:main");

    const CUSTOM_FIELDS = [
      siteSettings.topic_custom_field_price,
      siteSettings.topic_custom_field_link,
    ];

    CUSTOM_FIELDS.forEach((fieldName) => {
      withPluginApi("1.37.3", (api) => {
        api.serializeOnCreate(fieldName);
        api.serializeToDraft(fieldName);
        api.serializeToTopic(fieldName, `topic.${fieldName}`);

        const PLUGIN_ID = `topic-custom-field-input-${fieldName}`.toLowerCase();

        // NOTE: Mapear luego.
        api.modifyClass("component:topic-list-item", {
          pluginId: PLUGIN_ID,
          customFieldName: fieldName,
          customFieldValue: alias(`topic.${fieldName}`),

          @discourseComputed("customFieldValue")
          showCustomField: (value) => !!value,
        });

      });
    }); // end

  },
};
