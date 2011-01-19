module EnumColumn
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    # Define enum column to model.
    #
    # ==== Example
    #   enum_column :visibility, :privated, :friend_only, :publiced
    #   # Use alias column name.
    #   enum_column [:v, :visibility], :privated, :friend_only, :publiced
    #   # Change enum values. VISIBILITIES[:privated]) #=> 10
    #   enum_column :visibility, {privated: 10, friend_only: 11, publiced: 12}
    #
    # Define VISIBILITY constant.
    #
    #   Klass::VISIBILITIES[:privated] #=> 1
    #
    # Define methods.
    #
    #  # if visibility == VISIBILITIES[:privated]
    #  visibility_privated? #=> true
    #  visibility_friend_only? #=> false
    #  visibility_publiced? #=> false
    #  visibility_name #=> "privated"
    def enum_column(names, *options)
      enum = ActiveSupport::OrderedHash.new
      if options.first.is_a?(Hash)
        options.first.sort_by{|_, v| v.to_s.to_i}.each{|k, v| enum[k.to_sym] = v}
      else
        options.each_with_index{|k, i| enum[k.to_sym] = i+1}
      end
      if names.is_a?(Array)
        name, column = names
      else
        name = column = names
      end
      const_name = name.to_s.pluralize.upcase
      self.const_set(const_name, enum.freeze)

      enum.each do |key, value|
        class_eval <<-METHOD
          def #{name}_#{key}?; self[:#{column}] == #{const_name}[:#{key}]; end
        METHOD
      end

      class_eval <<-METHO
        def #{name}_name
          #{const_name}.invert[self[:#{column}]]
        end
      METHO
    end
  end
end
