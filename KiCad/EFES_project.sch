EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 3
Title "FPGA Based Digital Audio Synthesizer"
Date "2025-02-23"
Rev "1.0"
Comp "Politecnico di Torino"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Sheet
S 2800 4250 1500 1050
U 672F9148
F0 "FPGA" 50
F1 "subsheet_1.sch" 50
F2 "ATMEGA_CS" T L 2800 4750 50 
F3 "ATMEGA_MOSI" O L 2800 4950 50 
F4 "ATMEGA_MISO" I L 2800 4850 50 
F5 "ATMEGA_SCK" T L 2800 5050 50 
F6 "ATMEGA_INT0" O L 2800 4450 50 
F7 "ATMEGA_INT1" O L 2800 4550 50 
F8 "DAC_OUT1" O R 4300 4550 50 
F9 "DAC_OUT2" O R 4300 5000 50 
$EndSheet
$Sheet
S 1050 4250 1400 1050
U 672FE139
F0 "ATMEGA" 50
F1 "subsheet2.sch" 50
F2 "ATMEGA_MOSI" O R 2450 4850 50 
F3 "ATMEGA_SCK" T R 2450 5050 50 
F4 "ATMEGA_MISO" I R 2450 4950 50 
F5 "ATMEGA_CS" T R 2450 4750 50 
F6 "INT0" I R 2450 4450 50 
F7 "INT1" I R 2450 4550 50 
$EndSheet
$Comp
L Regulator_Switching:TMR_1-1212 U6
U 1 1 673027FD
P 3950 2900
F 0 "U6" H 3950 3367 50  0000 C CNN
F 1 "B1212S" H 3950 3276 50  0000 C CNN
F 2 "Converter_DCDC:Converter_DCDC_muRata_CRE1xxxxxxSC_THT" H 3950 2550 50  0001 C CNN
F 3 "http://assets.tracopower.com/TMR1/documents/tmr1-datasheet.pdf" H 3950 2400 50  0001 C CNN
	1    3950 2900
	1    0    0    -1  
$EndComp
$Comp
L Regulator_Switching:TMR_1-1212 U5
U 1 1 673030D8
P 3950 1900
F 0 "U5" H 3950 2367 50  0000 C CNN
F 1 "B1212S" H 3950 2276 50  0000 C CNN
F 2 "Converter_DCDC:Converter_DCDC_muRata_CRE1xxxxxxSC_THT" H 3950 1550 50  0001 C CNN
F 3 "http://assets.tracopower.com/TMR1/documents/tmr1-datasheet.pdf" H 3950 1400 50  0001 C CNN
	1    3950 1900
	1    0    0    -1  
$EndComp
$Comp
L Connector:Barrel_Jack_MountingPin J1
U 1 1 6730857F
P 1550 1700
F 0 "J1" H 1607 2017 50  0000 C CNN
F 1 "Barrel Jack" H 1607 1926 50  0000 C CNN
F 2 "Connector_BarrelJack:BarrelJack_Horizontal" H 1600 1660 50  0001 C CNN
F 3 "~" H 1600 1660 50  0001 C CNN
	1    1550 1700
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR01
U 1 1 67308E87
P 1550 2100
F 0 "#PWR01" H 1550 1850 50  0001 C CNN
F 1 "GND" H 1555 1927 50  0000 C CNN
F 2 "" H 1550 2100 50  0001 C CNN
F 3 "" H 1550 2100 50  0001 C CNN
	1    1550 2100
	1    0    0    -1  
$EndComp
Wire Wire Line
	3100 2700 3100 1700
Wire Wire Line
	4450 2700 4600 2700
Wire Wire Line
	4600 2100 4450 2100
Text Label 2800 1700 0    50   ~ 0
PWR_in
Wire Wire Line
	4450 1700 4600 1700
Wire Wire Line
	4450 3100 4600 3100
Wire Wire Line
	4600 2100 4600 2400
Connection ~ 2950 2100
Wire Wire Line
	2950 2100 2950 3100
Wire Wire Line
	3100 1700 3250 1700
Connection ~ 3100 1700
Wire Wire Line
	2950 2100 3250 2100
Wire Wire Line
	3100 2700 3250 2700
Wire Wire Line
	2950 3100 3250 3100
Wire Wire Line
	3250 3100 3250 3050
Wire Wire Line
	3250 2750 3250 2700
Connection ~ 3250 3100
Wire Wire Line
	3250 3100 3450 3100
Connection ~ 3250 2700
Wire Wire Line
	3250 2700 3450 2700
Wire Wire Line
	3250 2100 3250 2050
Wire Wire Line
	3250 1750 3250 1700
Connection ~ 3250 2100
Wire Wire Line
	3250 2100 3450 2100
Connection ~ 3250 1700
Wire Wire Line
	3250 1700 3450 1700
Wire Wire Line
	4600 2100 4600 2050
Wire Wire Line
	4600 1750 4600 1700
Connection ~ 4600 2100
Connection ~ 4600 1700
Wire Wire Line
	4600 1700 5050 1700
Wire Wire Line
	4600 3100 4600 3050
Wire Wire Line
	4600 2750 4600 2700
Connection ~ 4600 3100
Wire Wire Line
	4600 3100 5100 3100
Connection ~ 4600 2700
Connection ~ 4600 2400
Wire Wire Line
	4600 2400 4600 2700
$Comp
L power:+12V #PWR06
U 1 1 67316CA2
P 5050 1700
F 0 "#PWR06" H 5050 1550 50  0001 C CNN
F 1 "+12V" H 5065 1873 50  0000 C CNN
F 2 "" H 5050 1700 50  0001 C CNN
F 3 "" H 5050 1700 50  0001 C CNN
	1    5050 1700
	1    0    0    -1  
