--[[

  This script control LED for LEFT VPC Throttle MT-50CM3
  Requires: FSUIPC
  (c) Mugz (mixmugz@gmail.com)

--]]

local VPC = require("VPC_Base")

----------------------------------------------------
local Name = "L-VPC Throttle MT-50CM3"
local VID = 0x3344
local PID = 0x8194
local Device = 1
local Report = 0
local Pollrate = 25

----------------------------------------------------
local dev, rd, wrf, wr, init = com.openhid(VID, PID, Device, Report)
if dev == 0 then
  ipc.log("Could not open HID for device: " .. Name)
  ipc.exit()
end

----------------------------------------------------
local init = true
local apAvail = ipc.readUD(0x0764)
local apOn, apFD, apYD, apNav1, apApr, apGS, apBC
local led = {} -- Default state for LED's
led.b1  = "00" -- B1
led.b2  = "00" -- B2
led.b3  = "00" -- B3
led.b4  = "00" -- B4
led.b5  = "00" -- B5
led.b6  = "00" -- B6

----------------------------------------------------
function Poll(time)
  if apAvail == 1 then
    checkAutoPilot()
  end
  WriteLEDState()
end

function checkAutoPilot()
  apOn = ipc.readUD(0x07BC)
  if apOn == 1 then
    led.b6 = VPC.Color.G60
  else
    led.b6 = VPC.Color.BLK
  end
  apFD = ipc.readUD(0x2EE0)
  if apFD == 1 then
    led.b3 = apOn == 1 and VPC.Color.G60 or VPC.Color.B60
  else
    led.b3 = VPC.Color.BLK
  end
  apYD = ipc.readUD(0x0808)
  if apYD == 1 then
    led.b2 = apOn == 1 and VPC.Color.G60 or VPC.Color.B60
  else
    led.b2 = VPC.Color.BLK
  end
  apNav1 = ipc.readUD(0x07C4)
  if apNav1 == 1 then
    led.b1 = apOn == 1 and VPC.Color.G60 or VPC.Color.B60
  else
    led.b1 = VPC.Color.BLK
  end
  apApr = ipc.readUD(0x0800)
  apGS = ipc.readUB(0x0C7C)
  if apApr == 1 then
    if apGS == 1 then
      led.b4 = apOn == 1 and VPC.Blink(VPC.Color.G30,VPC.Color.G60,10) or VPC.Color.B60
    else
      led.b4 = apOn == 1 and VPC.Color.G60 or VPC.Color.B60
    end
  else
    led.b4 = VPC.Color.BLK
  end
  apBC = ipc.readUD(0x0804)
  if apBC == 1 then
    led.b5 = apOn == 1 and VPC.Color.G60 or VPC.Color.B60
  else
    led.b5 = VPC.Color.BLK
  end
end

function WriteLEDState()
  com.writefeature(dev, VPC.toByte(VPC.LEDs.Base_Set .. led.b1 .. led.b2 .. led.b3 .. led.b4 .. led.b5 .. led.b6), wrf)
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

if Pollrate == 0 then
  Pollrate = 25
end

----------------------------------------------------
event.timer(1000/Pollrate, "Poll") -- Poll values 'Pollrate' times per second
event.terminate("ResetLEDState") -- Reset all LED's to initial state
