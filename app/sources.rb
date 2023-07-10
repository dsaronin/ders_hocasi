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

    def find_or_new( key )
      obj = self.find( key ) || allocate
      obj.send(:initialize, key)

      if self.class_variable_get(:@@database).nil?
        self.class_variable_set(:@@database, obj) 
      end
      return obj
    end

    #  ------------------------------------------------------------
    #  sorted_keys -- returns array of keys (data entries) for 
    #  a given database
    #  ------------------------------------------------------------
    def sorted_keys
      return self.class_variable_get(:@@database).keys.sort
    end

    private

    def find( key )
      db = self.class_variable_get(:@@database)
      return nil if db.nil?
      if db.kind_of?( Hash )
        obj = db[ ( key.is_a?(Symbol) ? key : key.to_sym ) ]
        return (obj.nil?  ?  db[db.keys.first]  : obj) 
      end
      return db if db.kind_of?( Sources )
      raise NameError, "Source class of: #{db.class} unexpected."
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
  #  list_size  -- returns the length of data list
  #  ------------------------------------------------------------
  def list_size
    return fc_data.length
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
class Dictionary ; include Sources; @@database = nil;  end
class Articles ; include Sources; @@database = nil;  end

