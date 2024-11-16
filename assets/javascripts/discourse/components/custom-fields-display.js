import Component from "@glimmer/component";
import { computed } from "@ember/object";
import { alias } from "@ember/object/computed";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";


const REGEX_URL =
  /^(https?:\/\/(?:www\.)?[\w-]+\.[a-z]{2,6}(?:\/[\w\-._~:/?#[\]@!$&'()*+,;=]*)?)$/i;
export default class CustomFieldsDisplay extends Component {
  @service currentUser;
  @service siteSettings;

  @alias("siteSettings.topic_custom_field_price") fieldPrice;
  @alias("siteSettings.topic_custom_field_categories") allowedCategoryList;
  @alias("siteSettings.topic_custom_field_groups") allowedGroupsList;

  constructor() {
    super(...arguments);
    this.categoryId = this.args.model.categoryId || 0;
    this.postUserId = this.args.model.postUserId || 0;
    this.price = this.args.model.price || null;
    this.urlOrHandle = this.args.model.urlOrHandle || "";
  }

  @computed("siteSettings.topic_custom_field_groups")
  get allowedGroups() {
    return (this.siteSettings.topic_custom_field_groups || "")
      .split("|")
      .map((id) => parseInt(id, 10))
      .filter((id) => id);
  }

  get hasAllowedGroup() {
    const allowedGroups = this.allowedGroups || [];
    const userGroupsIds = this.userGroupsIds || [];
    return userGroupsIds.some((id) => allowedGroups.includes(id));
  }

  get userGroupsIds() {
    const groups = this.currentUser.groups;
    return groups.map((item) => item.id);
  }

  @computed("siteSettings.topic_custom_field_categories")
  get allowedCategories() {
    return (this.siteSettings.topic_custom_field_categories || "")
      .split("|")
      .map((id) => parseInt(id, 10))
      .filter((id) => id);
  }

  get currentCategoryId() {
    return this.categoryId;
  }

  get isTopicEnabled() {
    return this.allowedCategories.includes(this.currentCategoryId);
  }

  get isAuthenticated() {
    return this.currentUser;
  }

  get isMemberValid() {
    return this.hasAllowedGroup;
  }

  get getPrice() {
    // if (typeof this.price === 'number') {
    //   return `${this.price}$`;
    // }
    // return this.price;
    return htmlSafe(this.price);
  }

  get getUrlOrHandle() {
    let result =this.urlOrHandle;
    if (this.urlOrHandle && REGEX_URL.test(this.urlOrHandle)) {
      result = `<a href="${this.urlOrHandle}" target="_blank">${this.urlOrHandle}</a>`;
    }
    return htmlSafe(result);
  }

  get isMyOwnPost() {
    return this.currentUser.id === this.postUserId;
  }
}
