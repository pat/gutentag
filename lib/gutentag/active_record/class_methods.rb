module Gutentag::ActiveRecord::ClassMethods
  def tagged_with(*tags)
    Gutentag::TaggedWithQuery.call self, tags
  end
end
