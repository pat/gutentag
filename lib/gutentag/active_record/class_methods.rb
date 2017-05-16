module Gutentag::ActiveRecord::ClassMethods
  def tagged_with(*arguments)
    arguments.flatten!

    case arguments.first
    when Hash
      Gutentag::TaggedWithQuery.call(self, arguments.first)
    when Integer
      Rails.logger.warn "Calling tagged_with with an array of integers is deprecated, and will not be supported in Gutentag 1.0. Please use tagged_with :ids => [1, 2] instead."
      Gutentag::TaggedWithQuery.call(self, :ids => arguments)
    when Gutentag::Tag
      Rails.logger.warn "Calling tagged_with with an array of tags is deprecated, and will not be supported in Gutentag 1.0. Please use tagged_with :tags => [tag_a, tag_b] instead."
      Gutentag::TaggedWithQuery.call(self, :tags => arguments)
    else
      Rails.logger.warn "Calling tagged_with with an array of strings is deprecated, and will not be supported in Gutentag 1.0. Please use tagged_with :names => [\"melbourne\", \"ruby\"] instead."
      Gutentag::TaggedWithQuery.call(self, :names => arguments)
    end
  end
end
