require 'spec_helper'

SingleCov.covered!
SingleCov.covered! file: "lib/gutentag/tagged_with_query.rb"

describe Gutentag::ActiveRecord do
  describe '.tagged_with' do
    let!(:melbourne_article) do
      article = Article.create :title => 'Overview'
      article.tag_names << 'melbourne'
      article.save!
      article
    end

    let!(:oregon_article) do
      article = Article.create
      article.tag_names << 'oregon'
      article.save!
      article
    end

    let!(:melbourne_oregon_article) do
      article = Article.create
      article.tag_names = %w(oregon melbourne)
      article.save!
      article
    end

    context 'given a single tag name' do
      subject { Article.tagged_with('melbourne') }

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melbourne_article, melbourne_oregon_article }
      it { is_expected.not_to include oregon_article }
    end

    context 'given a single tag name[symbol]' do
      subject { Article.tagged_with(:melbourne) }

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melbourne_article, melbourne_oregon_article }
      it { is_expected.not_to include oregon_article }
    end

    context 'given a denormalized tag name' do
      subject { Article.tagged_with("MelbournE") }

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melbourne_article, melbourne_oregon_article }
      it { is_expected.not_to include oregon_article }
    end

    context 'given multiple tag names' do
      subject { Article.tagged_with('melbourne', 'oregon') }

      it { expect(subject.count).to eq 3 }
      it { is_expected.to include melbourne_article, oregon_article, melbourne_oregon_article }
    end

    context 'given an array of tag names' do
      subject { Article.tagged_with(%w(melbourne oregon)) }

      it { expect(subject.count).to eq 3 }
      it { is_expected.to include melbourne_article, oregon_article, melbourne_oregon_article }
    end

    context 'given a single tag instance' do
      subject { Article.tagged_with(Gutentag::Tag.find_by_name!('melbourne')) }

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melbourne_article, melbourne_oregon_article }
      it { is_expected.not_to include oregon_article }
      it { expect(subject.to_sql).not_to include 'gutentag_tags' }
    end

    context 'given a single tag id' do
      subject { Article.tagged_with(Gutentag::Tag.find_by_name!('melbourne').id) }

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melbourne_article, melbourne_oregon_article }
      it { is_expected.not_to include oregon_article }
      it { expect(subject.to_sql).not_to include 'gutentag_tags' }
    end

    context 'given multiple tag objects' do
      subject { Article.tagged_with(Gutentag::Tag.where(name: %w(melbourne oregon))) }

      it { expect(subject.count).to eq 3 }
      it { is_expected.to include melbourne_article, oregon_article, melbourne_oregon_article }
      it { expect(subject.to_sql).not_to include 'gutentag_tags' }
    end

    context 'chaining where clause' do
      subject { Article.tagged_with(%w(melbourne oregon)).where(title: 'Overview') }

      it { expect(subject.count).to eq 1 }
      it { is_expected.to include melbourne_article }
      it { is_expected.not_to include oregon_article, melbourne_oregon_article }
    end
  end
end
