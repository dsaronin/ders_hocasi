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
  require_relative 'vocabulary'
  require_relative 'sentences'
  require_relative 'player'
  require_relative 'phrases'
  require_relative 'readings'
  require_relative 'dialogs'
  require_relative 'opposites'
  require_relative 'dictionary'
  require_relative 'lessons'
  require_relative 'glossaries'

  attr_reader :my_settings, :my_source
  attr_accessor  :cur_ptr, :show_rear
 
  SOURCE_TYPES   = %w{Vocabulary Opposites Sentences Phrases Dialogs Readings Glossaries Dictionary}
  SELECTOR_TYPES = %w{ordered shuffled}
  SIZER_TYPES    = [5, 10, 15, 25, 50]
  GROUP_SIZES    = %w{5 10 15 25 50}   # display for html select
  SIDE_TYPES     = %w{front back shuffle}

    # TODO: future to be implemented
  SPEED_TYPES    = %w{slow medium fast}
  PLAYER_TYPES   = %w{manual auto}

    # TODO: might never be implemented
  ANSWER_TYPES   = %w{typed multiple-choice none}

  # EXAMPLE_TYPES used to invoke mine_examples in each
  # type of class and in the order given
  EXAMPLE_TYPES   = %w{Phrases Dialogs Sentences Readings Dictionary}
  # text types get shown without bullets in lists
  TEXT_TYPES   = %w{Dialogs Readings}
  LIST_TYPES   = %w{Vocabulary Sentences Phrases Opposites Readings Dialogs Glossary}

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  CLASS-LEVEL actions & methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
 
  @@defaults = {
    :topic    => Vocabulary.default_topic,
    :source   => SOURCE_TYPES[0],
    :selector => SELECTOR_TYPES[0],
    :sizer    => SIZER_TYPES[0],
    :side     => SIDE_TYPES[0],
    :answer   => ANSWER_TYPES[0],
    :speed    => SPEED_TYPES[0],
    :player   => PLAYER_TYPES[0],
    :rear     => true          # true -- show rear of card
  }

  def FlashManager.show_defaults()
    return @@defaults.inspect
  end

  def FlashManager.default_settings
    return @@defaults
  end

  #  ------------------------------------------------------------
  #  initialize  -- a new FlashManager object
  #  either picks up state from where we left off in earlier request
  #  or resets state. Finds a topic and gets it set up
  #  exception if topic not found.
  #  ------------------------------------------------------------
  def initialize( key, settings )
    @my_settings = ( settings || @@defaults.clone )    # set my settings from defaults

    key.gsub!( /:/, "")  # remove misguided attemps at making a symbol
    topic = ( key =~ /^def(ault)?$/  ?  @my_settings[:topic]  : key )
    Environ.log_info "FLASHMGR: source: #{@my_settings[:source]}, topic: #{topic}, entry: #{@my_settings[:entry]}"
    @my_topic = Vocabulary.find_topic( topic )

    if @my_topic.nil?
      raise TopicError, "Topic: #{topic} not found"
    end

    @my_settings[:topic] = topic  # replace topic in settings

      # NOTE:  @my_settings[:source] is possibly nil; it's ok
    @my_source = Module.const_get( @my_settings[:source] ).
                find_or_new( topic,  @my_settings[:entry] )

    if @my_source.nil?
      raise EntryError, "Source for topic: #{topic} not found"
    end
    reset_if_start
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  instance methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  #  ------------------------------------------------------------
  #  start_card_player  -- connects with a source obj, starts player
  #  returns nil if source wasn't found
  #  else returns player obj
  #  ------------------------------------------------------------
  # TODO: might be better to raise an exception and pass code
  # to show that SOURCE needs resolution
  def start_card_player
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
      @show_rear = @my_settings[:rear]
      @group_dex = @my_settings[:group_dex]
      @shuffle_indexes = @my_settings[:shuffle_indexes]
    end  # if.then.else
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def reset         # --resets all internals
    unshuffle
    @group_dex  = 0   # index at start of first group
    @show_rear = true   # default: show rear of card
  end

  #  ------------------------------------------------------------
  #  random_selection  -- generates a random array of indexes
  #  args:
  #    max -- max length of items in main array
  #    size  -- group size of number of indexes to be returned
  #  returns -- array of indexes for choosing the group
  #  ------------------------------------------------------------
  def random_selection( max, size )
    (0..(max-1)).to_a.shuffle.take( size )
  end

  #  ------------------------------------------------------------
  #  set_indexes  -- resets the index array to starting values
  #  which depends upon selector: ordered or shuffled
  #  returns true if selector is ordered
  #  ------------------------------------------------------------
  def set_indexes
    if @my_settings[:selector].match /ordered/
      @shuffle_indexes = (0..(@my_settings[:sizer]-1)).to_a  # normal order
      is_ordered = true
    else
      @shuffle_indexes = random_selection( @my_source.fc_data.length, @my_settings[:sizer] )
      is_ordered = false
    end
    return is_ordered
  end

  #  ------------------------------------------------------------
  def unshuffle       # --restore normal index order
    @cur_ptr    = 0   # current index into @shuffle_indexes
    set_indexes       # reset the index array
  end

  #  ------------------------------------------------------------
  def unshuffle_cards  
    unshuffle
    return current_card
  end

  #  ------------------------------------------------------------
  def current_card
    index =  @shuffle_indexes[@cur_ptr] + @group_dex 
    return @my_source.get_data_at_index( index, @my_settings[:side] )
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
  #  next_group_card -- advances to next group
  #  if an ordered selection: always resets the index order
  #  if a shuffled selection: always grabs a new random group
  #  ------------------------------------------------------------
  def next_group_card
    if set_indexes
      len =  @my_source.list_size
      size = @my_settings[:sizer]
      if ( ((@group_dex += size) + size) > len)
        @group_dex = len - size
      end
    end  # if ordered

    @cur_ptr    = 0   # current index into @shuffle_indexes
    return current_card
  end

  #  ------------------------------------------------------------
  #  prev_group_card -- advances to prev group
  #  if an ordered selection: always resets the index order
  #  if a shuffled selection: always grabs a new random group
  #  ------------------------------------------------------------
  def prev_group_card
    if set_indexes
      if ( (@group_dex -= @my_settings[:sizer]) < 0 )
        @group_dex = 0
      end
    end  # if ordered

    @cur_ptr    = 0   # current index into @shuffle_indexes
    return current_card
  end


  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  def prep_serialize_settings
      # save current state
    @my_settings[:cur_ptr] = @cur_ptr
    @my_settings[:rear]    = @show_rear
    @my_settings[:group_dex] = @group_dex
    @my_settings[:shuffle_indexes] = @shuffle_indexes
 
    return @my_settings
  end

 
  #  ------------------------------------------------------------
  #  mine_examples  -- mines the various note resources
  #  extracting examples based on keyword(s)
  #    puts "mining for key: #{key}"
  #    puts "examples list: " + list.inspect
  #  ------------------------------------------------------------
  def mine_examples(key)
    list = []
    unless key.empty?
      if @my_settings[:source].match /Dictionary/
        list = Dictionary.mine_examples(key)
      else
        EXAMPLE_TYPES.each do |asset|
          list.concat(  
              Module.const_get( asset ).mine_examples(key)
          )
        end  # each asset
      end  # if.then.else Dictionary
    end  # unless empty key
    return list
  end

  #  ------------------------------------------------------------
  #  extract_key  -- extracts sometype of meaningful key from a
  #  string to be used to search for examples
  #  ------------------------------------------------------------
  def extract_key( str )
    return str if @my_settings[:source].match /Dictionary/
    return "" unless @my_settings[:source].match /Vocabulary|Opposites/
    keys = str.gsub(/[:;.,-=+?!|~^$#@&*<>]/,' ').split
    return "" if keys.empty?  ||  keys.length > 6
    return str if keys.length < 3
    return keys.sort{ |x,y| y.length <=> x.length }.first
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def text_or_bullets
    return TEXT_TYPES.include?  @my_settings[:source]
  end

  def listable?
    return LIST_TYPES.include?  @my_settings[:source]
  end
  
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
end  # FlashManager

