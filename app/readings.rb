# 
# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#   
#

  require "yaml"

class Readings
  include Sources

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  CLASS-LEVEL actions & methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  # input READINGS database here if not done already 

  @@database ||= YAML.unsafe_load_file( "app/assets/readings.yml" )
  Environ.log_info( "Readings data loaded: #{@@database.length} entries" )
 
end # Readings


