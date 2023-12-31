# 
# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#   
#

  require "yaml"

class Sentences
  include Sources

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  CLASS-LEVEL actions & methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  # input SENTENCES database here if not done already 

  @@database ||= YAML.unsafe_load_file( "app/assets/sentences.yml" )
  Environ.log_info( "Sentences data loaded: #{@@database.length} entries" )
 
end # Sentences

