# LED control for VPC Virpil through FSUIPC7

Required: Full version of [FSUIPC7](http://www.fsuipc.com/) by Pete & John Dowson's

## Realized LED:
**- VPC Constellation Alpha Grip color**
1. Aircraft on ground - Orange color
2. Aircraft on ground, parking brake on - Blink Black/Red color
3. Aircraft in flight, autopilot off - Blue color
4. Aircraft in flight, autopilot on - Green color

**- VPC Throttle color**
1. Default state (turned off) black color
2. Autopilot FMS NAV Hold ON - B1 Green (if AP off - Blue)
3. Yaw Damper ON - B2 Green (if AP off - Blue)
4. Flight Director ON - B3 Green (if AP off - Blue)
5. Autopilot Approach mode ON B4 Green, GS Captured - Blink Green/Bright Green (if AP off - Blue)
6. Autopilot Back Course ON - B5 Green (if AP off - Blue)
7. Autopilot Master ON - B6 Green

**- VPC Panel #2 color**
1. Gear down - 3 down gear led green color (for each gear, left, center, right)
2. Gear up - 3 upper gear led red color
3. Gear deploying - middle gear led blink orange color
4. Gear not retractably - middle gear led blue color

## Instalation

Please make sure the LUA files are listed in the [LuaFiles] section of FSUIPC7.ini file.

Example:
```
[LuaFiles]
1=VPC_Base
2=VPC_LP_#2
3=VPC_LT_MT50CM3
4=VPC_RCA_MT50CM2
```

**Add to FSUIPC7.ini:**
```
[Auto]
1=Lua VPC_RCA_MT50CM2
2=Lua VPC_LT_MT50CM3
3=Lua VPC_LP_#2
```

## Donation

If you want to support me, here's my donation link:

[![Donation](https://i.imgur.com/vQyI7N5.png)](https://www.buymeacoffee.com/mugz)

or [PayPal.Me](https://paypal.me/mixmugz) :)
