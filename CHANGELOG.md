# Changelog

All notable changes to this project (at least, from v0.5.0 onwards) will be documented in this file.

## Unreleased

### Changed

* Switch normalising of tag names from a callback within `Gutentag::Tag` to `#name=` ([Tomasz Ras](https://github.com/pat/gutentag/pull/47)).

## 2.1.0 - 2018-02-01

### Added

* `Gutentag::RemoveUnused` is now present, and can be invoked with the `call` method. It will remove all unused tags (i.e. tags that aren't connected to any taggable objects). Related to [#19](https://github.com/pat/gutentag/issues/19).

### Fixed

* Tag validations logic fails gracefully when no database exists (Nishutosh Sharma in [#46](https://github.com/pat/gutentag/pull/46)).

## 2.0.0 - 2017-12-27

### Changed

This is **a breaking change** if you're using Gutentag without Rails: To ensure database-reliant code isn't invoked before it should be, `ActiveSupport.run_load_hooks :gutentag` should be called after your database is connected.

## 1.1.0 - 2017-12-16

No breaking changes.

Thanks to [Robin](https://github.com/rmehner), Gutentag::Tag#name will now validate default database column lengths ([#41](https://github.com/pat/gutentag/pull/41)).

## 1.0.0 - 2017-10-29

Behaviour that was deprecated in 0.9.0 (`has_many_tags`, `tagged_with` arguments) have now been removed.

## 0.9.0 - 2017-06-02

* In your models with tags, change `has_many_tags` to `Gutentag::ActiveRecord.call self`.
* Any calls to `tagged_with` should change from `Model.tagged_with('ruby', 'pancakes')` to `Model.tagged_with(:names => ['ruby', 'pancakes'])`.

In both of the above cases, the old behaviour will continue to work for 0.9.x releases, but with a deprecation warning.

## 0.8.0 - 2017-01-19

No breaking changes.

## 0.7.0 - 2015-08-27

No breaking changes.

## 0.6.0 - 2015-01-24

Rails 4.2 is supported as of Gutentag 0.6.0 - but please note that due to internal changes in ActiveRecord, changes to tag_names will no longer be tracked by your model's dirty state. This feature will continue to work in Rails 3.2 through to 4.1 though.

## 0.5.1 - 2014-07-29

## 0.5.0 - 2013-09-10

Between 0.4.0 and 0.5.0, Gutentag switched table names from `tags` and `taggings` to `gutentag_tags` and `gutentag_taggings`. This has been done to avoid conflicting with the more generic table names that may exist in Rails apps already.

If you were using Gutentag 0.4.0 (or older) and now want to upgrade, you'll need to create a migration manually that renames these tables:

```Ruby
rename_table :tags,     :gutentag_tags
rename_table :taggings, :gutentag_taggings
```

## 0.4.0 - 2013-09-03

## 0.3.0 - 2013-08-07

## 0.2.2 - 2013-07-25

## 0.2.1 - 2013-07-25

## 0.2.0 - 2013-07-15

## 0.1.0 - 2013-07-11
