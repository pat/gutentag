module Gutentag::ActiveRecord::ClassMethods
  def tagged_with(*arguments)
    arguments.flatten!

    case arguments.first
    when Hash
      Gutentag::TaggedWith.call(self, arguments.first)
    when Integer
      ActiveSupport::Deprecation.warn "Calling tagged_with with an array of integers will not be supported in Gutentag 1.0. Please use tagged_with :ids => [1, 2] instead."
      Gutentag::TaggedWith.call(self, :ids => arguments)
    when Gutentag::Tag
      ActiveSupport::Deprecation.warn "Calling tagged_with with an array of tags will not be supported in Gutentag 1.0. Please use tagged_with :tags => [tag_a, tag_b] instead."
      Gutentag::TaggedWith.call(self, :tags => arguments)
    else
      ActiveSupport::Deprecation.warn "Calling tagged_with with an array of strings will not be supported in Gutentag 1.0. Please use tagged_with :names => [\"melbourne\", \"ruby\"] instead."
      Gutentag::TaggedWith.call(self, :names => arguments)
    end
  end
end
