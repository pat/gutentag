require 'spec_helper'

describe "Managing tags via names" do
  let(:article)   { Article.create }
  let(:melbourne) { Gutentag::Tag.create :name => 'melbourne' }

  it "returns tag names" do
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
end
