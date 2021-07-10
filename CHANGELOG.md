# Changelog

All notable changes to this project (at least, from v0.5.0 onwards) will be documented in this file.

## 2.6.0 - 2021-07-10

### Added

* Queries can now be made for objects that have _none_ of the specified tags using `:match => :none` ([Rares S](https://github.com/laleshii) in [#79](https://github.com/pat/gutentag/pull/79)).
* Added a generator `gutentag:migration_versions` to update generated migrations so they use the current version of Rails/ActiveRecord's Migration superclass. See discussion in [#80](https://github.com/pat/gutentag/issues/80).

### Changed

* When adding Gutentag to a new app, the migrations require the `gutentag:migration_versions` generator to be run to ensure the latest ActiveRecord migration superclass is used. This change has no impact to existing apps. See discussion in [#80](https://github.com/pat/gutentag/issues/80).

## 2.5.4 - 2021-02-21

### Fixed

* Don't apply the tag length validation when `ActiveRecord::ConnectionNotEstablished` exceptions are raised. ([John Duff](https://github.com/jduff) in [#77](https://github.com/pat/gutentag/pull/77)).

## 2.5.3 - 2020-06-28

### Fixed

* Use `saved_change_to_tag_names?` instead of `tag_names_previously_changed?` for Rails 5.1+ ([Morten Trolle](https://github.com/mtrolle) in [#70](https://github.com/pat/gutentag/pull/70)).
* `Gutentag::Tag.names_for_scope` now handles empty scopes ([Mike Gunderloy](https://github.com/ffmike) in [#73](https://github.com/pat/gutentag/pull/73)).

## 2.5.2 - 2019-07-08

### Fixed

* `tag_names` will no longer be referenced as a database column when tagged models are requested in joins in Rails 4.2 (as reported in [issue #67](https://github.com/pat/gutentag/issues/67)).

## 2.5.1 - 2019-05-10

### Fixed

* Ensuring consistent behaviour for tag_names array - names are not duplicated, and are normalised prior to saving (as discussed in [issue #66](https://github.com/pat/gutentag/issues/66)).

## 2.5.0 - 2019-03-15

**Please note this release ends official support of Rails 3.2 and Ruby (MRI) 2.2.** The code currently still works on Ruby 2.2, and all features except for the new `Gutentag::Tag.names_for_scope` method work in Rails 3.2, but they're no longer tested against, and cannot be guaranteed to work in future releases.

### Added

* Added the `Gutentag::Tag.names_for_scope(scope)` method, which accepts an ActiveRecord model or a relation, and returns all tag names associated to that model/relation.

### Changed

* Removing support for MRI 2.2 and Rails 3.2.

## 2.4.1 - 2019-02-22

### Changed

* Tests are now run against Rails 6.0, MRI 2.6, JRuby 9.2.5.
* The README documents a simpler migration ([seelensonne](https://github.com/seelensonne) in [#55](https://github.com/pat/gutentag/pull/55)).

### Fixed

* Do not record changes when tag_names did not change ([Stephen Oberther](https://github.com/smo921) in [#60](https://github.com/pat/gutentag/pull/60)).

## 2.4.0 - 2018-05-18

### Changed

* Tag validation is now added only when the tag model is loaded, rather than when the app boots. This especially simplifies setup for non-Rails apps ([Michael Grosser](https://github.com/grosser) in [#54](https://github.com/pat/gutentag/pull/54)).
* A warning is displayed if the tag model is referenced without a database being present.
* Models are now lazily autoloaded for non-Rails apps (when `Rails::Engine` isn't present).

## 2.3.2 - 2018-04-27

### Fixed

* The `tagged_with` method now finds tagged objects belonging to STI models (as discussed in [#53](https://github.com/pat/gutentag/issues/53)).

## 2.3.1 - 2018-04-05

### Fixed

* Load tag validation code only when needed, rather than being reliant on database gems being loaded first.

## 2.3.0 - 2018-03-19

### Changed

* Filter out blank tag names when provided via `tag_names=` (as discussed in [#51](https://github.com/pat/gutentag/issues/51)).

### Fixed

* Tag validations logic fails gracefully when the database server cannot be reached.

## 2.2.1 - 2018-03-06

### Fixed

* Fix `tag_names` to return persisted values on a fresh load of a tagged object (which involved distinguishing Rails 4.2 behaviour from more recent approaches).

## 2.2.0 - 2018-03-04

### Added

* Dirty state support for `tag_names` is now available for Rails 4.2 onwards, and is more reliable for Rails 3.2-4.1 (supporting all known methods, such as `tag_names_changed?`, `previous_changes`, etc.)

### Changed

* Switch normalising of tag names from a callback within `Gutentag::Tag` to `#name=` ([Tomasz Ras](https://github.com/RasMachineMan) in [#47](https://github.com/pat/gutentag/pull/47)).

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
