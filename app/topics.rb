# 
# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#   
#

  require "yaml"

class Topics

  attr_accessor :name, :alt_name, :category, :target, :source
  attr_accessor :description, :summary, :vocabulary

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  CLASS-LEVEL actions & methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  # input TOPICS database here if not done already 
  #  ------------------------------------------------------------
  @@database ||= YAML.unsafe_load_file( "app/assets/topics.yml" )
  Environ.log_info( "Topics data loaded: #{@@database.length} entries" )
  #  ------------------------------------------------------------

  #  ------------------------------------------------------------
  #  default_topic  -- returns the first topic in keys list
  #  ------------------------------------------------------------
  def Topics.default_topic
    return @@database.keys.first
  end

  #  ------------------------------------------------------------
  #  find -- returns the Topics obj associated with a key; else nil
  #  ------------------------------------------------------------
  def Topics.find( key )
    return @@database[ key.to_sym ]
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  instance methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

 
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
end # Topics
