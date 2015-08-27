# Gutentag

[![Gem Version](https://badge.fury.io/rb/gutentag.png)](http://badge.fury.io/rb/gutentag)
[![Build Status](https://travis-ci.org/pat/gutentag.png?branch=master)](https://travis-ci.org/pat/gutentag)
[![Code Climate](https://codeclimate.com/github/pat/gutentag.png)](https://codeclimate.com/github/pat/gutentag)

A good, simple, solid tagging extension for ActiveRecord.

This was built partly as a proof-of-concept, and partly to see how a tagging gem could work when it's not all stuffed within models, and partly just because I wanted a simpler tagging library. If you want to know more, read [this blog post](http://freelancing-gods.com/posts/gutentag_simple_rails_tagging).

## Installation

Get it into your Gemfile - and don't forget the version constraint!

    gem 'gutentag', '~> 0.7.0'

Next: your tags get persisted to your database, so let's import and run the migrations to get the tables set up:

    rake gutentag:install:migrations
    rake db:migrate

If you want to use Gutentag outside of Rails, you can. However, this means you lose the migration import rake task. As a workaround, here's the expected schema (as of 0.7.0):

    create_table :gutentag_taggings do |t|
      t.integer :tag_id,        :null => false
      t.integer :taggable_id,   :null => false
      t.string  :taggable_type, :null => false
      t.timestamps :null => false
    end

    add_index :gutentag_taggings, :tag_id
    add_index :gutentag_taggings, [:taggable_type, :taggable_id]
    add_index :gutentag_taggings, [:taggable_type, :taggable_id, :tag_id],
      :unique => true, :name => 'unique_taggings'

    create_table :gutentag_tags do |t|
      t.string  :name,           :null => false
      t.integer :taggings_count, :null => false, :default => 0
      t.timestamps :null => false
    end

    add_index :gutentag_tags, :name, :unique => true
    add_index :gutentag_tags, :taggings_count

## Upgrading

### 0.6.0

Rails 4.2 is supported as of Gutentag 0.6.0 - but please note that due to internal changes in ActiveRecord, changes to tag_names will no longer be tracked by your model's dirty state. This feature will continue to work in Rails 3.2 through to 4.1 though.

### 0.5.0

Between 0.4.0 and 0.5.0, Gutentag switched table names from `tags` and `taggings` to `gutentag_tags` and `gutentag_taggings`. This has been done to avoid conflicting with the more generic table names that may exist in Rails apps already.

If you were using Gutentag 0.4.0 (or older) and now want to upgrade, you'll need to create a migration manually that renames these tables:

    rename_table :tags,     :gutentag_tags
    rename_table :taggings, :gutentag_taggings

## Usage

The first step is easy: add the tag associations to whichever models should have tags (in these examples, the Article model):

    class Article < ActiveRecord::Base
      # ...
      has_many_tags
      # ...
    end

That's all it takes to get a tags association on each article. Of course, populating tags can be a little frustrating, unless you want to manage Gutentag::Tag instances yourself? As an alternative, just use the tag_names accessor to get/set tags via string representations.

    article.tag_names #=> ['pancakes', 'melbourne', 'ruby']
    article.tag_names << 'portland'
    article.tag_names #=> ['pancakes', 'melbourne', 'ruby', 'portland']
    article.tag_names -= ['ruby']
    article.tag_names #=> ['pancakes', 'melbourne', 'portland']

Changes to tag_names are not persisted immediately - you must save your taggable object to have the tag changes reflected in your database:

    article.tag_names << 'ruby'
    article.save

## Contribution

Please note that this project now has a [Contributor Code of Conduct](http://contributor-covenant.org/version/1/0/0/). By participating in this project you agree to abide by its terms.

## Licence

Copyright (c) 2013-2015, Gutentag is developed and maintained by Pat Allan, and is released under the open MIT Licence.