$EndComp
$Comp
L power:-12V #PWR07
U 1 1 6731748D
P 5100 3100
F 0 "#PWR07" H 5100 3200 50  0001 C CNN
F 1 "-12V" H 5115 3273 50  0000 C CNN
F 2 "" H 5100 3100 50  0001 C CNN
F 3 "" H 5100 3100 50  0001 C CNN
	1    5100 3100
	1    0    0    -1  
$EndComp
Connection ~ 5050 1700
$Comp
L power:GND #PWR02
U 1 1 6731B0F4
P 3950 1150
F 0 "#PWR02" H 3950 900 50  0001 C CNN
F 1 "GND" H 3955 977 50  0000 C CNN
F 2 "" H 3950 1150 50  0001 C CNN
F 3 "" H 3950 1150 50  0001 C CNN
	1    3950 1150
	1    0    0    -1  
$EndComp
$Comp
L Device:C C1
U 1 1 6731F0C2
P 3250 1900
F 0 "C1" H 3365 1946 50  0000 L CNN
F 1 "2.2u" H 3365 1855 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 3288 1750 50  0001 C CNN
F 3 "~" H 3250 1900 50  0001 C CNN
	1    3250 1900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C2
U 1 1 6731FB98
P 3250 2900
F 0 "C2" H 3365 2946 50  0000 L CNN
F 1 "2.2u" H 3365 2855 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 3288 2750 50  0001 C CNN
F 3 "~" H 3250 2900 50  0001 C CNN
	1    3250 2900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C6
U 1 1 67320593
P 4600 2900
F 0 "C6" H 4715 2946 50  0000 L CNN
F 1 "2.2u" H 4715 2855 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 4638 2750 50  0001 C CNN
F 3 "~" H 4600 2900 50  0001 C CNN
	1    4600 2900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C5
U 1 1 67320A09
P 4600 1900
F 0 "C5" H 4700 2000 50  0000 L CNN
F 1 "2.2u" H 4700 1900 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 4638 1750 50  0001 C CNN
F 3 "~" H 4600 1900 50  0001 C CNN
	1    4600 1900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 6732158C
P 4400 1000
F 0 "C4" H 4515 1046 50  0000 L CNN
F 1 "100n" H 4515 955 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric" H 4438 850 50  0001 C CNN
F 3 "~" H 4400 1000 50  0001 C CNN
	1    4400 1000
	1    0    0    -1  
$EndComp
$Comp
L Device:C C3
U 1 1 67321E62
P 3400 1000
F 0 "C3" H 3515 1046 50  0000 L CNN
F 1 "470n" H 3515 955 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 3438 850 50  0001 C CNN
F 3 "~" H 3400 1000 50  0001 C CNN
	1    3400 1000
	1    0    0    -1  
$EndComp
Wire Wire Line
	4250 850  4400 850 
Connection ~ 3950 1150
Wire Wire Line
	3950 1150 4400 1150
Connection ~ 4400 850 
$Comp
L power:+5V #PWR03
U 1 1 67324099
P 4850 850
F 0 "#PWR03" H 4850 700 50  0001 C CNN
F 1 "+5V" H 4865 1023 50  0000 C CNN
F 2 "" H 4850 850 50  0001 C CNN
F 3 "" H 4850 850 50  0001 C CNN
	1    4850 850 
	1    0    0    -1  
$EndComp
Wire Wire Line
	1900 1800 1850 1800
$Comp
L Switch:SW_SPDT SW1
U 1 1 67338E9E
P 2200 1600
F 0 "SW1" H 2200 1275 50  0000 C CNN
F 1 "SW_PWR" H 2200 1366 50  0000 C CNN
F 2 "DM-OLED096-636:MTS-103" H 2200 1600 50  0001 C CNN
F 3 "~" H 2200 1600 50  0001 C CNN
	1    2200 1600
	1    0    0    1   
$EndComp
Wire Wire Line
	1550 2100 1900 2100
Wire Wire Line
	1550 2100 1550 2000
Connection ~ 1550 2100
Wire Wire Line
	1900 1800 1900 2100
Connection ~ 1900 2100
Wire Wire Line
	1900 2100 2600 2100
Wire Wire Line
	1850 1600 2000 1600
Wire Wire Line
	2400 1700 2600 1700
$Comp
L Device:LED D2
U 1 1 6733F5B4
P 5050 1850
F 0 "D2" V 5089 1732 50  0000 R CNN
F 1 "LED" V 4998 1732 50  0000 R CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 5050 1850 50  0001 C CNN
F 3 "~" H 5050 1850 50  0001 C CNN
	1    5050 1850
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R2
U 1 1 6734165C
P 5050 2200
F 0 "R2" H 5120 2246 50  0000 L CNN
F 1 "1k" H 5120 2155 50  0000 L CNN
F 2 "Resistor_SMD:R_1206_3216Metric" V 4980 2200 50  0001 C CNN
F 3 "~" H 5050 2200 50  0001 C CNN
	1    5050 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	4600 2400 4850 2400
Wire Wire Line
	5050 2400 5050 2350
Wire Wire Line
	5050 2050 5050 2000
$Comp
L power:GND #PWR04
U 1 1 67343B4E
P 4850 2400
F 0 "#PWR04" H 4850 2150 50  0001 C CNN
F 1 "GND" H 4855 2227 50  0000 C CNN
F 2 "" H 4850 2400 50  0001 C CNN
F 3 "" H 4850 2400 50  0001 C CNN
	1    4850 2400
	1    0    0    -1  
$EndComp
Connection ~ 4850 2400
Wire Wire Line
	4850 2400 5050 2400
