require 'spec_helper'

SingleCov.covered!

describe Gutentag::TagName do
  describe '.call' do
    it "downcases the provided name" do
      expect(Gutentag::TagName.call('Tasty Pancakes')).to eq('tasty pancakes')
    end
  end
end
