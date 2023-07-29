# 
# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#   
#

  require "yaml"

class Glossary
  include Sources

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  CLASS-LEVEL actions & methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  # input GLOSSARY database here if not done already 

  @@database ||= YAML.unsafe_load_file( "app/assets/glossary.yml" )
  Environ.log_info( "Glossary data loaded: #{@@database.length} entries" )
 
end # Glossary