$Comp
L Regulator_Linear:AMS1117-3.3 U9
U 1 1 67344544
P 6150 850
F 0 "U9" H 6150 1092 50  0000 C CNN
F 1 "AMS1117-3.3" H 6150 1001 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-223-3_TabPin2" H 6150 1050 50  0001 C CNN
F 3 "http://www.advanced-monolithic.com/pdf/ds1117.pdf" H 6250 600 50  0001 C CNN
	1    6150 850 
	1    0    0    -1  
$EndComp
$Comp
L Regulator_Linear:AMS1117-1.5 U10
U 1 1 673499E5
P 7600 850
F 0 "U10" H 7600 1092 50  0000 C CNN
F 1 "AMS1117-1.2" H 7600 1001 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-223-3_TabPin2" H 7600 1050 50  0001 C CNN
F 3 "http://www.advanced-monolithic.com/pdf/ds1117.pdf" H 7700 600 50  0001 C CNN
	1    7600 850 
	1    0    0    -1  
$EndComp
$Comp
L Device:C C10
U 1 1 6734C1AE
P 5600 1000
F 0 "C10" H 5715 1046 50  0000 L CNN
F 1 "100n" H 5715 955 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric" H 5638 850 50  0001 C CNN
F 3 "~" H 5600 1000 50  0001 C CNN
	1    5600 1000
	1    0    0    -1  
$EndComp
Connection ~ 5600 850 
Wire Wire Line
	5600 850  5850 850 
$Comp
L Device:C C9
U 1 1 67354767
P 5250 1000
F 0 "C9" H 5365 1046 50  0000 L CNN
F 1 "22u" H 5365 955 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 5288 850 50  0001 C CNN
F 3 "~" H 5250 1000 50  0001 C CNN
	1    5250 1000
	1    0    0    -1  
$EndComp
Connection ~ 5250 850 
Wire Wire Line
	5250 850  5600 850 
$Comp
L Device:C C12
U 1 1 673566A2
P 6850 1000
F 0 "C12" H 6965 1046 50  0000 L CNN
F 1 "100n" H 6965 955 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric" H 6888 850 50  0001 C CNN
F 3 "~" H 6850 1000 50  0001 C CNN
	1    6850 1000
	1    0    0    -1  
$EndComp
$Comp
L Device:C C11
U 1 1 673566A8
P 6500 1000
F 0 "C11" H 6615 1046 50  0000 L CNN
F 1 "22u" H 6615 955 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 6538 850 50  0001 C CNN
F 3 "~" H 6500 1000 50  0001 C CNN
	1    6500 1000
	1    0    0    -1  
$EndComp
Wire Wire Line
	6500 850  6450 850 
Wire Wire Line
	6500 850  6850 850 
Connection ~ 6500 850 
Connection ~ 6850 850 
Wire Wire Line
	5250 1150 5600 1150
Connection ~ 5600 1150
Wire Wire Line
	5600 1150 6150 1150
Connection ~ 6150 1150
Wire Wire Line
	6150 1150 6500 1150
Connection ~ 6500 1150
Wire Wire Line
	6500 1150 6850 1150
$Comp
L power:GND #PWR09
U 1 1 673595DC
P 6150 1150
F 0 "#PWR09" H 6150 900 50  0001 C CNN
F 1 "GND" H 6155 977 50  0000 C CNN
F 2 "" H 6150 1150 50  0001 C CNN
F 3 "" H 6150 1150 50  0001 C CNN
	1    6150 1150
	1    0    0    -1  
$EndComp
Connection ~ 4850 850 
Wire Wire Line
	4850 850  5250 850 
Wire Wire Line
	4400 850  4850 850 
$Comp
L pspice:DIODE D1
U 1 1 6735CA54
P 2600 1900
F 0 "D1" V 2646 1772 50  0000 R CNN
F 1 "MDD-M7" V 2555 1772 50  0000 R CNN
F 2 "Diode_SMD:D_SMA" H 2600 1900 50  0001 C CNN
F 3 "~" H 2600 1900 50  0001 C CNN
	1    2600 1900
	0    -1   -1   0   
$EndComp
Connection ~ 2600 2100
Wire Wire Line
	2600 2100 2950 2100
Connection ~ 2600 1700
Wire Wire Line
	2600 1700 3100 1700
$Comp
L Device:C C16
U 1 1 6735E351
P 8300 1000
F 0 "C16" H 8415 1046 50  0000 L CNN
F 1 "100n" H 8415 955 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric" H 8338 850 50  0001 C CNN
F 3 "~" H 8300 1000 50  0001 C CNN
	1    8300 1000
	1    0    0    -1  
$EndComp
$Comp
L Device:C C15
U 1 1 6735E357
P 7950 1000
F 0 "C15" H 8065 1046 50  0000 L CNN
F 1 "22u" H 8065 955 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 7988 850 50  0001 C CNN
F 3 "~" H 7950 1000 50  0001 C CNN
	1    7950 1000
	1    0    0    -1  
$EndComp
Wire Wire Line
	7600 1150 7950 1150
Connection ~ 7950 1150
Wire Wire Line
	7950 1150 8300 1150
Wire Wire Line
	7900 850  7950 850 
Connection ~ 7950 850 
Wire Wire Line
	7950 850  8300 850 
Connection ~ 8300 850 
Wire Wire Line
	8300 850  8750 850 
$Comp
L power:GND #PWR014
U 1 1 67362844
P 7600 1150
F 0 "#PWR014" H 7600 900 50  0001 C CNN
F 1 "GND" H 7605 977 50  0000 C CNN
F 2 "" H 7600 1150 50  0001 C CNN
F 3 "" H 7600 1150 50  0001 C CNN
	1    7600 1150
	1    0    0    -1  
$EndComp
Connection ~ 7600 1150
$Comp
L power:+1V2 #PWR017
U 1 1 67363D95
P 8750 850
F 0 "#PWR017" H 8750 700 50  0001 C CNN
F 1 "+1V2" H 8765 1023 50  0000 C CNN
F 2 "" H 8750 850 50  0001 C CNN
F 3 "" H 8750 850 50  0001 C CNN
	1    8750 850 
	1    0    0    -1  
