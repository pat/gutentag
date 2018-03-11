# frozen_string_literal: true

# For Rails 5.0+
module Gutentag::ActiveRecord::InstanceMethods
  # If the tag_names attribute was one of the modified values, then let's just
  # use the modifications, rather than overwriting the stored value.
  #
  # The reason we overwrite the stored value is because new tags may be added to
  # the instance directly (e.g. article.tags << tag), which invokes the save
  # callbacks, but the old tag_names value is stored but not updated.
  def reset_tag_names
    return if tag_names_previously_changed?

    # Update the underlying value rather than going through the setter, to
    # ensure this update doesn't get marked as a 'change'.
    @attributes.write_from_database "tag_names", nil
  end

  def tag_names
    # If the underlying value is nil, we've not requested this from the
    # database yet.
    self.tag_names = tags.pluck(:name) if super.nil?

    # Use ActiveRecord's underlying implementation with change tracking.
    super
  end

  def tag_names=(names)
    # This value is about to be overwritten, but we want to make sure the change
    # tracking doesn't think the original value was nil.
    @attributes.write_from_database "tag_names", []

    super Gutentag::TagNames.call(names)
  end

  private

  def persist_tags
    Gutentag::Persistence.new(Gutentag::ChangeState.new(self)).persist
  end
end
