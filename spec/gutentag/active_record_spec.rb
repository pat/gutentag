require 'spec_helper'

SingleCov.covered!

describe Gutentag::ActiveRecord do
  describe '.tagged_with' do
    let!(:melborne_article) do
      article = Article.create :title => 'Overview'
      article.tag_names << 'melborne'
      article.save!
      article
    end

    let!(:oregon_article) do
      article = Article.create
      article.tag_names << 'oregon'
      article.save!
      article
    end

    let!(:melborne_oregon_article) do
      article = Article.create
      article.tag_names = %w(oregon melborne)
      article.save!
      article
    end

    context 'given a single tag name' do
      subject { Article.tagged_with('melborne') }

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melborne_article, melborne_oregon_article }
      it { is_expected.not_to include oregon_article }
    end

    context 'given a single tag name[symbol]' do
      subject { Article.tagged_with(:melborne) }

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melborne_article, melborne_oregon_article }
      it { is_expected.not_to include oregon_article }
    end

    context 'given multiple tag names' do
      subject { Article.tagged_with('melborne', 'oregon') }

      it { expect(subject.count).to eq 3 }
      it { is_expected.to include melborne_article, oregon_article, melborne_oregon_article }
    end

    context 'given an array of tag names' do
      subject { Article.tagged_with(%w(melborne oregon)) }

      it { expect(subject.count).to eq 3 }
      it { is_expected.to include melborne_article, oregon_article, melborne_oregon_article }
    end

    context 'given a single tag instance' do
      subject { Article.tagged_with(Gutentag::Tag.find_by_name!('melborne')) }

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melborne_article, melborne_oregon_article }
      it { is_expected.not_to include oregon_article }
      it { expect(subject.to_sql).not_to include 'gutentag_tags' }
    end

    context 'given a single tag id' do
      subject { Article.tagged_with(Gutentag::Tag.find_by_name!('melborne').id) }

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melborne_article, melborne_oregon_article }
      it { is_expected.not_to include oregon_article }
      it { expect(subject.to_sql).not_to include 'gutentag_tags' }
    end

    context 'given multiple tag objects' do
      subject { Article.tagged_with(Gutentag::Tag.where(name: %w(melborne oregon))) }

      it { expect(subject.count).to eq 3 }
      it { is_expected.to include melborne_article, oregon_article, melborne_oregon_article }
      it { expect(subject.to_sql).not_to include 'gutentag_tags' }
    end

    context 'chaining where clause' do
      subject { Article.tagged_with(%w(melborne oregon)).where(title: 'Overview') }

      it { expect(subject.count).to eq 1 }
      it { is_expected.to include melborne_article }
      it { is_expected.not_to include oregon_article, melborne_oregon_article }
    end
  end

  describe "#tags_as_string" do
    let(:article) { Article.new }

    it "is empty" do
      expect(article.tags_as_string).to eq ""
    end

    it "shows tags" do
      article.tag_names = ["foo", "bar"]
      expect(article.tags_as_string).to eq "foo,bar"
    end
  end

  describe "#tags_as_string=" do
    let(:article) { Article.new }

    it "can empty" do
      article.tag_names = ["foo", "bar"]
      article.tags_as_string = ""
      expect(article.tag_names).to eq []
    end

    it "can assign" do
      article.tags_as_string = "a,b,c"
      expect(article.tag_names).to eq ["a", "b", "c"]
    end
  end
end
