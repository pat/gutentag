# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :articles, :force => true do |t|
    t.string :title
    t.string :type
    t.timestamps :null => false
  end

  create_table :comments, :force => true do |t|
    t.references :article
    t.string :name
    t.text :text
  end
end
