require 'spec_helper'

describe Gutentag::TagName do
  describe '.normalise' do
    it "downcases the provided name" do
      Gutentag::TagName.normalise('Tasty Pancakes').should == 'tasty pancakes'
    end
  end
end
