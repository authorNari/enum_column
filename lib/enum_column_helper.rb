module EnumColumnHelper
  # generate selectbox options by enum
  #
  # * model_class_name
  # * enum_name
  # * options
  # * <tt>:name_space</tt> - I18n label name space
  # * <tt>:label_prefix</tt> - I18n label prefix
  # * <tt>:choices</tt> - choice enum keys.
  def select_options_for_const(model_class_name, enum_name, options={})
    options[:label_prefix] ||= enum_name.downcase.singularize
    model_name = model_class_name.underscore
    const = "#{model_class_name}::#{enum_name}".constantize
    options[:choices] ||= const.sort_by{|_, v| v}.map(&:first)

    options[:choices].map do |key|
      labels = []
      labels << options[:name_space] if options[:name_space]
      labels += [model_name, "#{options[:label_prefix]}_label", key]
      [t(labels.join(".")), const[key]]
    end
  end
end
