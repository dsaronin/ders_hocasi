# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#
# module Sources -- loosely defines an interface for all Hocasi sources
# 
# makes initialize and new private; altho an extending class can
# define.
# DESIRED way to create an object: find_or_new( key )
#

module Sources
  def self.included(klass)
    klass.private_class_method :new
    klass.extend(ClassMethods)
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  ClassMethods -- will be extended into receiving class
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  module ClassMethods

    def find( key )
      return @@database 
    end

    def find_or_new( key )
      obj = self.find( key ) || allocate
      obj.send(:initialize, key)
      @@database ||= obj
      return obj
    end

  end  # ClassMethods

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  instance methods  -- will be included into receiving class
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  def fc_data
    return @fc_data  || []
  end

  private

  def initialize( topic )
  end

end  # module


# placeholders until we can write the code
class Vocabulary; include Sources; end
class Phrases ; include Sources;   end
class Dictionary ; include Sources;end
class Dialog ; include Sources;    end
class Articles ; include Sources;  end


