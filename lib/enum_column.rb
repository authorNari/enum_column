module EnumColumn
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def enum_column(column, *options)
      enum = ActiveSupport::OrderedHash.new
      if options.first.is_a?(Hash)
        options.first.sort_by{|_, v| v.to_s.to_i}.each{|k, v| enum[k.to_sym] = v}
      else
        options.each_with_index{|k, i| enum[k.to_sym] = i+1}
      end
      const_name = column.to_s.pluralize.upcase
      self.const_set(const_name, enum.freeze)

      enum.each do |key, value|
        class_eval <<-METHOD
          def #{column}_#{key}?; #{column} == #{const_name}[:#{key}]; end
        METHOD
      end

      class_eval <<-METHO
        def #{column}_name
          #{const_name}.invert[#{column}]
        end
      METHO
    end
  end
end
