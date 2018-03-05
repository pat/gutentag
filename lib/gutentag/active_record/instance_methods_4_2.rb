# frozen_string_literal: true

# For Rails 4.2 only.
module Gutentag::ActiveRecord::InstanceMethods
  # The reason we overwrite the stored value is because new tags may be added to
  # the instance directly (e.g. article.tags << tag), which invokes the save
  # callbacks, but the old tag_names value is stored but not updated.
  def reset_tag_names
    # Update the underlying value rather than going through the setter, to
    # ensure this update doesn't get marked as a 'change'.
    self.tag_names = nil
  end

  def tag_names
    # If the underlying value is nil, we've not requested this from the
    # database yet.
    if read_attribute("tag_names") { nil }.nil?
      self.tag_names = tags.pluck(:name)
    end

    # Use ActiveRecord's underlying implementation with change tracking.
    super
  end

  def tag_names=(names)
    Gutentag.dirtier.call self, names if Gutentag.dirtier

    super
  end

  private

  def persist_tags
    Gutentag::Persistence.new(Gutentag::ChangeState.new(self)).persist
  end
end
