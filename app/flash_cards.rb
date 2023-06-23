# 
# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#   
# FlashCards manages the big picture of generating and
# formatting flash card objects
#
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

class FlashCards
  require 'pp'

  SOURCE_TYPES   = %w{topics vocabulary sentences phrases dictionary dialog articles}
  SELECTOR_TYPES = %w{all random issues new}
  SIZER_TYPES    = %w{all 5 10 20 50}
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

  def FlashCards.show_defaults()
    return @@defaults.inspect
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def initialize()
    @my_settings = @@defaults.clone   # set my settings from defaults
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  #  instance methods
  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
 
end  # FlashCards

