# SpaNET SpaLINK API
#### Thanks to [@devbobo's](https://github.com/devbobo) original work and assistance of [@thehoff](https://github.com/thehoff)  
  
### Table of Contents
* 1. Logging into SpaNET
  * 1.1 Obtaining Login Password
  * 1.2 Making Login Request
* 2. Spa Socket
  * 2.1 Spa Socket Request
  * 2.2 Connecting to Spa Socket
* 3. Spa Status
* 4. Commands API
  * 4.1 Spa
    * 4.1.1 Temperature
    * 4.1.2 Clean/Sanitise
  * 4.2 Pumps
    * 4.2.1 Pump 1
    * 4.2.2 Pump 2
    * 4.2.3 Pump 3
    * 4.2.4 Pump 4
    * 4.2.5 Pump 5
  * 4.3 Blower
    * 4.3.1 Blower
    * 4.3.2 Blower Variable Speed
  * 4.4 Lights
    * 4.4.1 Lights
    * 4.4.2 Lights Off
    * 4.4.3 Lights Mode
    * 4.4.4 Lights Brightness
    * 4.4.5 Lights Effect Speed
    * 4.4.6 Lights Colour
  * 4.5 Settings
    * 4.5.1 Operation Mode
    * 4.5.2 Filtration
      * Filtration Runtime
      * Time Between Filtration Cycles
    * 4.5.3 Sleep Timers
      * Sleep Timer 1 State
      * Sleep Timer 1 Start Time
      * Sleep Timer 1 Finish Time
      * Sleep Timer 2 State
      * Sleep Timer 2 Start Time
      * Sleep Timer 2 Finish Time
    * 4.5.4 Power Save
      * Power Save
      * Peak Power Time Start
      * Peak Power Time End
    * 4.5.5 Auto Sanitise
    * 4.5.6 Time Out Duration
    * 4.5.7 Heat Pump Mode
      * Heat Pump Mode
      * SV Element Boost
    * 4.5.8 Set Time/Date
      * Time: Hour
      * Time: Minute
      * Date: Year
      * Date: Month
      * Date: Day
    * 4.5.9 Support Mode
    * 4.5.10 Lock Mode
    * 4.5.11 Notifications
* 5. Raw Commands List
* 6. Reading Spa Data API
* 6.1 Spa
    * 6.1.1 Set Temperature
    * 6.1.2 Water Temperature
    * 6.1.3 Heating
    * 6.1.4 Cleaning (UV/Ozone Running)
    * 6.1.5 Cleaning (Sanitise Cycle Running)
    * 6.1.6 Auto
    * 6.1.7 Sleeping
  * 6.2 Pumps
    * 6.2.1 Pump 1
      * Pump 1
      * Pump 1 Installation State
    * 6.2.2 Pump 2
      * Pump 2
      * Pump 2 Installation State
      * Pump 2 Switch On Status
    * 6.2.3 Pump 3
      * Pump 3
      * Pump 3 Installation State
      * Pump 3 Switch On Status
    * 6.2.4 Pump 4
      * Pump 4
      * Pump 4 Installation State
      * Pump 4 Switch On Status
    * 6.2.5 Pump 5
      * Pump 5
      * Pump 5 Installation State
      * Pump 5 Switch On Status
  * 6.3 Blower
    * 6.3.1 Blower
    * 6.3.2 Blower Variable Speed
  * 6.4 Lights
    * 6.4.1 Lights
    * 6.4.2 Lights Off
    * 6.4.3 Lights Mode
    * 6.4.4 Lights Brightness
    * 6.4.5 Lights Effect Speed
    * 6.4.6 Lights Colour
  * 6.5 Settings
    * 6.5.1 Operation Mode
    * 6.5.2 Filtration
      * Filtration Runtime
      * Time Between Filtration Cycles
    * 6.5.3 Sleep Timers
      * Sleep Timer 1 State
      * Sleep Timer 1 Start Time
      * Sleep Timer 1 Finish Time
      * Sleep Timer 2 State
      * Sleep Timer 2 Start Time
      * Sleep Timer 2 Finish Time
    * 6.5.4 Power Save
      * Power Save
      * Peak Power Time Start
      * Peak Power Time End
    * 6.5.5 Auto Sanitise
    * 6.5.6 Time Out Duration
    * 6.5.7 Heat Pump Mode
      * Heat Pump Mode
      * SV Element Boost
    * 6.5.8 Time/Date
      * Time: Hour
      * Time: Minute
      * Date: Year
      * Date: Month
      * Date: Day
    * 6.5.9 Support Mode
    * 6.5.10 Lock Mode
    * 6.5.11 Notifications
  
### 1. Logging into SpaNET
#### 1.1 Obtaining Login Password
To obtain your Encrypted Password for use below, use the utility for your platform from @thehoff's [SpaNET Password Hash Generator](https://github.com/thehoff/spanet-password-creator)

#### 1.2 Making Login Request
`POST` https://api.spanet.net.au/api/MemberLogin

*Request:*
```javascript
{
    "login": [Username],
    "api_key": "4a483b9a-8f02-4e46-8bfa-0cf5732dbbd5",
    "password": [Encrypted Password]
}
```
*Response:*
```javascript
{
    "data": {
        "email": null,
        "id_member": [MemberId],
        "login": [Username],
        "name": null,
        "password": null,
        "notification_enabled": 1,
        "id_session": [SessionId]
    },
    "error": null,
    "error_code": null,
    "message": null,
    "success": true
}
```

