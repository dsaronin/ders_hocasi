# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#
# module Sources -- loosely defines an interface for all Hocasi sources
#
#

module Sources

  def self.find( key )
    return @@database || self.new
  end

  def fc_data
    return @fc_data  || []
  end

end  # module


# placeholders until we can write the code
class Vocabulary; include Sources; end
class Phrases ; include Sources;   end
class Dictionary ; include Sources;end
class Dialog ; include Sources;    end
class Articles ; include Sources;  end


