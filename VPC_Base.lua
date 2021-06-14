--[[

  Base script for VPC devices.
  Requires: FSUIPC
  (c) Mugz (mixmugz@gmail.com)

--]]

module(..., package.seeall)

----------------------------------------------------
LEDs = {}
LEDs.Reset = "0264"
LEDs.Grip_Off = "026500000080808080"
LEDs.Base_Off = "02660000008080808080808080808080808080808080808080"
LEDs.Slave_Off = "02670000008080808080808080808080808080808080808080"
LEDs.Grip_Set = "0265000000"
LEDs.Base_Set = "0266000000"
LEDs.Slave_Set = "0267000000"

----------------------------------------------------
local blinkState = 0
local timer = 0
local colorPref = 128 -- LED prefix. Don't change
local blu = {
  [0]   = 0,  -- 0%
  [30]  = 16, -- 30%
  [60]  = 32, -- 60%
  [100] = 48, -- 100%
}
local grn = {
  [0]   = 0,  -- 0%
  [30]  = 4,  -- 30%
  [60]  = 8,  -- 60%
  [100] = 12, -- 100%
}
local red = {
  [0]   = 0,  -- 0%
  [30]  = 1,  -- 30%
  [60]  = 2,  -- 60%
  [100] = 3,  -- 100%
}

----------------------------------------------------
function toByte(str)
  return str:gsub('%x%x',function(c)return c.char(tonumber(c,16))end)
end

function toColor(b,g,r)
  return ('%X'):format(colorPref+blu[b]+grn[g]+red[r])
end

function Blink(c1,c2,z) -- (first_color, second_color, lag_time)
  local out = ""
  if timer <= 0 then blinkState = 1 end
  if timer >= z then blinkState = 0 end
  if blinkState == 0 then
    timer = timer - 1
    out = c1
  else
    timer = timer + 1
    out = c2
  end
  return out
end

----------------------------------------------------
Color = {} -- Predefined LED color
Color.BLK  = toColor(0,0,0)       -- Black
Color.R30  = toColor(0,0,30)      -- Red 30%
Color.G30  = toColor(0,30,0)      -- Green 30%
Color.B30  = toColor(30,0,0)      -- Blue 30%
Color.C30  = toColor(30,30,0)     -- Cyan 30%
Color.M30  = toColor(30,0,30)     -- Magenta 30%
Color.Y30  = toColor(0,30,30)     -- Yellow 30%
Color.W30  = toColor(30,30,30)    -- White 30%
Color.R60  = toColor(0,0,60)      -- Red 60%
Color.G60  = toColor(0,60,0)      -- Green 60%
Color.B60  = toColor(60,0,0)      -- Blue 60%
Color.C60  = toColor(60,60,0)     -- Cyan 60%
Color.M60  = toColor(60,0,60)     -- Magenta 60%
Color.Y60  = toColor(0,60,60)     -- Yellow 60%
Color.W60  = toColor(60,60,60)    -- White 60%
Color.R100 = toColor(0,0,100)     -- Red 100%
Color.B100 = toColor(0,100,0)     -- Green 100%
Color.B100 = toColor(100,0,0)     -- Blue 100%
Color.C100 = toColor(100,100,0)   -- Cyan 100%
Color.M100 = toColor(100,0,100)   -- Magenta 100%
Color.Y100 = toColor(0,100,100)   -- Yellow 100%
Color.W100 = toColor(100,100,100) -- White 100%
Color.O60  = toColor(0,30,60)     -- Orange 60%
Color.O100 = toColor(0,60,100)    -- Orange 100%
Color.L60  = toColor(0,60,30)     -- Lime 60%
Color.L100 = toColor(0,100,60)    -- Lime 100%
Color.S60  = toColor(60,30,0)     -- Sky 60%
Color.S100 = toColor(100,60,0)    -- Sky 100%
