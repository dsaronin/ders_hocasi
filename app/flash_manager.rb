# 
# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#   
# FlashManager manages constructing and display flashcards
# also the big picture of selecting settings therefore
#
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

class FlashManager
  require 'pp'
  require_relative 'sources'
  require_relative 'topics'
  require_relative 'sentences'
  require_relative 'player'
 
  SOURCE_TYPES   = %w{Topics Vocabulary Sentences Phrases Opposites Dictionary Dialog Articles}
  SELECTOR_TYPES = %w{ordered random issues new}
  SIZER_TYPES    = [5, 10, 15, 25]
  SIDE_TYPES     = %w{front back shuffle}
  ANSWER_TYPES   = %w{typed multiple-choice none}
  SPEED_TYPES    = %w{slow medium fast}
  PLAYER_TYPES   = %w{auto repeat manual}

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  CLASS-LEVEL actions & methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
 
  @@defaults = {
    :topic    => Topics.default_topic,
    :source   => SOURCE_TYPES[0],
    :selector => SELECTOR_TYPES[0],
    :sizer    => SIZER_TYPES[0],
    :side     => SIDE_TYPES[0],
    :answer   => ANSWER_TYPES[0],
    :speed    => SPEED_TYPES[0],
    :player   => PLAYER_TYPES[0]
  }

  def FlashManager.show_defaults()
    return @@defaults.inspect
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def initialize( key, settings )
    @my_settings = ( settings || @@defaults.clone )    # set my settings from defaults

    key.gsub!( /:/, "")  # remove misguided attemps at making a symbol
    topic = ( key =~ /^def(ault)?$/  ?  @my_settings[:topic]  : key )
    @my_topic = Topics.find( topic )

    if @my_topic.nil?
      raise ArgumentError, "Topics: #{topic} not found"
    end

    @my_settings[:topic] = topic  # replace topic in settings
    @my_source = Module.const_get( @my_settings[:source] ).find_or_new( topic )
    
    reset_if_start
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  instance methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def start_card_player
    puts "SHOW CARDS for topic: #{@my_settings[:topic]}; " +
      "fc data items: #{@my_source.fc_data.length}"

    return  Player.new(self)
  end

  #  ------------------------------------------------------------
  #  reset_if_start -- resets internal state of indexes iff 1st time
  #  ------------------------------------------------------------
  def reset_if_start
    if @my_settings[:cur_ptr].nil?
      reset    # does a complete reset of all card pointers
    else
        # restore from user's previous session
      @cur_ptr   = @my_settings[:cur_ptr]
      @group_dex = @my_settings[:group_dex]
      @shuffle_indexes = @my_settings[:shuffle_indexes]
    end  # if.then.else
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def reset         # --resets all internals
    unshuffle
    @group_dex  = 0   # index at start of first group
  end

  #  ------------------------------------------------------------
  def unshuffle       # --restore normal index order
    @cur_ptr    = 0   # current index into @shuffle_indexes
    @shuffle_indexes = (0..(@my_settings[:sizer]-1)).to_a  # normal order
  end

  #  ------------------------------------------------------------
  def unshuffle_cards  
    unshuffle
    return current_card
  end

  #  ------------------------------------------------------------
  def current_card
    return @my_source.fc_data[ @shuffle_indexes[@cur_ptr] + @group_dex ]
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
    if ( (@cur_ptr += 1) >= @my_settings[:sizer] ) 
      @cur_ptr = 0
    end
    return current_card
  end

  #  ------------------------------------------------------------
  def prev_card
    if ( (@cur_ptr -= 1) < 0 ) 
      @cur_ptr = @my_settings[:sizer] - 1
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
    len =  @my_source.fc_data.length
    size = @my_settings[:sizer]
    if ( ((@group_dex += size) + size) > len)
      @group_dex = len - size
    end
    @cur_ptr    = 0   # current index into @shuffle_indexes
    return current_card
  end

  #  ------------------------------------------------------------
  def prev_group_card
    if ( (@group_dex -= @my_settings[:sizer]) < 0 )
      @group_dex = 0
    end
    @cur_ptr    = 0   # current index into @shuffle_indexes
    return current_card
  end


  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  def prep_serialize_settings
      # save current state
    @my_settings[:cur_ptr] = @cur_ptr
    @my_settings[:group_dex] = @group_dex
    @my_settings[:shuffle_indexes] = @shuffle_indexes
 
    return @my_settings
  end
 
end  # FlashManager