### 2. Spa Socket
#### 2.1 Spa Socket Request
`GET` https://api.spanet.net.au/api/membersockets?id_member=[MemberId]&id_session=[SessionId]

*Response:*
```javascript
{
    "data": {
        "email": null,
        "id_member": 0,
        "login": null,
        "name": null,
        "password": null,
        "notification_enabled": 0,
        "id_session": null
    },
    "sockets": [{
        "id": [SocketId],
        "active": "1",
        "id_member": [MemberId],
        "id_sockets": [SocketId],
        "mac_addr": [MacAddress],
        "moburl": [WebSocketUrl]:9090,
        "name": [SpaName],
        "spaurl": [WebSocketUrl]:9090,
        "signalStrength": -69,
        "error": false
    }],
    "error": null,
    "error_code": null,
    "message": "",
    "success": true
}
```

#### 2.2 Connecting to Spa Socket
Open TCP Socket to `[WebUrl]` port `9090`, then send:

*Request:*
```
<connect--[SocketId]--[MemberId]>
```

*Response:*
```
Successfully connected
```

### 3. Spa Status
Get the current status of the spa.

*Request:*
```
RF\n
```

*Sample Response:*
```
RF:
,R2,18,250,51,70,4,13,50,55,19,6,2020,376,9999,1,0,490,207,34,6000,602,23,20,0,0,0,0,44,35,45,:
,R3,32,1,4,4,4,SW V5 17 05 31,SV3,18480001,20000826,1,0,0,0,0,0,NA,7,0,470,Filtering,4,0,7,7,0,0,:
,R4,NORM,0,0,0,1,0,3547,4,20,4500,7413,567,1686,0,8388608,0,0,5,0,98,0,10084,4,80,100,0,0,4,:
,R5,0,1,0,1,0,0,0,0,0,0,1,0,1,0,376,0,3,4,0,0,0,0,0,1,2,6,:
,R6,1,5,30,2,5,8,1,360,1,0,3584,5120,127,128,5632,5632,2304,1792,0,30,0,0,0,0,2,3,0,:
,R7,2304,0,1,1,1,0,1,0,0,0,253,191,253,240,483,125,77,1,0,0,0,23,200,1,0,1,31,32,35,100,5,:
,R9,F1,255,0,0,0,0,0,0,0,0,0,0,:
,RA,F2,0,0,0,0,0,0,255,0,0,0,0,:
,RB,F3,0,0,0,0,0,0,0,0,0,0,0,:
,RC,0,1,1,0,0,0,0,0,0,2,0,0,1,0,:
,RE,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,-4,13,30,8,5,1,0,0,0,0,0,:*
,RG,1,1,1,1,1,1,1-1-014,1-1-01,1-1-01,0-,0-,0,:*
```
Full documentation of parsing this data is below at section 7

### 4. Commands
##### NOTE - Make sure to include newline (\n) after all websocket commands
#### 4.1 Spa
##### 4.1.1 Temperature
Set the target temperature for the spa.

*Request:*
```
W40:nnn
```

*Response:*
```
nnn
```
where `nnn` denotes temperature in celsius * 10  between `5.0`-`41.0`c (ie: for 35.6c, `nnn` = 356)

##### 4.1.2 Clean/Santise
Start (or cancel) a Clean cycle.

*Request:*
```
W12
```

*Response:*
```
W12
```

#### 4.2 Pumps
##### 4.2.1 Pump 1
Control Pump 1.

*Request:*
```
S22:n
```

*Response:*
```
S22-OK
```
where `n` denotes
* `0` - Off
* `1` - On
* `4` - Auto

##### 4.2.2 Pump 2
Control Pump 2.

*Request:*
```
S23:n
```

*Response:*
```
S23-OK
```
where `n` denotes
* `0` - Off
* `1` - On

##### 4.2.3 Pump 3
Control Pump 3.

*Request:*
```
S24:n
```

*Response:*
```
S24-OK
```
where `n` denotes
* `0` - Off
* `1` - On

##### 4.2.4 Pump 4
Control Pump 4, if installed (section 6.2 shows how to check whether pumps are installed).

*Request:*
```
S25:n
```

*Response:*
```
S25-OK
```
where `n` denotes
* `0` - Off
* `1` - On

##### 4.2.5 Pump 5
Control Pump 5, if installed (section 6.2 shows how to check whether pumps are installed).

*Request:*
```
S26:n
```

*Response:*
```
S26-OK
```
where `n` denotes
* `0` - Off
* `1` - On

#### 4.3 Blower
##### 4.3.1 Blower
Control the Blower.

*Request:*
```
S28:n
```

*Response:*
```
S28-OK
```
where `n` denotes
* `0` - Variable
* `1` - Ramp
* `2` - Off

##### 4.3.2 Blower Variable Speed
Set the variable speed of the blower.

*Request:*
```
S13:n
```

*Response:*
```
n  S13
```
where `n` denotes speed `1`-`5`

