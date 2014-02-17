require 'spec_helper'

describe Gutentag::Tag do
  describe '.find_by_name' do
    it "returns a tag with the same name" do
      existing = Gutentag::Tag.create! :name => 'pancakes'

      Gutentag::Tag.find_by_name('pancakes').should == existing
    end

    it "returns a tag with the same normalised name" do
      existing = Gutentag::Tag.create! :name => 'pancakes'

      Gutentag::Tag.find_by_name('Pancakes').should == existing
    end

    it "otherwise returns nil" do
      Gutentag::Tag.find_by_name('pancakes').should be_nil
    end
  end

  describe '.find_or_create' do
    it "returns a tag with the same name" do
      existing = Gutentag::Tag.create! :name => 'pancakes'

      Gutentag::Tag.find_or_create('pancakes').should == existing
    end

    it "returns a tag with the same normalised name" do
      existing = Gutentag::Tag.create! :name => 'pancakes'

      Gutentag::Tag.find_or_create('Pancakes').should == existing
    end

    it "creates a new tag if no matches exist" do
      Gutentag::Tag.find_or_create('pancakes').should be_persisted
    end
  end

  describe '#name' do
    before :each do
      Gutentag::TagName.stub :call => 'waffles'
    end

    it "normalises the provided name" do
      Gutentag::TagName.should_receive(:call).with('Pancakes').
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
