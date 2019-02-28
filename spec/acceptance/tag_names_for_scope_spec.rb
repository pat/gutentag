# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Tag names for scopes" do
  it "returns tag names for a given model" do
    Article.create :tag_names => %w[ koala wombat ]
    Article.create :tag_names => %w[ cassowary ]

    expect(Gutentag::Tag.names_for_scope(Article)).
      to match_array(%w[ koala wombat cassowary ])
  end

  it "returns tag names for a given scope" do
    Article.create :title => "mammals", :tag_names => %w[ koala wombat ]
    Article.create :title => "birds",   :tag_names => %w[ cassowary ]

    expect(Gutentag::Tag.names_for_scope(Article.where(:title => "mammals"))).
      to match_array(%w[ koala wombat ])
  end

  it "does not duplicate tag names for a given model/scope" do
    Article.create :tag_names => %w[ koala wombat ]
    Article.create :tag_names => %w[ cassowary ]
    Article.create :tag_names => %w[ cassowary wombat ]

    expect(Gutentag::Tag.names_for_scope(Article)).
      to match_array(%w[ koala wombat cassowary ])
  end
end
