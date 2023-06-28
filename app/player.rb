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
  #  instance methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  #  ------------------------------------------------------------
  #  commands  -- player command interface
  #  returns [loop,display]
  #  ------------------------------------------------------------
  def commands( cmdlist )        
    loop = true                 # user input loop while true

        # parse command
    show = case ( cmdlist.first || ""  ).chomp

      when  "f", "flip"      then  do_flip
      when  "b", "back"      then  do_back
      when  "n", "next"      then  do_next
      when  ""               then  do_next
      when  "s", "shuffle"   then  do_shuffle
      when  "x", "exit"      then  loop = false; []  # exit program
      when  "q", "quit"      then  loop = false; [] # exit program
      else     
       do_next 
    end  # case

    return [loop, show]
  end


  #  ------------------------------------------------------------
  def do_flip
    return ["FLIP Reverse Side","FLIP Starting player"]
  end

  #  ------------------------------------------------------------
  def do_back
    return ["BACK Starting player","BACK Reverse Side"]
  end

  #  ------------------------------------------------------------
  def do_next
    return ["NEXT Starting player","NEXT Reverse Side"]
  end

  #  ------------------------------------------------------------
  def do_shuffle
    return ["SHUFFLE Starting player","SHUFFLE Reverse Side"]
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

end  # Player
