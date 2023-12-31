# 
# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#   
#

  require "yaml"

class Dialogs
  include Sources

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  CLASS-LEVEL actions & methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  # input DIALOGS database here if not done already 

  @@database ||= YAML.unsafe_load_file( "app/assets/dialogs.yml" )
  Environ.log_info( "Dialogs data loaded: #{@@database.length} entries" )
 
end # Dialogs

