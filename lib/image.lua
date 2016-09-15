--[[
 _____                              ___ ______ _____
|_   _|                            / _ \| ___ \_   _|
  | | _ __ ___   __ _  __ _  ___  / /_\ \ |_/ / | |
  | || '_ ` _ \ / _` |/ _` |/ _ \ |  _  |  __/  | |
 _| || | | | | | (_| | (_| |  __/ | | | | |    _| |_
|____/_| |_| |_|\__,_|\__, |\___| \_| |_|_|   |____/
                       __/ |
                      |___/

Simple API for creating image descriptor tables.

Requires style.lua's expand function

By: Aubergine18 (git:aubergine10) | License: MIT

Source: https://github.com/aubergine10/Style

Docs: https://github.com/aubergine10/Style/wiki/image-API

--]]

-- luacheck: globals data color

local image = { api = true }

-- indexes for parsed arrays (see style.expnd)
local x, y, w, h, top, right, bottom, left
    = 1, 2, 1, 2, 1  , 2    , 3     , 4

local expand = _G.style.expand

-- determine path to image file
-- deprecated style.path used as fallback until 1.0 release
function image.addPathTo( filename )
  if filename:find( '__', 1, true ) == 1 then
    return filename
  else
    local prefix = _G.image.path or (_G.style and _G.style.path) or ''
    return prefix .. filename
  end
end

-- no image
image.none = { type = 'none' }

-- a raw image which can be used in various prototypes
-- (not just LuaGuiElement styles)
function image.raw( filename, apiMethod )
  if type(filename) ~= 'string' then
    apiMethod = apiMethod or 'image.raw'
    error( apiMethod .. ': invalid filename' )
  end
  return function( settings )
    -- finalize settings
    settings    = settings or {}
    local pos   = expand( settings.pos, 0 ) -- x, y
    local size  = expand( settings.size   ) -- w, h
    -- build prototype
    return {
      filename     = image.addPathTo( filename );
      x            = pos  [x];
      y            = pos  [y];
      width        = size [w];
      height       = size [h];
      scale        = settings.scale; -- doesn't seem to work
      opacity      = settings.opacity; -- 0..1
      priority     = settings.priority or 'extra-high-no-scale';
    }, settings
  end
end

-- monolith image
function image.monolith( filename )
  return function( settings )
    local rawImage
    rawImage, settings = image.raw( filename, 'image.monolith' )( settings )
    local border = expand( settings.border ) -- top, right, bottom, left
    -- build prototype
    return {
      type = 'monolith';
      -- border props don't seem to do anything
      top_monolith_border    = border [top   ];
      right_monolith_border  = border [right ];
      bottom_monolith_border = border [bottom];
      left_monolith_border   = border [left  ];
      -- image
      monolith_image = rawImage;
      -- stretch image to fill parent?
      stretch_monolith_image_to_size = settings.autoSize;
    }
  end
end

-- composite image
function image.composite( filename )
  if type(filename) ~= 'string' then
    error 'image.composite: invalid filename'
  end
  return function( settings )
    -- finalize settings
    settings     = settings or {}
    local pos    = expand( settings.pos   , 0 )
    local corner = expand( settings.corner, 1 )
    -- build prototype
    return {
      type         = 'composition';
      filename     = image.addPathTo( filename );
      position     = { pos   [x], pos   [y] };
      corner_size  = { corner[w], corner[h] };
      scale        = settings.scale;
      opacity      = settings.opacity; -- 0..1
      priority     = 'extra-high-no-scale';
    }
  end
end

_G.image = image
return _G.image