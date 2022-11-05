# Gutentag

[![Gem Version](https://badge.fury.io/rb/gutentag.svg)](http://badge.fury.io/rb/gutentag)
[![Build Status](https://github.com/pat/gutentag/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/pat/gutentag/actions/)
[![Code Climate](https://codeclimate.com/github/pat/gutentag.svg)](https://codeclimate.com/github/pat/gutentag)

A good, simple, solid tagging extension for ActiveRecord.

This was initially built partly as a proof-of-concept, partly to see how a tagging gem could work when it's not all stuffed within models, and partly just because I wanted a simpler tagging library. It's now a solid little tagging Rails engine.

If you want to know more, read [this blog post](http://freelancing-gods.com/posts/gutentag_simple_rails_tagging), or have a look at [the Examples page](https://github.com/pat/gutentag/wiki/Examples) in the wiki (which includes a starting point for accepting tag values in a form).

## Contents

* [Usage](#usage)
* [Installation](#installation)
* [Upgrading](#upgrading)
* [Configuration](#configuration)
* [Extending](#extending)
* [Contribution](#contribution)
* [Licence](#licence)

<h2 id="usage">Usage</h2>

The first step is easy: add the tag associations to whichever models should have tags (in these examples, the Article model):

```Ruby
class Article < ActiveRecord::Base
  # ...
  Gutentag::ActiveRecord.call self
  # ...
end
```

That's all it takes to get a tags association on each article. Of course, populating tags can be a little frustrating, unless you want to manage Gutentag::Tag instances yourself? As an alternative, just use the tag_names accessor to get/set tags via string representations.

```Ruby
article.tag_names #=> ['pancakes', 'melbourne', 'ruby']
article.tag_names << 'portland'
article.tag_names #=> ['pancakes', 'melbourne', 'ruby', 'portland']
article.tag_names -= ['ruby']
article.tag_names #=> ['pancakes', 'melbourne', 'portland']
```

Changes to tag_names are not persisted immediately - you must save your taggable object to have the tag changes reflected in your database:

```Ruby
article.tag_names << 'ruby'
article.save
```

You can also query for instances with specified tags. The default `:match` mode is `:any`, and so provides OR logic, not AND - it'll match any instances that have _any_ of the tags or tag names:

```Ruby
Article.tagged_with(:names => ['tag1', 'tag2'], :match => :any)
Article.tagged_with(
  :tags  => Gutentag::Tag.where(name: ['tag1', 'tag2']),
  :match => :any
)
Article.tagged_with(:ids => [tag_id], :match => :any)
```

To return records that have _all_ specified tags, use `:match => :all`:

```ruby
# Returns all articles that have *both* tag_a and tag_b.
Article.tagged_with(:ids => [tag_a.id, tag_b.id], :match => :all)
```

To return records that have _none_ of the specified tags, use `:match => :none`:

```ruby
# Returns all articles that have *neither* tag_a nor tag_b.
Article.tagged_with(:ids => [tag_a.id, tag_b.id], :match => :none)
```

To return all tag names used by an instance of a model or relation

```ruby
# Returns array of tag names
Gutentag::Tag.names_for_scope(Article)
# => ['tag1', 'tag2', 'tag3']

Gutentag::Tag.names_for_scope(Article.where(:created_at => 1.week.ago..1.second.ago))
# => ['tag3']

# Return array of the tag names used from the two most recent articles
Gutentag::Tag.names_for_scope(Article.order(created_at: :desc).limit(2))
# => []
```

<h2 id="installation">Installation</h2>

### Dependencies

These are the versions the test suite runs against. It's possible it may work on older versions of Ruby, but it definitely won't work on older versions of Rails.

* Ruby: MRI v2.3-v3.1, JRuby v9.2.5
* Rails/ActiveRecord: v4.0-v7.0

If you're using MRI v2.2 and/or ActiveRecord v3.2, the last version of Gutentag that fully supported those versions is v2.4.1.

### Installing

Get it into your Gemfile - and don't forget the version constraint!

```Ruby
gem 'gutentag', '~> 2.6'
```

Next: your tags get persisted to your database, so let's import the migrations, update them to your current version of Rails, and then migrate:

```Bash
bundle exec rake gutentag:install:migrations
bundle exec rails generate gutentag:migration_versions
bundle exec rake db:migrate
```

If you're using UUID primary keys, make sure you alter the migration files before running `db:migrate` to use UUIDs for the `taggable_id` foreign key column (as noted in [issue 57](https://github.com/pat/gutentag/issues/57).)

### Without Rails

If you want to use Gutentag outside of Rails, you can. However, there is one caveat: You'll want to set up your database with the same schema (as importing in the migrations isn't possible without Rails). The schema from 0.7.0 onwards is below:

```ruby
create_table :gutentag_tags do |t|
  t.string :name,           null: false, index: {unique: true}
  t.bigint :taggings_count, null: false, index: true, default: 0
  t.timestamps              null: false
end

create_table :gutentag_taggings do |t|
  t.references :tag,      null: false, index: true, foreign_key: {to_table: :gutentag_tags}
  t.references :taggable, null: false, index: true, polymorphic: true
  t.timestamps            null: false
end
add_index :gutentag_taggings, [:taggable_type, :taggable_id, :tag_id], unique: true, name: "gutentag_taggings_uniqueness"
```

<h2 id="upgrading">Upgrading</h2>

Please refer to the [CHANGELOG](CHANGELOG.md), which covers significant and breaking changes between versions.

<h2 id="configuration">Configuration</h2>

Gutentag tries to take a convention-over-configuration approach, while also striving to be modular enough to allow changes to behaviour in certain cases.

### Tag validations

The default validations on `Gutentag::Tag` are:

* presence of the tag name.
* case-insensitive uniqueness of the tag name.
* maximum length of the tag name (if the column has a limit).

You can view the logic for this in [`Gutentag::TagValidations`](lib/gutentag/tag_validations.rb), and you can set an alternative if you wish:

```ruby
Gutentag.tag_validations = CustomTagValidations
```

The supplied value must respond to `call`, and the argument supplied is the model.

### Tag normalisation

Tag normalisation is used to convert supplied tag values consistently into string tag names. [The default](lib/gutentag.rb#L15) is to convert the value into a string, and then to lower-case.

If you want to do something different, provide an object that responds to call and accepts a single value to `Gutentag.normaliser`:

```ruby
Gutentag.normaliser = lambda { |value| value.to_s.upcase }
```

### Case-sensitive tags

Gutentag ignores case by default, but can be customised to be case-sensitive by supplying your own validations and normaliser, as outlined by [Robin Mehner](https://github.com/rmehner) in [issue 42](https://github.com/pat/gutentag/issues/42). Further changes may be required for your schema though, depending on your database.

<h2 id="extending">Extending</h2>

If you need to extend Gutentag's models, you will need to wrap the `include` inside a `to_prepare` hook to ensure it's loaded consistently in all Rails environments:

```ruby
# config/initializers/gutentag.rb or equivalent
Rails.application.config.to_prepare do
  Gutentag::Tag.include TagExtensions
end
```

Further discussion and examples of this can be found in [issue 65](https://github.com/pat/gutentag/issues/65).

<h2 id="contribution">Contribution</h2>

Please note that this project now has a [Contributor Code of Conduct](http://contributor-covenant.org/version/1/0/0/). By participating in this project you agree to abide by its terms.

<h2 id="licence">Licence</h2>

Copyright (c) 2013-2022, Gutentag is developed and maintained by Pat Allan, and is released under the open MIT Licence.
