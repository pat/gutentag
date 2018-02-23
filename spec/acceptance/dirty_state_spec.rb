# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Dirty state of tag names" do
  let(:article) { Article.create! }

  it "knows what tag names will change" do
    article.tag_names = ["pancakes"]

    expect(article).to be_changed
    expect(article.tag_names_changed?).to eq(true)
    expect(article.tag_names_was).to eq([])
    expect(article.tag_names_change).to eq([[], ["pancakes"]])

    if ActiveRecord::VERSION::STRING.to_f > 4.0
      expect(article.tag_names_changed?(:from => [], :to => ["pancakes"])).
        to eq(true)
    end

    if ActiveRecord::VERSION::STRING.to_f > 5.0
      expect(article.will_save_change_to_tag_names?).to eq(true)
      expect(article.tag_names_change_to_be_saved).to eq([[], ["pancakes"]])
      expect(article.tag_names_in_database).to eq([])
    end
  end

  it "knows what tag names have changed" do
    article.tag_names = ["pancakes"]
    article.save

    expect(article.tag_names).to eq(["pancakes"])

    expect(article).to_not be_changed
    expect(article.tag_names_changed?).to eq(false)
    expect(article.previous_changes["tag_names"]).to eq([[], ["pancakes"]])

    if ActiveRecord::VERSION::STRING.to_f >= 5.0
      expect(article.tag_names_previously_changed?).to eq(true)
      expect(article.tag_names_previous_change).to eq([[], ["pancakes"]])
    end

    if ActiveRecord::VERSION::STRING.to_f > 5.0
      expect(article.saved_change_to_tag_names?).to eq(true)
      expect(article.saved_change_to_tag_names).to eq([[], ["pancakes"]])
      expect(article.saved_changes["tag_names"]).to eq([[], ["pancakes"]])
      expect(article.tag_names_before_last_save).to eq([])
      expect(article.tag_names_change_to_be_saved).to eq(nil)
      expect(article.tag_names_in_database).to eq(["pancakes"])
    end
  end
end
