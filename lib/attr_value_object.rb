require 'attr_value_object/version'
require 'active_support/core_ext/string'

module AttrValueObject
  def attr_value_object(name, options = {})
  	klass = Object.const_get(options.fetch(:class_name, name.to_s.camelize))

  	define_method(name) do
			mappings = methods.map { |m| m.match(/\A#{name}_([0-9a-z_]+)\z/).try { |match| [m, match[1]] } }.compact
			params = {}
			mappings.each do |source, target|
				params[target.to_sym] = send(source.to_sym)
			end
			klass.new(params)
  	end

  	define_method("#{name}=") do |obj|
      mappings = methods.map { |m| m.match(/\A#{name}_([0-9a-z_]+)=\z/).try { |match| [m, match[1]] } }.compact
      mappings.each do |source, target|
        send(source, obj.send(target))
      end
      obj
  	end
  end
end
