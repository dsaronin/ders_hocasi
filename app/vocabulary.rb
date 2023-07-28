# 
# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#   
#

  require "yaml"

class Vocabulary
  include Sources

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  CLASS-LEVEL actions & methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  # input VOCABULARY database here if not done already 
  #  ------------------------------------------------------------
  @@database ||= YAML.unsafe_load_file( "app/assets/vocabulary.yml" )
  Environ.log_info( "Vocabulary data loaded: #{@@database.length} entries" )
  #  ------------------------------------------------------------

  #  ------------------------------------------------------------
  #  find_topic -- returns the vocabulary obj associated with a key; 
  #  else nil if not found 
  #     (flash_manager.initialize will generate an exception)
  #  ------------------------------------------------------------
  def self.find_topic( key )
    return @@database[ ( key.is_a?(Symbol) ? key : key.to_sym ) ]
  end

  #  ------------------------------------------------------------
  #  mine_examples  -- skip mining for examples from our DB
  #  ------------------------------------------------------------
  def self.mine_examples(key)
    return empty_mine
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  instance methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

 
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
end # Vocabulary
