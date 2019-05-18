local conky = conky or {
  DEBUG = true
}

function conky_main()
end

function conky.main()
end

do 
  conky.config = {
      out_to_x = false,
      out_to_console = true,
      times_in_seconds = false,
      update_interval = 5,
      update_interval_on_battery = 5,
      double_buffer = true,
      lua_load = '/home/jg/.i3/view.lua'
  }
  conky.text = '${lua main}'
end