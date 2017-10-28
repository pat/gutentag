# frozen_string_literal: true

require "spec_helper"

describe Gutentag::Tagging, :type => :model do
  describe "#valid?" do
    let(:tag)      { Gutentag::Tag.create! :name => "pancakes" }
    let(:taggable) { Article.create! }

    it "ensures tags are unique for any given taggable" do
      tagging = Gutentag::Tagging.new
      tagging.tag      = tag
      tagging.taggable = taggable
      tagging.save!

      tagging = Gutentag::Tagging.new
      tagging.tag      = tag
      tagging.taggable = taggable

      tagging.valid?
      expect(tagging.errors[:tag_id].length).to eq(1)
    end
  end
end
