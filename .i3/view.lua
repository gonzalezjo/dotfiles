local FILE_DIRECTORY = '/home/jg/.i3/storage'
local json_lua = loadstring([[local a={_version="0.1.1"}local b;local c={["\\"]="\\\\",["\""]="\\\"",["\b"]="\\b",["\f"]="\\f",["\n"]="\\n",["\r"]="\\r",["\t"]="\\t"}local d={["\\/"]="/"}for e,f in pairs(c)do d[f]=e end;local function g(h)return c[h]or string.format("\\u%04x",h:byte())end;local function i(j)return"null"end;local function k(j,l)local m={}l=l or{}if l[j]then error("circular reference")end;l[j]=true;if rawget(j,1)~=nil or next(j)==nil then local n=0;for e in pairs(j)do if type(e)~="number"then error("invalid table: mixed or invalid key types")end;n=n+1 end;if n~=#j then error("invalid table: sparse array")end;for o,f in ipairs(j)do table.insert(m,b(f,l))end;l[j]=nil;return"["..table.concat(m,",").."]"else for e,f in pairs(j)do if type(e)~="string"then error("invalid table: mixed or invalid key types")end;table.insert(m,b(e,l)..":"..b(f,l))end;l[j]=nil;return"{"..table.concat(m,",").."}"end end;local function p(j)return'"'..j:gsub('[%z\1-\31\\"]',g)..'"'end;local function q(j)if j~=j or j<=-math.huge or j>=math.huge then error("unexpected number value '"..tostring(j).."'")end;return string.format("%.14g",j)end;local r={["nil"]=i,["table"]=k,["string"]=p,["number"]=q,["boolean"]=tostring}b=function(j,l)local s=type(j)local t=r[s]if t then return t(j,l)end;error("unexpected type '"..s.."'")end;function a.encode(j)return b(j)end;local u;local function v(...)local m={}for o=1,select("#",...)do m[select(o,...)]=true end;return m end;local w=v(" ","\t","\r","\n")local x=v(" ","\t","\r","\n","]","}",",")local y=v("\\","/",'"',"b","f","n","r","t","u")local z=v("true","false","null")local A={["true"]=true,["false"]=false,["null"]=nil}local function B(C,D,E,F)for o=D,#C do if E[C:sub(o,o)]~=F then return o end end;return#C+1 end;local function G(C,D,H)local I=1;local J=1;for o=1,D-1 do J=J+1;if C:sub(o,o)=="\n"then I=I+1;J=1 end end;error(string.format("%s at line %d col %d",H,I,J))end;local function K(n)local t=math.floor;if n<=0x7f then return string.char(n)elseif n<=0x7ff then return string.char(t(n/64)+192,n%64+128)elseif n<=0xffff then return string.char(t(n/4096)+224,t(n%4096/64)+128,n%64+128)elseif n<=0x10ffff then return string.char(t(n/262144)+240,t(n%262144/4096)+128,t(n%4096/64)+128,n%64+128)end;error(string.format("invalid unicode codepoint '%x'",n))end;local function L(M)local N=tonumber(M:sub(3,6),16)local O=tonumber(M:sub(9,12),16)if O then return K((N-0xd800)*0x400+O-0xdc00+0x10000)else return K(N)end end;local function P(C,o)local Q=false;local R=false;local S=false;local T;for U=o+1,#C do local V=C:byte(U)if V<32 then G(C,U,"control character in string")end;if T==92 then if V==117 then local W=C:sub(U+1,U+5)if not W:find("%x%x%x%x")then G(C,U,"invalid unicode escape in string")end;if W:find("^[dD][89aAbB]")then R=true else Q=true end else local h=string.char(V)if not y[h]then G(C,U,"invalid escape char '"..h.."' in string")end;S=true end;T=nil elseif V==34 then local M=C:sub(o+1,U-1)if R then M=M:gsub("\\u[dD][89aAbB]..\\u....",L)end;if Q then M=M:gsub("\\u....",L)end;if S then M=M:gsub("\\.",d)end;return M,U+1 else T=V end end;G(C,o,"expected closing quote for string")end;local function X(C,o)local V=B(C,o,x)local M=C:sub(o,V-1)local n=tonumber(M)if not n then G(C,o,"invalid number '"..M.."'")end;return n,V end;local function Y(C,o)local V=B(C,o,x)local Z=C:sub(o,V-1)if not z[Z]then G(C,o,"invalid literal '"..Z.."'")end;return A[Z],V end;local function _(C,o)local m={}local n=1;o=o+1;while 1 do local V;o=B(C,o,w,true)if C:sub(o,o)=="]"then o=o+1;break end;V,o=u(C,o)m[n]=V;n=n+1;o=B(C,o,w,true)local a0=C:sub(o,o)o=o+1;if a0=="]"then break end;if a0~=","then G(C,o,"expected ']' or ','")end end;return m,o end;local function a1(C,o)local m={}o=o+1;while 1 do local a2,j;o=B(C,o,w,true)if C:sub(o,o)=="}"then o=o+1;break end;if C:sub(o,o)~='"'then G(C,o,"expected string for key")end;a2,o=u(C,o)o=B(C,o,w,true)if C:sub(o,o)~=":"then G(C,o,"expected ':' after key")end;o=B(C,o+1,w,true)j,o=u(C,o)m[a2]=j;o=B(C,o,w,true)local a0=C:sub(o,o)o=o+1;if a0=="}"then break end;if a0~=","then G(C,o,"expected '}' or ','")end end;return m,o end;local a3={['"']=P,["0"]=X,["1"]=X,["2"]=X,["3"]=X,["4"]=X,["5"]=X,["6"]=X,["7"]=X,["8"]=X,["9"]=X,["-"]=X,["t"]=Y,["f"]=Y,["n"]=Y,["["]=_,["{"]=a1}u=function(C,D)local a0=C:sub(D,D)local t=a3[a0]if t then return t(C,D)end;G(C,D,"unexpected character '"..a0 .."'")end;function a.decode(C)if type(C)~="string"then error("expected argument of type string, got "..type(C))end;local m,D=u(C,B(C,1,w,true))D=B(C,D,w,true)if D<=#C then G(C,D,"trailing garbage")end;return m end;return a]])()
do
  do
    local _with_0 = table
    local sanitized
    sanitized = function(v)
      local _exp_0 = type(v)
      if 'string' == _exp_0 then
        return ('%q'):format(v)
      elseif 'function' == _exp_0 then
        return "assert(loadstring(" .. tostring(sanitized(string.dump(v))) .. "))()"
      else
        return tostring(v)
      end
    end
    _with_0.load = function(s)
      return (assert(loadstring("return " .. tostring(s))))()
    end
    _with_0.dump = function(t, indentation)
      if indentation == nil then
        indentation = 4
      end
      local s = { }
      local size = 1
      local put
      put = function(...)
        for i = 1, select('#', ...) do
          s[size], size = (select(i, ...)), size + 1
        end
      end
      put('{', '\n')
      for k, v in pairs(t) do
        put((' '):rep(indentation), "[" .. tostring(sanitized(k)) .. "] = ")
        if type(v) == 'table' then
          put(_with_0.dump(v, indentation + 4))
        else
          put(sanitized(v))
        end
        put(',\n')
      end
      put((' '):rep(indentation - 4), '}')
      return table.concat(s)
    end
  end
end
local Cacheable
do
  local _class_0
  local _base_0 = {
    check = function(self, file)
      if file and #tostring(file:read('*a')) > 3 then
        return file:close()
      end
      return self:set(self:fn())
    end,
    get = function(self, ...)
      local file = io.open(tostring(FILE_DIRECTORY) .. "/" .. tostring(self.name), 'r+b')
      local contents = table.load(file:read('*a'))
      file:close()
      if (os.time() - self.expiry > contents.timestamp) then
        return self:set(self:fn(...))
      else
        return contents.data
      end
    end,
    set = function(self, data, ...)
      if (select('#', ...)) ~= 0 then
        error('Note that Cacheable::set should receive exactly one argument.')
      end
      local file = io.open(tostring(FILE_DIRECTORY) .. "/" .. tostring(self.name), 'wb')
      file:write(table.dump({
        timestamp = os.time(),
        data = data
      }))
      file:close()
      return data
    end,
    __call = function(self, ...)
      return self:get(...)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, name, expiry, fn)
      self.name, self.expiry, self.fn = name, expiry, fn
      return self:check(io.open(tostring(FILE_DIRECTORY) .. "/" .. tostring(name), 'r+b'))
    end,
    __base = _base_0,
    __name = "Cacheable"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Cacheable = _class_0
end
local string_builder = { }
do
  do
    local string_builder_mt = { }
    string_builder_mt.__index = string_builder_mt
    string_builder_mt.__tostring = function(self)
      return table.concat(self)
    end
    string_builder_mt.put = function(self, v)
      self[#self + 1] = tostring(v)
    end
    string_builder_mt.put_all = function(self, ...)
      for i = 1, select('#', ...) do
        self[#self + 1] = select(i, ...)
      end
    end
    string_builder.new = function()
      return setmetatable({ }, string_builder_mt)
    end
  end
end
local serializer = { }
do
  do
    local fix
    fix = function(t)
      for i = 1, #t - 1 do
        if t[i]:sub(-1) == ',' and t[i + 1]:sub(1, 1):match('[%}%]]') then
          t[i] = t[i]:sub(1, -2)
        end
      end
    end
    serializer.tostring = function(t)
      assert(t and type(t) == 'table', 'Invalid arguments.')
      local output = string_builder.new()
      output:put('[')
      for _, block in ipairs(t) do
        output:put('{')
        for k, v in pairs(block) do
          output:put('\"')
          output:put(k)
          output:put('\":')
          local serializing
          assert(type(v) ~= 'nil' and type(v) ~= 'userdata', 'Unserializable value.')
          if type(v) == 'table' then
            t = { }
            for _index_0 = 1, #v do
              local serializable = v[_index_0]
              local typename = type(serializable)
              assert(typename == 'string' or typename == 'function', 'Unserializable value.')
              t[#t + 1] = typename == 'string' and serializable or serializable()
            end
            serializing = table.concat(t)
          else
            serializing = v
          end
          if type(v) == 'boolean' or type(v) == 'number' then
            output:put(serializing)
          else
            output:put('\"')
            output:put(serializing)
            output:put('\"')
          end
          output:put(',')
        end
        output:put('},')
      end
      output:put('],')
      output:put(' ')
      fix(output)
      return tostring(output)
    end
  end
end
local system = { }
do
  do
    system.volume = function()
      local cmd = io.popen('amixer get Master', 'r')
      local amixerout = cmd:read('*a')
      io.close(cmd)
      return muted and 0 or tonumber(amixerout:match('(%d+)%%'))
    end
    system.battery = function()
      local batteries = {
        'BAT0',
        'BAT1'
      }
      local acpi, estimate = true, false
      local fullenergy = 0
      local currenergy = 0
      for _, bat in ipairs(batteries) do
        local f = io.open(('/sys/class/power_supply/%s/energy_full'):format(bat), 'r')
        fullenergy = fullenergy + f:read('*n')
        io.close(f)
        f = io.open(('/sys/class/power_supply/%s/energy_now'):format(bat), 'r')
        currenergy = currenergy + f:read('*n')
        io.close(f)
      end
      local percent = (currenergy / fullenergy) * 100
      if acpi then
        local cmd = io.popen('acpi', 'r')
        local acpiout = cmd:read('*a')
        io.close(cmd)
        local id = acpiout:match('Battery (%d+): D?i?s?c?harging')
        local estimated = ''
        if estimate then
          estimated = acpiout:match('([%d]*:?[%d]*):?%d* remaining')
          if not estimated then
            estimated = acpiout:match('([%d]*:?[%d]*):?%d* until')
          end
        end
        if not id then
          return ('BAT: %.2f%%'):format(percent)
        end
        return ('BAT%s: %.2f%% %s'):format(id, percent, estimated)
      else
        local out = ('BAT: %.2f%%'):format(percent)
        if estimate then
          out = out .. ' ${format_time ${battery_time BAT1}"\\hH \\mM"}'
        end
        return out
      end
    end
    system.song = function()
      local characters = 30
      local mode = 'time'
      local prefix = ''
      local cmd = io.popen('mpc status', 'r')
      local title = cmd:read('*l')
      local status = cmd:read('*l' or '')
      io.close(cmd)
      if not status:match('playing') then
        return 'No Song'
      end
      if #title > characters then
        title = title:sub(0, characters - 3) .. '...'
      end
      local out = prefix .. title
      if mode == 'none' then
        return out
      elseif mode == 'percent' then
        return out .. (' (%s)'):format(status:match('%d-%%'))
      elseif mode == 'time' then
        return out .. (' (%s)'):format(status:match('(%d-:%d-/.-)%s'))
      end
    end
    system.time = function()
      return string.upper(os.date('%p', os.time()))
    end
  end
end
local tcec = { }
do
  local decode = json_lua.decode
  local extract_data
  extract_data = function(json)
    local t = decode(json)
    local white, black = t.Headers.White, t.Headers.Black
    local moves = { }
    local white_eval, black_eval
    for i, move in ipairs(t.Moves) do
      do
        local filtered = { }
        local black_playing = (i % 2) == 0
        if black_playing then
          black_eval = move.wv
        else
          white_eval = move.wv
        end
        filtered.player = black_playing and black or white
        filtered.eval_black = black_eval and ('%.2f'):format(black_eval or 'BOOK')
        filtered.eval_white = white_eval and ('%.2f'):format(white_eval or 'BOOK')
        table.insert(moves, filtered)
      end
    end
    return {
      white = white,
      black = black,
      moves = moves
    }
  end
  local fetch_json = Cacheable('json', 30, function()
    local process = io.popen('curl --compressed --max-time 6 -s https://tcec.chessdom.com/live.json', 'r')
    do
      local _with_0 = process:read('*a')
      process:close()
      return _with_0
    end
  end)
  local pretty_names
  pretty_names = function(...)
    return unpack((function(...)
      local _accum_0 = { }
      local _len_0 = 1
      local _list_0 = {
        ...
      }
      for _index_0 = 1, #_list_0 do
        local v = _list_0[_index_0]
        _accum_0[_len_0] = v:match('(%w+) ')
        _len_0 = _len_0 + 1
      end
      return _accum_0
    end)(...))
  end
  do
    tcec.status = function()
      local json = fetch_json()
      if not (json and type(json) == 'string' and #json > 100) then
        return 'No connection to TCEC?'
      end
      local data = extract_data(json)
      local move = table.remove(data.moves)
      local white, black = pretty_names(data.white, data.black)
      return ("%s (%s) - %s (%s)"):format(white, move.eval_white, black, move.eval_black)
    end
  end
end
local SEPARATOR = {
  full_text = '|',
  color = '\\#657b83',
  separator = false,
  separator_block_width = 2
}
local unparsed = {
  {
    full_text = {
      tcec.status
    },
    separator = false,
    separator_block_width = 3,
    color = '\\#4ad0c6'
  },
  SEPARATOR,
  {
    full_text = {
      system.song
    },
    separator = false,
    separator_block_width = 3,
    color = '\\#4ad0c6'
  },
  SEPARATOR,
  {
    full_text = {
      '${time %m-%d-%Y}, ${time %I:%M} ',
      system.time
    },
    separator = false,
    separator_block_width = 2,
    color = '\\#4ad0c6'
  },
  {
    full_text = '${wireless_essid wlan0}',
    separator = false,
    separator_block_width = 3,
    color = '\\#4ad0c6'
  },
  SEPARATOR,
  {
    full_text = {
      '♪: ',
      system.volume,
      '%'
    },
    color = '\\#4ad0c6',
    separator = false,
    separator_block_width = 3
  },
  SEPARATOR,
  {
    full_text = {
      system.battery
    },
    color = '\\#4ad0c6',
    separator = false,
    separator_block_width = 0
  }
}
conky_main = function()
  return conky_parse(serializer.tostring(unparsed))
end
