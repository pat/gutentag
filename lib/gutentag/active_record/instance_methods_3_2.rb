# frozen_string_literal: true

# For Rails <= 4.1
module Gutentag::ActiveRecord::InstanceMethods
  # The reason we overwrite the stored value is because new tags may be added to
  # the instance directly (e.g. article.tags << tag), which invokes the save
  # callbacks, but the old tag_names value is stored but not updated.
  def reset_tag_names
    @tag_names = nil
  end

  def tag_names
    @tag_names ||= tags.pluck(:name)
  end

  def tag_names=(names)
    Gutentag.dirtier.call self, names if Gutentag.dirtier

    @tag_names = names
  end

  private

  def persist_tags
    Gutentag::Persistence.new(Gutentag::ChangeState.new(self)).persist
  end
end
