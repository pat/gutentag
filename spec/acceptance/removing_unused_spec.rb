# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Removing unused" do
  let(:article) { Article.create }

  it "deletes only unused tags" do
    pancakes = Gutentag::Tag.create :name => "pancakes"
    Gutentag::Tag.create :name => "waffles"

    Gutentag::Tagging.create :tag => pancakes, :taggable => article

    expect(Gutentag::Tag.pluck(:name)).to match_array(%w[ pancakes waffles ])

    Gutentag::RemoveUnused.call

    expect(Gutentag::Tag.pluck(:name)).to match_array(%w[ pancakes ])
  end
end
