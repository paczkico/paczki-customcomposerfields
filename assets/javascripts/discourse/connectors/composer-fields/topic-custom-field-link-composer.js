import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { alias } from "@ember/object/computed";
// import { inject as service } from "@ember/service";
import { service } from "@ember/service";

export default class TopicCustomFieldLinkComposer extends Component {
  @service composer;
  @service siteSettings;
  @tracked isHidden = true;
  @alias("siteSettings.topic_custom_field_link") fieldName;
  @alias("args.outletArgs.model") composerModel;
  @alias("composerModel.post") post;
  @alias("composerModel.topic") topic;

  constructor() {
    super(...arguments);
    if (
      !this.composerModel[this.fieldName] &&
      this.topic &&
      this.topic[this.fieldName]
    ) {
      this.composerModel.set(this.fieldName, this.topic[this.fieldName]);
    }

    this.fieldValue = this.composerModel.get(this.fieldName);
  }

  @action
  onChangeField(fieldValue) {
    this.composerModel.set(this.fieldName, fieldValue);
  }

  @action
  checkComposerType() {
    if (this.post && this.post.firstPost === true) {
      this.isHidden = false;
      return false;
    }
    if (this.composerModel.action === "createTopic") {
      this.isHidden = false;
      return false;
    }
    return true;
  }
}
