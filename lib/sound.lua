--[[
 _____                       _    ___ ______ _____
/  ___|                     | |  / _ \| ___ \_   _|
\ `--.  ___  _   _ _ __   __| | / /_\ \ |_/ / | |
 `--. \/ _ \| | | | '_ \ / _` | |  _  |  __/  | |
/\__/ / (_) | |_| | | | | (_| | | | | | |    _| |_
\____/ \___/ \__,_|_| |_|\__,_| \_| |_|_|   |____/

Simple API for creating sound descriptor tables.

By: Aubergine18 (git:aubergine10) | License: MIT

Source: https://github.com/aubergine10/Style

Docs: https://github.com/aubergine10/Style/wiki/sound-API

--]]

-- luacheck: globals color

local sound = { api = true }

-- determine path to sound file
-- deprecated style.path used as fallback until 1.0 release
function sound.addPathTo( filename )
  if filename:find( '__', 1, true ) == 1 then
    return filename
  else
    local prefix = _G.sound.path or (_G.style and _G.style.path) or ''
    return prefix .. filename
  end
end

-- adjust volume
local volume_mt = {
  __add = function( self, value )
    for _,clip in pairs(self) do
      clip.volume = clip.volume + value
    end
    return self
  end;
  __div = function( self, value )
    for _,clip in pairs(self) do
      clip.volume = clip.volume / value
    end
    return self
  end;
  __pow = function( self, volume )
    for _,clip in pairs(self) do
      clip.volume = volume
    end
    return self
  end;
  __mul = function( self, value )
    for _,clip in pairs(self) do
      clip.volume = clip.volume * value
    end
    return self
  end;
  __sub = function( self, value )
    for _,clip in pairs(self) do
      clip.volume = clip.volume - value
    end
    return self
  end;
}

-- click sound(s) for buttons
function sound.effect( filename, volume, preload )
  if type( filename ) ~= 'string' then
    error('sound.effect: invalid filename', 2)
  end
  volume  = volume or 1
  preload = preload or true
  return setmetatable( {{
    filename = sound.addPathTo( filename );
    volume   = volume;
    preload  = preload;
  }}, volume_mt )
end

-- game will choose sound at random
function sound.random( ... )
  local randomiser = {}
  local sounds = type(...) == 'table' and select(1,...) or table.pack(...)

  for i, effect in ipairs(sounds) do randomiser[i] = effect[1] end

  return setmetatable( randomiser, volume_mt )
end

_G.sound = sound
return _G.sound