# frozen_string_literal: true

# For Rails 4.2 only.
module Gutentag::ActiveRecord::InstanceMethods
  # The reason we overwrite the stored value is because new tags may be added to
  # the instance directly (e.g. article.tags << tag), which invokes the save
  # callbacks, but the old tag_names value is stored but not updated.
  def reset_tag_names
    # Update the underlying value rather than going through the setter, to
    # ensure this update doesn't get marked as a 'change'.
    @tag_names = nil
  end

  def tag_names
    @tag_names ||= begin
      raw = tags.pluck(:name)
      raw_write_attribute "tag_names", raw
      raw
    end
  end

  def tag_names=(names)
    new_names = Gutentag::TagNames.call names
    return if new_names.sort == tag_names.sort

    tag_names_will_change!

    write_attribute "tag_names", new_names
    @tag_names = new_names
  end

  private

  def persist_tags
    Gutentag::Persistence.new(Gutentag::ChangeState.new(self)).persist
  end
end
