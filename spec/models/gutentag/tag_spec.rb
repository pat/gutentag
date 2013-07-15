require 'spec_helper'

describe Gutentag::Tag do
  describe '#valid?' do
    it "ignores case when enforcing uniqueness" do
      Gutentag::Tag.create! :name => 'pancakes'

      Gutentag::Tag.create(:name => 'Pancakes').should have(1).error_on(:name)
    end
  end
end
