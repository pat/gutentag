# frozen_string_literal: true

module Gutentag::ActiveRecord::ClassMethods
  def tagged_with(options)
    Gutentag::TaggedWith.call self, options
  end

  if ActiveRecord::VERSION::STRING.to_f < 4.2
    def skip_time_zone_conversion_for_attributes
      super + [:tag_names]
    end
  end

  if ActiveRecord::VERSION::STRING.to_f < 4.0
    def create_time_zone_conversion_attribute?(attr_name, column)
      attr_name != "tag_names" && super
    end

    def attribute_cast_code(attr_name)
      attr_name == "tag_names" ? "v" : super
    end
  end
end
