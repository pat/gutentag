# frozen_string_literal: true

# For Rails 4.2+
module Gutentag::ActiveRecord::ModernInstanceMethods
  def reset_tag_names
    self.tag_names = nil
  end

  def tag_names
    self.tag_names= tags.pluck(:name) if super.nil?

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
