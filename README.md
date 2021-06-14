# LED control for VPC Virpil through FSUIPC7

Required: Full version of [FSUIPC7](http://www.fsuipc.com/) by Pete & John Dowson's

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
