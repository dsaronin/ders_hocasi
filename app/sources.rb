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

    attr_reader :recording, :has_glossary, :belongs_to
    attr_accessor  :my_topic

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  ClassMethods -- will be extended into receiving class
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  module ClassMethods


    def find_or_new( key, entry = nil )
      obj = self.find( key, entry ) 
      if obj.nil?
        allocate
        obj.send(:initialize, key)
      end

      if self.class_variable_get(:@@database).nil?
        self.class_variable_set(:@@database, obj) 
      end
      return obj
    end

    #  ------------------------------------------------------------
    #  default_topic  -- returns the first topic in keys list
    #  ------------------------------------------------------------
    def default_topic
      return self.class_variable_get(:@@database).keys.first
    end

    #  ------------------------------------------------------------
    #  sorted_keys -- returns array of keys (data entries) for 
    #  a given database
    #  ------------------------------------------------------------
    def sorted_keys
      return self.class_variable_get(:@@database).keys.sort
    end

    #  ------------------------------------------------------------
    #  empty_mine  -- common way to skip mining for examples
    #  ------------------------------------------------------------
    def empty_mine(key="")
      return []
    end

    #  ------------------------------------------------------------
    #  mine_examples  -- returns an example from DB for a key
    #  ------------------------------------------------------------
    def mine_examples(key)
      keyrex = Regexp.new("^(#{key})|\\s(#{key})", Regexp::IGNORECASE)

        # search thru all fc_data lists of all objs in DB
        # until a single match found, then return it
      self.class_variable_get(:@@database).each do |key,obj|
        obj.fc_data.each do |front,rear|
          if front.match keyrex
            return [front]   # got match, latch & exit
          end  # if match
        end  # do each fc_data item

      end   # do each obj in database
      return []   # no matches
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

        if obj.nil?
          use_key = db.keys.first
          obj = db[use_key]
        end

        obj.my_topic = use_key

        return obj

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

  def side_conversion(list, side)
    return list.reverse if side == "back"
    return list.shuffle if side == "shuffle"
    return list
  end

  #  ------------------------------------------------------------
  #  get_data_at_index -- returns an array of [front,back] data 
  #  NOTE: normally *should* access data this way.
  #  ------------------------------------------------------------
  def get_data_at_index( index, side = "front" )
    list = fc_data[ clamp_index(index, fc_data.length) ]
    return side_conversion(list, side)
  end

  #  ------------------------------------------------------------
  #  list_size  -- returns the length of data list
  #  ------------------------------------------------------------
  def list_size
    return fc_data.length
  end

  #  ------------------------------------------------------------
  #  fc_data -- returns the array of [front,back] data for cards
  #  NOTE: normally shouldn't access data this way.
  #  ------------------------------------------------------------
  def fc_data
    return  @fc_data  ||  EMPTY_DATA
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  private

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def initialize( topic )
    @my_topic = topic
  end

end  # module


# placeholders until we can write the code
class Articles ; include Sources; @@database = nil;  end

