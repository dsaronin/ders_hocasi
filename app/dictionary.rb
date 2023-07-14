# 
# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#   
#

class Dictionary

  FIELD_DELIMITER = /\t/
  DICTFILE = "app/assets/dictionary.txt"

  ENTRY = 0   # field index for key entry
  DEF   = 1   # field index for english definition
  EX    = 2   # field index for examples
 
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  CLASS-LEVEL actions & methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  #  ------------------------------------------------------------
  #  load_dictionary  -- loads verb database and creates dictionary
  #  ------------------------------------------------------------
  def Dictionary.load_data(file)
    Environ.log_info "Loading dictionary..."
    File.open(file, "r") do |f|
      while n = f.gets
        fields = n.chomp.split( FIELD_DELIMITER )
        key = fields[ ENTRY ]
        key.gsub!( /\s*{.+}/, "") unless key.nil?

        unless key.nil?
          @@data[key] ||= []
          list = fields[DEF..EX]
          puts "KEY #{key} yielding list empty!" if list.nil?
          @@data[key] <<= ( list.nil? || list.empty?  ?  [""]  :  list )
        end  # unless
        
      end  # while reading each line in file
    end  # file read
    Environ.log_info "Dictionary has #{@@data.length} entries."
  end

  #  ------------------------------------------------------------
  #  mine_examples  -- gather examples for a given dictionary key
  #  ------------------------------------------------------------
  def self.mine_examples(key)
    list = []

    defs = @@data[key]
    return list if defs.nil?

    defs.each do |adef|
      list.push( adef[1] )
    end

    return list.compact
  end


  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  def initialize( topic=nil )
    @fc_data = @@data
    @fc_keys = @@data.keys
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  @@database ||= Hash.new
  @@data = Hash.new
  Dictionary.load_data( DICTFILE )
  @@database[:dictionary] = Dictionary.new

  def self.database
    @@database
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  include Sources

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  get_data_at_index -- returns an array of [front,back] data 
  #  for a card at a given index.
  #  validity checking for index is performed. if beyond the limits
  #  of the database, will simply return data at the limit.
  #  ------------------------------------------------------------
  #  Dictionary is different from other sources; it 
  #  is a hash of key => array of definitions & examples
  #  so the index will be the index into the array of keys.
  #  then we'll have to mash together the definitions to yield our
  #  expected result of [front, back]
  #  ------------------------------------------------------------
  def get_data_at_index( index, side = "front" )
    index = clamp_index( index, @fc_keys.length )
    key = @fc_keys[index]
    # puts "Dictionary get_data @ #{index} for key #{key}"

    back = ""
    @fc_data[key].each { |english| back <<= english[0] + "; " }

    return side_conversion( [key, back.chop.chop], side )
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def mine_examples( key )

    return []
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
end  # Dictionary
