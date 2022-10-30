# frozen_string_literal: true

# For Rails 5.0+
module Gutentag::ActiveRecord::InstanceMethods
  AR_VERSION = ActiveRecord::VERSION::STRING.to_f

  # If the tag_names attribute was one of the modified values, then let's just
  # use the modifications, rather than overwriting the stored value.
  #
  # The reason we overwrite the stored value is because new tags may be added to
  # the instance directly (e.g. article.tags << tag), which invokes the save
  # callbacks, but the old tag_names value is stored but not updated.
  def reset_tag_names
    # Rails 5.1 introduces major changes to how ActiveModel::Dirty works:
    # https://github.com/pat/gutentag/pull/70#issuecomment-524605448
    # For Rails <5.1 we'll use *_previously_changed?
    # and for 5.1+ we'll use saved_change_to_*?
    return if AR_VERSION < 5.1 && tag_names_previously_changed?
    return if AR_VERSION >= 5.1 && saved_change_to_tag_names?

    # Update the underlying value rather than going through the setter, to
    # ensure this update doesn't get marked as a 'change'.
    @attributes.write_from_database "tag_names", []
    @prepared_tag_names = false
  end

  def tag_names
    if super.nil? || !prepared_tag_names?
      # If the underlying value is nil, we've not requested this from the
      # database yet. But we also don't want to make the query twice. So, grab
      # the names, prepare as needed, and make sure we also invoke the setter.
      names = tags.pluck(:name)

      prepare_tag_names(names)
      self.tag_names = names
    end

    # Use ActiveRecord's underlying implementation with change tracking.
    super
  end

  def tag_names=(names)
    # This value is about to be overwritten, but we want to make sure the change
    # tracking doesn't think the original value was nil.
    prepare_tag_names

    super Gutentag::TagNames.call(names)
  end

  private

  def persist_tags
    Gutentag::Persistence.new(Gutentag::ChangeState.new(self)).persist
  end

  def prepare_tag_names(names = nil)
    return if prepared_tag_names?

    names ||= tags.pluck(:name)
    @attributes.write_from_database("tag_names", names)

    @prepared_tag_names = true
  end

  def prepared_tag_names?
    @prepared_tag_names ||= false
  end
end
