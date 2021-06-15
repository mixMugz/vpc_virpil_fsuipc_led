--[[

  This script control LED for RIGHT VPC Constellation Alpha MT-50CM2
  Requires: FSUIPC
  (c) Mugz (mixmugz@gmail.com)

--]]

local VPC = require("VPC_Base")

----------------------------------------------------
local Name = "R-VPC Constellation Alpha MT-50CM2"
local VID = 0x3344
local PID = 0x4130
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
local apOn, onGround, parkBrake
local led = {} -- Default state for LED's
led.g1 = "00" -- Grip 1

----------------------------------------------------
function Poll(time)
  onGround = ipc.readUW(0x0366)
  if onGround == 1 then
    checkParkingBrake()
  else
    checkAutoPilot()
  end
  WriteLEDState()
end

function checkAutoPilot()
  apOn = ipc.readUD(0x07BC)
  if apOn == 1 then
    led.g1 = VPC.Color.G100
  else
    led.g1 = VPC.Color.B100
  end
end

function checkParkingBrake()
  parkBrake = ipc.readUW(0x0BC8)
  if parkBrake == 32767 then
    led.g1 = VPC.Blink(VPC.Color.BLK,VPC.Color.R100,10)
  else
    led.g1 = VPC.Color.O100
  end
end

function WriteLEDState()
  com.writefeature(dev, VPC.toByte(VPC.LEDs.Grip_Set..led.g1), wrf)
end

function ResetLEDState()
  com.writefeature(dev, VPC.toByte(VPC.LEDs.Reset), wrf)
  ipc.log("Reseting LED state!")
end

----------------------------------------------------
if init then
  ipc.log("Init LED state!")
  -- Turn all grip led off
  com.writefeature(dev, VPC.toByte(VPC.LEDs.Grip_Off), wrf)
  init = false
end

if Pollrate == 0 then
  Pollrate = 25
end

----------------------------------------------------
event.timer(1000/Pollrate, "Poll") -- Poll values 'Pollrate' times per second
event.terminate("ResetLEDState") -- Reset all LED's to initial state
