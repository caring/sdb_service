module Constantizer

  def constantize(klass_name, load_path)
    require "#{load_path}/#{klass_name}"
    eval(klass_name.gsub(/^[a-z]|\s|_+[a-z]/) { |a| a.upcase }.gsub(/\s|_/, '')) rescue nil
  end

end