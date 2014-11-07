class String
  def camelize
    self.split("_").each {|s| s.capitalize! }.join("")
  end

  def snakecase
    #gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr('-', '_').
    gsub(/\s/, '_').
    gsub(/__+/, '_').
    downcase
  end

  def constantize
     names = self.split('::')
     names.shift if names.empty? || names.first.empty?
     names.inject(Object) do |constant, name|
       if constant == Object
         constant.const_get(name)
       else
         candidate = constant.const_get(name)
         next candidate if constant.const_defined?(name, false)
         next candidate unless Object.const_defined?(name)
         # Go down the ancestors to check it it's owned
         # directly before we reach Object or the end of ancestors.
         constant = constant.ancestors.inject do |const, ancestor|
           break const    if ancestor == Object
           break ancestor if ancestor.const_defined?(name, false)
           const
         end
         # owner is in Object, so raise
         constant.const_get(name, false)
       end
     end
   end
end
