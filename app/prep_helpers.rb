#!/usr/bin/env ruby
# DersHocası: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#
# hocasi prep helpers for views
# ------------------------------------------------------

module Sinatra

  module AssetHelpers
# ------------------------------------------------------
# ------------------------------------------------------

  #  ------------------------------------------------------------
  #  save_session_state -- save state in user's session
  #  ------------------------------------------------------------
  def save_session_state(card)
    session[:settings] = YAML.dump(  
      card.prep_serialize_settings  # capture state
    )
  end

  def is_valid_class?(name)
    Object.const_defined?(name) && Object.const_get(name).is_a?(Class)
  end

  def get_parent_source_path( obj )
    return nil if obj.belongs_to.nil? || obj.belongs_to.empty?
    (source, key) = obj.belongs_to
    return nil unless is_valid_class?(source) && !key.nil? && !key.empty?
    return nil unless Module.const_get(source).respond_to? :get_item
    return nil if Module.const_get(source).get_item(key).nil?

    return "#{source}__#{key}"
  end

  #  ------------------------------------------------------------
  #  get_glossary  -- returns array of glossary items else nil
  #  ------------------------------------------------------------
  def get_glossary( obj )
    return nil if obj.has_glossary.nil?

    source = Glossaries.find_glossary( obj.has_glossary )
    return source.fc_data unless source.nil?

    flash[:error] = "Glossary <#{obj.has_glossary}> not found; typo?"
    return nil
  end

  #  ------------------------------------------------------------
  #  get_glossary_path  -- returns path for glossary
  #  ------------------------------------------------------------
  def get_glossary_path( obj )
    return nil if obj.has_glossary.nil?
    return nil if Glossaries.find_glossary( obj.has_glossary ).nil?
    return "Glossaries__#{obj.has_glossary}"
  end

  #  ------------------------------------------------------------
  #  helper_load_path -- DRY work to get path, decode, stuff in settings
  #  ------------------------------------------------------------
  def helper_load_path()
    helper_get_settings
    path = params[:path]
    if path.nil?
      flash[:error] = "aux path params missing."
    else
      (source,key) = path.split(/__/)
      puts "PATH: source: #{source}, key: #{key}"
      if !is_valid_class?(source)  ||  key.nil?  || key.empty?
        flash[:error] = "aux source or key invalid/missing."
      else
        @settings[:source] = source
        @settings[:entry]  = key
      end  # if.then.else source/key checks
    end   # if.then.else path missing

    return @settings
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def prep_dialog
    @front = @front.gsub( /^.: / , "" )
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def prep_opposites
    @front = @front.gsub( /::/, " &harr; " )
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def prep_dictionary
    @rear = @rear.split( /; / )
  end

  #  ------------------------------------------------------------
  #  helper_font_sizing  -- calcs size of font for player display
  #  ------------------------------------------------------------
  def helper_font_sizing
      # calculate variable font sizing
    @fontsize = case @front.length
                when (1..5)   then "huge"
                when (6..8)   then "large"
                when (9..16)  then "big1"
                when (17..39) then "big2"
                when (40..59) then "big3"
                else 
                  "normal"
                end
  end

  #  ------------------------------------------------------------
  #  helper_flashcard_display  -- stuff to get ready for view
  #  ------------------------------------------------------------
  def helper_flashcard_display( card, show )
    @action_box = :action_player   # use special action box
    @dark_background = true

    @front = show[0]
    @rear  = show[1]
    @time  = show[2] || 0    # maybe will be a time code for audio

    key = case card.my_settings[:side]
           when /front/ then card.extract_key( @front )
           when /back/  then card.extract_key( @rear )
           else
             ""   # empty key
           end
    @examples = card.mine_examples( key )
    @settings = card.my_settings
    @source = card.my_settings[:source]
    @recording_file = card.my_source.recording
    unless @rear_toggle.nil?
      card.show_rear ^= @rear_toggle
    end
    @show_rear = card.show_rear   # pick up switch for rear display
    @aux_type = "fc"
    @aux_path = get_parent_source_path(card.my_source)  || 
                get_glossary_path( card.my_source )

    case @source
      when /Dialogs/     then prep_dialog
      when /Opposites/   then prep_opposites
      when /Dictionary/  then prep_dictionary
    end

    helper_font_sizing
    save_session_state(card)
  end

  #  ------------------------------------------------------------
  #  prep_flashcards  -- DRY prep & start flashcards
  #  args:
  #    restore_session -- true if restore state from prev session
  #    no_lessons -- true if don't allow Source as Lessons
  #    new_settings  -- nil (if default or restore), else updated settings
  #  returns flashcard obj
  #  ------------------------------------------------------------
  def prep_flashcards(restore_session, no_lessons, new_settings)
    settings = (
      !restore_session || session[:settings].nil? ? 
      new_settings  :  
      YAML.load(session[:settings]) 
    )

    topic = ( settings && settings[:topic]  ?  settings[:topic]  : "def" )

    if no_lessons  &&  !settings.nil?  &&  settings[:source] == "Lessons"
      settings[:source] = "Vocabulary"
      flash[:error] = "Source set to Vocabulary."
    end

      # ok even if settings==nil at this point
    return HOCASI.do_flashcards( [topic.to_s], settings )
  end

  #  ------------------------------------------------------------
  #  helper_prep_player  -- does common player setup preparations
  #  args: 
  #    playcmd: command to be passed to player
  #    restore_session:  true if restore session; default false
  #    settings: nil or new set of settings for starting player
  #  returns: true if keep playing card; false to exit player
  #  ------------------------------------------------------------
  def helper_prep_player(playcmd = Player::PCMD_CURR, restore_session = false, new_settings=nil)

    @redirect_to_source = false

      # ok even if settings==nil at this point
    player = prep_flashcards(restore_session, true, new_settings).start_card_player

    if player.nil?  # due to exception
      loop = false
      if ($!.nil? || $!.message.match( /^Source/ ) )
        @redirect_to_source = true  
      end
    else
        # have the player do a command
      (loop, show) = player.commands( [playcmd] )

      # setup variables for player display
      helper_flashcard_display( player.card, show )
    end  # outer if

    return loop
  end

  #  ------------------------------------------------------------
  #  helper_do_player  -- DRYs up player controls coding
  #    primary difference from starting, is that we want to
  #    restore state from rack-sessions cookie
  #  ------------------------------------------------------------
  def helper_do_player( cmd )
    if helper_prep_player(cmd, true)
      haml :flashcards
    elsif @redirect_to_source
        flash[:error] = "Invalid Topic or Source"
        redirect '/source'
    else  # quit command received
      redirect '/'
    end
  end

  #  ------------------------------------------------------------
  #  helper_start_player  -- used to start player
  #    with default or changed settings
  #    primary difference from do_player, is that we do not want to
  #    restore state from rack-sessions cookie; we'll either
  #    use a new changed settings OR the current default settings
  #  ------------------------------------------------------------
  def helper_start_player(settings = nil)
    if helper_prep_player( Player::PCMD_CURR, false, settings )
      haml :flashcards
    elsif @redirect_to_source
        flash[:error] = "Invalid Topic or Source"
        redirect '/source'
    else  # quit command received
      redirect '/'
    end
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def helper_get_settings()
    return @settings = ( session[:settings].nil?  ?
      FlashManager.default_settings :
      YAML.load( session[:settings] ) 
    )
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def helper_player_or_list(submit, settings)
    case submit
      when  /flashcards/ then helper_start_player( settings )
      when  /lists/      then helper_prep_lists( false, settings )
      else
        flash[:error] = "Unknown submit type"
        redirect '/'
      end  # case
  end

  # ------------------------------------------------------
  # ------------------------------------------------------
  def helper_list_display(card)
      # setup variables for player display
    @action_box = :action_player   # use special action box
    @skip_menu = true    # skips player menu
    @topic  = card.my_settings[:topic]
    @source = card.my_settings[:source]
    @list   = card.my_source.fc_data[0..80]
    @text   = card.text_or_bullets
    @recording_file = card.my_source.recording
    @time   = 0
    @glossary = get_glossary( card.my_source )
    @aux_type = "list"
    @aux_path = get_parent_source_path(card.my_source)

    if @source == "Opposites"
      @subchar = [/::/, " &harr; "]
    end

    save_session_state(card)

    haml :lists
  end

  # ------------------------------------------------------
  # topic, source, list
  # ------------------------------------------------------
  def helper_prep_lists(restore_session = true, new_settings=nil)

    card = prep_flashcards(restore_session, true, new_settings)

    if card.nil?    # due to exception
      flash[:error] = "Invalid Topic or Source"
      redirect '/'
    elsif !card.listable? 
      flash[:error] = "Cannot list Lessons nor Dictionary!"
      redirect '/settings'
    else
      helper_list_display(card)
    end  # outer if

  end

  # ------------------------------------------------------
  # ------------------------------------------------------
  def helper_lessons_display(card,incr)
      # setup variables for player display
    @action_box = :action_player   # use special action box
    @skip_menu = true    # skips player menu

    @l   = card.my_source     # @l is the "lesson"
    @cur_ptr = card.my_settings[:cur_ptr]  || 0
    @cur_ptr += incr

    if @l.nil? ||  @l.my_topic != @settings[:topic]
      flash[:error] = "Missing Topic for Lessons; choose another."
      redirect '/'
    else
      @recording_file = @l.recording
      @time   = 0

      @cur_ptr = 0 if @cur_ptr >= @l.fc_data.length
      @cur_ptr = @l.fc_data.length - 1 if  @cur_ptr < 0

      card.cur_ptr = @cur_ptr

      save_session_state(card)

      haml :lessons
    end
  end

  # ------------------------------------------------------
  # 
  # ------------------------------------------------------
  def helper_prep_lessons( default=false, incr = 0 )

    helper_get_settings

    if default
      @settings[:topic] = Lessons.default_topic 
      @settings[:cur_ptr] = 0
    end

    @settings[:source] = "Lessons"    # spoof the source
    card = prep_flashcards( false, false, @settings )

    if card.nil?    # due to exception
      flash[:error] = "Invalid Topic or Source"
      redirect '/'
    else
      helper_lessons_display(card, incr)
    end  # outer if

  end

# ------------------------------------------------------
  # *************************************************
# ------------------------------------------------------
        
  end   #  module AssetHelpers
        
# ------------------------------------------------------
  # *************************************************
# ------------------------------------------------------
      
  helpers AssetHelpers

# ------------------------------------------------------
  # *************************************************
# ------------------------------------------------------
end  # module sinatra 
