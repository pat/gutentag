# frozen_string_literal: true

class Gutentag::TagValidations
  def self.call(klass)
    new(klass).call
  end

  def initialize(klass)
    @klass = klass
  end

  def call
    klass.validates :name,
      :presence   => true,
      :uniqueness => {:case_sensitive => false}

    limit = klass.columns_hash["name"].limit
    klass.validates_length_of :name, :maximum => limit if limit
  end

  private

  attr_reader :klass
end
