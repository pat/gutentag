# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :articles, :force => true do |t|
    t.string :title
    t.string :type
    t.timestamps :null => false
  end
end
