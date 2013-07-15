require 'spec_helper'

describe "Managing tags via names" do
  let(:article)   { Article.create }

  it "returns tag names" do
    melbourne = Gutentag::Tag.create :name => 'melbourne'

    article.tags << melbourne

    article.tag_names.to_a.should == ['melbourne']
  end

  it "adds tags via their names" do
    article.tag_names << 'melbourne'

    article.tags.collect(&:name).should == ['melbourne']
  end

  it "accepts a completely new set of tags" do
    article.tag_names = ['portland', 'oregon']

    article.tags.collect(&:name).should == ['portland', 'oregon']
  end

  it "enumerates through tag names" do
    article.tag_names = ['melbourne', 'victoria']
    names = []

    article.tag_names.each do |name|
      names << name
    end

    names.should == ['melbourne', 'victoria']
  end

  it "does not allow duplication of tags" do
    existing = Article.create
    existing.tags << Gutentag::Tag.create(:name => 'portland')

    article.tag_names = ['portland']

    existing.tag_ids.should == article.tag_ids
  end

  it "appends tag names" do
    article.tag_names  = ['portland']
    article.tag_names += ['oregon', 'ruby']

    article.tags.collect(&:name).should == ['portland', 'oregon', 'ruby']
  end

  it "removes a single tag name" do
    article.tag_names = ['portland', 'oregon']
    article.tag_names.delete 'oregon'

    article.tags.collect(&:name).should == ['portland']
  end

  it "removes tag names" do
    article.tag_names  = ['portland', 'oregon', 'ruby']
    article.tag_names -= ['oregon', 'ruby']

    article.tags.collect(&:name).should == ['portland']
  end

  it "provides union operators" do
    article.tag_names  = ['portland', 'ruby']
    article.tag_names |= ['ruby', 'melbourne']

    article.tags.collect(&:name).should == ['portland', 'ruby', 'melbourne']
  end

  it "provides intersection operators" do
    article.tag_names  = ['portland', 'ruby']
    article.tag_names &= ['ruby', 'melbourne']

    article.tags.collect(&:name).should == ['ruby']
  end
end
