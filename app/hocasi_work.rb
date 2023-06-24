# DrillTutor: A Drill Sergent for language students
# Copyright (c) 2023 David S Anderson, All Rights Reserved
#
# class HocasiWork -- main work module for doing everything
#

class HocasiWork
  require_relative 'environ'
  require_relative 'flash_manager'
 
  #  ------------------------------------------------------------
  #  initialize  -- creates a new object
  #  ------------------------------------------------------------
  def initialize()
    @my_env    = Environ.instance
  end

  #  ------------------------------------------------------------
  #  hocasi  -- creates a new hocasi system work object
  #  CLI entry point
  #  ------------------------------------------------------------
  def hocasi()
    setup_work()
    do_work()      # do the work of çekimi
    shutdown_work()

    return 1
  end


  #  ------------------------------------------------------------
  #  setup_work  -- handles initializing hocasi system
  #  ------------------------------------------------------------
  def setup_work()
    Environ.log_info( "starting..." )
    Environ.put_info FlashManager.show_defaults
  end

  #  ------------------------------------------------------------
  #  do_work  -- handles primary hocasi stuff
  #  CLI usage only
  #  ------------------------------------------------------------
  def do_work()
    Environ.put_message "\n\t#{ Environ.app_name }: A Drill Sergent for language learners.\n"
      # loop for command prompt & user input
    begin
      Environ.put_prompt("\n#{ Environ.app_name } > ")  
    end    while    parse_commands( Environ.get_input_list )
 
  end

  #  ------------------------------------------------------------
  #  shutdown_work  -- handles pre-termination stuff
  #  ------------------------------------------------------------
  def shutdown_work()
    Environ.log_info( "...ending" )
  end

  #  ------------------------------------------------------------
  #  parse_commands  -- command interface
  #  ------------------------------------------------------------
  def parse_commands( cmdlist )        
    loop = true                 # user input loop while true

        # parse command
    case ( cmdlist.first || ""  ).chomp

      when  "f", "flags"     then  do_flags( cmdlist )     # print flags
      when  "h", "help"      then  do_help      # print help
      when  "v", "version"   then  do_version   # print version
      when  "o", "options"   then  do_options   # print options

      when  "x", "exit"      then  loop = false  # exit program
      when  "q", "quit"      then  loop = false  # exit program

      when  ""               then  loop = true   # empty line; NOP
      else        
        do_flashcards( cmdlist )
    end

    return loop
    end
  
  #  ------------------------------------------------------------
  #  do_status  -- display list of all hocasi rules
  #  ------------------------------------------------------------
  def do_status
    sts = ""
    Environ.put_info ">>>>> status:  " + sts
    return sts
  end

  #  ------------------------------------------------------------
  #  do_flags  -- display flag states
  #  args:
  #    list  -- cli array, with cmd at top
  #  ------------------------------------------------------------
  def do_flags(list)
    list.shift  # pop first element, the "f" command
    if ( Environ.flags.parse_flags( list ) )
      Environ.change_log_level( Environ.flags.flag_log_level )
    end

    sts = Environ.flags.to_s
    Environ.put_info ">>>>>  flags: " + sts
    return sts
  end

  #  ------------------------------------------------------------
  #  do_help  -- display help line
  #  ------------------------------------------------------------
  def do_help
    sts = Environ.hocasi_help + "\n" + Environ.flags.to_help 
    Environ.put_info sts
    return sts
  end

  #  ------------------------------------------------------------
  #  do_version  -- display hocasi version
  #  ------------------------------------------------------------
  def do_version        
    sts = Environ.app_name + " v" + Environ.hocasi_version
    Environ.put_info sts  
    return sts
  end

  #  ------------------------------------------------------------
  #  do_options  -- display any options
  #  ------------------------------------------------------------
  def do_options        
    sts = ">>>>> options "
    Environ.put_info  sts  
    return sts
  end

  #  ------------------------------------------------------------
  #  ------------------------------------------------------------
  def do_flashcards( list )
    begin
      fm = FlashManager.new( list.first )
      fm.show_cards
    rescue ArgumentError
      Environ.put_and_log_error( ">>  " + $!.message )
    end  # exception handling
  end


  #  ------------------------------------------------------------
  #  ------------------------------------------------------------

end  # class HocasiWork

