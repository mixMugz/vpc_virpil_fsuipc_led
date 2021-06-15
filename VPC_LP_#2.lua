--[[

  This script control LED for LEFT VPC Panel #2
  Requires: FSUIPC
  (c) Mugz (mixmugz@gmail.com)

--]]

local VPC = require("VPC_Base")

----------------------------------------------------
local Name = "L-VPC Panel #2"
local VID = 0x3344
local PID = 0x825B
local Device = 1
local Report = 0
local Pollrate = 25

----------------------------------------------------
local dev, rd, wrf, wr, init = com.openhid(VID, PID, Device, Report)
if dev == 0 then
  ipc.log("Could not open HID for device: "..Name)
  ipc.exit()
end

----------------------------------------------------
local init = true
local noseGear, leftGear, rightGear
local isRetractable = ipc.readUB(0x060C)
local led = {} -- Default state for LED's
led.b1  = "00" -- B2
led.b2  = "00" -- B1
led.b3  = "00" -- B4
led.b4  = "00" -- B3
led.b5  = "00" -- Gear Up Nose
led.b6  = "00" -- Gear Indicator
led.b7  = "00" -- Gear Up Left
led.b8  = "00" -- Gear Down Left
led.b9  = "00" -- Gear Down Nose
led.b10 = "00" -- Gear Down Right
led.b11 = "00" -- Gear Up Right
led.b12 = "00" -- B10
led.b13 = "00" -- B8
led.b14 = "00" -- B6
led.b15 = "00" -- B9
led.b16 = "00" -- B7
led.b17 = "00" -- B5

----------------------------------------------------
function Poll(time)
  if isRetractable == 1 then
    GearStatus()
  end
  WriteLEDState()
end

function GearStatus()
  noseGear = ipc.readUD(0x0BEC)
  leftGear = ipc.readUD(0x0BF4)
  rightGear = ipc.readUD(0x0BF0)
  if noseGear ~= 0 and noseGear ~= 16383 or leftGear ~= 0 and leftGear ~= 16383 or rightGear ~= 0 and rightGear ~= 16383 then
    led.b6 = VPC.Blink(VPC.Color.BLK,VPC.Color.O60,10)
  else
    led.b6 = VPC.Color.BLK
  end
  if noseGear == 0 then
    led.b5 = VPC.Color.R60
    led.b9 = VPC.Color.BLK
  elseif noseGear == 16383 then
    led.b5 = VPC.Color.BLK
    led.b9 = VPC.Color.G60
  else
    led.b5 = VPC.Color.BLK
    led.b9 = VPC.Color.BLK
  end
  if leftGear == 0 then
    led.b7 = VPC.Color.R60
    led.b8 = VPC.Color.BLK
  elseif leftGear == 16383 then
    led.b7 = VPC.Color.BLK
    led.b8 = VPC.Color.G60
  else
    led.b7 = VPC.Color.BLK
    led.b8 = VPC.Color.BLK
  end
  if rightGear == 0 then
    led.b11 = VPC.Color.R60
    led.b10 = VPC.Color.BLK
  elseif rightGear == 16383 then
    led.b11 = VPC.Color.BLK
    led.b10 = VPC.Color.G60
  else
    led.b11 = VPC.Color.BLK
    led.b10 = VPC.Color.BLK
  end
end

function WriteLEDState()
  com.writefeature(dev, VPC.toByte(VPC.LEDs.Base_Set..led.b1..led.b2..led.b3..led.b4..led.b5..led.b6..led.b7..led.b8..led.b9..led.b10..led.b11..led.b12..led.b13..led.b14..led.b15..led.b16..led.b17), wrf)
end

function ResetLEDState()
  com.writefeature(dev, VPC.toByte(VPC.LEDs.Reset), wrf)
  ipc.log("Reseting LED state!")
end

----------------------------------------------------
if init then
  ipc.log("Init LED state!")
  -- Turn all base led off
  com.writefeature(dev, VPC.toByte(VPC.LEDs.Base_Off), wrf)
  init = false
end

if isRetractable ~= 1 then
  led.b6 = VPC.Color.B60
end

if Pollrate == 0 then
  Pollrate = 25
end

----------------------------------------------------
event.timer(1000/Pollrate, "Poll") -- Poll values 'Pollrate' times per second
event.terminate("ResetLEDState") -- Reset all LED's to initial state
