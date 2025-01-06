; Configuration file for RailCore II 300ZL

; Debugging
M111 S1                             	; Debug off
M929 P"eventlog.txt" S1					; Start logging to file evenlog.txt

; General preferences
G21                                 	; Work in millimetres
G90                                		; Send absolute coordinates...
M83                                 	; ...but relative extruder moves

M555 P2                           		; Set output to look like Marlin
M669 K1									; set CoreXY mode
M575 P1 S1 B57600						; Comms parameters for PanelDue

; Wifi Networking
M550 P"RailCore"						; Machine name and Netbios name (can be anything you like)
M552 S1	P"CID"							; Enable WiFi

; Drives
M584 X0 Y1 Z5:6:7 E3					; Map Z to drivers 5, 6, 7.  Extruder to 3
M569 P0 S0                          	; Drive 0 goes backwards	X stepper (Rear)
M569 P1 S1                          	; Drive 1 goes forwards		Y Stepper (Front)
M569 P3 S0                          	; Drive 3 goes backwards	Extruder 
M569 P5 S0								; Drive 5 goes backwards	Front Left Z
M569 P6 S0								; Drive 6 goes backwards	Rear Left Z
M569 P7 S0								; Drive 7 goes backwards	Right Z

; Leadscrew locations
M671 X-8.5:-8.5:346.5 Y26:281:153.5 S7.5  	; Front left, Rear Left, Right  S7.5 is the max correction - measure your own offsets, to the bolt for the yoke of each leadscrew

; Axis and motor configurations
M350 X16 Y16 Z16 E16 I1	    			; set 16x microstepping for axes & extruder, with interpolation
M906 X1400 Y1400 Z1100 E1000 I60		; Set motor currents (mA)
M201 X4800 Y4800 Z500 E1500        		; Accelerations (mm/s^2)
M203 X18000 Y18000 Z1500 E3600      	; Maximum speeds (mm/min)
M566 X600 Y600 Z200 E1000         		; Maximum jerk speeds mm/minute 
M208 X301 Y310 Z320       				; set axis maxima and high homing switch positions (adjust to suit your machine)
M208 X-1 Y0 Z-0.10 S1                 	; set axis minima and low homing switch positions (adjust to make X=0 and Y=0 the edges of the bed)
M92 X160 Y160 Z800 E830	    			; steps/mm
M556 S100 X0.6							; XY Skew correction 100mm Califlower measured Sept 21 2024
M84 S60                                 ; Set idle timeout

; PRESSURE ADVANCE
;M572 D0 S0.09 			             	 ; set extruder 0 pressure advance. Default for PLA direct drive is 0.09 seconds, PETG 0.145

; NON-LINEAR EXTRUSION
;M592 D0 A0.1214 B0.1786                 ; set parameters for extruder drive 0

;Input Shaper
M593 P"mzv" F42

; End stops
M574 X1 S1 P"xstop"						; set X endstop to xstop port active high
M574 Y1 S1 P"ystop"						; set Y endstop to ystop port active high

; Thermistors
M308 S0 P"bedtemp" Y"thermistor" A"Heated Bed" T100000 B3950 R4700 H0 L0 	; Bed thermistor, connected to bedtemp on Duet2
M308 S1 P"spi.cs1" Y"rtd-max31865" A"Nozzle" F60
M308 S2 P"duex.e6temp" Y"thermistor" A"Keenovo" T100000 B3950 R4700 H0 L0 
M308 S3 Y"mcu-temp" A"MCU" 				; configure sensor 3 as on-chip MCU temperature sensor
M308 S4 Y"drivers-duex" A"Duex Drivers"
M308 S5 Y"drivers" A"Duet Drivers"

M950 H0 C"bedheat" T0					; define Bed heater is on bedheat
M307 H0 B0 S1.00                        ; disable bang-bang mode for the bed heater and set PWM limit
M140 H0									; map heated bed to heater 0
M143 H0 S125                            ; set temperature limit for heater 0 to 125C
M950 H1 C"e0heat" T1					; define Hotend heater is on e0heat
M307 H1 B0 S1.00                        ; disable bang-bang mode for heater and set PWM limit
M143 H1 S300							; set temperature limit for heater 1 to 300c

M307 H0 R0.330 K0.128:0.000 D19.76 E1.35 S1.00 B0 		; Bed PID tune for 70c - doors cracked, top off
M307 H1 R1.711 K0.314:0.000 D4.92 E1.35 S1.00 B0 V24.0	; E3D V6 Gold PID tune for 220c - doors cracked, top off, bed at 60c
M570 H1 S360							; Hot end may be a little slow to heat up so allow it 180 seconds
M143 H1 S300							; set temperature limit for heater 1 to 300c

; Fans
M950 F0 C"fan0"							; define fan0
M950 F1 C"fan1"							; define fan1
M950 F2 C"duex.fan3" 	 				; create fan 2 on pin duex.fan3, electronics cooling fan
M106 P0 H-1 							; disable thermostatic mode for fan 0
M106 P1 T50 H1 							; enable thermostatic mode for fan 1
M106 P2 H3 T35:60						; set fan 2 value    
M106 P0 S0 								; turn off fans
M106 P1 S0
M106 P2 S0

; Filter fan
M950 F3 C"duex.fan4" 
M106 P3 C"Filter Fan"

; LED Lights - Duex5
M950 F4 C"duex.pwm5" 
M106 P4 S0.15 C"LEDs" A3	

; create dummy fan so we can use variables
M950 F8 C"duex.fan8" Q0                  ; create fan 8 on pin and set its frequency
M106 P8 C"No_Filament" S0 X255 H-1
	
; accellerometer
;M955 P0 C"spi.cs4+spi.cs3" 				; all wires connected to temp DB connector, stacked on one temperature daughterboard
	
; Tool definitions
M563 P0 S"E3D V6-Gold" D0 H1 F0         ; Define tool 0
G10 P0 S0 R0                        	; Set tool 0 operating and standby temperatures

; BLTouch
M950 S0 C"duex.pwm1"				  	; Define BLTouch Servo (S0) on duet pwm1
M558 P9 C"^zprobe.in" H5 F800:120 T12000 A10 S0.005  ; BLTouch connected to Z probe IN pin
G31 P25 X-3.5 Y36 Z2.605				; set Z probe trigger value, offset and trigger height. Larger Z moves closer to bed.

; Mesh Bed Levelling area
M557 X48:288 Y50:260 P5:4       		; Set Default Mesh 

T0										; select first hot end

; extrusion
if move.extruders[state.currentTool].filament=""
	echo "No filament loaded.  Cold extrude & retract set to defaults"
	M302 S190 R110 ; Allow extrusion starting from 190°C and retractions already from 110°C (defaults)
else
	echo "Filament loaded.  Set values per config for filament"
	M703 ; if a filament is loaded, set all the heats and speeds for it by loading config.g
	M106 P8 C{move.extruders[state.currentTool].filament} S0 H-1

; Start up Tune
G4 S3									; Pause machine for S'seconds'
M98 P"0:/macros/Tunes/StartUp.g"		; Play start up tune
G4 S1									; Pause machine for S'seconds'