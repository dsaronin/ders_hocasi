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

    EMPTY_DATA = [["boş","tupu"]]

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

  #  ------------------------------------------------------------
  #  get_data_at_index -- returns an array of [front,back] data 
  #  for a card at a given index.
  #  validity checking for index is performed. if beyond the limits
  #  of the database, will simply return data at the limit.
  #  NOTE: normally *should* access data this way.
  #  ------------------------------------------------------------
  def get_data_at_index( index )
    list = fc_data
    index = 0 if index < 0
    index = list.length-1 if index >= list.length
    return list[index]
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  private

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def initialize( topic )
  end

  #  ------------------------------------------------------------
  #  fc_data -- returns the array of [front,back] data for cards
  #  NOTE: normally shouldn't access data this way.
  #  ------------------------------------------------------------
  def fc_data
    return  @fc_data  ||  EMPTY_DATA
  end

end  # module


# placeholders until we can write the code
class Dictionary ; include Sources; end
class Articles ; include Sources;  end

