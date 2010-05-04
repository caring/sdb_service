module SdbService
  module Constantizer

    # hackish helper method for properly casting a string to a constantized class.
    def constantize(klass_name, load_path)
      require "#{load_path}/#{klass_name}"
      eval(klass_name.gsub(/^[a-z]|\s|_+[a-z]/) { |a| a.upcase }.gsub(/\s|_/, '')) rescue nil
    end

  end
end