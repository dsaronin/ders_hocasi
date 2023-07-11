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
    # Environ.log_info 
    puts "Loading dictionary..."
    File.open(file, "r") do |f|
      while n = f.gets
        fields = n.chomp.split( FIELD_DELIMITER )
        key = fields[ ENTRY ]
        @@data[key] ||= []
        @@data[key] <<= fields[DEF..EX]
      end  # while reading each line in file
    end  # file read
    # Environ.log_info 
    puts "Dictionary has #{@@data.length} entries."
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  def initialize( topic=nil )
    @fc_data = @@data
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  @@database ||= Hash.new
  @@data = Hash.new
  Dictionary.load_data( DICTFILE )
  @@database[:dictionary] = Dictionary.new


  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  include Sources

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
end  # Dictionary
