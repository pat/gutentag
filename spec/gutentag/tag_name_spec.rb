require 'spec_helper'

describe Gutentag::TagName do
  describe '.call' do
    it "downcases the provided name" do
      Gutentag::TagName.call('Tasty Pancakes').should == 'tasty pancakes'
    end
  end
end
