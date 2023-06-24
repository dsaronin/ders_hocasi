# 
# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#   
# FlashManager manages the big picture of flash card objects
#
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

class FlashManager
  require 'pp'
  require_relative 'topics'
  require_relative 'sentences'
  require_relative 'player'
  require_relative 'flash_card'
 
  SOURCE_TYPES   = %w{topics vocabulary sentences phrases dictionary dialog articles}
  SELECTOR_TYPES = %w{ordered random issues new}
  SIZER_TYPES    = %w{5 10 25}
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
  def initialize( key )
    @my_settings = @@defaults.clone   # set my settings from defaults
    topic = ( key =~ /^def(ault)?$/  ?  @my_settings[:topic]  : key )
    @my_topic = Topics.find( topic )
    if @my_topic.nil?
      raise ArgumentError, "Topics: #{topic} not found"
    end
    @my_settings[:topic] = topic  # replace topic in settings
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  instance methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

  def show_cards
    puts "SHOW CARDS for topic: #{@my_settings[:topic]}; " +
      "vocab items: #{@my_topic.vocabulary.length}"

    fc = FlashCard.new(
      @my_topic, 
      @my_topic.vocabulary, 
      @my_settings[:sizer],
      @my_settings[:side]
    )

    fp = Player.new(fc)
    fp.play
  end
 
end  # FlashManager

