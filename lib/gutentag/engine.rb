# frozen_string_literal: true

class Gutentag::Engine < Rails::Engine
  engine_name :gutentag

  config.after_initialize do
    ActiveSupport.run_load_hooks :gutentag
  end
end
