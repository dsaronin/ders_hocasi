# 
# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#   
#

  require "yaml"

class Opposites
  include Sources

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  CLASS-LEVEL actions & methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  # input OPPOSITES database here if not done already 

  @@database ||= YAML.unsafe_load_file( "app/assets/opposites.yml" )
  Environ.log_info( "Opposites data loaded: #{@@database.length} entries" )
 
end # Opposites

