FILE_DIRECTORY = '/home/jg/.i3/storage'

--
-- json.lua
--
-- Copyright (c) 2019 rxi
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
json_lua = loadstring[[local a={_version="0.1.1"}local b;local c={["\\"]="\\\\",["\""]="\\\"",["\b"]="\\b",["\f"]="\\f",["\n"]="\\n",["\r"]="\\r",["\t"]="\\t"}local d={["\\/"]="/"}for e,f in pairs(c)do d[f]=e end;local function g(h)return c[h]or string.format("\\u%04x",h:byte())end;local function i(j)return"null"end;local function k(j,l)local m={}l=l or{}if l[j]then error("circular reference")end;l[j]=true;if rawget(j,1)~=nil or next(j)==nil then local n=0;for e in pairs(j)do if type(e)~="number"then error("invalid table: mixed or invalid key types")end;n=n+1 end;if n~=#j then error("invalid table: sparse array")end;for o,f in ipairs(j)do table.insert(m,b(f,l))end;l[j]=nil;return"["..table.concat(m,",").."]"else for e,f in pairs(j)do if type(e)~="string"then error("invalid table: mixed or invalid key types")end;table.insert(m,b(e,l)..":"..b(f,l))end;l[j]=nil;return"{"..table.concat(m,",").."}"end end;local function p(j)return'"'..j:gsub('[%z\1-\31\\"]',g)..'"'end;local function q(j)if j~=j or j<=-math.huge or j>=math.huge then error("unexpected number value '"..tostring(j).."'")end;return string.format("%.14g",j)end;local r={["nil"]=i,["table"]=k,["string"]=p,["number"]=q,["boolean"]=tostring}b=function(j,l)local s=type(j)local t=r[s]if t then return t(j,l)end;error("unexpected type '"..s.."'")end;function a.encode(j)return b(j)end;local u;local function v(...)local m={}for o=1,select("#",...)do m[select(o,...)]=true end;return m end;local w=v(" ","\t","\r","\n")local x=v(" ","\t","\r","\n","]","}",",")local y=v("\\","/",'"',"b","f","n","r","t","u")local z=v("true","false","null")local A={["true"]=true,["false"]=false,["null"]=nil}local function B(C,D,E,F)for o=D,#C do if E[C:sub(o,o)]~=F then return o end end;return#C+1 end;local function G(C,D,H)local I=1;local J=1;for o=1,D-1 do J=J+1;if C:sub(o,o)=="\n"then I=I+1;J=1 end end;error(string.format("%s at line %d col %d",H,I,J))end;local function K(n)local t=math.floor;if n<=0x7f then return string.char(n)elseif n<=0x7ff then return string.char(t(n/64)+192,n%64+128)elseif n<=0xffff then return string.char(t(n/4096)+224,t(n%4096/64)+128,n%64+128)elseif n<=0x10ffff then return string.char(t(n/262144)+240,t(n%262144/4096)+128,t(n%4096/64)+128,n%64+128)end;error(string.format("invalid unicode codepoint '%x'",n))end;local function L(M)local N=tonumber(M:sub(3,6),16)local O=tonumber(M:sub(9,12),16)if O then return K((N-0xd800)*0x400+O-0xdc00+0x10000)else return K(N)end end;local function P(C,o)local Q=false;local R=false;local S=false;local T;for U=o+1,#C do local V=C:byte(U)if V<32 then G(C,U,"control character in string")end;if T==92 then if V==117 then local W=C:sub(U+1,U+5)if not W:find("%x%x%x%x")then G(C,U,"invalid unicode escape in string")end;if W:find("^[dD][89aAbB]")then R=true else Q=true end else local h=string.char(V)if not y[h]then G(C,U,"invalid escape char '"..h.."' in string")end;S=true end;T=nil elseif V==34 then local M=C:sub(o+1,U-1)if R then M=M:gsub("\\u[dD][89aAbB]..\\u....",L)end;if Q then M=M:gsub("\\u....",L)end;if S then M=M:gsub("\\.",d)end;return M,U+1 else T=V end end;G(C,o,"expected closing quote for string")end;local function X(C,o)local V=B(C,o,x)local M=C:sub(o,V-1)local n=tonumber(M)if not n then G(C,o,"invalid number '"..M.."'")end;return n,V end;local function Y(C,o)local V=B(C,o,x)local Z=C:sub(o,V-1)if not z[Z]then G(C,o,"invalid literal '"..Z.."'")end;return A[Z],V end;local function _(C,o)local m={}local n=1;o=o+1;while 1 do local V;o=B(C,o,w,true)if C:sub(o,o)=="]"then o=o+1;break end;V,o=u(C,o)m[n]=V;n=n+1;o=B(C,o,w,true)local a0=C:sub(o,o)o=o+1;if a0=="]"then break end;if a0~=","then G(C,o,"expected ']' or ','")end end;return m,o end;local function a1(C,o)local m={}o=o+1;while 1 do local a2,j;o=B(C,o,w,true)if C:sub(o,o)=="}"then o=o+1;break end;if C:sub(o,o)~='"'then G(C,o,"expected string for key")end;a2,o=u(C,o)o=B(C,o,w,true)if C:sub(o,o)~=":"then G(C,o,"expected ':' after key")end;o=B(C,o+1,w,true)j,o=u(C,o)m[a2]=j;o=B(C,o,w,true)local a0=C:sub(o,o)o=o+1;if a0=="}"then break end;if a0~=","then G(C,o,"expected '}' or ','")end end;return m,o end;local a3={['"']=P,["0"]=X,["1"]=X,["2"]=X,["3"]=X,["4"]=X,["5"]=X,["6"]=X,["7"]=X,["8"]=X,["9"]=X,["-"]=X,["t"]=Y,["f"]=Y,["n"]=Y,["["]=_,["{"]=a1}u=function(C,D)local a0=C:sub(D,D)local t=a3[a0]if t then return t(C,D)end;G(C,D,"unexpected character '"..a0 .."'")end;function a.decode(C)if type(C)~="string"then error("expected argument of type string, got "..type(C))end;local m,D=u(C,B(C,1,w,true))D=B(C,D,w,true)if D<=#C then G(C,D,"trailing garbage")end;return m end;return a]]!

do -- should refactor to use te stringbuilder
  with table
    sanitized  = (v) -> -- because '%q'\format v has different behavior on different lua versions
      switch type(v)
        when 'string'
         '%q'\format v
        when 'function'
          "assert(loadstring(#{sanitized string.dump v}))()"
        else 
          tostring v

    .load = (s) -> (assert loadstring "return #{s}")!
    .dump = (t, indentation = 4) -> 
      s = {}
      size = 1
      put  = (...) -> s[size], size = (select i, ...), size + 1 for i = 1, select '#', ...

      put '{', '\n'

      for k, v in pairs t
        put ' '\rep(indentation), "[#{sanitized k}] = "
        put .dump v, indentation + 4 if type(v) == 'table' else put sanitized v
        put ',\n'

      put ' '\rep(indentation - 4), '}'

      table.concat s

class Cacheable
  -- @name: Name of file to store cache
  -- @expiry: After how many seconds should a cache entry be considered stale?
  -- @fn: Callback used to update a cache entry.
  new: (@name, @expiry, @fn) => @check io.open "#{FILE_DIRECTORY}/#{name}", 'r+b' -- this should be a variable

  check: (file) => 
    return file\close! if file and #tostring(file\read('*a')) > 3 
    @set @fn!  
  
  -- @...: Arguments to updater callback
  get: (...) =>
    file     = io.open "#{FILE_DIRECTORY}/#{@name}", 'r+b'
    contents = table.load file\read '*a'
    file\close!

    if (os.time! - @expiry > contents.timestamp) 
      @set @fn ...
    else 
      contents.data

  -- @data: a table containing the data to be written
  -- @...: used for debug assertions (ignore it)
  set: (data, ...) => 
    if (select '#', ...) ~= 0
      error 'Note that Cacheable::set should receive exactly one argument.'

    file = io.open "#{FILE_DIRECTORY}/#{@name}", 'wb'
    file\write table.dump timestamp: os.time!, data: data
    file\close!

    data

  __call: (...) => @get ...

string_builder = {}
do
  with string_builder_mt = {}
    .__index    = string_builder_mt
    .__tostring = => table.concat @
    .put        = (v)   => @[#@ + 1] = tostring v
    .put_all    = (...) => @[#@ + 1] = select i, ... for i = 1, select '#', ...

    string_builder.new = -> setmetatable {}, string_builder_mt

serializer = {}
do
  with serializer
    fix = (t) ->
      for i = 1, #t - 1
        if t[i]\sub(-1) == ',' and t[i + 1]\sub(1,1)\match '[%}%]]'
          t[i] = t[i]\sub 1, -2

    .tostring = (t) ->
      assert t and type(t) == 'table', 'Invalid arguments.'

      output = string_builder.new!
      output\put '['

      for _, block in ipairs t
        output\put '{'
        for k, v in pairs block
          output\put '\"' -- refactor to put_all
          output\put k
          output\put '\":'

          local serializing

          assert type(v) ~= 'nil' and type(v) ~= 'userdata', 'Unserializable value.'

          if type(v) == 'table'
            t = {}
            for serializable in *v
              typename = type serializable
              assert typename == 'string' or typename == 'function', 'Unserializable value.'
              t[#t + 1] = typename == 'string' and serializable or serializable!
            serializing = table.concat t
          else
            serializing = v

          if type(v) == 'boolean' or type(v) == 'number'
            output\put serializing
          else
            output\put '\"'
            output\put(serializing)
            output\put '\"'

          output\put ','
        output\put '},'
      output\put '],'
      output\put ' '

      fix output

      tostring output

system = {}
do
  with system
    .volume = ->
      cmd = io.popen 'amixer get Master', 'r'
      amixerout = cmd\read '*a'

      io.close cmd

      return muted and 0 or tonumber amixerout\match '(%d+)%%'

    .battery = ->
      batteries = {'BAT0', 'BAT1'} -- should add autoreading w/acpi
      acpi, estimate = true, false

      fullenergy = 0
      currenergy = 0

      for _, bat in ipairs batteries
        f = io.open '/sys/class/power_supply/%s/energy_full'\format(bat), 'r'
        fullenergy = fullenergy + f\read '*n'
        io.close f

        f = io.open '/sys/class/power_supply/%s/energy_now'\format(bat), 'r'
        currenergy = currenergy + f\read '*n'
        io.close f

      percent = (currenergy / fullenergy) * 100

      if acpi then
        cmd = io.popen 'acpi', 'r'
        acpiout = cmd\read '*a'

        io.close cmd

        id = acpiout\match 'Battery (%d+): D?i?s?c?harging'
        estimated = ''
        if estimate then
          estimated = acpiout\match '([%d]*:?[%d]*):?%d* remaining'
          if not estimated then
            estimated = acpiout\match '([%d]*:?[%d]*):?%d* until'

        if not id then
          return 'BAT: %.2f%%'\format  percent -- incomplete

        return 'BAT%s: %.2f%% %s'\format id, percent, estimated
      else
        out   = 'BAT: %.2f%%'\format percent
        out ..= ' ${format_time ${battery_time BAT1}"\\hH \\mM"}' if estimate
        return out

    .song = ->
      characters = 30
      mode = 'time' -- or percent, or neither
      prefix = ''

      cmd    = io.popen 'mpc status', 'r'
      title  = cmd\read '*l'
      status = cmd\read '*l' or ''

      io.close cmd

      if not status\match 'playing'
        return 'No Song'

      if #title > characters
        title = title\sub(0, characters - 3) .. '...'

      out = prefix .. title

      if mode == 'none'
        return out
      elseif mode == 'percent'
        return out .. ' (%s)'\format status\match '%d-%%'
      elseif mode == 'time'
        return out .. ' (%s)'\format status\match '(%d-:%d-/.-)%s'

    .time = -> string.upper os.date '%p', os.time!

tcec = {}
do
  decode = json_lua.decode

  extract_data = (json) ->
    t = decode json

    white, black = t.Headers.White, t.Headers.Black
    moves = {}

    local white_eval, black_eval

    for i, move in ipairs t.Moves do
      with filtered = {}
        black_playing = (i % 2) == 0

        if black_playing
          black_eval = move.wv
        else
          white_eval = move.wv

        .player     = black_playing and black or white
        .eval_black = black_eval and '%.2f'\format black_eval or 'BOOK'
        .eval_white = white_eval and '%.2f'\format white_eval or 'BOOK'

        table.insert moves, filtered

    {:white, :black, :moves}

  fetch_json = Cacheable 'json', 30, -> 
    process = io.popen 'curl --compressed --max-time 6 -s https://tcec.chessdom.com/live.json', 'r'
    with process\read '*a'
      process\close! 

  pretty_names = (...) -> unpack [v\match'(%w+) ' for v in *{...}]

  with tcec
    .status = ->
      json = fetch_json! 

      if not (json and type(json) == 'string' and #json > 100)
        return 'No connection to TCEC?'

      data = extract_data json
      move = table.remove data.moves
      white, black = pretty_names data.white, data.black

      "%s (%s) - %s (%s)"\format white, move.eval_white, black, move.eval_black

SEPARATOR =
  full_text:   '|'
  color:       '\\#657b83', -- base_03
  separator:   false,
  separator_block_width: 2

unparsed = {
  {
    full_text: {tcec.status},
    separator: false,
    separator_block_width: 3,
    color: '\\#4ad0c6'
  },
  SEPARATOR, 
  {
    full_text: {system.song},
    separator: false,
    separator_block_width: 3,
    color: '\\#4ad0c6'
  },
  SEPARATOR,
  {
    full_text: {'${time %m-%d-%Y}, ${time %I:%M} ', system.time},
    separator: false,
    separator_block_width: 2,
    color:'\\#4ad0c6'
  },
  -- {
  --   full_text: {'${time %I:%M }', system.time},
  --   separator: false,
  --   separator_block_width: 2,
  -- },
  -- SEPARATOR,
  -- {
  --   full_text: 'WiFi:',
  --   separator: false,
  --   separator_block_width: 3,
  -- },
  {
    full_text: '${wireless_essid wlan0}',
    separator: false,
    separator_block_width: 3,
    color: '\\#4ad0c6'
  },
  SEPARATOR,
  {
    full_text: {'♪: ', system.volume, '%'},
    color: '\\#4ad0c6',
    separator: false,
    separator_block_width: 3,
  },
  -- SEPARATOR,
  -- {
  --   full_text: '${fs_free /home}' ,
  --   color: '\\#4ad0c6',
  --   separator: false,
  --   separator_block_width: 3,
  -- },
  SEPARATOR,
  {
    full_text: {system.battery},
    color: '\\#4ad0c6',
    separator: false,
    separator_block_width: 0,
  },
  -- SEPARATOR,
}

export conky_main = -> conky_parse serializer.tostring unparsed