# 
# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#   
# Player manages the formatting and display of flash card objects
#
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

class Player

    PCMD_EXIT     = :exit
    PCMD_FLIP     = :flip
    PCMD_BACK1    = :back
    PCMD_NEXT1    = :next
    PCMD_STOP     = :stop
    PCMD_START    = :start
    PCMD_HEAD     = :head
    PCMD_NEXT_GRP = :group
    PCMD_SHUFFLE  = :shfl


  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  CLASS-LEVEL actions & methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
 
    def initialize( card )
      @card = card
      card.reset   # initialize starting point
    end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

end  # Player