#### 4.4 Lights
##### 4.4.1 Lights
Toggle the state of the lights (on/off). Other commands should be sent first to set the brightness, mode, effect speed and colour if applicable otherwise last used settings will be applied.

*Request:*
```
W14
```

*Response:*
```
W14
```

##### 4.4.2 Lights Off
Turn all lights off.

*Request:*
```
S11
```

*Response:*
```
S11
```

##### 4.4.3 Lights mode
Set the mode for the lights.

*Request:*
```
S07:n
```

*Response:*
```
n  S07
```
where `n` denotes
* `0` - White
* `1` - Colour
* `2` - Fade
* `3` - Step
* `4` - Party

##### 4.4.4 Lights brightness
Set the brightness for the lights.

*Request:*
```
S08:n
```

*Response:*
```
n  S08
```
where `n` denotes brightness `1`-`5`

##### 4.4.5 Lights effect speed
Set the effect speed for the lights. Only applicable for modes fade, step and party.

*Request:*
```
S09:n
```

*Response:*
```
n  S09
```
where `n` denotes effect speed `1`-`5`

##### 4.4.6 Lights colour
Set the colour for the lights. Only applicable for colour mode.

*Request:*
```
S10:n
```

*Response:*
```
n  S10
```
where `n` denotes colour `0`-`30`

#### 4.5 Settings
##### 4.5.1 Operation Mode
Set the operation mode.

*Request:*
```
W66:n
```

*Response:*
```
n
```
where `n` denotes
* `0` - Norm
* `1` - Econ
* `2` - Away
* `3` - Week

##### 4.5.2 Filtration
###### Filtration Runtime
Set the filtration runtime.

*Request:*
```
W60:n
```

*Response:*
```
n
```
where `n` denotes hours between `1`-`24`.

###### Time Between Filtration Cycles
Set the time between filtration cycles.

*Request:*
```
W90:n
```

*Response:*
```
n
```
where `n` denotes hours as
* `1` -   1 hr
* `2` -   2 hr
* `3` -   3 hr
* `4` -   4 hr
* `6` -   6 hr
* `8` -   8 hr
* `12` - 12 hr
* `24` - 24 hr

##### 4.5.3 Sleep Timers
###### Sleep Timer 1 State
Set the state of sleep timer 1.

*Request:*
```
W67:n
```

*Response:*
```
n
```
where `n` denotes
* `128` - Off
* `127` - Everyday
* `96` - Weekends
* `31` - Weekdays

###### Sleep Timer 1 Start Time
Set the start time of sleep timer 1 in 24-hour time.

*Request:*
```
W68:nnnn
```

*Response:*
```
nnnn
```
where `nnnn` denotes time between `0`-`5947` with the formula `h*256+m` (ie: for 20:00, `nnnn` = 20\*256+0 = 5120; for 13:47, `nnnn` = 13\*256+47 = 3375)

###### Sleep Timer 1 Finish Time
Set the finish time of sleep timer 1 in 24-hour time.

*Request:*
```
W69:nnnn
```

*Response:*
```
nnnn
```
where `nnnn` denotes time between `0`-`5947` with the formula `h*256+m` (ie: for 20:00, `nnnn` = 20\*256+0 = 5120; for 13:47, `nnnn` = 13\*256+47 = 3375)

###### Sleep Timer 2 State
Set the state of sleep timer 2.

*Request:*
```
W70:n
```

*Response:*
```
n
```
where `n` denotes
* `128` - Off
* `127` - Everyday
* `96` - Weekends
* `31` - Weekdays

###### Sleep Timer 2 Start Time
Set the start time of sleep timer 2 in 24-hour time.

*Request:*
```
W71:nnnn
```

*Response:*
```
nnnn
```
where `nnnn` denotes time between `0`-`5947` with the formula `h*256+m` (ie: for 20:00, `nnnn` = 20\*256+0 = 5120; for 13:47, `nnnn` = 13\*256+47 = 3375)

###### Sleep Timer 2 Finish Time
Set the finish time of sleep timer 2 in 24-hour time.

*Request:*
```
W72:nnnn
```

*Response:*
```
nnnn
```
where `nnnn` denotes time between `0`-`5947` with the formula `h*256+m` (ie: for 20:00, `nnnn` = 20\*256+0 = 5120; for 13:47, `nnnn` = 13\*256+47 = 3375)

##### 4.5.4 Power Save
###### Power Save
Set the Power Save option.

*Request:*
```
W63:n
```

*Response:*
```
n
```
where `n` denotes
* `0` - Off
* `1` - Low
* `2` - High

###### Peak Power Time Start
Set the start of the Peak Power Time, in hours and minutes.

*Request:*
```
W64:nnnn
```

*Response:*
```
nnnn
```
where `nnnn` denotes time between `0`-`5947` with the formula `h*256+m` (ie: for 20:00, `nnnn` = 20\*256+0 = 5120; for 13:47, `nnnn` = 13\*256+47 = 3375)

###### Peak Power Time End
Set the end of the Peak Power Time, in hours and minutes.

*Request:*
```
W64:nnnn
```

*Response:*
```
nnnn
```
where `nnnn` denotes time between `0`-`5947` with the formula `h*256+m` (ie: for 20:00, `nnnn` = 20\*256+0 = 5120; for 13:47, `nnnn` = 13\*256+47 = 3375)

