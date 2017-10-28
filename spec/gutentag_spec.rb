# frozen_string_literal: true

require "spec_helper"

describe Gutentag do
  describe ".normalizer" do
    it "downcases the provided name" do
      expect(Gutentag.normaliser.call("Tasty Pancakes")).to eq("tasty pancakes")
    end
  end
end
