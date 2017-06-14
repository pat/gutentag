module Gutentag::ActiveRecord::ClassMethods
  def tagged_with(options)
    Gutentag::TaggedWith.call self, options
  end
end
