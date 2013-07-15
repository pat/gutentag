require 'spec_helper'

describe Gutentag::Tag do
  describe '#name' do
    before :each do
      Gutentag::TagName.stub :normalise => 'waffles'
    end

    it "normalises the provided name" do
      Gutentag::TagName.should_receive(:normalise).with('Pancakes').
        and_return('waffles')

      Gutentag::Tag.create!(:name => 'Pancakes')
    end

    it "saves the normalised name" do
      Gutentag::Tag.create!(:name => 'Pancakes').name.should == 'waffles'
    end
  end

  describe '#valid?' do
    it "ignores case when enforcing uniqueness" do
      Gutentag::Tag.create! :name => 'pancakes'

      Gutentag::Tag.create(:name => 'Pancakes').should have(1).error_on(:name)
    end
  end
end