##### 4.5.5 Auto Santise
Set the Auto Sanitise starting time.

*Request:*
```
W73:nnnn
```

*Response:*
```
nnnn
```
where `nnnn` denotes time between `0`-`5947` with the formula `h*256+m` (ie: for 20:00, `nnnn` = 20\*256+0 = 5120; for 13:47, `nnnn` = 13\*256+47 = 3375)

##### 4.5.6 Time Out Duration
Set the Time Out duration for pumps and blower.

*Request:*
```
W74:nn
```

*Response:*
```
nn
```
where `nn` denotes time in minutes from `10`-`60`

##### 4.5.7 Heat Pump Mode
###### Heat Pump Mode
Set the Heat Pump Mode.

*Request:*
```
W99:n
```

*Response:*
```
n
```
where `n` denotes
* `0` - Auto
* `1` - Heat
* `2` - Cool
* `3` - Disabled

###### SV Element Boost
Turn on/off SV Element Boost.

*Request:*
```
W98:n
```

*Response:*
```
n
```
where `n` denotes
* `0` - Off
* `1` - On

##### 4.5.8 Set Time/Date
###### Time: Hour
Set the hour of the day for the spa.

*Request:*
```
S04:nn
```

*Response:*
```
nn
S04
```
where `nn` denotes hour of the day from `0`-`23`

###### Time: Minute
Set the minute of the hour for the spa.

*Request:*
```
S05:nn
```

*Response:*
```
nn
S05
```
where `nn` denotes minute of the hour from `00`-`59`

###### Date: Year
Set the year for the spa.

*Request:*
```
S01:nnnn
```

*Response:*
```
nnnn
S01
```
where `nnnn` denotes a valid year from `1970`-`2037` (correct 2021)

###### Date: Month
Set the month for the spa.

*Request:*
```
S02:nn
```

*Response:*
```
nn
S02
```
where `nn` denotes the month represented by a number from `1`-`12`

###### Date: Day
Set the day for the spa.

*Request:*
```
S03:nn
```

*Response:*
```
nn
S03
```
where `nn` denotes the day represented from `1`-`31` (must be a valid day for the current month)

##### 4.5.9 Support Mode
Set support mode on/off for the spa with a pin.

`POST` https://api.spanet.net.au/api/MemberLogin

*Request:*
```javascript
{
    "login": [Username],
    "pin": [Pin],
    "password": [Encrypted Password]
}
```
*Response:*
```javascript
{
    "error": null,
    "error_code": null,
    "message": null,
    "success": true
}
```
where Pin is either a 6-digit pin which will be used as the support code to turn it on (should be randomly generated by code), or a blank string to turn it off ("").

##### 4.5.10 Lock Mode
Set the Lock Mode.

*Request:*
```
S21:n
```

*Response:*
```
n
```
where `n` denotes 
* `0` - Off
* `1` - Partial
* `2` - Full

##### 4.5.11 Notification
Set push notification mode on/off

`GET` https://api.spanet.net.au/api/membersetnotification?login=[Username]&password=[Encrypted Password]&token=(null)&notificationOnOff=[Bool]&type=1

*Response:*
```javascript
{
    "error": null,
    "error_code": null,
    "message": null,
    "success": true
}
```
where Bool is either true for notifications on, or false for notifications off.

### 5. Raw command list

S01 - Date / Year  
S02 - Date / Month  
S03 - Date / Day  
S04 - Time / Hour  
S05 - Time / Minute  
S06 - Time / N/A  
S07 - Lights / Mode  
S08 - Lights / Brightness  
S09 - Lights / Effect Speed  
S10 - Lights / Colour  
S11 - Lights / Off  
S13 - Blower / Variable Speed  
S21 - Settings / Lock Mode  
S22 - Pumps / Pump 1  
S23 - Pumps / Pump 2  
S24 - Pumps / Pump 3  
S25 - Pumps / Pump 4  
S26 - Pumps / Pump 5  
S27 - Pumps / Pump Variable  
S28 - Blower / Blower  
W12 - Clean / Sanitise  
W14 - Lights / Toggle  
W40 - Spa / Temperature  
W60 - Filtration / Runtime  
W63 - Settings / Power Save  
W64 - Settings / Power Save / Peak Power Time Begin  
W65 - Settings / Power Save / Peak Power Time End  
W66 - Settings / Operation Mode  
W67 - Sleep Timers / Sleep Timer 1 State  
W68 - Sleep Timers / Sleep Timer 1 Start Time  
W69 - Sleep Timers / Sleep Timer 1 Finish Time  
W70 - Sleep Timers / Sleep Timer 2 State  
W71 - Sleep Timers / Sleep Timer 2 Start Time  
W72 - Sleep Timers / Sleep Timer 2 Finish Time  
W73 - Settings / Auto Sanitise  
W74 - Settings / Time Out Duration  
W90 - Settings / Time Between Filtration Cycles  
W98 - Settings / SV Element Boost  
W99 - Settings / Heat Pump Mode  

### 6. Reading Spa Data
##### NOTE:
The command to get spa data is RF\n as shown in section 4

