# frozen_string_literal: true

class Article < ActiveRecord::Base
  Gutentag::ActiveRecord.call self
end
