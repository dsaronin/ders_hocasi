# 
# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#   
# FlashCard manages group of values for a 
# sequence of flash cards to be displayed.
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

class FlashCard

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  CLASS-LEVEL actions & methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  
  def initialize( topic, set )
    @topic = topic
    @set = set
    self.reset
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  instance methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  def reset
    @index = 0
  end
 

end   # FlashCard
