# frozen_string_literal: true

class Gutentag::TagValidations
  def self.call(klass)
    new(klass).call
  end

  def initialize(klass)
    @klass = klass
  end

  def call
    klass.validates :name, :presence => true,
      :uniqueness => {:case_sensitive => false}
  end

  private

  attr_reader :klass
end
