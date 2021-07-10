# frozen_string_literal: true

require "fileutils"
require "gutentag/generators/migration_versions_generator"

class AdjustMigrations
  def self.call(application)
    new(application).call
  end

  def initialize(application)
    @application = application
  end

  def call
    copy_migrations_to_app
    run_generator
    run_migrations
  end

  private

  attr_reader :application

  def copy_migrations_to_app
    FileUtils.mkdir_p application.root.join("db/migrate")

    Dir["#{__dir__}/../../db/migrate/*.rb"].each do |file|
      name = File.basename(file.gsub(/rb\z/, "gutentag.rb"))
      destination = application.root.join("db/migrate/#{name}")

      FileUtils.cp file, destination.to_s
    end
  end

  def migration_context
    if ActiveRecord::MigrationContext.instance_method(:initialize).arity <= 1
      ActiveRecord::MigrationContext.new migration_paths
    else
      ActiveRecord::MigrationContext.new(
        migration_paths, ActiveRecord::Base.connection.schema_migration
      )
    end
  end

  def migration_paths
    application.root.join("db/migrate")
  end

  def run_generator
    Gutentag::Generators::MigrationVersionsGenerator.start(
      ["--quiet"], :destination_root => application.root
    )
  end

  def run_migrations
    if ActiveRecord::VERSION::STRING.to_f >= 5.2
      migration_context.migrate
    else
      ActiveRecord::Migrator.migrate migration_paths, nil
    end
  end
end