$EndComp
Wire Wire Line
	6850 850  7100 850 
$Comp
L power:+3V3 #PWR010
U 1 1 6736587D
P 6850 850
F 0 "#PWR010" H 6850 700 50  0001 C CNN
F 1 "+3V3" H 6865 1023 50  0000 C CNN
F 2 "" H 6850 850 50  0001 C CNN
F 3 "" H 6850 850 50  0001 C CNN
	1    6850 850 
	1    0    0    -1  
$EndComp
$Comp
L Regulator_Linear:AMS1117-5.0 U4
U 1 1 6736CB51
P 3950 850
F 0 "U4" H 3950 1092 50  0000 C CNN
F 1 "AMS1117-5.0" H 3950 1001 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-223-3_TabPin2" H 3950 1050 50  0001 C CNN
F 3 "http://www.advanced-monolithic.com/pdf/ds1117.pdf" H 4050 600 50  0001 C CNN
	1    3950 850 
	1    0    0    -1  
$EndComp
$Comp
L Amplifier_Operational:NE5532 U7
U 1 1 6737B2F2
P 6000 4450
F 0 "U7" H 6000 4150 50  0000 C CNN
F 1 "NE5532" H 6000 4250 50  0000 C CNN
F 2 "Package_SO:SOIC-8-1EP_3.9x4.9mm_P1.27mm_EP2.29x3mm" H 6000 4450 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/ne5532.pdf" H 6000 4450 50  0001 C CNN
	1    6000 4450
	1    0    0    1   
$EndComp
$Comp
L Amplifier_Operational:NE5532 U7
U 2 1 6737DDC5
P 7500 4150
F 0 "U7" H 7500 4517 50  0000 C CNN
F 1 "NE5532" H 7500 4426 50  0000 C CNN
F 2 "Package_SO:SOIC-8-1EP_3.9x4.9mm_P1.27mm_EP2.29x3mm" H 7500 4150 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/ne5532.pdf" H 7500 4150 50  0001 C CNN
	2    7500 4150
	1    0    0    1   
$EndComp
$Comp
L Amplifier_Operational:NE5532 U7
U 3 1 673810D3
P 5500 2450
F 0 "U7" H 5458 2496 50  0000 L CNN
F 1 "NE5532" H 5458 2405 50  0000 L CNN
F 2 "Package_SO:SOIC-8-1EP_3.9x4.9mm_P1.27mm_EP2.29x3mm" H 5500 2450 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/ne5532.pdf" H 5500 2450 50  0001 C CNN
	3    5500 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	3400 1150 3950 1150
Wire Wire Line
	3400 850  3650 850 
Wire Wire Line
	5100 3100 5400 3100
Wire Wire Line
	5400 3100 5400 2750
Wire Wire Line
	5050 1700 5400 1700
Wire Wire Line
	5400 2150 5400 1700
Connection ~ 5100 3100
Text Label 1850 1600 0    50   ~ 0
Brl_J
Text Label 2150 2100 0    50   ~ 0
GND
Text Label 5050 2050 2    50   ~ 0
PWR_LED
NoConn ~ 2400 1500
Connection ~ 3400 850 
Wire Wire Line
	3100 850  3400 850 
Wire Wire Line
	3100 1700 3100 850 
Wire Wire Line
	2450 4750 2800 4750
Wire Wire Line
	2800 4850 2450 4850
Wire Wire Line
	2450 4950 2800 4950
Wire Wire Line
	2800 5050 2450 5050
Wire Wire Line
	2450 4450 2800 4450
Wire Wire Line
	2800 4550 2450 4550
$Comp
L power:+3.3V #PWR011
U 1 1 674D5BB5
P 7100 850
F 0 "#PWR011" H 7100 700 50  0001 C CNN
F 1 "+3.3V" H 7115 1023 50  0000 C CNN
F 2 "" H 7100 850 50  0001 C CNN
F 3 "" H 7100 850 50  0001 C CNN
	1    7100 850 
	1    0    0    -1  
$EndComp
Connection ~ 7100 850 
Wire Wire Line
	7100 850  7300 850 
$Comp
L Device:R_POT RV?
U 1 1 6AF22554
P 8150 4350
AR Path="/672F9148/6AF22554" Ref="RV?"  Part="1" 
AR Path="/6AF22554" Ref="RV1"  Part="1" 
F 0 "RV1" H 8050 4300 50  0000 R CNN
F 1 "R_ATT_1" H 8050 4400 50  0000 R CNN
F 2 "Potentiometer_THT:Potentiometer_Alpha_RD901F-40-00D_Single_Vertical" H 8150 4350 50  0001 C CNN
F 3 "~" H 8150 4350 50  0001 C CNN
	1    8150 4350
	1    0    0    1   
$EndComp
$Comp
L power:GND #PWR015
U 1 1 6AF25230
P 8150 4550
F 0 "#PWR015" H 8150 4300 50  0001 C CNN
F 1 "GND" H 8155 4377 50  0000 C CNN
F 2 "" H 8150 4550 50  0001 C CNN
F 3 "" H 8150 4550 50  0001 C CNN
	1    8150 4550
	1    0    0    -1  
$EndComp
Wire Wire Line
	8150 4550 8150 4500
Wire Wire Line
	7800 4150 8150 4150
Wire Wire Line
	8150 4150 8150 4200
