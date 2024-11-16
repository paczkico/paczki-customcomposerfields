import Component from "@glimmer/component";
import { Input } from "@ember/component";
import { on } from "@ember/modifier";
import { computed } from "@ember/object";
import { readOnly } from "@ember/object/computed";
import { service } from "@ember/service";
import i18n from "discourse-common/helpers/i18n";

export default class TopicCustomFieldPriceInput extends Component {
  @service composer;
  @service siteSettings;
  @readOnly("siteSettings.topic_custom_field_price") fieldName;

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

<template>
  {{#if this.shouldShowField}}
    <div style="width: 66.66%" class="ccf__field ember-view">
      <input
        id="ember134"
        class="ember-text-field ember-view ccf__input"
        type="number"
        placeholder={{i18n
          "topic_custom_field_price.placeholder"
          field=this.fieldName
        }}
        autocomplete="off"
        value={{@fieldValue}}
        required=""
        {{on "input" (fn @onChangeField (target.value))}}
        ...attributes
      />
    </div>
  {{/if}}
</template>
}
