require 'spec_helper'

SingleCov.covered! uncovered: 7

describe Gutentag do
  describe '.normalizer' do
    it "downcases the provided name" do
      expect(Gutentag.normaliser.call('Tasty Pancakes')).to eq('tasty pancakes')
    end
  end
end
