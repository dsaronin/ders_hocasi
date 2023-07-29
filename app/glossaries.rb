# 
# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#   
#

  require "yaml"

class Glossaries
  include Sources

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  CLASS-LEVEL actions & methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  # input GLOSSARIES database here if not done already 

  @@database ||= YAML.unsafe_load_file( "app/assets/glossaries.yml" )
  Environ.log_info( "Glossaries data loaded: #{@@database.length} entries" )
 
end # Glossaries


