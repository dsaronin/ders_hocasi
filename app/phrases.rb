# 
# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#   
#

  require "yaml"

class Phrases
  include Sources

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  CLASS-LEVEL actions & methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  # input PHRASES database here if not done already 

  @@database ||= YAML.unsafe_load_file( "app/assets/phrases.yml" )
  Environ.log_info( "Phrases data loaded: #{@@database.length} entries" )
 
end # Phrases

