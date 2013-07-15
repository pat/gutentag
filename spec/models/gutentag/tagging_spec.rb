require 'spec_helper'

describe Gutentag::Tagging do
  describe '#valid?' do
    let(:tag)      { Gutentag::Tag.create! :name => 'pancakes' }
    let(:taggable) { Article.create! }

    it "ensures tags are unique for any given taggable" do
      Gutentag::Tagging.create! :tag => tag, :taggable => taggable

      Gutentag::Tagging.create(
        :tag => tag, :taggable => taggable
      ).should have(1).error_on(:tag_id)
    end
  end
end
