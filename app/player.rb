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
    PCMD_PREV1    = :prev
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

      when  "c", "curr"      then  do_current
      when  "f", "flip"      then  do_flip
      when  "p", "prev"      then  do_back
      when  "n", "next"      then  do_next
      when  "s", "shuffle"   then  do_shuffle
      when  "u", "unshuf"    then  do_unshuffle

      when  "0", "gplus"     then  do_start_over
      when  "+", "gplus"     then  do_next_group
      when  "-", "gminus"    then  do_prev_group
      when  "g", "gminus"    then  do_group_head

      when  "x", "exit"      then  loop = false; []  # exit program
      when  "q", "quit"      then  loop = false; [] # exit program
      else     
       do_next 
    end  # case

    return [loop, show]
  end


  #  ------------------------------------------------------------
  def do_current
    return @card.current_card
  end

  #  ------------------------------------------------------------
  def do_flip
    return @card.current_card.reverse
  end

  #  ------------------------------------------------------------
  def do_back
    return @card.prev_card
  end

  #  ------------------------------------------------------------
  def do_next
    return @card.next_card
  end

  #  ------------------------------------------------------------
  def do_shuffle
    return @card.shuffle_cards
  end

  #  ------------------------------------------------------------
  def do_unshuffle
    return @card.unshuffle_cards
  end

  #  ------------------------------------------------------------
  def do_group_head
    return @card.head_card
  end

  def do_next_group
    return @card.next_group_card
  end

  def do_prev_group
    return @card.prev_group_card
  end

  def do_start_over
    return @card.reset_cards
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

end  # Player
