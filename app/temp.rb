module Sources
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def mshow; self.class_variable_get(:@@database); end
  end  # ClassMethods

  def mshow; self.class.class_variable_get(:@@database); end

end  # module

class Lime
  include Sources
  @@database = "wildblue"

  def self.show; @@database; end

  def show; @@database; end
end
