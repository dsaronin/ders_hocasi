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

    def find_or_new( key, entry = nil )
      obj = self.find( key, entry ) || allocate
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

    #  ------------------------------------------------------------
    #  find  -- finds the source obj for generating flashcards
    #  args:
    #    key -- topics key
    #    entry -- non-topics hash key to try
    #  returns: an object of the main Class hoding data
    #  ------------------------------------------------------------
    def find( key, entry )
      db = self.class_variable_get(:@@database)
      return nil if db.nil?

      if db.kind_of?( Hash )

        use_key = ( entry.nil?  ?  key  :  entry )
        obj = db[ ( use_key.is_a?(Symbol) ? use_key : use_key.to_sym ) ]

        return ( obj.nil?  ? db[db.keys.first] : obj ) 

      end

      return db if db.kind_of?( Sources )

      raise EntryError, "Source class of: #{db.class} unexpected."
    end

  end  # ClassMethods

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  instance methods  -- will be included into receiving class
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  #  ------------------------------------------------------------
  #  clamp_index -- returns a valid index into an array
  #  for a card at a given index.
  #  validity checking for index is performed. if beyond the limits
  #  of the database, will simply return data at the limit.
  #  ------------------------------------------------------------
  def clamp_index(index, length)
    index = 0 if index < 0
    index = length-1 if index >= length
    return index
  end

  #  ------------------------------------------------------------
  #  get_data_at_index -- returns an array of [front,back] data 
  #  NOTE: normally *should* access data this way.
  #  ------------------------------------------------------------
  def get_data_at_index( index )
    return fc_data[ clamp_index(index, fc_data.length) ]
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
class Articles ; include Sources; @@database = nil;  end

