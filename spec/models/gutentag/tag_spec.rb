require 'spec_helper'

describe Gutentag::Tag, :type => :model do
  describe '.find_by_name' do
    it "returns a tag with the same name" do
      existing = Gutentag::Tag.create! :name => 'pancakes'

      expect(Gutentag::Tag.find_by_name('pancakes')).to eq(existing)
    end

    it "returns a tag with the same normalised name" do
      existing = Gutentag::Tag.create! :name => 'pancakes'

      expect(Gutentag::Tag.find_by_name('Pancakes')).to eq(existing)
    end

    it "otherwise returns nil" do
      expect(Gutentag::Tag.find_by_name('pancakes')).to be_nil
    end
  end

  describe '.find_or_create' do
    it "returns a tag with the same name" do
      existing = Gutentag::Tag.create! :name => 'pancakes'

      expect(Gutentag::Tag.find_or_create('pancakes')).to eq(existing)
    end

    it "returns a tag with the same normalised name" do
      existing = Gutentag::Tag.create! :name => 'pancakes'

      expect(Gutentag::Tag.find_or_create('Pancakes')).to eq(existing)
    end

    it "creates a new tag if no matches exist" do
      expect(Gutentag::Tag.find_or_create('pancakes')).to be_persisted
    end
  end

  describe '#name' do
    before :each do
      allow(Gutentag::TagName).to receive(:call).and_return('waffles')
    end

    it "normalises the provided name" do
      expect(Gutentag::TagName).to receive(:call).with('Pancakes').
        and_return('waffles')

      Gutentag::Tag.create!(:name => 'Pancakes')
    end

    it "saves the normalised name" do
      expect(Gutentag::Tag.create!(:name => 'Pancakes').name).to eq('waffles')
    end
  end

  describe '#valid?' do
    it "ignores case when enforcing uniqueness" do
      Gutentag::Tag.create! :name => 'pancakes'

      tag = Gutentag::Tag.create(:name => 'Pancakes')
      expect(tag.errors[:name].length).to eq(1)
    end
  end
end
