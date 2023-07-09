  require_relative 'sources'

class Lime
  include Sources
  @@database = "wildblue"

  def self.show; @@database; end

  def show; @@database; end
end