A sample response is:
```
RF:
,R2,18,250,51,70,4,13,50,55,19,6,2020,376,9999,1,0,490,207,34,6000,602,23,20,0,0,0,0,44,35,45,:
,R3,32,1,4,4,4,SW V5 17 05 31,SV3,18480001,20000826,1,0,0,0,0,0,NA,7,0,470,Filtering,4,0,7,7,0,0,:
,R4,NORM,0,0,0,1,0,3547,4,20,4500,7413,567,1686,0,8388608,0,0,5,0,98,0,10084,4,80,100,0,0,4,:
,R5,0,1,0,1,0,0,0,0,0,0,1,0,1,0,376,0,3,4,0,0,0,0,0,1,2,6,:
,R6,1,5,30,2,5,8,1,360,1,0,3584,5120,127,128,5632,5632,2304,1792,0,30,0,0,0,0,2,3,0,:
,R7,2304,0,1,1,1,0,1,0,0,0,253,191,253,240,483,125,77,1,0,0,0,23,200,1,0,1,31,32,35,100,5,:
,R9,F1,255,0,0,0,0,0,0,0,0,0,0,:
,RA,F2,0,0,0,0,0,0,255,0,0,0,0,:
,RB,F3,0,0,0,0,0,0,0,0,0,0,0,:
,RC,0,1,1,0,0,0,0,0,0,2,0,0,1,0,:
,RE,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,-4,13,30,8,5,1,0,0,0,0,0,:*
,RG,1,1,1,1,1,1,1-1-014,1-1-01,1-1-01,0-,0-,0,:*
```

Each below aspect of the spa will show which value of this RF fix needs to be read and what it's possible values are. It will say the read line (R2, R3, R4 etc.) and the read bit, which is the index number of the value to read from the line seperated by commas. The first value of each line is index number 2 (the name of each line is index number 1). e.g. If an aspect of the spa was represented by the 70 on line R2, the information for reading it would be *Line R2, Read Bit 5*.

