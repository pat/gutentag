require 'spec_helper'

describe "Managing tags via names" do
  let(:article)   { Article.create }

  it "returns tag names" do
    melbourne = Gutentag::Tag.create :name => 'melbourne'

    article.tags << melbourne

    article.tag_names.should == ['melbourne']
  end

  it "adds tags via their names" do
    article.tag_names << 'melbourne'
    article.save!

    article.tags.collect(&:name).should == ['melbourne']
  end

  it "makes model dirty when changing through tag_names" do
    article.tag_names << 'melbourne'
    article.save!

    article.tag_names = ['sydney']

    article.changed_attributes.should == { :tag_names => ['melbourne'] }
  end

  it "does not make model dirty when changing through tag_names" do
    article.tag_names << 'melbourne'
    article.save!

    article.tag_names = ['melbourne']

    article.changed_attributes.should == {}
  end

  it "allows for different tag normalisation" do
    Gutentag.normaliser = lambda { |name| name.upcase }

    Gutentag::Tag.create(:name => 'melbourne').name.should == 'MELBOURNE'

    Gutentag.normaliser = nil
  end

  it "doesn't complain when adding an existing tag" do
    article.tag_names << 'melbourne'
    article.tag_names << 'melbourne'
    article.save!

    article.tags.collect(&:name).should == ['melbourne']
  end

  it "accepts a completely new set of tags" do
    article.tag_names = ['portland', 'oregon']
    article.save!

    article.tags.collect(&:name).should == ['portland', 'oregon']
  end

  it "does not allow duplication of tags" do
    existing = Article.create
    existing.tags << Gutentag::Tag.create(:name => 'portland')

    article.tag_names = ['portland']
    article.save!

    existing.tag_ids.should == article.tag_ids
  end

  it "appends tag names" do
    article.tag_names  = ['portland']
    article.tag_names += ['oregon', 'ruby']
    article.save!

    article.tags.collect(&:name).should == ['portland', 'oregon', 'ruby']
  end

  it "does not repeat appended names that already exist" do
    article.tag_names  = ['portland', 'oregon']
    article.tag_names += ['oregon', 'ruby']
    article.save!

    article.tags.collect(&:name).should == ['portland', 'oregon', 'ruby']
  end

  it "removes a single tag name" do
    article.tag_names = ['portland', 'oregon']
    article.tag_names.delete 'oregon'
    article.save!

    article.tags.collect(&:name).should == ['portland']
  end

  it "removes tag names" do
    article.tag_names  = ['portland', 'oregon', 'ruby']
    article.tag_names -= ['oregon', 'ruby']
    article.save!

    article.tags.collect(&:name).should == ['portland']
  end

  it "matches tag names ignoring case" do
    article.tag_names  = ['portland']
    article.tag_names += ['Portland']
    article.save!

    article.tags.collect(&:name).should == ['portland']

    article.tag_names << 'Portland'
    article.save!

    article.tags.collect(&:name).should == ['portland']
  end

  it "allows setting of tag names on unpersisted objects" do
    article = Article.new :tag_names => ['melbourne', 'pancakes']
    article.save!

    article.tag_names.should == ['melbourne', 'pancakes']
  end

  it "allows overriding of tag_names=" do
    Article.instance_methods(false).should_not include(:tag_names=)
  end
end
