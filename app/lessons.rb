# 
# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#   
#

  require "yaml"

class Lessons
  include Sources

  attr_reader  :title, :description, :introduction

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  CLASS-LEVEL actions & methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  # input LESSONS database here if not done already 

  @@database ||= YAML.unsafe_load_file( "app/assets/lessons.yml" )
  Environ.log_info( "Lessons data loaded: #{@@database.length} entries" )
 
end # Lessons