$Comp
L Device:R R?
U 1 1 6AF4897D
P 7300 3750
AR Path="/672F9148/6AF4897D" Ref="R?"  Part="1" 
AR Path="/6AF4897D" Ref="R6"  Part="1" 
F 0 "R6" V 7400 3700 50  0000 L CNN
F 1 "10k" V 7200 3700 50  0000 L CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 7230 3750 50  0001 C CNN
F 3 "~" H 7300 3750 50  0001 C CNN
	1    7300 3750
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R?
U 1 1 6AF4A69C
P 7600 3750
AR Path="/672F9148/6AF4A69C" Ref="R?"  Part="1" 
AR Path="/6AF4A69C" Ref="R8"  Part="1" 
F 0 "R8" V 7700 3700 50  0000 L CNN
F 1 "10k" V 7500 3700 50  0000 L CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 7530 3750 50  0001 C CNN
F 3 "~" H 7600 3750 50  0001 C CNN
	1    7600 3750
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7750 3750 7800 3750
Wire Wire Line
	7800 3750 7800 4150
Connection ~ 7800 4150
Wire Wire Line
	7100 4050 7100 3750
Wire Wire Line
	7100 3750 7150 3750
Wire Wire Line
	7100 4050 7200 4050
Wire Wire Line
	7200 4250 7100 4250
$Comp
L Device:R R?
U 1 1 6AF57096
P 6850 4050
AR Path="/672F9148/6AF57096" Ref="R?"  Part="1" 
AR Path="/6AF57096" Ref="R4"  Part="1" 
F 0 "R4" V 6950 4000 50  0000 L CNN
F 1 "10k" V 6750 4000 50  0000 L CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 6780 4050 50  0001 C CNN
F 3 "~" H 6850 4050 50  0001 C CNN
	1    6850 4050
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7000 4050 7100 4050
Connection ~ 7100 4050
Wire Wire Line
	7100 4250 7100 4550
$Comp
L power:GND #PWR012
U 1 1 6AF7D5EA
P 7100 4550
F 0 "#PWR012" H 7100 4300 50  0001 C CNN
F 1 "GND" H 7105 4377 50  0000 C CNN
F 2 "" H 7100 4550 50  0001 C CNN
F 3 "" H 7100 4550 50  0001 C CNN
	1    7100 4550
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 6AF91265
P 4950 5500
AR Path="/672F9148/6AF91265" Ref="R?"  Part="1" 
AR Path="/6AF91265" Ref="R1"  Part="1" 
F 0 "R1" H 5050 5550 50  0000 L CNN
F 1 "10k" H 5050 5450 50  0000 L CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 4880 5500 50  0001 C CNN
F 3 "~" H 4950 5500 50  0001 C CNN
	1    4950 5500
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 6AF9478D
P 5250 5500
AR Path="/672F9148/6AF9478D" Ref="R?"  Part="1" 
AR Path="/6AF9478D" Ref="R3"  Part="1" 
F 0 "R3" H 5350 5550 50  0000 L CNN
F 1 "10k" H 5350 5450 50  0000 L CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 5180 5500 50  0001 C CNN
F 3 "~" H 5250 5500 50  0001 C CNN
	1    5250 5500
	1    0    0    -1  
$EndComp
$Comp
L Device:C C7
U 1 1 6AF96DA5
P 4650 4550
F 0 "C7" V 4500 4500 50  0000 L CNN
F 1 "4.7u" V 4800 4450 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 4688 4400 50  0001 C CNN
F 3 "~" H 4650 4550 50  0001 C CNN
	1    4650 4550
	0    1    1    0   
$EndComp
$Comp
L Device:C C8
U 1 1 6AF9A279
P 4650 5000
F 0 "C8" V 4500 4950 50  0000 L CNN
F 1 "4.7u" V 4800 4900 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 4688 4850 50  0001 C CNN
F 3 "~" H 4650 5000 50  0001 C CNN
	1    4650 5000
	0    1    1    0   
$EndComp
Wire Wire Line
	4300 5000 4500 5000
Wire Wire Line
	5250 5000 5250 5350
Wire Wire Line
	4800 5000 5250 5000
Wire Wire Line
	4800 4550 4950 4550
Wire Wire Line
	4950 4550 4950 5350
$Comp
L Amplifier_Operational:NE5532 U8
U 1 1 6AFBDFDE
P 6000 5100
F 0 "U8" H 6000 4900 50  0000 C CNN
F 1 "NE5532" H 6000 4800 50  0000 C CNN
F 2 "" H 6000 5100 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/ne5532.pdf" H 6000 5100 50  0001 C CNN
	1    6000 5100
	1    0    0    -1  
$EndComp
$Comp
L Amplifier_Operational:NE5532 U8
U 3 1 6AFC3567
P 5950 2450
F 0 "U8" H 5908 2496 50  0000 L CNN
F 1 "NE5532" H 5908 2405 50  0000 L CNN
F 2 "" H 5950 2450 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/ne5532.pdf" H 5950 2450 50  0001 C CNN
	3    5950 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	5400 3100 5850 3100
Wire Wire Line
	5850 3100 5850 2750
Connection ~ 5400 3100
Wire Wire Line
	5400 1700 5850 1700
Wire Wire Line
	5850 1700 5850 2150
Connection ~ 5400 1700
Connection ~ 5250 5000
Wire Wire Line
	5250 5000 5700 5000
Wire Wire Line
	4950 4550 5700 4550
Connection ~ 4950 4550
Wire Wire Line
	5700 5200 5650 5200
Wire Wire Line
	5650 5200 5650 5500
Wire Wire Line
	5650 5500 6300 5500
Wire Wire Line
	6300 5500 6300 5100
Wire Wire Line
	5700 4350 5650 4350
Wire Wire Line
	5650 4350 5650 4050
Wire Wire Line
	5650 4050 6300 4050
Wire Wire Line
	6300 4050 6300 4450
