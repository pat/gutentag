require 'rails/engine'

class Gutentag::Engine < Rails::Engine
  ActiveSupport.on_load :active_record do
    include Gutentag::ActiveRecord
  end
end
