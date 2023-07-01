# 
# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#   
# Player manages the formatting and display of flash card objects
#
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

class Player

  attr_reader  :card

    PCMD_CURR     = :curr
    PCMD_FLIP     = :flip
    PCMD_PREV     = :prev
    PCMD_NEXT     = :next
    PCMD_SHUFFLE  = :shfl
    PCMD_UNSHFLE  = :unsh

    PCMD_RESET    = :reset
    PCMD_NEXT_GRP = :gplus
    PCMD_PREV_GRP = :gminus
    PCMD_GHEAD    = :ghead

    PCMD_QUIT     = :quit

    PCMD_STOP     = :stop      # unused
    PCMD_START    = :start     # unused


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
  #  args: cmdlist array of strings or symbols for player commands
  #     only .first is accessed
  #  returns [loop,display]
  #  ------------------------------------------------------------
  def commands( cmdlist )        
    loop = true    # user input loop while true

    cmd = cmdlist.first || ""   # efficiency

        # parse command
    show = case ( cmd.is_a?(Symbol)  ?  cmd  :  cmd.chomp )

      when  "c", PCMD_CURR      then  do_current
      when  "f", PCMD_FLIP      then  do_flip
      when  "p", PCMD_PREV      then  do_back
      when  "n", PCMD_NEXT      then  do_next
      when  "s", PCMD_SHUFFLE   then  do_shuffle
      when  "u", PCMD_UNSHFLE   then  do_unshuffle

      when  "0", PCMD_RESET     then  do_start_over
      when  "+", PCMD_NEXT_GRP  then  do_next_group
      when  "-", PCMD_PREV_GRP  then  do_prev_group
      when  "g", PCMD_GHEAD     then  do_group_head

      when  "q", PCMD_QUIT      then  loop = false; [] # exit program
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
