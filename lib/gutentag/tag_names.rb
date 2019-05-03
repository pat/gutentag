# frozen_string_literal: true

class Gutentag::TagNames
  def self.call(names)
    return nil if names.nil?

    names.reject(&:blank?).uniq
  end
end
