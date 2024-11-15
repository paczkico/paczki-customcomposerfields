import { hbs } from "ember-cli-htmlbars";
import { withPluginApi } from "discourse/lib/plugin-api";
import { registerWidgetShim } from "discourse/widgets/render-glimmer";

export default {
  name: "extend-post-content-initializer",
  initialize(container) {
    const siteSettings = container.lookup("site-settings:main");
    const PRICE = siteSettings.topic_custom_field_price;
    const LINK = siteSettings.topic_custom_field_link;

    registerWidgetShim(
      "before-post-content",
      "div.custom-fields-container",
      hbs`<CustomFieldsDisplay @model={{@data}}/>`
    );

    withPluginApi("0.8.31", (api) => {
      api.decorateWidget("post-contents:before", (helper) => {
        const postNumber = helper.widget.attrs["post_number"];
        if (postNumber !== 1) {
          return;
        }
        const postModel = helper.getModel();
        if (!postModel) {
          return;
        }
        const topic = postModel.topic;
        if (!topic) {
          return;
        }
        const categoryId = topic.category_id;
        const postUserId = postModel.user_id;
        const price = topic[PRICE] || null;
        const urlOrHandle = topic[LINK] || null;
        const data = {
          categoryId,
          postUserId,
          price,
          urlOrHandle,
        };
        return helper.attach("before-post-content", data);
      });
    }); // end
  },
};
