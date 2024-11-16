import Component from "@glimmer/component";
import { Input } from "@ember/component";
import { on } from "@ember/modifier";
// import { action } from "@ember/object";
import { computed } from "@ember/object";
import { readOnly } from "@ember/object/computed";
import { service } from "@ember/service";
import i18n from "discourse-common/helpers/i18n";

export default class TopicCustomFieldLinkInput extends Component {
  @service composer;
  @service siteSettings;
  @readOnly("siteSettings.topic_custom_field_link") fieldName;

  // urlPattern =
  //   /^(https?:\/\/)?([a-zA-Z0-9]+([-\w]*[a-zA-Z0-9])*\.)+[a-zA-Z]{2,6}(\/[^\s]*)?$/;
  // usernamePattern = /^@[a-zA-Z0-9_]+$/;

  constructor() {
    super(...arguments);
    // this.showField = this.shouldShowField;
  }

  get isCategoryValid() {
    const allowedCategories = this.allowedCategories || [];
    const currentCategoryId = this.currentCategoryId;
    return allowedCategories.includes(currentCategoryId);
  }

  @computed("siteSettings.topic_custom_field_categories")
  get allowedCategories() {
    return (this.siteSettings.topic_custom_field_categories || "")
      .split("|")
      .map((id) => parseInt(id, 10))
      .filter((id) => id);
  }

  get currentCategoryId() {
    this.categoryId = this.composer.model.categoryId;
    return this.categoryId;
  }

  get isTopicEnabled() {
    return this.allowedCategories.includes(this.currentCategoryId);
  }

  get shouldShowField() {
    return this.isTopicEnabled && this.isCategoryValid;
  }

  // get isValidUrl() {
  //   return this.urlPattern.test(this.inputValue);
  // }

  // get isValidUsername() {
  //   return this.usernamePattern.test(this.inputValue);
  // }

  <template>
    {{#if this.shouldShowField}}
      <Input
        @type="text"
        @value={{@fieldValue}}
        @autocomplete="off"
        placeholder={{i18n
          "topic_custom_field_link.placeholder"
          field=this.fieldName
        }}
        {{on "change" (action @onChangeField value="target.value")}}
        ...attributes
      />
    {{/if}}
  </template>
}