#### 6.1 Spa Status
##### 6.1.1 Set Temperature
`,R6,1,5,30,2,5,8,1,`360`,1,0,3584,5120,127,128,5632,5632,2304,1792,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 9  
Data Type: Integer  
Range: `50` to `410`  
Data: Represents spa set temperature in degrees celcius * 10 (e.g. `360` is 36.00°C and `76` is 7.60°C)

##### 6.1.2 Water Temperature
`,R5,0,1,0,1,0,0,0,0,0,0,1,0,1,0,`376`,0,3,4,0,0,0,0,0,1,2,6,:`

Line: R5  
Read Bit: 16  
Data Type: Integer  
Data: Represents spa actual temperature in degrees celcius * 10 (e.g. `360` is 36.00°C and `76` is 7.60°C)

##### 6.1.3 Heating
`,R5,0,1,0,1,0,0,0,0,0,0,1,`0`,1,0,376,0,3,4,0,0,0,0,0,1,2,6,:`

Line: R5  
Read Bit: 13  
Data Type: Integer  
Range: `0` to `1`  
Data: Integer is `1` when the heater is on (currently heating/cooling the water) and `0` when it is off

##### 6.1.4 Cleaning (UV/Ozone running)
`,R5,0,1,0,1,0,0,0,0,0,0,`1`,0,1,0,376,0,3,4,0,0,0,0,0,1,2,6,:`

Line: R5  
Read Bit: 12  
Data Type: Integer  
Range: `0` to `1`  
Data: Integer is `1` when the Ozone/UV is cleaning the spa and `0` when it is off

##### 6.1.5 Cleaning (Sanitise cycle running)
`,R5,0,1,0,1,0,0,0,0,0,0,1,0,1,0,376,`0`,3,4,0,0,0,0,0,1,2,6,:`

Line: R5  
Read Bit: 17  
Data Type: Integer  
Range: `0` to `1`  
Data: Integer is `1` when clean cycle is running and `0` when it is not

##### 6.1.6 Auto
`,R5,0,1,0,1,0,0,0,0,0,0,1,0,`1`,0,376,0,3,4,0,0,0,0,0,1,2,6,:`

Line: R5  
Read Bit: 14  
Data Type: Integer  
Range: `0` to `1`  
Data: Integer is `1` when the auto is enabled and `0` when it is not

##### 6.1.7 Sleeping
`,R5,0,1,0,1,0,0,0,0,0,`0`,1,0,1,0,376,0,3,4,0,0,0,0,0,1,2,6,:`

Line: R5  
Read Bit: 11  
Data Type: Integer  
Range: `0` to `1`  
Data: Integer is `1` when the spa is currently sleeping due to a sleep timer `0` when it is not

#### 6.2 Pumps
##### 6.2.1 Pump 1
###### Pump 1
`,R5,0,1,0,1,0,0,0,0,0,0,1,0,1,0,376,0,3,`4`,0,0,0,0,0,1,2,6,:`

Line: R5  
Read Bit: 19  
Data Type: Integer  
Range: `0` to `4`  
Data: Integer is `4` when pump is set to auto, `1` when it is on and `0` when it is off

###### Pump 1 Installation State
`,RG,1,1,1,1,1,1,`1-1-014`,1-1-01,1-1-01,0-,0-,0,:*`

Line: RG  
Read Bit: 8  
Data Type: String  
Data: First part (1- or 0-) indicates whether the pump is installed/fitted. If so (1- means it is), the second part (1- above) indicates it's speed type. The third part (014 above) represents it's possible states (0 OFF, 1 ON, 4 AUTO)

##### 6.2.2 Pump 2
###### Pump 2
`,R5,0,1,0,1,0,0,0,0,0,0,1,0,1,0,376,0,3,4,`0`,0,0,0,0,1,2,6,:`

Line: R5  
Read Bit: 20  
Data Type: Integer  
Range: `0` to `1`  
Data: Integer is `1` when pump is on and `0` when it is off

###### Pump 2 Installation State
`,RG,1,1,1,1,1,1,1-1-014,`1-1-01`,1-1-01,0-,0-,0,:*`

Line: RG  
Read Bit: 9  
Data Type: String  
Data: First part (1- or 0-) indicates whether the pump is installed/fitted. If so (1- means it is), the second part (1- above) indicates it's speed type. The third part (01 above) represents it's possible states (0 OFF, 1 ON)

###### Pump 2 Switch On Status
`,RG,1,`1`,1,1,1,1,1-1-014,1-1-01,1-1-01,0-,0-,0,:*`

Line: RG  
Read Bit: 3  
Data Type: Integer  
Range: `0` to `1`  
Data: Integer is `1` when the pump is OK to turn on and `0` when it is not

##### 6.2.3 Pump 3
###### Pump 3
`,R5,0,1,0,1,0,0,0,0,0,0,1,0,1,0,376,0,3,4,0,`0`,0,0,0,1,2,6,:`

Line: R5  
Read Bit: 21  
Data Type: Integer  
Range: `0` to `1`  
Data: Integer is `1` when pump is on and `0` when it is off

###### Pump 3 Installation State
`,RG,1,1,1,1,1,1,1-1-014,1-1-01,`1-1-01`,0-,0-,0,:*`

Line: RG  
Read Bit: 10  
Data Type: String  
Data: First part (1- or 0-) indicates whether the pump is installed/fitted. If so (1- means it is), the second part (1- above) indicates it's speed type. The third part (01 above) represents it's possible states (0 OFF, 1 ON)

###### Pump 3 Switch On Status
`,RG,1,1,`1`,1,1,1,1-1-014,1-1-01,1-1-01,0-,0-,0,:*`

Line: RG  
Read Bit: 4  
Data Type: Integer  
Range: `0` to `1`  
Data: Integer is `1` when the pump is OK to turn on and `0` when it is not

##### 6.2.4 Pump 4
###### Pump 4
`,R5,0,1,0,1,0,0,0,0,0,0,1,0,1,0,376,0,3,4,0,0,`0`,0,0,1,2,6,:`

Line: R5  
Read Bit: 22  
Data Type: Integer  
Range: `0` to `1`  
Data: Integer is `1` when pump is on and `0` when it is off

###### Pump 4 Installation State
`,RG,1,1,1,1,1,1,1-1-014,1-1-01,1-1-01,`0-`,0-,0,:*`

Line: RG  
Read Bit: 11  
Data Type: String  
Data: First part (1- or 0-) indicates whether the pump is installed/fitted. If so (1- means it is), the second part indicates it's speed type. The third part represents it's possible states

###### Pump 4 Switch On Status
`,RG,1,1,1,`1`,1,1,1-1-014,1-1-01,1-1-01,0-,0-,0,:*`

Line: RG  
Read Bit: 5  
Data Type: Integer  
Range: `0` to `1`  
Data: Integer is `1` when the pump is OK to turn on and `0` when it is not

##### 6.2.5 Pump 5
`,R5,0,1,0,1,0,0,0,0,0,0,1,0,1,0,376,0,3,4,0,0,0,`0`,0,1,2,6,:`

Line: R5  
Read Bit: 23  
Data Type: Integer  
Range: `0` to `1`  
Data: Integer is `1` when pump is on and `0` when it is off

###### Pump 5 Installation State
`,RG,1,1,1,1,1,1,1-1-014,1-1-01,1-1-01,0-,`0-`,0,:*`

Line: RG  
Read Bit: 12  
Data Type: String  
Data: First part (1- or 0-) indicates whether the pump is installed/fitted. If so (1- means it is), the second part indicates it's speed type. The third part represents it's possible states

###### Pump 5 Switch On Status
`,RG,1,1,1,1,`1`,1,1-1-014,1-1-01,1-1-01,0-,0-,0,:*`

Line: RG  
Read Bit: 6  
Data Type: Integer  
Range: `0` to `1`  
Data: Integer is `1` when the pump is OK to turn on and `0` when it is not

#### 6.3 Blower
##### 6.3.1 Blower
`,RC,0,1,1,0,0,0,0,0,0,`2`,0,0,1,0,:`

Line: RC  
Read Bit: 11  
Data Type: Integer  
Range: `0` to `2`  
Data: Integer is `2` when pump is off, `1` when it is on ramp mode and `0` when it is on variable mode

##### 6.3.1 Blower Variable Speed
`,R6,`1`,5,0,2,5,8,1,360,1,0,3584,5120,127,128,5632,5632,2304,1792,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 2  
Data Type: Integer  
Range: `1` to `5`  
Data: Integer represents blower variable speed from speed `1` to speed `5`

