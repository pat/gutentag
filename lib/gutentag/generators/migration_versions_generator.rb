# frozen_string_literal: true

require "rails/generators"

module Gutentag
  module Generators
    class MigrationVersionsGenerator < Rails::Generators::Base
      desc "Update the ActiveRecord version in Gutentag migrations"

      def update_migration_versions
        superclass = "ActiveRecord::Migration[#{rails_version}]"

        if ::ActiveRecord::VERSION::MAJOR < 5
          superclass = "ActiveRecord::Migration"
        end

        migration_files.each do |file|
          gsub_file file,
            /< ActiveRecord::Migration\[4\.2\]$/,
            "< #{superclass}"
        end
      end

      private

      def migration_files
        Dir[Rails.root.join("db/migrate/*.rb")].select do |path|
          known_migration_names.any? do |known|
            File.basename(path)[/\A\d+_#{known}\.gutentag.rb\z/]
          end
        end
      end

      def known_migration_names
        @known_migration_names ||= begin
          Dir[File.join(__dir__, "../../../db/migrate/*.rb")].collect do |path|
            File.basename(path).gsub(/\A\d+_/, "").gsub(/\.rb\z/, "")
          end
        end
      end

      def rails_version
        @rails_version ||= [
          ::ActiveRecord::VERSION::MAJOR,
          ::ActiveRecord::VERSION::MINOR
        ].join(".")
      end
    end
  end
end
