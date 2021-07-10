# frozen_string_literal: true

class Gutentag::Engine < Rails::Engine
  engine_name :gutentag

  generators do
    require "gutentag/generators/migration_versions_generator"
  end
end
