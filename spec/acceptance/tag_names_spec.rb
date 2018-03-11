# frozen_string_literal: true

require "spec_helper"

describe "Managing tags via names" do
  let(:article) { Article.create }

  it "returns tag names" do
    melbourne = Gutentag::Tag.create :name => "melbourne"

    article.tags << melbourne

    expect(article.tag_names).to eq(["melbourne"])
  end

  it "adds tags via their names" do
    article.tag_names << "melbourne"
    article.save!

    expect(article.tags.collect(&:name)).to eq(["melbourne"])
  end

  it "allows for different tag normalisation" do
    Gutentag.normaliser = lambda { |name| name.upcase }

    tag = Gutentag::Tag.create(:name => "melbourne")
    expect(tag.name).to eq("MELBOURNE")

    Gutentag.normaliser = nil
  end

  it "doesn't complain when adding an existing tag" do
    article.tag_names << "melbourne"
    article.tag_names << "melbourne"
    article.save!

    expect(article.tags.collect(&:name)).to eq(["melbourne"])
  end

  it "accepts a completely new set of tags" do
    article.tag_names = %w[ portland oregon ]
    article.save!

    expect(article.tags.collect(&:name)).to eq(%w[ portland oregon ])
  end

  it "does not allow duplication of tags" do
    existing = Article.create
    existing.tags << Gutentag::Tag.create(:name => "portland")

    article.tag_names = %w[ portland ]
    article.save!

    expect(existing.tag_ids).to eq(article.tag_ids)
  end

  it "appends tag names" do
    article.tag_names  = %w[ portland ]
    article.tag_names += %w[ oregon ruby ]
    article.save!

    expect(article.tags.collect(&:name)).to eq(%w[ portland oregon ruby ])
  end

  it "does not repeat appended names that already exist" do
    article.tag_names  = %w[ portland oregon ]
    article.tag_names += %w[ oregon ruby ]
    article.save!

    expect(article.tags.collect(&:name)).to eq(%w[ portland oregon ruby ])
  end

  it "removes a single tag name" do
    article.tag_names = %w[ portland oregon ]
    article.tag_names.delete "oregon"
    article.save!

    expect(article.tags.collect(&:name)).to eq(%w[ portland ])
  end

  it "removes tag names" do
    article.tag_names  = %w[ portland oregon ruby ]
    article.tag_names -= %w[ oregon ruby ]
    article.save!

    expect(article.tags.collect(&:name)).to eq(%w[ portland ])
  end

  it "matches tag names ignoring case" do
    article.tag_names  = %w[ portland ]
    article.tag_names += %w[ Portland ]
    article.save!

    expect(article.tags.collect(&:name)).to eq(%w[ portland ])

    article.tag_names << "Portland"
    article.save!

    expect(article.tags.collect(&:name)).to eq(%w[ portland ])
  end

  it "allows setting of tag names on unpersisted objects" do
    article = Article.new :tag_names => %w[ melbourne pancakes ]
    article.save!

    expect(article.tag_names).to eq(%w[ melbourne pancakes ])
  end

  it "allows overriding of tag_names=" do
    expect(Article.instance_methods(false)).to_not include(:tag_names=)
  end

  it "returns known tag names from a freshly loaded object" do
    article.tag_names << "melbourne"
    article.save!

    expect(Article.find(article.id).tag_names).to eq(["melbourne"])
  end

  it "ignores blank tags" do
    article = Article.new :tag_names => ["", "melbourne"]
    article.save!

    expect(article.tag_names).to eq(%w[ melbourne ])
  end
end