$Comp
L power:GND #PWR05
U 1 1 6B00BE59
P 4950 5650
F 0 "#PWR05" H 4950 5400 50  0001 C CNN
F 1 "GND" H 4955 5477 50  0000 C CNN
F 2 "" H 4950 5650 50  0001 C CNN
F 3 "" H 4950 5650 50  0001 C CNN
	1    4950 5650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR08
U 1 1 6B00C4BB
P 5250 5650
F 0 "#PWR08" H 5250 5400 50  0001 C CNN
F 1 "GND" H 5255 5477 50  0000 C CNN
F 2 "" H 5250 5650 50  0001 C CNN
F 3 "" H 5250 5650 50  0001 C CNN
	1    5250 5650
	1    0    0    -1  
$EndComp
$Comp
L Amplifier_Operational:NE5532 U8
U 2 1 6B0157E3
P 7500 5600
F 0 "U8" H 7500 5967 50  0000 C CNN
F 1 "NE5532" H 7500 5876 50  0000 C CNN
F 2 "Package_SO:SOIC-8-1EP_3.9x4.9mm_P1.27mm_EP2.29x3mm" H 7500 5600 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/ne5532.pdf" H 7500 5600 50  0001 C CNN
	2    7500 5600
	1    0    0    1   
$EndComp
$Comp
L Device:R_POT RV?
U 1 1 6B0157E9
P 8150 5800
AR Path="/672F9148/6B0157E9" Ref="RV?"  Part="1" 
AR Path="/6B0157E9" Ref="RV2"  Part="1" 
F 0 "RV2" H 8050 5750 50  0000 R CNN
F 1 "R_ATT_2" H 8050 5850 50  0000 R CNN
F 2 "Potentiometer_THT:Potentiometer_Alpha_RD901F-40-00D_Single_Vertical" H 8150 5800 50  0001 C CNN
F 3 "~" H 8150 5800 50  0001 C CNN
	1    8150 5800
	1    0    0    1   
$EndComp
$Comp
L power:GND #PWR016
U 1 1 6B0157EF
P 8150 6000
F 0 "#PWR016" H 8150 5750 50  0001 C CNN
F 1 "GND" H 8155 5827 50  0000 C CNN
F 2 "" H 8150 6000 50  0001 C CNN
F 3 "" H 8150 6000 50  0001 C CNN
	1    8150 6000
	1    0    0    -1  
$EndComp
Wire Wire Line
	8150 6000 8150 5950
Wire Wire Line
	7800 5600 8150 5600
Wire Wire Line
	8150 5600 8150 5650
$Comp
L Device:R R?
U 1 1 6B0157F8
P 7300 5200
AR Path="/672F9148/6B0157F8" Ref="R?"  Part="1" 
AR Path="/6B0157F8" Ref="R7"  Part="1" 
F 0 "R7" V 7400 5150 50  0000 L CNN
F 1 "10k" V 7200 5150 50  0000 L CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 7230 5200 50  0001 C CNN
F 3 "~" H 7300 5200 50  0001 C CNN
	1    7300 5200
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R?
U 1 1 6B0157FE
P 7600 5200
AR Path="/672F9148/6B0157FE" Ref="R?"  Part="1" 
AR Path="/6B0157FE" Ref="R9"  Part="1" 
F 0 "R9" V 7700 5150 50  0000 L CNN
F 1 "10k" V 7500 5150 50  0000 L CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 7530 5200 50  0001 C CNN
F 3 "~" H 7600 5200 50  0001 C CNN
	1    7600 5200
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7750 5200 7800 5200
Wire Wire Line
	7800 5200 7800 5600
Connection ~ 7800 5600
Wire Wire Line
	7100 5500 7100 5200
Wire Wire Line
	7100 5200 7150 5200
Wire Wire Line
	7100 5500 7200 5500
Wire Wire Line
	7200 5700 7100 5700
$Comp
L Device:R R?
U 1 1 6B01580B
P 6850 5500
AR Path="/672F9148/6B01580B" Ref="R?"  Part="1" 
AR Path="/6B01580B" Ref="R5"  Part="1" 
F 0 "R5" V 6950 5450 50  0000 L CNN
F 1 "10k" V 6750 5450 50  0000 L CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 6780 5500 50  0001 C CNN
F 3 "~" H 6850 5500 50  0001 C CNN
	1    6850 5500
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7000 5500 7100 5500
Connection ~ 7100 5500
Wire Wire Line
	7100 5700 7100 6000
$Comp
L power:GND #PWR013
U 1 1 6B015814
P 7100 6000
F 0 "#PWR013" H 7100 5750 50  0001 C CNN
F 1 "GND" H 7105 5827 50  0000 C CNN
F 2 "" H 7100 6000 50  0001 C CNN
F 3 "" H 7100 6000 50  0001 C CNN
	1    7100 6000
	1    0    0    -1  
$EndComp
Wire Wire Line
	6300 4050 6700 4050
Connection ~ 6300 4050
Wire Wire Line
	6300 5500 6700 5500
Connection ~ 6300 5500
$Comp
L Device:C C13
U 1 1 6B03D8F3
P 7450 3400
F 0 "C13" V 7300 3350 50  0000 L CNN
F 1 "470p" V 7600 3300 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 7488 3250 50  0001 C CNN
F 3 "~" H 7450 3400 50  0001 C CNN
	1    7450 3400
	0    1    1    0   
$EndComp
$Comp
L Device:C C14
U 1 1 6B03E1CD
P 7450 4850
F 0 "C14" V 7300 4800 50  0000 L CNN
F 1 "470p" V 7600 4750 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 7488 4700 50  0001 C CNN
F 3 "~" H 7450 4850 50  0001 C CNN
	1    7450 4850
	0    1    1    0   
$EndComp
Wire Wire Line
	7100 3750 7100 3400
Wire Wire Line
	7100 3400 7300 3400
Wire Wire Line
	7800 3400 7800 3750