#### 6.4 Lights
##### 6.4.1 Lights
`,R5,0,1,0,1,0,0,0,0,0,0,1,0,1,`0`,376,0,3,4,0,0,0,0,0,1,2,6,:`

Line: R5  
Read Bit: 15  
Data Type: Integer  
Range: `0` to `1`  
Data: Integer is `1` when lights are on `0` when they are off

##### 6.4.2 Lights Mode
`,R6,1,5,0,`2`,5,8,1,360,1,0,3584,5120,127,128,5632,5632,2304,1792,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 5  
Data Type: Integer  
Range: `0` to `4`  
Data: Integer is `0` for mode white, `1` for mode colour, `2` for mode step, `3` for mode fade and `4` for mode party

##### 6.4.3 Lights Brightness
`,R6,1,`5`,0,2,5,8,1,360,1,0,3584,5120,127,128,5632,5632,2304,1792,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 3  
Data Type: Integer  
Range: `1` to `5`  
Data: Integer represents brightness from `1` to `5`

##### 6.4.4 Lights Effect Speed
`,R6,1,5,30,2,`5`,8,1,360,1,0,3584,5120,127,128,5632,5632,2304,1792,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 6  
Data Type: Integer  
Range: `1` to `5`  
Data: Integer represents effect speed from `1` to `5`

##### 6.4.5 Lights Colour
`,R6,1,5,`0`,2,5,8,1,360,1,0,3584,5120,127,128,5632,5632,2304,1792,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 4  
Data Type: Integer  
Range: `0` to `30`  
Data: Integer represents colour from `0` to `30`

#### 6.5 Settings
##### 6.5.1 Operation Mode
`,R4,`NORM`,0,0,0,1,0,3547,4,20,4500,7413,567,1686,0,8388608,0,0,5,0,98,0,10084,4,80,100,0,0,4,:`

Line: R4  
Read Bit: 2  
Data Type: String  
Data: `NORM` represents normal mode, `ECON` economy mode, `AWAY` away mode and `WEEK` weekdays mode

##### 6.5.2 Filtration
###### Filtration Runtime
`,R6,1,5,30,2,5,`8`,1,360,1,0,3584,5120,127,128,5632,5632,2304,1792,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 7  
Data Type: Integer  
Range: `1` to `24`  
Data: Integer represents hours from `1` to `24`

###### Time Between Filtration Cycles
`,R6,1,5,30,2,5,8,`1`,360,1,0,3584,5120,127,128,5632,5632,2304,1792,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 8  
Data Type: Integer  
Range: `1` to `24`  
Data: Integer represents hours, where possible values are `1`, `2`, `3`, `4`, `6`, `8`, `12` and `24`

##### 6.5.3 Sleep Timers
###### Sleep Timer 1 State
`,R6,1,5,30,2,5,8,1,360,1,0,3584,5120,`127`,128,5632,5632,2304,1792,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 14  
Data Type: Integer  
Range: `1` to `128`  
Data: `128` represents off, `127` represents everyday mode, `96` represents weekends mode and `31` represents weekdays mode

###### Sleep Timer 1 Start Time
`,R6,1,5,30,2,5,8,1,360,1,0,3584,5120,127,128,`5632`,5632,2304,1792,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 16  
Data Type: Integer  
Range: `0` to `5947`  
Data: Time with the formula `h*256+m` (ie: for 20:00, integer will be 20\*256+0 = 5120; for 13:47, integer will be 13\*256+47 = 3375)

###### Sleep Timer 1 Finish Time
`,R6,1,5,30,2,5,8,1,360,1,0,3584,5120,127,128,5632,5632,`2304`,1792,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 18  
Data Type: Integer  
Range: `0` to `5947`  
Data: Time with the formula `h*256+m` (ie: for 20:00, integer will be 20\*256+0 = 5120; for 13:47, integer will be 13\*256+47 = 3375)

###### Sleep Timer 2 State
`,R6,1,5,30,2,5,8,1,360,1,0,3584,5120,127,`128`,5632,5632,2304,1792,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 15  
Data Type: Integer  
Range: `1` to `128`  
Data: `128` represents off, `127` represents everyday mode, `96` represents weekends mode and `31` represents weekdays mode.

###### Sleep Timer 2 Start Time
`,R6,1,5,30,2,5,8,1,360,1,0,3584,5120,127,128,5632,`5632`,2304,1792,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 17  
Data Type: Integer  
Range: `0` to `5947`  
Data: Time with the formula `h*256+m` (ie: for 20:00, integer will be 20\*256+0 = 5120; for 13:47, integer will be 13\*256+47 = 3375)

###### Sleep Timer 2 Finish Time
`,R6,1,5,30,2,5,8,1,360,1,0,3584,5120,127,128,5632,5632,2304,`1792`,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 19  
Data Type: Integer  
Range: `0` to `5947`  
Data: Time with the formula `h*256+m` (ie: for 20:00, integer will be 20\*256+0 = 5120; for 13:47, integer will be 13\*256+47 = 3375)

