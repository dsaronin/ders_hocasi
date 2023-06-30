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
    self.reset   # resets internal state of indexes
  end

  # to get current flashcard value:
  # fc_data[ @shuffle_index[@cur_ptr] + @group_dex ]

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  instance methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  #  ------------------------------------------------------------

  #  ------------------------------------------------------------
  def reset         # --resets all internals
    unshuffle
    @group_dex  = 0   # index at start of first group
  end

  #  ------------------------------------------------------------
  def unshuffle       # --restore normal index order
    @cur_ptr    = 0   # current index into @shuffle_indexes
    @shuffle_indexes = (0..(@size-1)).to_a  # normal order
  end

  #  ------------------------------------------------------------
  def unshuffle_cards  
    unshuffle
    return current_card
  end

  #  ------------------------------------------------------------
  def current_card
    return @source.fc_data[ @shuffle_indexes[@cur_ptr] + @group_dex ]
  end

  #  ------------------------------------------------------------
  def reset_cards
    reset
    return current_card
  end

  #  ------------------------------------------------------------
  def shuffle_cards
    @shuffle_indexes.shuffle!(random: Random.new(3))
    @cur_ptr    = 0   # current index into @shuffle_indexes
    return current_card
  end

  #  ------------------------------------------------------------
  def next_card
    if ( (@cur_ptr += 1) >= @size ) 
      @cur_ptr = 0
    end
    return current_card
  end

  #  ------------------------------------------------------------
  def prev_card
    if ( (@cur_ptr -= 1) < 0 ) 
      @cur_ptr = @size - 1
    end
    return current_card
  end

  #  ------------------------------------------------------------
  def head_card
    @cur_ptr    = 0   # current index into @shuffle_indexes
    return current_card
  end

  #  ------------------------------------------------------------
  def next_group_card
    len =  @source.fc_data.length
    if ( ((@group_dex += @size) + @size) > len)
      @group_dex = len - @size
    end
    @cur_ptr    = 0   # current index into @shuffle_indexes
    return current_card
  end

  #  ------------------------------------------------------------
  def prev_group_card
    if ( (@group_dex -= @size) < 0 )
      @group_dex = 0
    end
    @cur_ptr    = 0   # current index into @shuffle_indexes
    return current_card
  end


  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

end   # FlashCard