Wire Wire Line
	7600 3400 7800 3400
Connection ~ 7100 3750
Connection ~ 7800 3750
Wire Wire Line
	7100 5200 7100 4850
Wire Wire Line
	7100 4850 7300 4850
Wire Wire Line
	7800 4850 7800 5200
Wire Wire Line
	7600 4850 7800 4850
Connection ~ 7100 5200
Connection ~ 7800 5200
Text Label 5000 4550 0    50   ~ 0
HPF_A
Text Label 5000 5000 0    50   ~ 0
HPF_B
Text Label 6350 4050 0    50   ~ 0
S_IN_A
Text Label 6350 5500 0    50   ~ 0
S_IN_B
Text Label 7100 3700 1    50   ~ 0
OP_A-
Text Label 7100 5150 1    50   ~ 0
OP_B-
Text Label 7850 4150 0    50   ~ 0
OP_A_OUT
Text Label 7850 5600 0    50   ~ 0
OP_B_OUT
Text Label 8400 4350 0    50   ~ 0
AUDIO_OUT_A
Text Label 8400 5800 0    50   ~ 0
AUDIO_OUT_B
$Comp
L Connector:AudioJack2_Dual_Ground_Switch J2
U 1 1 6B06F6E4
P 9350 4450
F 0 "J2" H 9120 4468 50  0000 R CNN
F 1 "AUDIO_OUT_A" H 9120 4377 50  0000 R CNN
F 2 "DM-OLED096-636:PJ-307" H 9300 4650 50  0001 C CNN
F 3 "~" H 9300 4650 50  0001 C CNN
	1    9350 4450
	-1   0    0    -1  
$EndComp
$Comp
L power:GND #PWR018
U 1 1 6B075561
P 9350 4750
F 0 "#PWR018" H 9350 4500 50  0001 C CNN
F 1 "GND" H 9355 4577 50  0000 C CNN
F 2 "" H 9350 4750 50  0001 C CNN
F 3 "" H 9350 4750 50  0001 C CNN
	1    9350 4750
	1    0    0    -1  
$EndComp
Wire Wire Line
	9150 4450 9050 4450
Wire Wire Line
	9050 4450 9050 4350
Wire Wire Line
	9050 4250 9150 4250
Wire Wire Line
	8300 4350 9050 4350
Connection ~ 9050 4350
Wire Wire Line
	9050 4350 9050 4250
NoConn ~ 9150 4350
NoConn ~ 9150 4550
$Comp
L Connector:AudioJack2_Dual_Ground_Switch J3
U 1 1 6B0968DD
P 9350 5900
F 0 "J3" H 9120 5918 50  0000 R CNN
F 1 "AUDIO_OUT_B" H 9120 5827 50  0000 R CNN
F 2 "DM-OLED096-636:PJ-307" H 9300 6100 50  0001 C CNN
F 3 "~" H 9300 6100 50  0001 C CNN
	1    9350 5900
	-1   0    0    -1  
$EndComp
$Comp
L power:GND #PWR019
U 1 1 6B0968E3
P 9350 6200
F 0 "#PWR019" H 9350 5950 50  0001 C CNN
F 1 "GND" H 9355 6027 50  0000 C CNN
F 2 "" H 9350 6200 50  0001 C CNN
F 3 "" H 9350 6200 50  0001 C CNN
	1    9350 6200
	1    0    0    -1  
$EndComp
Wire Wire Line
	9150 5900 9050 5900
Wire Wire Line
	9050 5700 9150 5700
NoConn ~ 9150 5800
NoConn ~ 9150 6000
Wire Wire Line
	9050 5700 9050 5800
Wire Wire Line
	8300 5800 9050 5800
Connection ~ 9050 5800
Wire Wire Line
	9050 5800 9050 5900
$Comp
L Connector:Conn_01x02_Male J?
U 1 1 673BEDD1
P 4600 4100
AR Path="/672FE139/673BEDD1" Ref="J?"  Part="1" 
AR Path="/673BEDD1" Ref="J17"  Part="1" 
F 0 "J17" V 4450 4100 50  0000 R CNN
F 1 "DAC_OUT_A" V 4550 4250 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 4600 4100 50  0001 C CNN
F 3 "~" H 4600 4100 50  0001 C CNN
	1    4600 4100
	0    -1   1    0   
$EndComp
$Comp
L Connector:Conn_01x02_Male J?
U 1 1 673D4C24
P 4600 5400
AR Path="/672FE139/673D4C24" Ref="J?"  Part="1" 
AR Path="/673D4C24" Ref="J18"  Part="1" 
F 0 "J18" V 4450 5400 50  0000 R CNN
F 1 "DAC_OUT_B" V 4550 5550 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 4600 5400 50  0001 C CNN
F 3 "~" H 4600 5400 50  0001 C CNN
	1    4600 5400
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4700 5200 4800 5200
Wire Wire Line
	4800 5200 4800 5000
Connection ~ 4800 5000
Wire Wire Line
	4600 5200 4500 5200
Wire Wire Line
	4500 5200 4500 5000
Connection ~ 4500 5000
Wire Wire Line
	4300 4550 4500 4550
Wire Wire Line
	4500 4550 4500 4300
Wire Wire Line
	4500 4300 4600 4300
Connection ~ 4500 4550
Wire Wire Line
	4700 4300 4800 4300
Wire Wire Line
	4800 4300 4800 4550
Connection ~ 4800 4550
Text Label 4400 4550 1    50   ~ 0
DAC_OUT_A
Text Label 4400 5000 3    50   ~ 0
DAC_OUT_B
$Comp
L Connector_Generic:Conn_02x06_Odd_Even J19
U 1 1 674050EC
P 7450 2050
F 0 "J19" H 7500 2467 50  0000 C CNN
F 1 "PWR_conn" H 7500 2376 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x06_P2.54mm_Vertical" H 7450 2050 50  0001 C CNN
F 3 "~" H 7450 2050 50  0001 C CNN
	1    7450 2050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 67406B39