##### 6.5.4 Power Save
###### Power Save
`,R6,1,5,30,2,5,8,1,360,1,`0`,3584,5120,127,128,5632,5632,2304,1792,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 11  
Data Type: Integer  
Range: `0` to `2`  
Data: Integer is `0` for off, `1` for low and `2` for high

###### Peak Power Time Start
`,R6,1,5,30,2,5,8,1,360,1,0,`3584`,5120,127,128,5632,5632,2304,1792,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 12  
Data Type: Integer  
Range: `0` to `5947`  
Data: Time with the formula `h*256+m` (ie: for 20:00, integer will be 20\*256+0 = 5120; for 13:47, integer will be 13\*256+47 = 3375)

###### Peak Power Time End
`,R6,1,5,30,2,5,8,1,360,1,0,3584,`5120`,127,128,5632,5632,2304,1792,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 13  
Data Type: Integer  
Range: `0` to `5947`  
Data: Time with the formula `h*256+m` (ie: for 20:00, integer will be 20\*256+0 = 5120; for 13:47, integer will be 13\*256+47 = 3375)

##### 6.5.5 Auto Sanitise
`,R7,`2304`,0,1,1,1,0,1,0,0,0,253,191,253,240,483,125,77,1,0,0,0,23,200,1,0,1,31,32,35,100,5,:`

Line: R7  
Read Bit: 12  
Data Type: Integer  
Range: `0` to `5947`  
Data: Time with the formula `h*256+m` (ie: for 20:00, integer will be 20\*256+0 = 5120; for 13:47, integer will be 13\*256+47 = 3375)

##### 6.5.6 Time Out Mode
`,R6,1,5,`30`,2,5,8,1,360,1,0,3584,5120,127,128,5632,5632,2304,1792,0,30,0,0,0,0,2,3,0,:`

Line: R6  
Read Bit: 4  
Data Type: Integer  
Range: `10` to `30`  
Data: Integer is time in minutes before pump and blower auto time-out

##### 6.5.7 Heat Pump Mode
###### Heat Pump Mode
`,R7,2304,0,1,1,1,0,1,0,0,0,253,191,253,240,483,125,77,1,0,0,0,23,200,1,0,`1`,31,32,35,100,5,:`

Line: R7  
Read Bit: 27  
Data Type: Integer  
Range: `0` to `3`  
Data: `0` represents auto mode, `1` heat mode, `2` cool mode and `3` disabled mode

###### SV Element Boost
`,R7,2304,0,1,1,1,0,1,0,0,0,253,191,253,240,483,125,77,1,0,0,0,23,200,1,`0`,1,31,32,35,100,5,:`

Line: R7  
Read Bit: 26  
Data Type: Integer  
Range: `0` to `1`  
Data: Integer is `0` when off and `1` when on

##### 6.5.8 Time/Date
###### Time: Hour
`,R2,18,250,51,70,4,`13`,50,55,19,6,2020,376,9999,1,0,490,207,34,6000,602,23,20,0,0,0,0,44,35,45,:`

Line: R2  
Read Bit: 7  
Data Type: Integer  
Range: `0` to `23`  
Data: Represents hour of the day in 24-hour time

###### Time: Minute
`,R2,18,250,51,70,4,13,`50`,55,19,6,2020,376,9999,1,0,490,207,34,6000,602,23,20,0,0,0,0,44,35,45,:`

Line: R2  
Read Bit: 8  
Data Type: Integer  
Range: `0` to `59`  
Data: Represents minute of the hour

###### Date: Year
`,R2,18,250,51,70,4,13,50,55,19,6,`2020`,376,9999,1,0,490,207,34,6000,602,23,20,0,0,0,0,44,35,45,:`

Line: R2  
Read Bit: 12  
Data Type: Integer  
Range: `1970` to `2037` (correct 2021)  
Data: Represents current year

###### Date: Month
`,R2,18,250,51,70,4,13,50,55,19,`6`,2020,376,9999,1,0,490,207,34,6000,602,23,20,0,0,0,0,44,35,45,:`

Line: R2  
Read Bit: 11  
Data Type: Integer  
Range: `1` to `12`  
Data: Represents current month of the year, where `1` is January and `12` is December

###### Date: Day
`,R2,18,250,51,70,4,13,50,55,`19`,6,2020,376,9999,1,0,490,207,34,6000,602,23,20,0,0,0,0,44,35,45,:`

Line: R2  
Read Bit: 10  
Data Type: Integer  
Range: `1` to `31`  
Data: Represents current day of the month, where the integer will only be a valid day of the current month

##### 6.5.9 Support Mode
If your application sets a support pin for the spa, it must locally store this pin. Support PIN's created by the official SpaLINK app are registered through a web request (see 4.5.9) but not shared across to other devices running the same app with the same spa logged in. That goes to say, PIN's are registered for the spa on the SpaNET server but individual to devices on which they were created/registered.

##### 6.5.10 Lock Mode
`,RG,1,1,1,1,1,1,1-1-014,1-1-01,1-1-01,0-,0-,`0`,:*`

Line: RG  
Read Bit: 13  
Data Type: Integer  
Range: `0` to `2`  
Data: `0` represents keypad lock off, `1` partial keypad lock and `2` full keypad lock

##### 6.5.11 Notification
Notifications status for devices is sent to the SpaNET API server but is individual to devices, so your app must keep track if it has turned notifications on for itself. This setting should not be applicable for most plugins/code anyway, unless you are making an app which can send a type of notifications (e.g. push notifications).
