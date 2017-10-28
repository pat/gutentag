# frozen_string_literal: true

require "spec_helper"

describe "Adding and removing tags" do
  let(:article)  { Article.create }
  let(:pancakes) { Gutentag::Tag.create :name => "pancakes" }

  it "stores new tags" do
    article.tags << pancakes

    expect(article.tags.reload).to eq([pancakes])
  end

  it "removes existing tags" do
    article.tags << pancakes

    article.tags.delete pancakes

    expect(article.tags.reload).to eq([])
  end

  it "removes taggings when an article is deleted" do
    article.tags << pancakes

    article.destroy

    expect(Gutentag::Tagging.where(
      :taggable_type => "Article", :taggable_id => article.id
    ).count).to be_zero
  end

  it "removes taggings when a tag is deleted" do
    article.tags << pancakes

    pancakes.destroy

    expect(Gutentag::Tagging.where(:tag_id => pancakes.id).count).to be_zero
  end

  it "should have a mean tag cloud" do
    gorillas = Gutentag::Tag.create(:name => "gorillas")
    another_article = Article.create

    article.tags << pancakes
    expect(Gutentag::Tag.by_weight.first).to eq(pancakes)

    article.tags << gorillas
    another_article.tags << gorillas
    expect(Gutentag::Tag.by_weight.first).to eq(gorillas)
  end
end
