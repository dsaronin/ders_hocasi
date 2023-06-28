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
  
  def initialize( topic, source, size, side )
    @topic  = topic
    @source = source
    @size   = size
    @side   = side
    @cur_ptr = 0
    self.reset
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  instance methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  #  ------------------------------------------------------------
  #  reset -- resets all internals
  #  ------------------------------------------------------------
  def reset
    @index = 0
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
 

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

end   # FlashCard
