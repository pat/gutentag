# frozen_string_literal: true

require "spec_helper"

describe Gutentag::ActiveRecord do
  describe ".tagged_with" do
    let!(:melbourne_article) do
      article = Article.create :title => "Overview"
      article.tag_names << "melbourne"
      article.save!
      article
    end

    let!(:oregon_article) do
      article = Article.create
      article.tag_names << "oregon"
      article.save!
      article
    end

    let!(:melbourne_oregon_article) do
      article = Article.create
      article.tag_names = %w[ oregon melbourne ]
      article.save!
      article
    end

    context "given a single tag name" do
      subject { Article.tagged_with(:names => "melbourne") }

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melbourne_article, melbourne_oregon_article }
      it { is_expected.not_to include oregon_article }
    end

    context "given a single tag name[symbol]" do
      subject { Article.tagged_with(:names => :melbourne) }

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melbourne_article, melbourne_oregon_article }
      it { is_expected.not_to include oregon_article }
    end

    context "given a denormalized tag name" do
      subject { Article.tagged_with(:names => "MelbournE") }

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melbourne_article, melbourne_oregon_article }
      it { is_expected.not_to include oregon_article }
    end

    context "given multiple tag names" do
      subject { Article.tagged_with(:names => %w[ melbourne oregon ]) }

      it { expect(subject.count).to eq 3 }
      it do
        is_expected.to include(
          melbourne_article, oregon_article, melbourne_oregon_article
        )
      end
    end

    context "given an array of tag names" do
      subject { Article.tagged_with(:names => %w[ melbourne oregon ]) }

      it { expect(subject.count).to eq 3 }
      it do
        is_expected.to include(
          melbourne_article, oregon_article, melbourne_oregon_article
        )
      end
    end

    context "given a single tag instance" do
      subject do
        Article.tagged_with(:tags => Gutentag::Tag.find_by_name!("melbourne"))
      end

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melbourne_article, melbourne_oregon_article }
      it { is_expected.not_to include oregon_article }
      it { expect(subject.to_sql).not_to include "gutentag_tags" }
    end

    context "given a single tag id" do
      subject do
        Article.tagged_with(:ids => Gutentag::Tag.find_by_name!("melbourne").id)
      end

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melbourne_article, melbourne_oregon_article }
      it { is_expected.not_to include oregon_article }
      it { expect(subject.to_sql).not_to include "gutentag_tags" }
    end

    context "given multiple tag objects" do
      subject do
        Article.tagged_with(
          :tags => Gutentag::Tag.where(:name => %w[ melbourne oregon ])
        )
      end

      it { expect(subject.count).to eq 3 }
      it do
        is_expected.to include(
          melbourne_article, oregon_article, melbourne_oregon_article
        )
      end
      it { expect(subject.to_sql).not_to include "gutentag_tags" }
    end

    context "chaining where clause" do
      subject do
        Article.tagged_with(:names => %w[ melbourne oregon ]).
          where(:title => "Overview")
      end

      it { expect(subject.count).to eq 1 }
      it { is_expected.to include melbourne_article }
      it { is_expected.not_to include oregon_article, melbourne_oregon_article }
    end

    context "appended onto a relation" do
      subject do
        Article.where(:title => "Overview").
          tagged_with(:names => %w[ melbourne oregon ])
      end

      it { expect(subject.count).to eq 1 }
      it { is_expected.to include melbourne_article }
      it { is_expected.not_to include oregon_article, melbourne_oregon_article }
    end

    context "matching against all tags" do
      subject do
        Article.tagged_with(:names => %w[ melbourne oregon ], :match => :all)
      end

      it { expect(subject.count).to eq 1 }
      it { is_expected.to include melbourne_oregon_article }
      it { is_expected.not_to include oregon_article, melbourne_article }
    end

    context "matching against all tag ids" do
      let(:tag_ids) do
        Gutentag::Tag.where(:name => %w[ melbourne oregon ]).pluck(:id)
      end
      subject { Article.tagged_with(:ids => tag_ids, :match => :all) }

      it { expect(subject.count).to eq 1 }
      it { is_expected.to include melbourne_oregon_article }
      it { is_expected.not_to include oregon_article, melbourne_article }
    end

    context "matching against all one tag is the same as any" do
      subject { Article.tagged_with(:names => %w[ melbourne ], :match => :all) }

      it { expect(subject.count).to eq 2 }
      it { is_expected.to include melbourne_article, melbourne_oregon_article }
      it { is_expected.not_to include oregon_article }
    end
  end
end
