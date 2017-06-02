class Gutentag::TaggedWith
  def self.call(model, options)
    match = options[:match] || :any
    if options[:ids]
      IDQuery.new(model, options[:ids], match).call
    elsif options[:tags]
      IDQuery.new(model, Array(options[:tags]).collect(&:id), match).call
    else
      NameQuery.new(model, options[:names], match).call
    end
  end
end

require 'gutentag/tagged_with/query'
require 'gutentag/tagged_with/id_query'
require 'gutentag/tagged_with/name_query'
