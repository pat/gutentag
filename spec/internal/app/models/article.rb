class Article < ActiveRecord::Base
  Gutentag::ActiveRecord.call self
end