P 7200 2400
F 0 "#PWR0101" H 7200 2150 50  0001 C CNN
F 1 "GND" H 7205 2227 50  0000 C CNN
F 2 "" H 7200 2400 50  0001 C CNN
F 3 "" H 7200 2400 50  0001 C CNN
	1    7200 2400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 67407183
P 7800 2400
F 0 "#PWR0102" H 7800 2150 50  0001 C CNN
F 1 "GND" H 7805 2227 50  0000 C CNN
F 2 "" H 7800 2400 50  0001 C CNN
F 3 "" H 7800 2400 50  0001 C CNN
	1    7800 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	7200 2400 7200 1850
Wire Wire Line
	7200 1850 7250 1850
Wire Wire Line
	7800 1850 7750 1850
$Comp
L power:+1V2 #PWR0103
U 1 1 674135F4
P 7100 1950
F 0 "#PWR0103" H 7100 1800 50  0001 C CNN
F 1 "+1V2" V 7100 2200 50  0000 C CNN
F 2 "" H 7100 1950 50  0001 C CNN
F 3 "" H 7100 1950 50  0001 C CNN
	1    7100 1950
	0    -1   -1   0   
$EndComp
$Comp
L power:+1V2 #PWR0104
U 1 1 6741451A
P 7900 1950
F 0 "#PWR0104" H 7900 1800 50  0001 C CNN
F 1 "+1V2" V 7900 2200 50  0000 C CNN
F 2 "" H 7900 1950 50  0001 C CNN
F 3 "" H 7900 1950 50  0001 C CNN
	1    7900 1950
	0    1    1    0   
$EndComp
Wire Wire Line
	7250 1950 7100 1950
Wire Wire Line
	7750 1950 7900 1950
$Comp
L power:+3.3V #PWR0105
U 1 1 67421175
P 7100 2050
F 0 "#PWR0105" H 7100 1900 50  0001 C CNN
F 1 "+3.3V" V 7100 2300 50  0000 C CNN
F 2 "" H 7100 2050 50  0001 C CNN
F 3 "" H 7100 2050 50  0001 C CNN
	1    7100 2050
	0    -1   -1   0   
$EndComp
$Comp
L power:+3.3V #PWR0106
U 1 1 67421B9E
P 7900 2050
F 0 "#PWR0106" H 7900 1900 50  0001 C CNN
F 1 "+3.3V" V 7900 2300 50  0000 C CNN
F 2 "" H 7900 2050 50  0001 C CNN
F 3 "" H 7900 2050 50  0001 C CNN
	1    7900 2050
	0    1    1    0   
$EndComp
Wire Wire Line
	7100 2050 7250 2050
Wire Wire Line
	7750 2050 7900 2050
$Comp
L power:+5V #PWR0107
U 1 1 67430D85
P 7100 2150
F 0 "#PWR0107" H 7100 2000 50  0001 C CNN
F 1 "+5V" V 7100 2350 50  0000 C CNN
F 2 "" H 7100 2150 50  0001 C CNN
F 3 "" H 7100 2150 50  0001 C CNN
	1    7100 2150
	0    -1   -1   0   
$EndComp
$Comp
L power:+5V #PWR0108
U 1 1 67431C96
P 7900 2150
F 0 "#PWR0108" H 7900 2000 50  0001 C CNN
F 1 "+5V" V 7900 2350 50  0000 C CNN
F 2 "" H 7900 2150 50  0001 C CNN
F 3 "" H 7900 2150 50  0001 C CNN
	1    7900 2150
	0    1    -1   0   
$EndComp
Wire Wire Line
	7750 2150 7900 2150
Wire Wire Line
	7100 2150 7250 2150
$Comp
L power:+12V #PWR0109
U 1 1 6743F79E
P 7100 2250
F 0 "#PWR0109" H 7100 2100 50  0001 C CNN
F 1 "+12V" V 7100 2450 50  0000 C CNN
F 2 "" H 7100 2250 50  0001 C CNN
F 3 "" H 7100 2250 50  0001 C CNN
	1    7100 2250
	0    -1   -1   0   
$EndComp
$Comp
L power:+12V #PWR0110
U 1 1 674405D3
P 7900 2250
F 0 "#PWR0110" H 7900 2100 50  0001 C CNN
F 1 "+12V" V 7900 2450 50  0000 C CNN
F 2 "" H 7900 2250 50  0001 C CNN
F 3 "" H 7900 2250 50  0001 C CNN
	1    7900 2250
	0    1    1    0   
$EndComp
Wire Wire Line
	7800 1850 7800 2400
Wire Wire Line
	7900 2250 7750 2250
Wire Wire Line
	7250 2250 7100 2250
$Comp
L power:-12V #PWR0111
U 1 1 6745563C
P 7100 2350
F 0 "#PWR0111" H 7100 2450 50  0001 C CNN
F 1 "-12V" V 7100 2550 50  0000 C CNN
F 2 "" H 7100 2350 50  0001 C CNN
F 3 "" H 7100 2350 50  0001 C CNN
	1    7100 2350
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7100 2350 7250 2350
Wire Wire Line
	7750 2350 7900 2350
$Comp
L power:-12V #PWR0112
U 1 1 67463A02
P 7900 2350
F 0 "#PWR0112" H 7900 2450 50  0001 C CNN
F 1 "-12V" V 7900 2550 50  0000 C CNN
F 2 "" H 7900 2350 50  0001 C CNN
F 3 "" H 7900 2350 50  0001 C CNN
	1    7900 2350
	0    1    -1   0   
$EndComp
$EndSCHEMATC
