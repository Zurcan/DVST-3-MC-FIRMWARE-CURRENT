
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega168P
;Program type             : Application
;Clock frequency          : 0,460800 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega168P
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1279
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x04FF
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rxEnable=R4
	.DEF _txEnable=R3
	.DEF _calibration_point1=R5
	.DEF _calibration_point2=R7
	.DEF _rangeIndex=R10
	.DEF _tmp_calibration=R11
	.DEF _crc=R13
	.DEF _dataToSave=R9

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  _spi_isr
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  _adc_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_Parameter_mask:
	.DB  0x0,0x1,0x2,0x3,0x4,0x5,0x6,0x7
	.DB  0x8,0x9,0xC,0xD,0x11,0x15,0x19,0x1A
	.DB  0x20,0x38,0x44,0x47,0x4A,0x4E,0x52,0x56
	.DB  0x57,0x58,0x5C,0x60,0x61,0x62,0x65,0x69
	.DB  0x6D,0x71,0x75,0x7B,0x86,0x87,0x88,0x89
_Command_mask:
	.DB  0x26,0x1,0x2,0x3,0x4,0x5,0x6,0x7
	.DB  0x8,0x9,0x9,0x9,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0xA,0xB,0xB,0xB,0xB,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0xC,0xC,0xC,0xC,0xD,0xD
	.DB  0xD,0xD,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0xC,0xC,0xC,0xC,0xA
	.DB  0xD,0xD,0xD,0xD,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0xE,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x26,0x1,0x2
	.DB  0x3,0x4,0x5,0x6,0x7,0x8,0x9,0x9
	.DB  0x9,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x10,0x10
	.DB  0x10,0x10,0x10,0x10,0x10,0x10,0x10,0x10
	.DB  0x10,0x10,0x10,0x10,0x10,0x10,0x10,0x10
	.DB  0x10,0x10,0x10,0x10,0x10,0x10,0x0,0xF
	.DB  0xF,0xF,0xF,0xF,0xF,0x11,0x11,0x11
	.DB  0x11,0x11,0x11,0x11,0x11,0x11,0x11,0x11
	.DB  0x11,0x12,0x12,0x12,0x0,0x0,0x0,0x0
	.DB  0x13,0x13,0x13,0xA,0x14,0x14,0x14,0x14
	.DB  0x15,0x15,0x15,0x15,0x16,0x16,0x16,0x16
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x17,0x18,0xA,0x19,0x19,0x19,0x19
	.DB  0x1A,0x1A,0x1A,0x1A,0x27,0x27,0x27,0x27
	.DB  0x1B,0x1C,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1D,0x1D,0x1D,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x10,0x10,0x10,0x10,0x10
	.DB  0x10,0x10,0x10,0x10,0x10,0x10,0x10,0x10
	.DB  0x10,0x10,0x10,0x10,0x10,0x10,0x10,0x10
	.DB  0x10,0x10,0x10,0x0,0xF,0xF,0xF,0xF
	.DB  0xF,0xF,0x11,0x11,0x11,0x11,0x11,0x11
	.DB  0x11,0x11,0x11,0x11,0x11,0x11,0x12,0x12
	.DB  0x12,0x0,0x0,0x0,0x0,0x1D,0x1D,0x1D
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0xA,0x19
	.DB  0x19,0x19,0x19,0x1A,0x1A,0x1A,0x1A,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1E,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0xA,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x1F
	.DB  0x1F,0x1F,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x20,0x20,0x20,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x21,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x22,0x22,0x22,0x22,0x22,0x22
	.DB  0x27,0x27,0x27,0x27,0x27,0x27,0x27,0x27
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x0,0x13,0x13,0x13,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x3,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x24,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x25,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0
_Command_number:
	.DB  0x0,0x1,0x2,0x3,0x6,0xB,0xC,0xD
	.DB  0xE,0xF,0x10,0x11,0x12,0x13,0x23,0x24
	.DB  0x25,0x26,0x28,0x29,0x2A,0x2B,0x2C,0x2D
	.DB  0x2E,0x2F,0x30,0x31,0x3B,0x6C,0x6D,0x0
	.DB  0x0,0x0,0x0,0x1,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x1,0x1,0x1,0x1,0x1
	.DB  0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1
	.DB  0x1,0x0,0x1,0x1,0x1,0x1,0x0,0x1
	.DB  0x1,0x1,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x1,0x1
_crctable:
	.DB  0x0,0x0,0xC0,0xC1,0xC1,0x81,0x1,0x40
	.DB  0xC3,0x1,0x3,0xC0,0x2,0x80,0xC2,0x41
	.DB  0xC6,0x1,0x6,0xC0,0x7,0x80,0xC7,0x41
	.DB  0x5,0x0,0xC5,0xC1,0xC4,0x81,0x4,0x40
	.DB  0xCC,0x1,0xC,0xC0,0xD,0x80,0xCD,0x41
	.DB  0xF,0x0,0xCF,0xC1,0xCE,0x81,0xE,0x40
	.DB  0xA,0x0,0xCA,0xC1,0xCB,0x81,0xB,0x40
	.DB  0xC9,0x1,0x9,0xC0,0x8,0x80,0xC8,0x41
	.DB  0xD8,0x1,0x18,0xC0,0x19,0x80,0xD9,0x41
	.DB  0x1B,0x0,0xDB,0xC1,0xDA,0x81,0x1A,0x40
	.DB  0x1E,0x0,0xDE,0xC1,0xDF,0x81,0x1F,0x40
	.DB  0xDD,0x1,0x1D,0xC0,0x1C,0x80,0xDC,0x41
	.DB  0x14,0x0,0xD4,0xC1,0xD5,0x81,0x15,0x40
	.DB  0xD7,0x1,0x17,0xC0,0x16,0x80,0xD6,0x41
	.DB  0xD2,0x1,0x12,0xC0,0x13,0x80,0xD3,0x41
	.DB  0x11,0x0,0xD1,0xC1,0xD0,0x81,0x10,0x40
	.DB  0xF0,0x1,0x30,0xC0,0x31,0x80,0xF1,0x41
	.DB  0x33,0x0,0xF3,0xC1,0xF2,0x81,0x32,0x40
	.DB  0x36,0x0,0xF6,0xC1,0xF7,0x81,0x37,0x40
	.DB  0xF5,0x1,0x35,0xC0,0x34,0x80,0xF4,0x41
	.DB  0x3C,0x0,0xFC,0xC1,0xFD,0x81,0x3D,0x40
	.DB  0xFF,0x1,0x3F,0xC0,0x3E,0x80,0xFE,0x41
	.DB  0xFA,0x1,0x3A,0xC0,0x3B,0x80,0xFB,0x41
	.DB  0x39,0x0,0xF9,0xC1,0xF8,0x81,0x38,0x40
	.DB  0x28,0x0,0xE8,0xC1,0xE9,0x81,0x29,0x40
	.DB  0xEB,0x1,0x2B,0xC0,0x2A,0x80,0xEA,0x41
	.DB  0xEE,0x1,0x2E,0xC0,0x2F,0x80,0xEF,0x41
	.DB  0x2D,0x0,0xED,0xC1,0xEC,0x81,0x2C,0x40
	.DB  0xE4,0x1,0x24,0xC0,0x25,0x80,0xE5,0x41
	.DB  0x27,0x0,0xE7,0xC1,0xE6,0x81,0x26,0x40
	.DB  0x22,0x0,0xE2,0xC1,0xE3,0x81,0x23,0x40
	.DB  0xE1,0x1,0x21,0xC0,0x20,0x80,0xE0,0x41
	.DB  0xA0,0x1,0x60,0xC0,0x61,0x80,0xA1,0x41
	.DB  0x63,0x0,0xA3,0xC1,0xA2,0x81,0x62,0x40
	.DB  0x66,0x0,0xA6,0xC1,0xA7,0x81,0x67,0x40
	.DB  0xA5,0x1,0x65,0xC0,0x64,0x80,0xA4,0x41
	.DB  0x6C,0x0,0xAC,0xC1,0xAD,0x81,0x6D,0x40
	.DB  0xAF,0x1,0x6F,0xC0,0x6E,0x80,0xAE,0x41
	.DB  0xAA,0x1,0x6A,0xC0,0x6B,0x80,0xAB,0x41
	.DB  0x69,0x0,0xA9,0xC1,0xA8,0x81,0x68,0x40
	.DB  0x78,0x0,0xB8,0xC1,0xB9,0x81,0x79,0x40
	.DB  0xBB,0x1,0x7B,0xC0,0x7A,0x80,0xBA,0x41
	.DB  0xBE,0x1,0x7E,0xC0,0x7F,0x80,0xBF,0x41
	.DB  0x7D,0x0,0xBD,0xC1,0xBC,0x81,0x7C,0x40
	.DB  0xB4,0x1,0x74,0xC0,0x75,0x80,0xB5,0x41
	.DB  0x77,0x0,0xB7,0xC1,0xB6,0x81,0x76,0x40
	.DB  0x72,0x0,0xB2,0xC1,0xB3,0x81,0x73,0x40
	.DB  0xB1,0x1,0x71,0xC0,0x70,0x80,0xB0,0x41
	.DB  0x50,0x0,0x90,0xC1,0x91,0x81,0x51,0x40
	.DB  0x93,0x1,0x53,0xC0,0x52,0x80,0x92,0x41
	.DB  0x96,0x1,0x56,0xC0,0x57,0x80,0x97,0x41
	.DB  0x55,0x0,0x95,0xC1,0x94,0x81,0x54,0x40
	.DB  0x9C,0x1,0x5C,0xC0,0x5D,0x80,0x9D,0x41
	.DB  0x5F,0x0,0x9F,0xC1,0x9E,0x81,0x5E,0x40
	.DB  0x5A,0x0,0x9A,0xC1,0x9B,0x81,0x5B,0x40
	.DB  0x99,0x1,0x59,0xC0,0x58,0x80,0x98,0x41
	.DB  0x88,0x1,0x48,0xC0,0x49,0x80,0x89,0x41
	.DB  0x4B,0x0,0x8B,0xC1,0x8A,0x81,0x4A,0x40
	.DB  0x4E,0x0,0x8E,0xC1,0x8F,0x81,0x4F,0x40
	.DB  0x8D,0x1,0x4D,0xC0,0x4C,0x80,0x8C,0x41
	.DB  0x44,0x0,0x84,0xC1,0x85,0x81,0x45,0x40
	.DB  0x87,0x1,0x47,0xC0,0x46,0x80,0x86,0x41
	.DB  0x82,0x1,0x42,0xC0,0x43,0x80,0x83,0x41
	.DB  0x41,0x0,0x81,0xC1,0x80,0x81,0x40,0x40

_0x3:
	.DB  0x0,0x0,0x80,0x3F
_0x4:
	.DB  0x1
_0x5:
	.DB  0x2
_0x6:
	.DB  0x1
_0x7:
	.DB  0x5
_0x123:
	.DB  0x1,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _SPI_tEnd
	.DW  _0x6*2

	.DW  0x01
	.DW  _preambula_bytes
	.DW  _0x7*2

	.DW  0x02
	.DW  0x03
	.DW  _0x123*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x200

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.03.4 Standard
;Automatic Program Generator
;© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 29.07.2010
;Author  :
;Company :
;Comments:
;
;
;Chip type           : ATmega168P
;Program type        : Application
;Clock frequency     : 1 MHz
;Memory model        : Small
;External RAM size   : 0
;Data Stack size     : 256
;*****************************************************/
;
;//#include <mega168.h>
;
;#include <delay.h>
;
;//#include <stdio.h>
;
;#include <data_arrays.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;
;//#include <stdlib.h>
;#include <math.h>
;//#include <data_arrays.c>
;
;
;char rxEnable=0, txEnable=1;
;
;
;
;
;#define RXB8 1
;#define TXB8 0
;#define UPE 2
;#define OVR 3
;#define FE 4
;#define UDRE 5
;#define RXC 7
;//#define disable_uart UCSR0B=0xc0
;//#define enable_uart UCSR0B=0xd8
;//#define disable_uart UCSR0B=0x00
;//#define enable_uart UCSR0B=0x18
;//#define enable_transmit UCSR0B=0x08
;//#define enable_recieve UCSR0B=0x10
;#define alarm3_75mA 0x3c00
;#define alarm22mA 0x6000
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<OVR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define RxEn UCSR0B=(UCSR0B&0xc0)|0x10
;#define TxEn UCSR0B=(UCSR0B&0xc0)|0x08
;#define Transmit PORTD.3=0//=PORTD&0xf7
;#define Recieve PORTD.3=1//PORTD|0x08
;#define wait_startOCD EICRA=0x03
;#define wait_stopOCD EICRA=0x00
;#define disable_uart UCSR0B=0xc0
;#define disable_eints {EIMSK=0x00;EIFR=0x00;}
;#define enable_eints {EIMSK=0x01;EIFR=0x01;}
;//#define enable_led PORTD=PORTD|0x40
;//#define disable_led PORTD=PORTD&0xbf
;#define start_wait_Rx_timer {TIMSK0=0x01;TCCR0A=0x00;TCCR0B=0x04;TCNT0=0xA0;}
;#define stop_wait_Rx_timer {TIMSK0=0x00;TCCR0A=0x00;TCCR0B=0x00;TCNT0=0x00;}
;#define disable_SPI {SPCR=0x12;}
;#define enable_SPI {SPCR=0x52;}
;#define DAC_max_val 0xffc0
;#define mamps_toDAC_default_ratio 0.00024437928
;#define setlevel_0_10 {PORTD.7=0;PORTD.6=0;}
;#define setlevel_0_20 {PORTD.7=0;PORTD.6=1;}
;#define setlevel_0_30 {PORTD.7=1;PORTD.6=0;}
;#define setlevel_0_50 {PORTD.7=1;PORTD.6=1;}
;// USART Receiver buffer
;#define RX_BUFFER_SIZE0 64
;
;//eeprom unsigned int ADC_PV_calibration_point1_10;
;//eeprom unsigned int buf;
;//eeprom unsigned int ADC_PV_calibration_point2_10;
;//eeprom unsigned int ADC_PV_calibration_point1_20;
;//eeprom unsigned int ADC_PV_calibration_point2_20;
;//eeprom unsigned int ADC_PV_calibration_point1_30;
;//eeprom unsigned int ADC_PV_calibration_point2_30;
;//eeprom unsigned int ADC_PV_calibration_point1_50;
;//eeprom unsigned int ADC_PV_calibration_point2_50;
;float DAC_to_current_ratio=1;

	.DSEG
;unsigned int calibration_point1;
;unsigned int calibration_point2;
;eeprom unsigned int ADC_PV_calibration_point1[4];
;eeprom unsigned int ADC_PV_calibration_point2[4];
;eeprom char rangeIndexEep;
;eeprom char CalibrationConfigChanged;
;eeprom float calibrationKeep[4];
;eeprom float calibrationBeep[4];
;eeprom int crceep = 0x0000;
;eeprom const int crcstatic = 0x105D;
;eeprom char tmpEepPriValCode = 0x6d;
;//eeprom unsigned int serial_address=0x0000;
;//flash const unsigned long *serial @0x00100;
;char rangeIndex;
;float calibrationK;
;float calibrationB;
;unsigned int tmp_calibration, crc;
;unsigned int ADC_PV_zero_val=0x0001;
;char rx_buffer0[RX_BUFFER_SIZE0];
;char string_tmp[4];
;//char *str[4];
;char com_data_rx[25];
;float dynamic_variables[3];         //0 - скорость, 1 - ток, 2 - %диапазона
;char dataToSave,sensor_address=0x02,com_bytes_rx=0,update_args_flag=0,p_bank_addr=0;
;void transmit_HART(void); int check_recieved_message(); int generate_command_data_array_answer(char command_recieved);
;void update_eeprom_parameters(char update_flag);
;void start_transmit(int transmit_param); void clear_buffer();
;void CalculateCalibrationRates();
;void ResetDeviceSettings(char notreset);
;void  CRC_update(unsigned char d);
;void PerformDeviceApplicationErase();
;void (*voidFuncPtr)(void);
;int read_program_memory (int adr);
;#if RX_BUFFER_SIZE0<256
;unsigned char rx_wr_index0,rx_rd_index0,rx_counter0,echo;
;#else
;unsigned int rx_wr_index0,rx_rd_index0,rx_counter0,SPI_data;
;#endif
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow0,printflag=0,RxTx=0,new_data=0,message_recieved=0,answering=0,burst_mode=0;
;flash  int crctable[256]= {
;        0x0000, 0xC1C0, 0x81C1, 0x4001, 0x01C3, 0xC003, 0x8002, 0x41C2, 0x01C6, 0xC006,
;        0x8007, 0x41C7, 0x0005, 0xC1C5, 0x81C4, 0x4004, 0x01CC, 0xC00C, 0x800D, 0x41CD,
;        0x000F, 0xC1CF, 0x81CE, 0x400E, 0x000A, 0xC1CA, 0x81CB, 0x400B, 0x01C9, 0xC009,
;        0x8008, 0x41C8, 0x01D8, 0xC018, 0x8019, 0x41D9, 0x001B, 0xC1DB, 0x81DA, 0x401A,
;        0x001E, 0xC1DE, 0x81DF, 0x401F, 0x01DD, 0xC01D, 0x801C, 0x41DC, 0x0014, 0xC1D4,
;        0x81D5, 0x4015, 0x01D7, 0xC017, 0x8016, 0x41D6, 0x01D2, 0xC012, 0x8013, 0x41D3,
;        0x0011, 0xC1D1, 0x81D0, 0x4010, 0x01F0, 0xC030, 0x8031, 0x41F1, 0x0033, 0xC1F3,
;        0x81F2, 0x4032, 0x0036, 0xC1F6, 0x81F7, 0x4037, 0x01F5, 0xC035, 0x8034, 0x41F4,
;        0x003C, 0xC1FC, 0x81FD, 0x403D, 0x01FF, 0xC03F, 0x803E, 0x41FE, 0x01FA, 0xC03A,
;        0x803B, 0x41FB, 0x0039, 0xC1F9, 0x81F8, 0x4038, 0x0028, 0xC1E8, 0x81E9, 0x4029,
;        0x01EB, 0xC02B, 0x802A, 0x41EA, 0x01EE, 0xC02E, 0x802F, 0x41EF, 0x002D, 0xC1ED,
;        0x81EC, 0x402C, 0x01E4, 0xC024, 0x8025, 0x41E5, 0x0027, 0xC1E7, 0x81E6, 0x4026,
;        0x0022, 0xC1E2, 0x81E3, 0x4023, 0x01E1, 0xC021, 0x8020, 0x41E0, 0x01A0, 0xC060,
;        0x8061, 0x41A1, 0x0063, 0xC1A3, 0x81A2, 0x4062, 0x0066, 0xC1A6, 0x81A7, 0x4067,
;        0x01A5, 0xC065, 0x8064, 0x41A4, 0x006C, 0xC1AC, 0x81AD, 0x406D, 0x01AF, 0xC06F,
;        0x806E, 0x41AE, 0x01AA, 0xC06A, 0x806B, 0x41AB, 0x0069, 0xC1A9, 0x81A8, 0x4068,
;        0x0078, 0xC1B8, 0x81B9, 0x4079, 0x01BB, 0xC07B, 0x807A, 0x41BA, 0x01BE, 0xC07E,
;        0x807F, 0x41BF, 0x007D, 0xC1BD, 0x81BC, 0x407C, 0x01B4, 0xC074, 0x8075, 0x41B5,
;        0x0077, 0xC1B7, 0x81B6, 0x4076, 0x0072, 0xC1B2, 0x81B3, 0x4073, 0x01B1, 0xC071,
;        0x8070, 0x41B0, 0x0050, 0xC190, 0x8191, 0x4051, 0x0193, 0xC053, 0x8052, 0x4192,
;        0x0196, 0xC056, 0x8057, 0x4197, 0x0055, 0xC195, 0x8194, 0x4054, 0x019C, 0xC05C,
;	0x805D, 0x419D, 0x005F, 0xC19F, 0x819E, 0x405E, 0x005A, 0xC19A, 0x819B, 0x405B,
;	0x0199, 0xC059, 0x8058, 0x4198, 0x0188, 0xC048, 0x8049, 0x4189, 0x004B, 0xC18B,
;	0x818A, 0x404A, 0x004E, 0xC18E, 0x818F, 0x404F, 0x018D, 0xC04D, 0x804C, 0x418C,
;	0x0044, 0xC184, 0x8185, 0x4045, 0x0187, 0xC047, 0x8046, 0x4186, 0x0182, 0xC042,
;	0x8043, 0x4183, 0x0041, 0xC181, 0x8180, 0x4040};
;long  adc_data, DAC_data, SPI_tData ;
;char SPI_tEnd=1,checking_result=0,preambula_bytes=5,preambula_bytes_rec=0,bytes_quantity_ans=0,bytes_quantity_q=0,data_q=0, command_rx_val=0;
;// USART Receiver interrupt service routine
;char Command_data[25];
;
;int read_program_memory (int adr)
; 0000 00A9 {

	.CSEG
_read_program_memory:
; 0000 00AA        #asm
;	adr -> Y+0
; 0000 00AB        LPM R22,Z+;//     загрузка в регистр R23 содержимого флеш по адресу Z с постинкрементом (мл. байт)
       LPM R22,Z+;//     загрузка в регистр R23 содержимого флеш по адресу Z с постинкрементом (мл. байт)
; 0000 00AC        LPM R23,Z; //     загрузка в регистр R22 содержимого Flash  по адресу Z+1 (старший байт)
       LPM R23,Z; //     загрузка в регистр R22 содержимого Flash  по адресу Z+1 (старший байт)
; 0000 00AD        MOV R30, R22;
       MOV R30, R22;
; 0000 00AE        MOV R31, R23;
       MOV R31, R23;
; 0000 00AF        #endasm
; 0000 00B0 }
	ADIW R28,2
	RET
;void  CRC_update(unsigned char d)
; 0000 00B2 {
_CRC_update:
; 0000 00B3   //unsigned char uindex;
; 0000 00B4   //uindex = CRCHigh^d;
; 0000 00B5   //CRCHigh=CRCLow^((int)crctable[uindex]>>8);
; 0000 00B6   //CRCLow=crctable[uindex];
; 0000 00B7   //crc = CRCHigh;
; 0000 00B8   //crc = ((int)crc)<<8+CRCLow;
; 0000 00B9   crc = crctable[((crc>>8)^d)&0xFF] ^ (crc<<8);
;	d -> Y+0
	MOV  R30,R14
	ANDI R31,HIGH(0x0)
	MOVW R26,R30
	LD   R30,Y
	LDI  R31,0
	EOR  R26,R30
	EOR  R27,R31
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	AND  R30,R26
	AND  R31,R27
	LDI  R26,LOW(_crctable*2)
	LDI  R27,HIGH(_crctable*2)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW2PF
	MOV  R31,R13
	LDI  R30,LOW(0)
	EOR  R30,R26
	EOR  R31,R27
	__PUTW1R 13,14
; 0000 00BA }
	ADIW R28,1
	RET
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)     //таймер, который ждет необходимое число циклов, соответствующее появлению сигнала на детекторе несущей
; 0000 00BD {
_timer0_ovf_isr:
	ST   -Y,R30
; 0000 00BE enable_eints;
	LDI  R30,LOW(1)
	OUT  0x1D,R30
	OUT  0x1C,R30
; 0000 00BF wait_stopOCD;
	LDI  R30,LOW(0)
	STS  105,R30
; 0000 00C0 }
	LD   R30,Y+
	RETI
;
;// Declare your global variables here
;interrupt [USART_RXC] void usart_rx_isr(void)//прием по USART
; 0000 00C4 {
_usart_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00C5 
; 0000 00C6 char status,data;
; 0000 00C7 #asm("cli")
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	cli
; 0000 00C8 status=UCSR0A;
	LDS  R17,192
; 0000 00C9 
; 0000 00CA data=UDR0;
	LDS  R16,198
; 0000 00CB //#asm("sei")
; 0000 00CC if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)//если нет ошибок, то читаем данные в буфере USART
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x8
; 0000 00CD    {
; 0000 00CE    rx_buffer0[rx_wr_index0]=data;
	LDS  R30,_rx_wr_index0
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 00CF    if (++rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDS  R26,_rx_wr_index0
	SUBI R26,-LOW(1)
	STS  _rx_wr_index0,R26
	CPI  R26,LOW(0x40)
	BRNE _0x9
	LDI  R30,LOW(0)
	STS  _rx_wr_index0,R30
; 0000 00D0    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x9:
	LDS  R26,_rx_counter0
	SUBI R26,-LOW(1)
	STS  _rx_counter0,R26
	CPI  R26,LOW(0x40)
	BRNE _0xA
; 0000 00D1       {
; 0000 00D2       rx_counter0=0;
	LDI  R30,LOW(0)
	STS  _rx_counter0,R30
; 0000 00D3       rx_buffer_overflow0=1;
	SBI  0x1E,0
; 0000 00D4 
; 0000 00D5      };
_0xA:
; 0000 00D6    };
_0x8:
; 0000 00D7  #asm("sei")
	sei
; 0000 00D8 }
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void) //не используется
; 0000 00DF {
; 0000 00E0 char data;
; 0000 00E1 while (rx_counter0==0);
;	data -> R17
; 0000 00E2 data=rx_buffer0[rx_rd_index0];
; 0000 00E3 if (++rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
; 0000 00E4 #asm("cli")
; 0000 00E5 --rx_counter0;
; 0000 00E6 #asm("sei")
; 0000 00E7 return data;
; 0000 00E8 }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE0 64
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0<256
;unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
;#else
;unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)//передача по USART соответственно
; 0000 00F8 {
_usart_tx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00F9 #asm("cli")
	cli
; 0000 00FA if (tx_counter0)
	LDS  R30,_tx_counter0
	CPI  R30,0
	BREQ _0x11
; 0000 00FB    {
; 0000 00FC    --tx_counter0;
	SUBI R30,LOW(1)
	STS  _tx_counter0,R30
; 0000 00FD 
; 0000 00FE    UDR0=tx_buffer0[tx_rd_index0];
	LDS  R30,_tx_rd_index0
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	STS  198,R30
; 0000 00FF 
; 0000 0100    if (++tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDS  R26,_tx_rd_index0
	SUBI R26,-LOW(1)
	STS  _tx_rd_index0,R26
	CPI  R26,LOW(0x40)
	BRNE _0x12
	LDI  R30,LOW(0)
	STS  _tx_rd_index0,R30
; 0000 0101    };
_0x12:
_0x11:
; 0000 0102    #asm("sei")
	sei
; 0000 0103 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)                                       //не используется
; 0000 010A {
; 0000 010B //while (tx_counter0 == TX_BUFFER_SIZE0);
; 0000 010C //#asm("cli")
; 0000 010D //if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
; 0000 010E //   {
; 0000 010F //   tx_buffer0[tx_wr_index0]=c;
; 0000 0110 //   if (++tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
; 0000 0111 //   ++tx_counter0;
; 0000 0112 //   }
; 0000 0113 //else
; 0000 0114 while ((UCSR0A & DATA_REGISTER_EMPTY)==0)
;	c -> Y+0
; 0000 0115    UDR0=c;
; 0000 0117 }
;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)//первоначально прерывание работает по нарастающему уровню (set_rising_edge_int), а затем ловим низкий (set_falling_edge_int), это устанавливаем уже в таймере, с последующим запуском нашего любимого таймера.1-прием, 0- передача.
; 0000 011C //изменено, таймер, отсчитывающий задержку, сейчас не активен, пользуемся только OCD ногой модема
; 0000 011D {
_ext_int0_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 011E //RxTx=!RxTx;//RxTx=0 =>no recieve ||RxTx=1 => recieve||
; 0000 011F //if(RxTx)Recieve;
; 0000 0120 if(EICRA==0x03)                    //если сработало прерывание по верхнему уровню, то переключаемся на отлов нижнего уровня и наоборот
	LDS  R26,105
	CPI  R26,LOW(0x3)
	BRNE _0x16
; 0000 0121                 {
; 0000 0122                 Recieve;
	SBI  0xB,3
; 0000 0123                 RxEn;
	LDS  R30,193
	ANDI R30,LOW(0xC0)
	ORI  R30,0x10
	STS  193,R30
; 0000 0124                 //wait_stopOCD;
; 0000 0125                 //start_wait_Rx_timer;
; 0000 0126                 //disable_eints;
; 0000 0127                 wait_stopOCD;           //EICRA=0x00
	LDI  R30,LOW(0)
	STS  105,R30
; 0000 0128                 message_recieved=0;
	CBI  0x1E,4
; 0000 0129                 //mono_channel_mode;
; 0000 012A                 }
; 0000 012B else
	RJMP _0x1B
_0x16:
; 0000 012C                 {
; 0000 012D                 //Transmit;
; 0000 012E 
; 0000 012F                 //stop_wait_Rx_timer;
; 0000 0130                 wait_startOCD;            //EICRA=0x03
	LDI  R30,LOW(3)
	STS  105,R30
; 0000 0131                 disable_uart;             //отключаем USART, переходим в режим приема
	LDI  R30,LOW(192)
	STS  193,R30
; 0000 0132                 message_recieved=1;
	SBI  0x1E,4
; 0000 0133 
; 0000 0134                 }
_0x1B:
; 0000 0135 //start_check_OCD_timer;//стартуем таймер отсчитывающий задержку 3.33 мс (4 цикла при минимальной частоте 1200Гц)
; 0000 0136 
; 0000 0137 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;
;#pragma used-
;#endif
;// ADC interrupt service routine
;interrupt [ADC_INT] void adc_isr(void)//прерывания ацп по завершению преобразования
; 0000 013E {
_adc_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 013F //#asm("cli")
; 0000 0140 delay_us(10);
	__DELAY_USB 2
; 0000 0141 adc_data=ADCW;
	LDS  R30,120
	LDS  R31,120+1
	CLR  R22
	CLR  R23
	STS  _adc_data,R30
	STS  _adc_data+1,R31
	STS  _adc_data+2,R22
	STS  _adc_data+3,R23
; 0000 0142 printflag=1;
	SBI  0x1E,1
; 0000 0143 ADMUX=0x20;
	LDI  R30,LOW(32)
	STS  124,R30
; 0000 0144 ADCSRA=0x4f;
	LDI  R30,LOW(79)
	STS  122,R30
; 0000 0145 //#asm("sei")
; 0000 0146 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
;
;
;// SPI interrupt service routine
;interrupt [SPI_STC] void spi_isr(void)       //прерывание по SPI, в случае, если один фрейм SPI отправлен, оно срабатывает
; 0000 014B {                                              // в случае необходимости, либо продлевает фрейм, либо финализирует
_spi_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 014C 
; 0000 014D //#asm
; 0000 014E   //  in   r30,spsr
; 0000 014F   //  in   r30,spdr
; 0000 0150 //#endasm
; 0000 0151 //data=SPDR;
; 0000 0152 //SPCR=0xD0;
; 0000 0153 //SPSR=0x00;
; 0000 0154 // Place your code here
; 0000 0155 if(SPI_tEnd==0){
	LDS  R30,_SPI_tEnd
	CPI  R30,0
	BRNE _0x20
; 0000 0156 SPDR=0xff;
	LDI  R30,LOW(255)
	OUT  0x2E,R30
; 0000 0157 SPI_tEnd=1;
	LDI  R30,LOW(1)
	STS  _SPI_tEnd,R30
; 0000 0158 }
; 0000 0159 else PORTB.2=0;
	RJMP _0x21
_0x20:
	CBI  0x5,2
; 0000 015A ADCSRA=0xcf;
_0x21:
	LDI  R30,LOW(207)
	STS  122,R30
; 0000 015B 
; 0000 015C }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;void transmit_SPI(unsigned int SPI_data,char SPI_mode){//4 режима работы: 2-норма, 0-авария 3.75мА, 1-авария 22мА, 3-моноканал
; 0000 015E void transmit_SPI(unsigned int SPI_data,char SPI_mode){
_transmit_SPI:
; 0000 015F //#asm ("cli")                                          //прерывания мы здесь не используем, потому как с ними получается какой-то гемор
; 0000 0160 delay_us(10);
;	SPI_data -> Y+1
;	SPI_mode -> Y+0
	__DELAY_USB 2
; 0000 0161 PORTB.2=0;
	CBI  0x5,2
; 0000 0162 if(SPI_mode<2)
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRSH _0x26
; 0000 0163 {
; 0000 0164 SPDR=SPI_mode;
	LD   R30,Y
	OUT  0x2E,R30
; 0000 0165 if(SPI_mode==0)SPI_data=alarm3_75mA;
	CPI  R30,0
	BRNE _0x27
	LDI  R30,LOW(15360)
	LDI  R31,HIGH(15360)
	RJMP _0x11E
; 0000 0166 else SPI_data=alarm22mA;
_0x27:
	LDI  R30,LOW(24576)
	LDI  R31,HIGH(24576)
_0x11E:
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0000 0167 while(SPSR<0x80){;}
_0x29:
	IN   R30,0x2D
	CPI  R30,LOW(0x80)
	BRLO _0x29
; 0000 0168 }
; 0000 0169 if(SPI_mode==3){
_0x26:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x2C
; 0000 016A SPI_data=0;}
	LDI  R30,LOW(0)
	STD  Y+1,R30
	STD  Y+1+1,R30
; 0000 016B if(SPI_mode==2)
_0x2C:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x2D
; 0000 016C {
; 0000 016D SPDR=(long)(DAC_data>>16);
	LDS  R26,_DAC_data
	LDS  R27,_DAC_data+1
	LDS  R24,_DAC_data+2
	LDS  R25,_DAC_data+3
	LDI  R30,LOW(16)
	CALL __ASRD12
	OUT  0x2E,R30
; 0000 016E while(SPSR<0x80){;}
_0x2E:
	IN   R30,0x2D
	CPI  R30,LOW(0x80)
	BRLO _0x2E
; 0000 016F }
; 0000 0170 SPDR=SPI_data>>8;
_0x2D:
	LDD  R30,Y+2
	ANDI R31,HIGH(0x0)
	OUT  0x2E,R30
; 0000 0171 PORTB.2=0;
	CBI  0x5,2
; 0000 0172 while(SPSR<0x80){;}
_0x33:
	IN   R30,0x2D
	CPI  R30,LOW(0x80)
	BRLO _0x33
; 0000 0173 SPDR=SPI_data;
	LDD  R30,Y+1
	OUT  0x2E,R30
; 0000 0174 while(SPSR<0x80){;}
_0x36:
	IN   R30,0x2D
	CPI  R30,LOW(0x80)
	BRLO _0x36
; 0000 0175 //#asm ("sei")
; 0000 0176 }
	ADIW R28,3
	RET
;
;
;void transmit_HART(void)//подпрограмма передачи в по HART
; 0000 017A {
_transmit_HART:
; 0000 017B int error_log;
; 0000 017C error_log=check_recieved_message();    //здесь проверяем корректность принятого сообщения и устанавливаем значение переменной "результат проверки"
	ST   -Y,R17
	ST   -Y,R16
;	error_log -> R16,R17
	RCALL _check_recieved_message
	MOVW R16,R30
; 0000 017D if(answering)                         //если нужен ответ
	SBIS 0x1E,5
	RJMP _0x39
; 0000 017E         {
; 0000 017F         if (!error_log)               //ошибок нет
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x3A
; 0000 0180                 {
; 0000 0181                 checking_result=0;                //сбрасываем "результат проверки"
	LDI  R30,LOW(0)
	STS  _checking_result,R30
; 0000 0182                 rx_wr_index0=0;
	STS  _rx_wr_index0,R30
; 0000 0183                 rx_buffer_overflow0=0;
	CBI  0x1E,0
; 0000 0184                 error_log=error_log|(generate_command_data_array_answer(command_rx_val));//здесь обращаемся в генератор массивов ответов по HART
	LDS  R30,_command_rx_val
	ST   -Y,R30
	RCALL _generate_command_data_array_answer
	__ORWRR 16,17,30,31
; 0000 0185                 start_transmit(error_log);
	RJMP _0x11F
; 0000 0186                 }
; 0000 0187         else
_0x3A:
; 0000 0188                 { //соответственно, если ошибки есть
; 0000 0189                 //PORTD=0x08;
; 0000 018A                 Recieve;
	SBI  0xB,3
; 0000 018B                 rx_buffer_overflow0=0;
	CBI  0x1E,0
; 0000 018C                 checking_result=0;
	LDI  R30,LOW(0)
	STS  _checking_result,R30
; 0000 018D                 rx_wr_index0=0;
	STS  _rx_wr_index0,R30
; 0000 018E                 message_recieved=0;
	CBI  0x1E,4
; 0000 018F                 start_transmit(error_log);
_0x11F:
	ST   -Y,R17
	ST   -Y,R16
	RCALL _start_transmit
; 0000 0190                 }
; 0000 0191         }
; 0000 0192 else                              //ответ по HART не нужен
	RJMP _0x44
_0x39:
; 0000 0193         {
; 0000 0194         rx_buffer_overflow0=0;
	CBI  0x1E,0
; 0000 0195         checking_result=0;
	LDI  R30,LOW(0)
	STS  _checking_result,R30
; 0000 0196         rx_wr_index0=0;
	STS  _rx_wr_index0,R30
; 0000 0197         RxEn;
	LDS  R30,193
	ANDI R30,LOW(0xC0)
	ORI  R30,0x10
	STS  193,R30
; 0000 0198         Recieve;
	SBI  0xB,3
; 0000 0199         }
_0x44:
; 0000 019A clear_buffer();
	RCALL _clear_buffer
; 0000 019B }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void start_transmit(int transmit_param)
; 0000 019E {
_start_transmit:
; 0000 019F char i=0,j=0;
; 0000 01A0 char check_sum_tx=0;
; 0000 01A1 while(UCSR0A<0x20){;}
	CALL __SAVELOCR4
;	transmit_param -> Y+4
;	i -> R17
;	j -> R16
;	check_sum_tx -> R19
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
_0x49:
	LDS  R26,192
	CPI  R26,LOW(0x20)
	BRLO _0x49
; 0000 01A2 //if(!RxTx){
; 0000 01A3 preambula_bytes=Parameter_bank[3];
	__POINTW2MN _Parameter_bank,3
	CALL __EEPROMRDB
	STS  _preambula_bytes,R30
; 0000 01A4 delay_ms(25);
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01A5 Transmit;
	CBI  0xB,3
; 0000 01A6 TxEn;
	LDS  R30,193
	ANDI R30,LOW(0xC0)
	ORI  R30,8
	STS  193,R30
; 0000 01A7 delay_ms(15);
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01A8 for (i=0;i<preambula_bytes;i++)
	LDI  R17,LOW(0)
_0x4F:
	LDS  R30,_preambula_bytes
	CP   R17,R30
	BRSH _0x50
; 0000 01A9         {
; 0000 01AA         tx_buffer0[i]=0xff;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LDI  R26,LOW(255)
	STD  Z+0,R26
; 0000 01AB         tx_counter0++;
	LDS  R30,_tx_counter0
	SUBI R30,-LOW(1)
	STS  _tx_counter0,R30
; 0000 01AC         }
	SUBI R17,-1
	RJMP _0x4F
_0x50:
; 0000 01AD //i++;
; 0000 01AE if(burst_mode)tx_buffer0[i]=0x01;//стартовый байт
	SBIS 0x1E,6
	RJMP _0x51
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LDI  R26,LOW(1)
	RJMP _0x120
; 0000 01AF else tx_buffer0[i]=0x06;
_0x51:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LDI  R26,LOW(6)
_0x120:
	STD  Z+0,R26
; 0000 01B0 check_sum_tx=check_sum_tx^tx_buffer0[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	EOR  R19,R30
; 0000 01B1 i++;
	SUBI R17,-1
; 0000 01B2 tx_buffer0[i]=rx_buffer0[preambula_bytes_rec-preambula_bytes+i];//адрес
	MOV  R30,R17
	LDI  R31,0
	MOVW R22,R30
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	MOVW R0,R30
	LDS  R26,_preambula_bytes_rec
	CLR  R27
	LDS  R30,_preambula_bytes
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R30,R22
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	MOVW R26,R0
	ST   X,R30
; 0000 01B3 check_sum_tx=check_sum_tx^tx_buffer0[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	EOR  R19,R30
; 0000 01B4 i++;
	SUBI R17,-1
; 0000 01B5 tx_buffer0[i]=rx_buffer0[preambula_bytes_rec-preambula_bytes+i];//команда
	MOV  R30,R17
	LDI  R31,0
	MOVW R22,R30
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	MOVW R0,R30
	LDS  R26,_preambula_bytes_rec
	CLR  R27
	LDS  R30,_preambula_bytes
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R30,R22
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	MOVW R26,R0
	ST   X,R30
; 0000 01B6 check_sum_tx=check_sum_tx^tx_buffer0[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	EOR  R19,R30
; 0000 01B7 i++;
	SUBI R17,-1
; 0000 01B8 if(!transmit_param)
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BREQ PC+3
	JMP _0x53
; 0000 01B9         {
; 0000 01BA         tx_buffer0[i]=bytes_quantity_ans+2;                                                  //число байт  //нужно создать массив с количеством байт для конкретной команды
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_tx_buffer0)
	SBCI R27,HIGH(-_tx_buffer0)
	LDS  R30,_bytes_quantity_ans
	SUBI R30,-LOW(2)
	ST   X,R30
; 0000 01BB         check_sum_tx=check_sum_tx^tx_buffer0[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	EOR  R19,R30
; 0000 01BC         i++;
	SUBI R17,-1
; 0000 01BD         tx_buffer0[i]=p_bank_addr;                                             //статус 1й байт
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LDS  R26,_p_bank_addr
	STD  Z+0,R26
; 0000 01BE         check_sum_tx=check_sum_tx^tx_buffer0[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	EOR  R19,R30
; 0000 01BF         i++;
	SUBI R17,-1
; 0000 01C0         tx_buffer0[i]=0x00;                                             //статус 2й байт
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 01C1         check_sum_tx=check_sum_tx^tx_buffer0[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	EOR  R19,R30
; 0000 01C2         i++;
	SUBI R17,-1
; 0000 01C3         for(j=0;j<bytes_quantity_ans;j++)
	LDI  R16,LOW(0)
_0x55:
	LDS  R30,_bytes_quantity_ans
	CP   R16,R30
	BRSH _0x56
; 0000 01C4                 {
; 0000 01C5                 tx_buffer0[i]=Command_data[j];                                                //данные //здесь нужно создать массив с данными для конкретной команды и перегружать его по запросу в буфер отправки
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_tx_buffer0)
	SBCI R27,HIGH(-_tx_buffer0)
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_Command_data)
	SBCI R31,HIGH(-_Command_data)
	LD   R30,Z
	ST   X,R30
; 0000 01C6                 check_sum_tx=check_sum_tx^tx_buffer0[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	EOR  R19,R30
; 0000 01C7                 i++;
	SUBI R17,-1
; 0000 01C8                 }
	SUBI R16,-1
	RJMP _0x55
_0x56:
; 0000 01C9         }
; 0000 01CA else {
	RJMP _0x57
_0x53:
; 0000 01CB         tx_buffer0[i]=com_bytes_rx+2;       //здесь просто берем количество байт из принятого сообщения                                           //число байт  //нужно создать массив с количеством байт для конкретной команды
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_tx_buffer0)
	SBCI R27,HIGH(-_tx_buffer0)
	LDS  R30,_com_bytes_rx
	SUBI R30,-LOW(2)
	ST   X,R30
; 0000 01CC         //bytes_quantity_ans=rx_buffer0[preambula_bytes_rec-preambula_bytes+i]+2;  //эту величину все же нужно сохранить, дабы юзать в цикле
; 0000 01CD         check_sum_tx=check_sum_tx^tx_buffer0[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	EOR  R19,R30
; 0000 01CE         i++;
	SUBI R17,-1
; 0000 01CF         tx_buffer0[i]=transmit_param>>8;                                       //статус 1й байт
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_tx_buffer0)
	SBCI R27,HIGH(-_tx_buffer0)
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL __ASRW8
	ST   X,R30
; 0000 01D0         check_sum_tx=check_sum_tx^tx_buffer0[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	EOR  R19,R30
; 0000 01D1         i++;
	SUBI R17,-1
; 0000 01D2         tx_buffer0[i]=transmit_param;                                          //статус 2й байт
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LDD  R26,Y+4
	STD  Z+0,R26
; 0000 01D3         check_sum_tx=check_sum_tx^tx_buffer0[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	EOR  R19,R30
; 0000 01D4         i++;
	SUBI R17,-1
; 0000 01D5         j=i;
	MOV  R16,R17
; 0000 01D6         for(i=j;i<com_bytes_rx+j;i++)
	MOV  R17,R16
_0x59:
	LDS  R26,_com_bytes_rx
	CLR  R27
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x5A
; 0000 01D7                 {
; 0000 01D8                 tx_buffer0[i]=rx_buffer0[preambula_bytes_rec-preambula_bytes+i-2];                                                //данные прямо из массива принятых данных
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	MOVW R22,R30
	LDS  R26,_preambula_bytes_rec
	CLR  R27
	LDS  R30,_preambula_bytes
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	MOVW R26,R22
	ST   X,R30
; 0000 01D9                 check_sum_tx=check_sum_tx^tx_buffer0[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	EOR  R19,R30
; 0000 01DA                 //i++;
; 0000 01DB                 }
	SUBI R17,-1
	RJMP _0x59
_0x5A:
; 0000 01DC         }
_0x57:
; 0000 01DD         //i++;
; 0000 01DE tx_buffer0[i]=check_sum_tx;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	ST   Z,R19
; 0000 01DF tx_rd_index0=1;
	LDI  R30,LOW(1)
	STS  _tx_rd_index0,R30
; 0000 01E0 //if(!transmit_param){
; 0000 01E1 //for(i=0;i<=rx_counter0;i++)tx_buffer0[i]=rx_buffer0[i]; }
; 0000 01E2 //tx_rd_index0=1;
; 0000 01E3 tx_counter0=i;
	STS  _tx_counter0,R17
; 0000 01E4 UDR0=tx_buffer0[0];
	LDS  R30,_tx_buffer0
	STS  198,R30
; 0000 01E5 while(tx_counter0){;}
_0x5B:
	LDS  R30,_tx_counter0
	CPI  R30,0
	BRNE _0x5B
; 0000 01E6 delay_ms(15);
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01E7 //RxEn;
; 0000 01E8 Recieve;
	SBI  0xB,3
; 0000 01E9 message_recieved=0;
	CBI  0x1E,4
; 0000 01EA rx_counter0=0;
	LDI  R30,LOW(0)
	STS  _rx_counter0,R30
; 0000 01EB 
; 0000 01EC }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;
;int generate_command_data_array_answer(char command_recieved)//загружаем из эсппзу сохраненный массив параметров (Parameter_bank) и записываем его в динамический массив команд (Command_data) с помощью связывающего массива (Command_mask)
; 0000 01EF {
_generate_command_data_array_answer:
; 0000 01F0 char i=0,j=0,k=0;
; 0000 01F1 char dynamic_parameter=0, writing_command=0, error=1, parameter_tmp=0,parameter_tmp_length=0,tmp_command_number=0;
; 0000 01F2 union ieeesender      //это объединение создано специально для передачи числа в формате плавающей точки в виде 4х байт
; 0000 01F3         {
; 0000 01F4         float value;
; 0000 01F5         char byte[4];
; 0000 01F6         }floatsend;
; 0000 01F7 //for (i=0;i<4;i++)
; 0000 01F8 //        {
; 0000 01F9 //        str[i]=&string_tmp[i];
; 0000 01FA //        }
; 0000 01FB //        i=0;
; 0000 01FC 
; 0000 01FD for (i=0;i<31;i++)//счетчик № команды
	SBIW R28,7
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+5,R30
	STD  Y+6,R30
	CALL __SAVELOCR6
;	command_recieved -> Y+13
;	i -> R17
;	j -> R16
;	k -> R19
;	dynamic_parameter -> R18
;	writing_command -> R21
;	error -> R20
;	parameter_tmp -> Y+12
;	parameter_tmp_length -> Y+11
;	tmp_command_number -> Y+10
;	ieeesender -> Y+13
;	floatsend -> Y+6
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	LDI  R18,0
	LDI  R21,0
	LDI  R20,1
	LDI  R17,LOW(0)
_0x63:
	CPI  R17,31
	BRSH _0x64
; 0000 01FE                 {
; 0000 01FF                 if(Command_number[0][i]==command_recieved)
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_Command_number*2)
	SBCI R31,HIGH(-_Command_number*2)
	LPM  R26,Z
	LDD  R30,Y+13
	CP   R30,R26
	BRNE _0x65
; 0000 0200                                 {
; 0000 0201                                 error=0;//отсутствие совпадений соответствует ошибке "команда не поддерживается"
	LDI  R20,LOW(0)
; 0000 0202                                 tmp_command_number=i;
	__PUTBSR 17,10
; 0000 0203                                 }
; 0000 0204                 }
_0x65:
	SUBI R17,-1
	RJMP _0x63
_0x64:
; 0000 0205 if(!error)      {//если ошибок нет, формируем команду
	CPI  R20,0
	BREQ PC+3
	JMP _0x66
; 0000 0206                 writing_command=Command_number[1][tmp_command_number];//команда записи=1
	__POINTW1FN _Command_number,31
	MOVW R26,R30
	LDD  R30,Y+10
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R21,Z
; 0000 0207                 dynamic_parameter=Command_number[2][tmp_command_number];//динамический параметр=2
	__POINTW1FN _Command_number,62
	MOVW R26,R30
	LDD  R30,Y+10
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R18,Z
; 0000 0208                         if(writing_command)
	CPI  R21,0
	BREQ _0x67
; 0000 0209                                 {
; 0000 020A                                 for(j=0;j<com_bytes_rx+1;j++)
	LDI  R16,LOW(0)
_0x69:
	LDS  R30,_com_bytes_rx
	LDI  R31,0
	ADIW R30,1
	MOV  R26,R16
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x6A
; 0000 020B                                         {
; 0000 020C                                         Command_data[j]=com_data_rx[j];
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_Command_data)
	SBCI R27,HIGH(-_Command_data)
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_com_data_rx)
	SBCI R31,HIGH(-_com_data_rx)
	LD   R30,Z
	ST   X,R30
; 0000 020D                                         //Parameter_bank[Parameter_mask[parameter_tmp]+(k+parameter_tmp_length-j)];//Command_data[k]=Parameter_bank[Parameter_mask[parameter_tmp]+(k+parameter_tmp_length-j)];
; 0000 020E                                         }
	SUBI R16,-1
	RJMP _0x69
_0x6A:
; 0000 020F                                 update_args_flag=tmp_command_number;
	LDD  R30,Y+10
	STS  _update_args_flag,R30
; 0000 0210                                 update_eeprom_parameters(tmp_command_number);
	ST   -Y,R30
	RCALL _update_eeprom_parameters
; 0000 0211                                 j=0;
	LDI  R16,LOW(0)
; 0000 0212                                 }
; 0000 0213                         else
	RJMP _0x6B
_0x67:
; 0000 0214                                 {
; 0000 0215                                  //представленный ниже код работает только для команд чтения, нединамических и динамических.
; 0000 0216                                  /* приведенный ниже код работает следующим образом: сперва мы обращаемся к массиву Command_mask
; 0000 0217                                  с помощью которого получаем представление о том, какой параметр соответствует какому байту в команде,
; 0000 0218                                  а также какова его длина в байтах, затем поочередно перезагружаем из массива Parameter_bank данные(которые хранятся в нем последовательно) в
; 0000 0219                                  массив Command_data, используя для этого массив Parameter_mask (в этом массиве каждому элементу поставлен в прямое соответствие номер параметра
; 0000 021A                                 , который мы берем из массива Command_mask, а содержимое каждой ячейки определяет, с какой ячейки начинаются данные соответствующего параметра*/
; 0000 021B                                  parameter_tmp=Command_mask[tmp_command_number][j];
	LDD  R30,Y+10
	LDI  R26,LOW(25)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_Command_mask*2)
	SBCI R31,HIGH(-_Command_mask*2)
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R0,Z
	STD  Y+12,R0
; 0000 021C 
; 0000 021D                                  for(j=0;j<24;j++)
	LDI  R16,LOW(0)
_0x6D:
	CPI  R16,24
	BRLO PC+3
	JMP _0x6E
; 0000 021E                                          {
; 0000 021F                                          if(parameter_tmp!=Command_mask[tmp_command_number][j])
	LDD  R30,Y+10
	LDI  R26,LOW(25)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_Command_mask*2)
	SBCI R31,HIGH(-_Command_mask*2)
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	LDD  R26,Y+12
	CP   R30,R26
	BRNE PC+3
	JMP _0x6F
; 0000 0220                                                      {
; 0000 0221                                                      for(k=(j-parameter_tmp_length);k<j;k++)
	MOV  R26,R16
	CLR  R27
	LDD  R30,Y+11
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOV  R19,R30
_0x71:
	CP   R19,R16
	BRLO PC+3
	JMP _0x72
; 0000 0222                                                                 {
; 0000 0223                                                                 if((parameter_tmp<11)|(parameter_tmp>13))
	LDD  R26,Y+12
	LDI  R30,LOW(11)
	CALL __LTB12U
	MOV  R0,R30
	LDI  R30,LOW(13)
	CALL __GTB12U
	OR   R30,R0
	BREQ _0x73
; 0000 0224                                                                         {
; 0000 0225                                                                         Command_data[k]=Parameter_bank[Parameter_mask[parameter_tmp]+(k+parameter_tmp_length-j)];
	MOV  R30,R19
	LDI  R31,0
	SUBI R30,LOW(-_Command_data)
	SBCI R31,HIGH(-_Command_data)
	MOVW R24,R30
	LDD  R30,Y+12
	LDI  R31,0
	SUBI R30,LOW(-_Parameter_mask*2)
	SBCI R31,HIGH(-_Parameter_mask*2)
	LPM  R22,Z
	CLR  R23
	MOV  R26,R19
	CLR  R27
	LDD  R30,Y+11
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R16
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	ADD  R30,R22
	ADC  R31,R23
	SUBI R30,LOW(-_Parameter_bank)
	SBCI R31,HIGH(-_Parameter_bank)
	MOVW R26,R30
	CALL __EEPROMRDB
	MOVW R26,R24
	ST   X,R30
; 0000 0226                                                                         }
; 0000 0227                                                                 else
	RJMP _0x74
_0x73:
; 0000 0228                                                                         {
; 0000 0229                                                                          //ttest=(long)dynamic_variables[0];
; 0000 022A                                                                         #asm ("cli")
	cli
; 0000 022B                                                                         floatsend.value=dynamic_variables[parameter_tmp-11];
	LDD  R30,Y+12
	LDI  R31,0
	SBIW R30,11
	LDI  R26,LOW(_dynamic_variables)
	LDI  R27,HIGH(_dynamic_variables)
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETD1P
	__PUTD1S 6
; 0000 022C                                                                         //test=*str[k-1];
; 0000 022D                                                                         Command_data[k]=floatsend.byte[k+parameter_tmp_length-j]; //(char)(test>>8*(k-1)); //(char)((long)((dynamic_variables[Parameter_mask[parameter_tmp]+(k+parameter_tmp_length-j)-11])<<8*(k+parameter_tmp_length-j)));
	MOV  R30,R19
	LDI  R31,0
	SUBI R30,LOW(-_Command_data)
	SBCI R31,HIGH(-_Command_data)
	MOVW R22,R30
	MOV  R26,R19
	CLR  R27
	LDD  R30,Y+11
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R16
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R22
	ST   X,R30
; 0000 022E                                                                         #asm("sei")
	sei
; 0000 022F                                                                         }
_0x74:
; 0000 0230                                                                 }
	SUBI R19,-1
	RJMP _0x71
_0x72:
; 0000 0231                                                       parameter_tmp_length=0;
	LDI  R30,LOW(0)
	STD  Y+11,R30
; 0000 0232                                                      }
; 0000 0233                                          parameter_tmp=Command_mask[tmp_command_number][j];
_0x6F:
	LDD  R30,Y+10
	LDI  R26,LOW(25)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_Command_mask*2)
	SBCI R31,HIGH(-_Command_mask*2)
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R0,Z
	STD  Y+12,R0
; 0000 0234                                          parameter_tmp_length++;
	LDD  R30,Y+11
	SUBI R30,-LOW(1)
	STD  Y+11,R30
; 0000 0235                                          if(!Command_mask[tmp_command_number][j])j=24;
	LDD  R30,Y+10
	LDI  R26,LOW(25)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_Command_mask*2)
	SBCI R31,HIGH(-_Command_mask*2)
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	CPI  R30,0
	BRNE _0x75
	LDI  R16,LOW(24)
; 0000 0236                                          }
_0x75:
	SUBI R16,-1
	RJMP _0x6D
_0x6E:
; 0000 0237                                  bytes_quantity_ans=k;
	STS  _bytes_quantity_ans,R19
; 0000 0238                                  k=0;
	LDI  R19,LOW(0)
; 0000 0239                                 }
_0x6B:
; 0000 023A                         }
; 0000 023B 
; 0000 023C return error;
_0x66:
	MOV  R30,R20
	LDI  R31,0
	CALL __LOADLOCR6
	ADIW R28,14
	RET
; 0000 023D }
;
;void update_eeprom_parameters(char update_flag)
; 0000 0240 {
_update_eeprom_parameters:
; 0000 0241 char i=0,j=0,k=0,parameter_tmp=0,parameter_tmp_length=0;
; 0000 0242 parameter_tmp=Command_mask[update_flag][0];
	CALL __SAVELOCR6
;	update_flag -> Y+6
;	i -> R17
;	j -> R16
;	k -> R19
;	parameter_tmp -> R18
;	parameter_tmp_length -> R21
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	LDI  R18,0
	LDI  R21,0
	LDD  R30,Y+6
	LDI  R26,LOW(25)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_Command_mask*2)
	SBCI R31,HIGH(-_Command_mask*2)
	LPM  R18,Z
; 0000 0243 
; 0000 0244 for(j=0;j<com_bytes_rx+1;j++)
	LDI  R16,LOW(0)
_0x77:
	LDS  R30,_com_bytes_rx
	LDI  R31,0
	ADIW R30,1
	MOV  R26,R16
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRLT PC+3
	JMP _0x78
; 0000 0245         {
; 0000 0246                     if(parameter_tmp!=Command_mask[update_flag][j])
	LDD  R30,Y+6
	LDI  R26,LOW(25)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_Command_mask*2)
	SBCI R31,HIGH(-_Command_mask*2)
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	CP   R30,R18
	BREQ _0x79
; 0000 0247                              {
; 0000 0248                              for(k=(j-parameter_tmp_length);k<j;k++)
	MOV  R26,R16
	CLR  R27
	MOV  R30,R21
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOV  R19,R30
_0x7B:
	CP   R19,R16
	BRSH _0x7C
; 0000 0249                                     {
; 0000 024A                                     Parameter_bank[Parameter_mask[parameter_tmp]+(k+parameter_tmp_length-j)]=Command_data[k];
	MOV  R30,R18
	LDI  R31,0
	SUBI R30,LOW(-_Parameter_mask*2)
	SBCI R31,HIGH(-_Parameter_mask*2)
	LPM  R22,Z
	CLR  R23
	MOV  R26,R19
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	MOV  R30,R16
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	ADD  R30,R22
	ADC  R31,R23
	SUBI R30,LOW(-_Parameter_bank)
	SBCI R31,HIGH(-_Parameter_bank)
	MOVW R26,R30
	MOV  R30,R19
	LDI  R31,0
	SUBI R30,LOW(-_Command_data)
	SBCI R31,HIGH(-_Command_data)
	LD   R30,Z
	CALL __EEPROMWRB
; 0000 024B                                     }
	SUBI R19,-1
	RJMP _0x7B
_0x7C:
; 0000 024C                                parameter_tmp_length=0;
	LDI  R21,LOW(0)
; 0000 024D                              }
; 0000 024E 
; 0000 024F                     parameter_tmp=Command_mask[update_flag][j];
_0x79:
	LDD  R30,Y+6
	LDI  R26,LOW(25)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_Command_mask*2)
	SBCI R31,HIGH(-_Command_mask*2)
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R18,Z
; 0000 0250                     parameter_tmp_length++;
	SUBI R21,-1
; 0000 0251                     if(!Command_mask[update_flag][j])j=com_bytes_rx+1;
	LDD  R30,Y+6
	LDI  R26,LOW(25)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_Command_mask*2)
	SBCI R31,HIGH(-_Command_mask*2)
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	CPI  R30,0
	BRNE _0x7D
	LDS  R30,_com_bytes_rx
	SUBI R30,-LOW(1)
	MOV  R16,R30
; 0000 0252         }
_0x7D:
	SUBI R16,-1
	RJMP _0x77
_0x78:
; 0000 0253 }
	CALL __LOADLOCR6
	ADIW R28,7
	RET
;
;
;
;int check_recieved_message(){
; 0000 0257 int check_recieved_message(){
_check_recieved_message:
; 0000 0258 char i=0,j=0,k=0,l=0, tmp_i=0;//здесь i - счетчик всех байт j- счетчик байт преамбул
; 0000 0259 
; 0000 025A int check_sum=0;
; 0000 025B checking_result=0;
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	CALL __SAVELOCR6
;	i -> R17
;	j -> R16
;	k -> R19
;	l -> R18
;	tmp_i -> R21
;	check_sum -> Y+6
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	LDI  R18,0
	LDI  R21,0
	STS  _checking_result,R30
; 0000 025C answering=1;
	SBI  0x1E,5
; 0000 025D while ((rx_buffer0[j])==0xff)
_0x80:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R26,Z
	CPI  R26,LOW(0xFF)
	BRNE _0x82
; 0000 025E         {
; 0000 025F         if(8<j)
	CPI  R16,9
	BRLO _0x83
; 0000 0260                 {checking_result=0x90;//ошибка формирования фрейма, если количество преамбул больше либо равно количеству символов
	LDI  R30,LOW(144)
	STS  _checking_result,R30
; 0000 0261                  //rx_buffer0[i+1]=0x00;
; 0000 0262                  return checking_result;
	RJMP _0x2080002
; 0000 0263                  }
; 0000 0264          j++;
_0x83:
	SUBI R16,-1
; 0000 0265         }
	RJMP _0x80
_0x82:
; 0000 0266         preambula_bytes_rec=j;
	STS  _preambula_bytes_rec,R16
; 0000 0267         i=j;
	MOV  R17,R16
; 0000 0268 if ((rx_buffer0[j])!=0x02)
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R26,Z
	CPI  R26,LOW(0x2)
	BREQ _0x84
; 0000 0269 //if ((rx_buffer0[i])!=0x02)
; 0000 026A         {
; 0000 026B         checking_result=0x02;
	LDI  R30,LOW(2)
	STS  _checking_result,R30
; 0000 026C         //return checking_result;
; 0000 026D         }//диагностируем ошибку команд "неверный выбор", если не от главного устройства
; 0000 026E //else    {
; 0000 026F         check_sum=check_sum^rx_buffer0[i];
_0x84:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	EOR  R30,R26
	EOR  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0270 //        }
; 0000 0271 i++;
	SUBI R17,-1
; 0000 0272 if (((rx_buffer0[i])&0x30)!=0x00)
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	ANDI R30,LOW(0x30)
	BREQ _0x85
; 0000 0273         {checking_result=0x90;
	LDI  R30,LOW(144)
	STS  _checking_result,R30
; 0000 0274         //return checking_result;
; 0000 0275         }
; 0000 0276 //burst_mode=(rx_buffer0[i]&0x40)>>6;                          //burst_mode нужно вообще-то прописывать в команде
; 0000 0277 if((rx_buffer0[i]&0x0f)==Parameter_bank[25])answering=1;       //это проверка адреса, если адрес не тот, датчик молчит
_0x85:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	ANDI R30,LOW(0xF)
	MOV  R0,R30
	__POINTW2MN _Parameter_bank,25
	CALL __EEPROMRDB
	CP   R30,R0
	BRNE _0x86
	SBI  0x1E,5
; 0000 0278 else answering=0;
	RJMP _0x89
_0x86:
	CBI  0x1E,5
; 0000 0279 check_sum=check_sum^rx_buffer0[i];
_0x89:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	EOR  R30,R26
	EOR  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 027A i++;
	SUBI R17,-1
; 0000 027B command_rx_val=rx_buffer0[i];// здесь сделаем проверку команды: если она состоит в листе команд, то ошибку не выдаем, если нет => checking_result=0x0600;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	STS  _command_rx_val,R30
; 0000 027C if(command_rx_val==35)
	LDS  R26,_command_rx_val
	CPI  R26,LOW(0x23)
	BRNE _0x8C
; 0000 027D         {
; 0000 027E //        tmpEepPriValCode = rx_buffer0[i+2];
; 0000 027F //       Parameter_bank[12]= (char)rx_buffer0[i+2];
; 0000 0280         for(l=0;l<4;l++)
	LDI  R18,LOW(0)
_0x8E:
	CPI  R18,4
	BRSH _0x8F
; 0000 0281                 {
; 0000 0282                 Parameter_bank[88+l]=rx_buffer0[i+3+l];
	MOV  R30,R18
	LDI  R31,0
	MOVW R22,R30
	__ADDW1MN _Parameter_bank,88
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,3
	ADD  R30,R22
	ADC  R31,R23
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 0283                 Parameter_bank[92+l]=rx_buffer0[i+7+l];
	MOV  R30,R18
	LDI  R31,0
	MOVW R22,R30
	__ADDW1MN _Parameter_bank,92
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,7
	ADD  R30,R22
	ADC  R31,R23
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 0284                 }
	SUBI R18,-1
	RJMP _0x8E
_0x8F:
; 0000 0285         }
; 0000 0286 //if(command_rx_val==36)for(l=0;l<4;l++)Parameter_bank[88+l]=rx_buffer0[i+2+l];
; 0000 0287 //if(command_rx_val==37)for(l=0;l<4;l++)Parameter_bank[92+l]=rx_buffer0[i+2+l];
; 0000 0288 //if(command_rx_val==38)configuration_changed_flag=0;
; 0000 0289 //if(command_rx_val==40)enter_fixed_current_mode(float(rx_buffer0[i+2])||float(rx_buffer0[i+3]<<8)||float(rx_buffer0[i+4]<<16)||float(rx_buffer0[i+5]<<24));
; 0000 028A //if(command_rx_val==41)perform_device_self_test();
; 0000 028B //if(command_rx_val==42)perform_device_reset();
; 0000 028C if(command_rx_val==38)ResetDeviceSettings(0);
_0x8C:
	LDS  R26,_command_rx_val
	CPI  R26,LOW(0x26)
	BRNE _0x90
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _ResetDeviceSettings
; 0000 028D if(command_rx_val==42)
_0x90:
	LDS  R26,_command_rx_val
	CPI  R26,LOW(0x2A)
	BRNE _0x91
; 0000 028E                                 {
; 0000 028F                                 if((rx_buffer0[i+2]==0x45)&(rx_buffer0[i+3]==0x52)&(rx_buffer0[i+4]==0x41)&(rx_buffer0[i+5]==0x53)&(rx_buffer0[i+6]==0x45)) //ERASE в ASCII
	MOV  R30,R17
	LDI  R31,0
	MOVW R22,R30
	__ADDW1MN _rx_buffer0,2
	LD   R26,Z
	LDI  R30,LOW(69)
	CALL __EQB12
	MOV  R0,R30
	MOVW R30,R22
	__ADDW1MN _rx_buffer0,3
	LD   R26,Z
	LDI  R30,LOW(82)
	CALL __EQB12
	AND  R0,R30
	MOVW R30,R22
	__ADDW1MN _rx_buffer0,4
	LD   R26,Z
	LDI  R30,LOW(65)
	CALL __EQB12
	AND  R0,R30
	MOVW R30,R22
	__ADDW1MN _rx_buffer0,5
	LD   R26,Z
	LDI  R30,LOW(83)
	CALL __EQB12
	AND  R0,R30
	MOVW R30,R22
	__ADDW1MN _rx_buffer0,6
	LD   R26,Z
	LDI  R30,LOW(69)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x92
; 0000 0290                                 PerformDeviceApplicationErase();                                                                                                                                     //удаляем штатную прошвку нафиг, доступно только из хексхартлодера
	RCALL _PerformDeviceApplicationErase
; 0000 0291                                 }
_0x92:
; 0000 0292 if(command_rx_val==43){
_0x91:
	LDS  R26,_command_rx_val
	CPI  R26,LOW(0x2B)
	BRNE _0x93
; 0000 0293                         #asm ("cli")
	cli
; 0000 0294                         ADC_PV_calibration_point1[rangeIndex]=adc_data;//ADC_PV_zero_val=adc_data;
	MOV  R30,R10
	LDI  R26,LOW(_ADC_PV_calibration_point1)
	LDI  R27,HIGH(_ADC_PV_calibration_point1)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
	CALL __EEPROMWRW
; 0000 0295                         calibration_point1=adc_data;
	__GETWRMN 5,6,0,_adc_data
; 0000 0296                         CalibrationConfigChanged=1;
	LDI  R26,LOW(_CalibrationConfigChanged)
	LDI  R27,HIGH(_CalibrationConfigChanged)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 0297                         #asm ("sei")
	sei
; 0000 0298                         CalculateCalibrationRates();
	RCALL _CalculateCalibrationRates
; 0000 0299                         }
; 0000 029A if(command_rx_val==45)for(l=0;l<4;l++)Parameter_bank[105+l]=rx_buffer0[i+2+l];    //записываем соответствующий току битовый код АЦП
_0x93:
	LDS  R26,_command_rx_val
	CPI  R26,LOW(0x2D)
	BRNE _0x94
	LDI  R18,LOW(0)
_0x96:
	CPI  R18,4
	BRSH _0x97
	MOV  R30,R18
	LDI  R31,0
	MOVW R22,R30
	__ADDW1MN _Parameter_bank,105
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,2
	ADD  R30,R22
	ADC  R31,R23
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	MOVW R26,R0
	CALL __EEPROMWRB
	SUBI R18,-1
	RJMP _0x96
_0x97:
; 0000 029B if(command_rx_val==46)for(l=0;l<4;l++)Parameter_bank[109+l]=rx_buffer0[i+2+l];
_0x94:
	LDS  R26,_command_rx_val
	CPI  R26,LOW(0x2E)
	BRNE _0x98
	LDI  R18,LOW(0)
_0x9A:
	CPI  R18,4
	BRSH _0x9B
	MOV  R30,R18
	LDI  R31,0
	MOVW R22,R30
	__ADDW1MN _Parameter_bank,109
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,2
	ADD  R30,R22
	ADC  R31,R23
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	MOVW R26,R0
	CALL __EEPROMWRB
	SUBI R18,-1
	RJMP _0x9A
_0x9B:
; 0000 029D if(command_rx_val==111){
_0x98:
	LDS  R26,_command_rx_val
	CPI  R26,LOW(0x6F)
	BRNE _0x9C
; 0000 029E                         #asm ("cli")
	cli
; 0000 029F                         ADC_PV_calibration_point2[rangeIndex]=adc_data;
	MOV  R30,R10
	LDI  R26,LOW(_ADC_PV_calibration_point2)
	LDI  R27,HIGH(_ADC_PV_calibration_point2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
	CALL __EEPROMWRW
; 0000 02A0                         calibration_point2=adc_data;
	__GETWRMN 7,8,0,_adc_data
; 0000 02A1                         CalibrationConfigChanged=1;
	LDI  R26,LOW(_CalibrationConfigChanged)
	LDI  R27,HIGH(_CalibrationConfigChanged)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 02A2                         #asm ("sei")
	sei
; 0000 02A3                         CalculateCalibrationRates();
	RCALL _CalculateCalibrationRates
; 0000 02A4                         }
; 0000 02A5 check_sum=check_sum^rx_buffer0[i];
_0x9C:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	EOR  R30,R26
	EOR  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 02A6 i++;
	SUBI R17,-1
; 0000 02A7 com_bytes_rx=rx_buffer0[i];                    //количество байт, зная их проверяем число байт данных и если оно не совпадает, диагностируем как раз-таки ошибку формирования фрейма 0х9000
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	STS  _com_bytes_rx,R30
; 0000 02A8 check_sum=check_sum^rx_buffer0[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	EOR  R30,R26
	EOR  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 02A9 i++;
	SUBI R17,-1
; 0000 02AA tmp_i=i;
	MOV  R21,R17
; 0000 02AB j=tmp_i;
	MOV  R16,R21
; 0000 02AC for (i=tmp_i;i<tmp_i+com_bytes_rx;i++)
	MOV  R17,R21
_0x9E:
	MOV  R26,R21
	CLR  R27
	LDS  R30,_com_bytes_rx
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x9F
; 0000 02AD        {
; 0000 02AE        j++;
	SUBI R16,-1
; 0000 02AF        com_data_rx[k]=rx_buffer0[i];
	MOV  R26,R19
	LDI  R27,0
	SUBI R26,LOW(-_com_data_rx)
	SBCI R27,HIGH(-_com_data_rx)
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	ST   X,R30
; 0000 02B0        check_sum=check_sum^rx_buffer0[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	EOR  R30,R26
	EOR  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 02B1        k++;
	SUBI R19,-1
; 0000 02B2        }
	SUBI R17,-1
	RJMP _0x9E
_0x9F:
; 0000 02B3                 //j++;
; 0000 02B4 //        if(com_bytes_rx!=0)i--;
; 0000 02B5 if (j!=i)
	CP   R17,R16
	BREQ _0xA0
; 0000 02B6        {checking_result=0x90;
	LDI  R30,LOW(144)
	STS  _checking_result,R30
; 0000 02B7        //return checking_result;
; 0000 02B8        }
; 0000 02B9 //i++;
; 0000 02BA if(rx_buffer0[i]!=check_sum)
_0xA0:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R26,Z
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0xA1
; 0000 02BB         {
; 0000 02BC         checking_result=0x88;
	LDI  R30,LOW(136)
	STS  _checking_result,R30
; 0000 02BD         //return checking_result;
; 0000 02BE         }
; 0000 02BF return checking_result;
_0xA1:
_0x2080002:
	LDS  R30,_checking_result
	LDI  R31,0
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; 0000 02C0 }
;
;void clear_buffer()
; 0000 02C3 {
_clear_buffer:
; 0000 02C4 char i=0;
; 0000 02C5 for (i=0;i<RX_BUFFER_SIZE0;i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	LDI  R17,LOW(0)
_0xA3:
	CPI  R17,64
	BRSH _0xA4
; 0000 02C6         {
; 0000 02C7         rx_buffer0[i]=0;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 02C8         tx_buffer0[i]=0;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	STD  Z+0,R26
; 0000 02C9         }
	SUBI R17,-1
	RJMP _0xA3
_0xA4:
; 0000 02CA for (i=0;i<25;i++)
	LDI  R17,LOW(0)
_0xA6:
	CPI  R17,25
	BRSH _0xA7
; 0000 02CB         {
; 0000 02CC         com_data_rx[i]=0;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_com_data_rx)
	SBCI R31,HIGH(-_com_data_rx)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 02CD         Command_data[i]=0;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_Command_data)
	SBCI R31,HIGH(-_Command_data)
	STD  Z+0,R26
; 0000 02CE         }
	SUBI R17,-1
	RJMP _0xA6
_0xA7:
; 0000 02CF }
	LD   R17,Y+
	RET
;// Declare your global variables here
;void system_init_(char initVar){
; 0000 02D1 void system_init_(char initVar){
; 0000 02D2 #asm("wdr")
;	initVar -> Y+0
; 0000 02D3 WDTCSR=0x38;
; 0000 02D4 WDTCSR=0x0E;
; 0000 02D5 // Crystal Oscillator division factor: 1
; 0000 02D6 /*#pragma optsize-
; 0000 02D7 CLKPR=0x80;
; 0000 02D8 CLKPR=0x00;
; 0000 02D9 #ifdef _OPTIMIZE_SIZE_
; 0000 02DA #pragma optsize+
; 0000 02DB #endif
; 0000 02DC   */
; 0000 02DD // Input/Output Ports initialization
; 0000 02DE // Port B initialization
; 0000 02DF // Func7=In Func6=In Func5=Out Func4=In Func3=Out Func2=Out Func1=In Func0=In
; 0000 02E0 // State7=T State6=T State5=0 State4=T State3=0 State2=0 State1=T State0=T
; 0000 02E1 PORTB=0x00;
; 0000 02E2 DDRB=0x2c;
; 0000 02E3 
; 0000 02E4 // Port C initialization
; 0000 02E5 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 02E6 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 02E7 PORTC=0x00;
; 0000 02E8 DDRC=0x00;
; 0000 02E9 
; 0000 02EA // Port D initialization
; 0000 02EB // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 02EC // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 02ED //PORTD=0x00;
; 0000 02EE DDRD.3=1;
; 0000 02EF PORTD.3=1;
; 0000 02F0 DDRD.6=1;
; 0000 02F1 DDRD.7=1;
; 0000 02F2 PORTD.6=0;
; 0000 02F3 PORTD.7=0;
; 0000 02F4 // Timer/Counter 0 initialization
; 0000 02F5 // Clock source: System Clock
; 0000 02F6 // Clock value: Timer 0 Stopped
; 0000 02F7 // Mode: Normal top=FFh
; 0000 02F8 // OC0A output: Disconnected
; 0000 02F9 // OC0B output: Disconnected
; 0000 02FA //TCCR0A=0x00;
; 0000 02FB //TCCR0B=0x04;
; 0000 02FC //TCNT0=0xA5;
; 0000 02FD //OCR0A=0x00;
; 0000 02FE //OCR0B=0x00;
; 0000 02FF stop_wait_Rx_timer;
; 0000 0300 /*USART predefinition: 1200 baud rate, tx enable, all interrutpts enabled 8bit buffer*/
; 0000 0301 UCSR0A=0x00;
; 0000 0302 UCSR0B=0xc0;
; 0000 0303 UCSR0C=0x06;
; 0000 0304 UBRR0H=0x00;
; 0000 0305 UBRR0L=0x17;
; 0000 0306 
; 0000 0307 // Timer/Counter 1 initialization
; 0000 0308 // Clock source: System Clock
; 0000 0309 // Clock value: Timer 1 Stopped
; 0000 030A // Mode: Normal top=FFFFh
; 0000 030B // OC1A output: Discon.
; 0000 030C // OC1B output: Discon.
; 0000 030D // Noise Canceler: Off
; 0000 030E // Input Capture on Falling Edge
; 0000 030F // Timer 1 Overflow Interrupt: Off
; 0000 0310 // Input Capture Interrupt: Off
; 0000 0311 // Compare A Match Interrupt: Off
; 0000 0312 // Compare B Match Interrupt: Off
; 0000 0313 TCCR1A=0x00;
; 0000 0314 TCCR1B=0x00;
; 0000 0315 TCNT1H=0x00;
; 0000 0316 TCNT1L=0x00;
; 0000 0317 ICR1H=0x00;
; 0000 0318 ICR1L=0x00;
; 0000 0319 OCR1AH=0x00;
; 0000 031A OCR1AL=0x00;
; 0000 031B OCR1BH=0x00;
; 0000 031C OCR1BL=0x00;
; 0000 031D 
; 0000 031E // Timer/Counter 2 initialization
; 0000 031F // Clock source: System Clock
; 0000 0320 // Clock value: Timer 2 Stopped
; 0000 0321 // Mode: Normal top=FFh
; 0000 0322 // OC2A output: Disconnected
; 0000 0323 // OC2B output: Disconnected
; 0000 0324 ASSR=0x00;
; 0000 0325 TCCR2A=0x00;
; 0000 0326 TCCR2B=0x00;
; 0000 0327 TCNT2=0x00;
; 0000 0328 OCR2A=0x00;
; 0000 0329 OCR2B=0x00;
; 0000 032A 
; 0000 032B // External Interrupt(s) initialization
; 0000 032C // INT0: On
; 0000 032D // INT0 Mode: Any change
; 0000 032E // INT1: Off
; 0000 032F // Interrupt on any change on pins PCINT0-7: Off
; 0000 0330 // Interrupt on any change on pins PCINT8-14: Off
; 0000 0331 // Interrupt on any change on pins PCINT16-23: Off
; 0000 0332 wait_startOCD;
; 0000 0333 EIMSK=0x01;
; 0000 0334 EIFR=0x01;
; 0000 0335 PCICR=0x00;
; 0000 0336 
; 0000 0337 
; 0000 0338 // Timer/Counter 0 Interrupt(s) initialization
; 0000 0339 TIMSK0=0x00;
; 0000 033A // Timer/Counter 1 Interrupt(s) initialization
; 0000 033B TIMSK1=0x00;
; 0000 033C // Timer/Counter 2 Interrupt(s) initialization
; 0000 033D TIMSK2=0x00;
; 0000 033E 
; 0000 033F // Analog Comparator initialization
; 0000 0340 // Analog Comparator: Off
; 0000 0341 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0342 ACSR=0x80;
; 0000 0343 ADCSRB=0x00;
; 0000 0344 
; 0000 0345 // ADC initialization
; 0000 0346 // ADC Clock frequency: 230,400 kHz
; 0000 0347 // ADC Voltage Reference: AREF pin
; 0000 0348 // ADC Auto Trigger Source: Free Running
; 0000 0349 // Digital input buffers on ADC0: On, ADC1: Off, ADC2: Off, ADC3: Off
; 0000 034A // ADC4: Off, ADC5: Off
; 0000 034B if(initVar==1)
; 0000 034C {
; 0000 034D DIDR0=0x3f;
; 0000 034E ADMUX=0x20;
; 0000 034F ADCSRA=0xcf;
; 0000 0350 ADCSRB=ADCSRB||0x00;
; 0000 0351 }
; 0000 0352 else
; 0000 0353 {
; 0000 0354 DIDR0=0x3f;
; 0000 0355 ADMUX=0x00;
; 0000 0356 ADCSRA=0x0f;
; 0000 0357 ADCSRB=ADCSRB||0x00;
; 0000 0358 
; 0000 0359 }
; 0000 035A // SPI initialization
; 0000 035B // SPI Type: Master
; 0000 035C // SPI Clock Rate: 2*115,200 kHz
; 0000 035D // SPI Clock Phase: Cycle Half
; 0000 035E // SPI Clock Polarity: Low
; 0000 035F // SPI Data Order: MSB First
; 0000 0360 SPCR=0x53;
; 0000 0361 SPSR=0x00;
; 0000 0362 //SPDR=0x00;
; 0000 0363 //enable_SPI;
; 0000 0364 }
;
;void system_init(){
; 0000 0366 void system_init(){
_system_init:
; 0000 0367 #asm("wdr")
	wdr
; 0000 0368 WDTCSR=0x38;
	LDI  R30,LOW(56)
	STS  96,R30
; 0000 0369 WDTCSR=0x0E;
	LDI  R30,LOW(14)
	STS  96,R30
; 0000 036A // Crystal Oscillator division factor: 1
; 0000 036B /*#pragma optsize-
; 0000 036C CLKPR=0x80;
; 0000 036D CLKPR=0x00;
; 0000 036E #ifdef _OPTIMIZE_SIZE_
; 0000 036F #pragma optsize+
; 0000 0370 #endif
; 0000 0371   */
; 0000 0372 // Input/Output Ports initialization
; 0000 0373 // Port B initialization
; 0000 0374 // Func7=In Func6=In Func5=Out Func4=In Func3=Out Func2=Out Func1=In Func0=In
; 0000 0375 // State7=T State6=T State5=0 State4=T State3=0 State2=0 State1=T State0=T
; 0000 0376 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 0377 DDRB=0x2c;
	LDI  R30,LOW(44)
	OUT  0x4,R30
; 0000 0378 
; 0000 0379 // Port C initialization
; 0000 037A // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 037B // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 037C PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 037D DDRC=0x00;
	OUT  0x7,R30
; 0000 037E 
; 0000 037F // Port D initialization
; 0000 0380 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0381 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0382 //PORTD=0x00;
; 0000 0383 DDRD.3=1;
	SBI  0xA,3
; 0000 0384 PORTD.3=1;
	SBI  0xB,3
; 0000 0385 DDRD.6=1;
	SBI  0xA,6
; 0000 0386 DDRD.7=1;
	SBI  0xA,7
; 0000 0387 PORTD.6=0;
	CBI  0xB,6
; 0000 0388 PORTD.7=0;
	CBI  0xB,7
; 0000 0389 // Timer/Counter 0 initialization
; 0000 038A // Clock source: System Clock
; 0000 038B // Clock value: Timer 0 Stopped
; 0000 038C // Mode: Normal top=FFh
; 0000 038D // OC0A output: Disconnected
; 0000 038E // OC0B output: Disconnected
; 0000 038F //TCCR0A=0x00;
; 0000 0390 //TCCR0B=0x04;
; 0000 0391 //TCNT0=0xA5;
; 0000 0392 //OCR0A=0x00;
; 0000 0393 //OCR0B=0x00;
; 0000 0394 stop_wait_Rx_timer;
	STS  110,R30
	OUT  0x24,R30
	OUT  0x25,R30
	OUT  0x26,R30
; 0000 0395 /*USART predefinition: 1200 baud rate, tx enable, all interrutpts enabled 8bit buffer*/
; 0000 0396 UCSR0A=0x00;
	STS  192,R30
; 0000 0397 UCSR0B=0xc0;
	LDI  R30,LOW(192)
	STS  193,R30
; 0000 0398 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 0399 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 039A UBRR0L=0x17;
	LDI  R30,LOW(23)
	STS  196,R30
; 0000 039B 
; 0000 039C // Timer/Counter 1 initialization
; 0000 039D // Clock source: System Clock
; 0000 039E // Clock value: Timer 1 Stopped
; 0000 039F // Mode: Normal top=FFFFh
; 0000 03A0 // OC1A output: Discon.
; 0000 03A1 // OC1B output: Discon.
; 0000 03A2 // Noise Canceler: Off
; 0000 03A3 // Input Capture on Falling Edge
; 0000 03A4 // Timer 1 Overflow Interrupt: Off
; 0000 03A5 // Input Capture Interrupt: Off
; 0000 03A6 // Compare A Match Interrupt: Off
; 0000 03A7 // Compare B Match Interrupt: Off
; 0000 03A8 TCCR1A=0x00;
	LDI  R30,LOW(0)
	STS  128,R30
; 0000 03A9 TCCR1B=0x00;
	STS  129,R30
; 0000 03AA TCNT1H=0x00;
	STS  133,R30
; 0000 03AB TCNT1L=0x00;
	STS  132,R30
; 0000 03AC ICR1H=0x00;
	STS  135,R30
; 0000 03AD ICR1L=0x00;
	STS  134,R30
; 0000 03AE OCR1AH=0x00;
	STS  137,R30
; 0000 03AF OCR1AL=0x00;
	STS  136,R30
; 0000 03B0 OCR1BH=0x00;
	STS  139,R30
; 0000 03B1 OCR1BL=0x00;
	STS  138,R30
; 0000 03B2 
; 0000 03B3 // Timer/Counter 2 initialization
; 0000 03B4 // Clock source: System Clock
; 0000 03B5 // Clock value: Timer 2 Stopped
; 0000 03B6 // Mode: Normal top=FFh
; 0000 03B7 // OC2A output: Disconnected
; 0000 03B8 // OC2B output: Disconnected
; 0000 03B9 ASSR=0x00;
	STS  182,R30
; 0000 03BA TCCR2A=0x00;
	STS  176,R30
; 0000 03BB TCCR2B=0x00;
	STS  177,R30
; 0000 03BC TCNT2=0x00;
	STS  178,R30
; 0000 03BD OCR2A=0x00;
	STS  179,R30
; 0000 03BE OCR2B=0x00;
	STS  180,R30
; 0000 03BF 
; 0000 03C0 // External Interrupt(s) initialization
; 0000 03C1 // INT0: On
; 0000 03C2 // INT0 Mode: Any change
; 0000 03C3 // INT1: Off
; 0000 03C4 // Interrupt on any change on pins PCINT0-7: Off
; 0000 03C5 // Interrupt on any change on pins PCINT8-14: Off
; 0000 03C6 // Interrupt on any change on pins PCINT16-23: Off
; 0000 03C7 wait_startOCD;
	LDI  R30,LOW(3)
	STS  105,R30
; 0000 03C8 EIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x1D,R30
; 0000 03C9 EIFR=0x01;
	OUT  0x1C,R30
; 0000 03CA PCICR=0x00;
	LDI  R30,LOW(0)
	STS  104,R30
; 0000 03CB 
; 0000 03CC 
; 0000 03CD // Timer/Counter 0 Interrupt(s) initialization
; 0000 03CE TIMSK0=0x00;
	STS  110,R30
; 0000 03CF // Timer/Counter 1 Interrupt(s) initialization
; 0000 03D0 TIMSK1=0x00;
	STS  111,R30
; 0000 03D1 // Timer/Counter 2 Interrupt(s) initialization
; 0000 03D2 TIMSK2=0x00;
	STS  112,R30
; 0000 03D3 
; 0000 03D4 // Analog Comparator initialization
; 0000 03D5 // Analog Comparator: Off
; 0000 03D6 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 03D7 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 03D8 ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 03D9 
; 0000 03DA // ADC initialization
; 0000 03DB // ADC Clock frequency: 230,400 kHz
; 0000 03DC // ADC Voltage Reference: AREF pin
; 0000 03DD // ADC Auto Trigger Source: Free Running
; 0000 03DE // Digital input buffers on ADC0: On, ADC1: Off, ADC2: Off, ADC3: Off
; 0000 03DF // ADC4: Off, ADC5: Off
; 0000 03E0 DIDR0=0x3f;
	LDI  R30,LOW(63)
	STS  126,R30
; 0000 03E1 ADMUX=0x20;
	LDI  R30,LOW(32)
	STS  124,R30
; 0000 03E2 ADCSRA=0xcf;
	LDI  R30,LOW(207)
	STS  122,R30
; 0000 03E3 ADCSRB=ADCSRB||0x00;
	LDS  R30,123
	CPI  R30,0
	BRNE _0xC6
	LDI  R30,LOW(0)
	CPI  R30,0
	BRNE _0xC6
	LDI  R30,0
	RJMP _0xC7
_0xC6:
	LDI  R30,1
_0xC7:
	STS  123,R30
; 0000 03E4 
; 0000 03E5 // SPI initialization
; 0000 03E6 // SPI Type: Master
; 0000 03E7 // SPI Clock Rate: 2*115,200 kHz
; 0000 03E8 // SPI Clock Phase: Cycle Half
; 0000 03E9 // SPI Clock Polarity: Low
; 0000 03EA // SPI Data Order: MSB First
; 0000 03EB SPCR=0x53;
	LDI  R30,LOW(83)
	OUT  0x2C,R30
; 0000 03EC SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 03ED //SPDR=0x00;
; 0000 03EE //enable_SPI;
; 0000 03EF }
	RET
;
;void update_dynamic_vars()
; 0000 03F2 {
_update_dynamic_vars:
; 0000 03F3 float DAC_zero_current, DAC_measured_current, Lower_Range_value, Upper_Range_value,tmp;
; 0000 03F4 char i,j=0;
; 0000 03F5 long tmp_adc=0;
; 0000 03F6 
; 0000 03F7 union DAC_char_to_float
; 0000 03F8         {
; 0000 03F9         float value_float;
; 0000 03FA         char value_char[4];
; 0000 03FB         }DAC_val;
; 0000 03FC 
; 0000 03FD for (i=0;i<4;i++)
	SBIW R28,28
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+5,R30
	STD  Y+6,R30
	STD  Y+7,R30
	ST   -Y,R17
	ST   -Y,R16
;	DAC_zero_current -> Y+26
;	DAC_measured_current -> Y+22
;	Lower_Range_value -> Y+18
;	Upper_Range_value -> Y+14
;	tmp -> Y+10
;	i -> R17
;	j -> R16
;	tmp_adc -> Y+6
;	DAC_char_to_float -> Y+30
;	DAC_val -> Y+2
	LDI  R16,0
	LDI  R17,LOW(0)
_0xC9:
	CPI  R17,4
	BRSH _0xCA
; 0000 03FE         {
; 0000 03FF          DAC_val.value_char[i]=Parameter_bank[88+i];
	MOV  R30,R17
	LDI  R31,0
	MOVW R22,R30
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R22
	__ADDW1MN _Parameter_bank,88
	MOVW R26,R30
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
; 0000 0400          if(i==3)
	CPI  R17,3
	BRNE _0xCB
; 0000 0401                 {
; 0000 0402                 Upper_Range_value=DAC_val.value_float;
	__GETD1S 2
	__PUTD1S 14
; 0000 0403                 }
; 0000 0404         }
_0xCB:
	SUBI R17,-1
	RJMP _0xC9
_0xCA:
; 0000 0405 for (i=0;i<4;i++)
	LDI  R17,LOW(0)
_0xCD:
	CPI  R17,4
	BRSH _0xCE
; 0000 0406         {
; 0000 0407          DAC_val.value_char[i]=Parameter_bank[92+i];
	MOV  R30,R17
	LDI  R31,0
	MOVW R22,R30
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R22
	__ADDW1MN _Parameter_bank,92
	MOVW R26,R30
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
; 0000 0408          if(i==3)
	CPI  R17,3
	BRNE _0xCF
; 0000 0409                 {
; 0000 040A                 Lower_Range_value=DAC_val.value_float;
	__GETD1S 2
	__PUTD1S 18
; 0000 040B                 }
; 0000 040C         }
_0xCF:
	SUBI R17,-1
	RJMP _0xCD
_0xCE:
; 0000 040D 
; 0000 040E for (i=0;i<4;i++)
	LDI  R17,LOW(0)
_0xD1:
	CPI  R17,4
	BRSH _0xD2
; 0000 040F         {
; 0000 0410          DAC_val.value_char[i]=Parameter_bank[105+i];
	MOV  R30,R17
	LDI  R31,0
	MOVW R22,R30
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R22
	__ADDW1MN _Parameter_bank,105
	MOVW R26,R30
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
; 0000 0411          if(i==3)
	CPI  R17,3
	BRNE _0xD3
; 0000 0412                 {
; 0000 0413                 DAC_zero_current=DAC_val.value_float;
	__GETD1S 2
	__PUTD1S 26
; 0000 0414                 }
; 0000 0415         }
_0xD3:
	SUBI R17,-1
	RJMP _0xD1
_0xD2:
; 0000 0416 for (i=0;i<4;i++)
	LDI  R17,LOW(0)
_0xD5:
	CPI  R17,4
	BRSH _0xD6
; 0000 0417         {
; 0000 0418          DAC_val.value_char[i]=Parameter_bank[109+i];
	MOV  R30,R17
	LDI  R31,0
	MOVW R22,R30
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R22
	__ADDW1MN _Parameter_bank,109
	MOVW R26,R30
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
; 0000 0419          if(i==3)
	CPI  R17,3
	BRNE _0xD7
; 0000 041A                 {
; 0000 041B                 DAC_measured_current=DAC_val.value_float;
	__GETD1S 2
	__PUTD1S 22
; 0000 041C                 }
; 0000 041D         }
_0xD7:
	SUBI R17,-1
	RJMP _0xD5
_0xD6:
; 0000 041E //коэффициент преобразования кода ЦАП в ток, равен отношению приращения тока к приращению битового кода АЦП
; 0000 041F if(adc_data<=0)tmp_adc=0;
	LDS  R26,_adc_data
	LDS  R27,_adc_data+1
	LDS  R24,_adc_data+2
	LDS  R25,_adc_data+3
	CALL __CPD02
	BRGE _0x122
; 0000 0420 //if(adc_data>ADC_PV_calibration_point1)//для калиброванного значения на 4.8 мА
; 0000 0421 //else
; 0000 0422 else
; 0000 0423 {
; 0000 0424 //CalculateCalibrationRates();
; 0000 0425 tmp_adc=(long)((float)((float)(adc_data)/calibrationK) - (float)calibrationB);
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
	LDS  R22,_adc_data+2
	LDS  R23,_adc_data+3
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_calibrationK
	LDS  R31,_calibrationK+1
	LDS  R22,_calibrationK+2
	LDS  R23,_calibrationK+3
	CALL __DIVF21
	LDS  R26,_calibrationB
	LDS  R27,_calibrationB+1
	LDS  R24,_calibrationB+2
	LDS  R25,_calibrationB+3
	CALL __SUBF12
	CALL __CFD1
	__PUTD1S 6
; 0000 0426 //tmp_adc=(long)((float)tmp_adc*1.118);
; 0000 0427 if(tmp_adc>0xffc0)tmp_adc=0xffc0;
	__GETD2S 6
	__CPD2N 0xFFC1
	BRLT _0xDA
	__GETD1N 0xFFC0
	__PUTD1S 6
; 0000 0428 if(tmp_adc<0x0000)tmp_adc=0x0000;
_0xDA:
	LDD  R26,Y+9
	TST  R26
	BRPL _0xDB
_0x122:
	LDI  R30,LOW(0)
	__CLRD1S 6
; 0000 0429 }
_0xDB:
; 0000 042A /*        {
; 0000 042B         tmp_adc=(long)(adc_data-calibration_point1)*((float)(calibration_point2/(calibration_point2-calibration_point1)));//+ADC_PV_calibration_point;
; 0000 042C         DAC_zero_current = 4.8;
; 0000 042D         DAC_data=((long)(tmp_adc*((DAC_measured_current-DAC_zero_current)/16))+(signed int)((DAC_zero_current)/mamps_toDAC_default_ratio));
; 0000 042E         }
; 0000 042F else
; 0000 0430         {
; 0000 0431          if(adc_data<=ADC_PV_zero_val)adc_data=0;
; 0000 0432          else
; 0000 0433                 {
; 0000 0434                 tmp_adc=(long)(adc_data-ADC_PV_zero_val)*((float)(calibration_point2/(calibration_point2-ADC_PV_zero_val)));
; 0000 0435                 }
; 0000 0436 
; 0000 0437         }
; 0000 0438         */
; 0000 0439 DAC_data=((long)(tmp_adc*((DAC_measured_current-DAC_zero_current)/16))+(signed int)((DAC_zero_current)/mamps_toDAC_default_ratio));
	__GETD2S 26
	__GETD1S 22
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41800000
	CALL __DIVF21
	__GETD2S 6
	CALL __CDF2
	CALL __MULF12
	CALL __CFD1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 26
	__GETD1N 0x39802008
	CALL __DIVF21
	CALL __CFD1
	CLR  R22
	CLR  R23
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CWD1
	CALL __ADDD12
	STS  _DAC_data,R30
	STS  _DAC_data+1,R31
	STS  _DAC_data+2,R22
	STS  _DAC_data+3,R23
; 0000 043A if(DAC_data<=DAC_zero_current)DAC_data=DAC_zero_current;
	__GETD1S 26
	LDS  R26,_DAC_data
	LDS  R27,_DAC_data+1
	LDS  R24,_DAC_data+2
	LDS  R25,_DAC_data+3
	CALL __CDF2
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0xDC
	__GETD1S 26
	LDI  R26,LOW(_DAC_data)
	LDI  R27,HIGH(_DAC_data)
	CALL __CFD1
	CALL __PUTDP1
; 0000 043B dynamic_variables[1]=(float)DAC_data*mamps_toDAC_default_ratio;//adc_data*mamps_toDAC_default_ratio;//current, mA - ток
_0xDC:
	LDS  R30,_DAC_data
	LDS  R31,_DAC_data+1
	LDS  R22,_DAC_data+2
	LDS  R23,_DAC_data+3
	CALL __CDF1
	__GETD2N 0x39802008
	CALL __MULF12
	__PUTD1MN _dynamic_variables,4
; 0000 043C dynamic_variables[2]=(float)(100*(dynamic_variables[1]-DAC_zero_current)/(DAC_measured_current-DAC_zero_current));
	__GETD1MN _dynamic_variables,4
	__GETD2S 26
	CALL __SUBF12
	__GETD2N 0x42C80000
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 26
	__GETD1S 22
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	__PUTD1MN _dynamic_variables,8
; 0000 043D tmp = Upper_Range_value-Lower_Range_value;
	__GETD2S 18
	__GETD1S 14
	CALL __SUBF12
	__PUTD1S 10
; 0000 043E if(tmp==10)
	__GETD2S 10
	__CPD2N 0x41200000
	BRNE _0xDD
; 0000 043F     {
; 0000 0440     Parameter_bank[12]= 10;
	__POINTW2MN _Parameter_bank,12
	LDI  R30,LOW(10)
	CALL __EEPROMWRB
; 0000 0441     setlevel_0_10;
	CBI  0xB,7
	CBI  0xB,6
; 0000 0442     rangeIndex = 0;
	CLR  R10
; 0000 0443     }
; 0000 0444 if(tmp==20)
_0xDD:
	__GETD2S 10
	__CPD2N 0x41A00000
	BRNE _0xE2
; 0000 0445     {
; 0000 0446     Parameter_bank[12]= 20;
	__POINTW2MN _Parameter_bank,12
	LDI  R30,LOW(20)
	CALL __EEPROMWRB
; 0000 0447     setlevel_0_20;
	CBI  0xB,7
	SBI  0xB,6
; 0000 0448     rangeIndex = 1;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 0449     }
; 0000 044A if(tmp==30)
_0xE2:
	__GETD2S 10
	__CPD2N 0x41F00000
	BRNE _0xE7
; 0000 044B     {
; 0000 044C     Parameter_bank[12]=30;
	__POINTW2MN _Parameter_bank,12
	LDI  R30,LOW(30)
	CALL __EEPROMWRB
; 0000 044D    setlevel_0_30;
	SBI  0xB,7
	CBI  0xB,6
; 0000 044E    rangeIndex = 2;
	LDI  R30,LOW(2)
	MOV  R10,R30
; 0000 044F     }
; 0000 0450 if(tmp==50)
_0xE7:
	__GETD2S 10
	__CPD2N 0x42480000
	BRNE _0xEC
; 0000 0451     {
; 0000 0452     Parameter_bank[12]= 50;
	__POINTW2MN _Parameter_bank,12
	LDI  R30,LOW(50)
	CALL __EEPROMWRB
; 0000 0453     setlevel_0_50;
	SBI  0xB,7
	SBI  0xB,6
; 0000 0454     rangeIndex = 3;
	LDI  R30,LOW(3)
	MOV  R10,R30
; 0000 0455     }
; 0000 0456 if(rangeIndexEep!=rangeIndex)
_0xEC:
	LDI  R26,LOW(_rangeIndexEep)
	LDI  R27,HIGH(_rangeIndexEep)
	CALL __EEPROMRDB
	CP   R10,R30
	BREQ _0xF1
; 0000 0457         {
; 0000 0458          //CalculateCalibrationRates();
; 0000 0459         calibrationB=calibrationBeep[rangeIndex];
	MOV  R30,R10
	LDI  R26,LOW(_calibrationBeep)
	LDI  R27,HIGH(_calibrationBeep)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDD
	STS  _calibrationB,R30
	STS  _calibrationB+1,R31
	STS  _calibrationB+2,R22
	STS  _calibrationB+3,R23
; 0000 045A         calibrationK=calibrationKeep[rangeIndex];
	MOV  R30,R10
	LDI  R26,LOW(_calibrationKeep)
	LDI  R27,HIGH(_calibrationKeep)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDD
	STS  _calibrationK,R30
	STS  _calibrationK+1,R31
	STS  _calibrationK+2,R22
	STS  _calibrationK+3,R23
; 0000 045B         rangeIndexEep=rangeIndex;
	MOV  R30,R10
	LDI  R26,LOW(_rangeIndexEep)
	LDI  R27,HIGH(_rangeIndexEep)
	CALL __EEPROMWRB
; 0000 045C 
; 0000 045D         }
; 0000 045E dynamic_variables[0]=(float)dynamic_variables[2]*(float)((tmp)/100);//100;////primary variable (PV) - виброскорость
_0xF1:
	__GETD2S 10
	__GETD1N 0x42C80000
	CALL __DIVF21
	__GETD2MN _dynamic_variables,8
	CALL __MULF12
	STS  _dynamic_variables,R30
	STS  _dynamic_variables+1,R31
	STS  _dynamic_variables+2,R22
	STS  _dynamic_variables+3,R23
; 0000 045F }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,30
	RET
;
;void CalculateCalibrationRates()
; 0000 0462 {
_CalculateCalibrationRates:
; 0000 0463 
; 0000 0464 unsigned int calibration_div = 0xf2f7;//0xe4c0;//0xe600;
; 0000 0465 unsigned int calibrationBasic5val = 0x0cc9;
; 0000 0466 //unsigned int calibrationBasic95val = 0xe4c0;
; 0000 0467 //#asm("cli");
; 0000 0468 tmp_calibration =calibration_point2 - calibration_point1;
	CALL __SAVELOCR4
;	calibration_div -> R16,R17
;	calibrationBasic5val -> R18,R19
	__GETWRN 16,17,-3337
	__GETWRN 18,19,3273
	__GETW1R 7,8
	SUB  R30,R5
	SBC  R31,R6
	__PUTW1R 11,12
; 0000 0469 calibrationK = (float)(tmp_calibration/62199.00);//58560.00);//58880.00);
	__GETW1R 11,12
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4772F700
	CALL __DIVF21
	STS  _calibrationK,R30
	STS  _calibrationK+1,R31
	STS  _calibrationK+2,R22
	STS  _calibrationK+3,R23
; 0000 046A calibrationKeep[rangeIndex] =  calibrationK;
	MOV  R30,R10
	LDI  R26,LOW(_calibrationKeep)
	LDI  R27,HIGH(_calibrationKeep)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_calibrationK
	LDS  R31,_calibrationK+1
	LDS  R22,_calibrationK+2
	LDS  R23,_calibrationK+3
	CALL __EEPROMWRD
; 0000 046B //calibrK = ((tmp_calibration*1000/calibration_div)) ;
; 0000 046C calibrationB = (float)((float)calibration_point1-(float)(calibrationK*calibrationBasic5val)) ;
	__GETW1R 5,6
	CLR  R22
	CLR  R23
	CALL __CDF1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R18
	LDS  R26,_calibrationK
	LDS  R27,_calibrationK+1
	LDS  R24,_calibrationK+2
	LDS  R25,_calibrationK+3
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __SWAPD12
	CALL __SUBF12
	STS  _calibrationB,R30
	STS  _calibrationB+1,R31
	STS  _calibrationB+2,R22
	STS  _calibrationB+3,R23
; 0000 046D calibrationBeep[rangeIndex] = calibrationB;
	MOV  R30,R10
	LDI  R26,LOW(_calibrationBeep)
	LDI  R27,HIGH(_calibrationBeep)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_calibrationB
	LDS  R31,_calibrationB+1
	LDS  R22,_calibrationB+2
	LDS  R23,_calibrationB+3
	CALL __EEPROMWRD
; 0000 046E //#asm("sei");
; 0000 046F }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;
;
;void ResetDeviceSettings(char notreset)
; 0000 0473 {
_ResetDeviceSettings:
; 0000 0474 int i=0;
; 0000 0475 for(i =0; i<139;i++)
	ST   -Y,R17
	ST   -Y,R16
;	notreset -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
	__GETWRN 16,17,0
_0xF3:
	__CPWRN 16,17,139
	BRGE _0xF4
; 0000 0476         {
; 0000 0477         if (i==98)i=100;
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0xF5
	__GETWRN 16,17,100
; 0000 0478         else Parameter_bank[i]=Parameter_defaults[i];
	RJMP _0xF6
_0xF5:
	MOVW R30,R16
	SUBI R30,LOW(-_Parameter_bank)
	SBCI R31,HIGH(-_Parameter_bank)
	MOVW R0,R30
	LDI  R26,LOW(_Parameter_defaults)
	LDI  R27,HIGH(_Parameter_defaults)
	ADD  R26,R16
	ADC  R27,R17
	CALL __EEPROMRDB
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 0479         }
_0xF6:
	__ADDWRN 16,17,1
	RJMP _0xF3
_0xF4:
; 0000 047A         for (i=0; i<4; i++)
	__GETWRN 16,17,0
_0xF8:
	__CPWRN 16,17,4
	BRGE _0xF9
; 0000 047B         {
; 0000 047C         calibrationBeep[i]=0;
	MOVW R30,R16
	LDI  R26,LOW(_calibrationBeep)
	LDI  R27,HIGH(_calibrationBeep)
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	__GETD1N 0x0
	CALL __EEPROMWRD
; 0000 047D         calibrationKeep[i]=1;
	MOVW R30,R16
	LDI  R26,LOW(_calibrationKeep)
	LDI  R27,HIGH(_calibrationKeep)
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	__GETD1N 0x3F800000
	CALL __EEPROMWRD
; 0000 047E         ADC_PV_calibration_point1[i] = 0x0cc9;//0x0bc0; //0x0cc0;
	MOVW R30,R16
	LDI  R26,LOW(_ADC_PV_calibration_point1)
	LDI  R27,HIGH(_ADC_PV_calibration_point1)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(3273)
	LDI  R31,HIGH(3273)
	CALL __EEPROMWRW
; 0000 047F         ADC_PV_calibration_point2[i] = 0xffc0;//0xe4c0; //0xf2c0;
	MOVW R30,R16
	LDI  R26,LOW(_ADC_PV_calibration_point2)
	LDI  R27,HIGH(_ADC_PV_calibration_point2)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(65472)
	LDI  R31,HIGH(65472)
	CALL __EEPROMWRW
; 0000 0480         }
	__ADDWRN 16,17,1
	RJMP _0xF8
_0xF9:
; 0000 0481         calibrationB=0;
	LDI  R30,LOW(0)
	STS  _calibrationB,R30
	STS  _calibrationB+1,R30
	STS  _calibrationB+2,R30
	STS  _calibrationB+3,R30
; 0000 0482         calibrationK=1;
	__GETD1N 0x3F800000
	STS  _calibrationK,R30
	STS  _calibrationK+1,R31
	STS  _calibrationK+2,R22
	STS  _calibrationK+3,R23
; 0000 0483         calibration_point1=0x0cc9;//0x0bc0;//0x0cc0;
	LDI  R30,LOW(3273)
	LDI  R31,HIGH(3273)
	__PUTW1R 5,6
; 0000 0484         calibration_point2=0xffc0;//0xe4c0;//0xf2c0;
	LDI  R30,LOW(65472)
	LDI  R31,HIGH(65472)
	__PUTW1R 7,8
; 0000 0485         rangeIndexEep=1;
	LDI  R26,LOW(_rangeIndexEep)
	LDI  R27,HIGH(_rangeIndexEep)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 0486         rangeIndex=rangeIndexEep;
	LDI  R26,LOW(_rangeIndexEep)
	LDI  R27,HIGH(_rangeIndexEep)
	CALL __EEPROMRDB
	MOV  R10,R30
; 0000 0487         //Upper_Range_value = 20;
; 0000 0488         //Lower_Range_value = 0;
; 0000 0489 }
	RJMP _0x2080001
;
;void PerformDeviceApplicationErase()
; 0000 048C {
_PerformDeviceApplicationErase:
; 0000 048D MCUCR = 0x01;
	LDI  R30,LOW(1)
	OUT  0x35,R30
; 0000 048E MCUCR = 0x02;
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 048F Parameter_bank[0]=0xee;
	LDI  R26,LOW(_Parameter_bank)
	LDI  R27,HIGH(_Parameter_bank)
	LDI  R30,LOW(238)
	CALL __EEPROMWRB
; 0000 0490 Parameter_bank[2]=0xa3;
	__POINTW2MN _Parameter_bank,2
	LDI  R30,LOW(163)
	CALL __EEPROMWRB
; 0000 0491 voidFuncPtr=(void(*)(void))0x1C00;   //адресс куда переходим
	LDI  R30,LOW(7168)
	LDI  R31,HIGH(7168)
	STS  _voidFuncPtr,R30
	STS  _voidFuncPtr+1,R31
; 0000 0492 voidFuncPtr();
	__CALL1MN _voidFuncPtr,0
; 0000 0493 }
	RET
;
;void LoadCalibrationSettings(char flag)
; 0000 0496 {
_LoadCalibrationSettings:
; 0000 0497 //#asm("cli");
; 0000 0498 int i=0;
; 0000 0499 if(flag==0x01)
	ST   -Y,R17
	ST   -Y,R16
;	flag -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0xFA
; 0000 049A         {
; 0000 049B         calibration_point1=ADC_PV_calibration_point1[rangeIndexEep];
	LDI  R26,LOW(_rangeIndexEep)
	LDI  R27,HIGH(_rangeIndexEep)
	CALL __EEPROMRDB
	LDI  R26,LOW(_ADC_PV_calibration_point1)
	LDI  R27,HIGH(_ADC_PV_calibration_point1)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	__PUTW1R 5,6
; 0000 049C         calibration_point2=ADC_PV_calibration_point2[rangeIndexEep];
	LDI  R26,LOW(_rangeIndexEep)
	LDI  R27,HIGH(_rangeIndexEep)
	CALL __EEPROMRDB
	LDI  R26,LOW(_ADC_PV_calibration_point2)
	LDI  R27,HIGH(_ADC_PV_calibration_point2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	__PUTW1R 7,8
; 0000 049D         calibrationB=calibrationBeep[rangeIndexEep];
	LDI  R26,LOW(_rangeIndexEep)
	LDI  R27,HIGH(_rangeIndexEep)
	CALL __EEPROMRDB
	LDI  R26,LOW(_calibrationBeep)
	LDI  R27,HIGH(_calibrationBeep)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDD
	STS  _calibrationB,R30
	STS  _calibrationB+1,R31
	STS  _calibrationB+2,R22
	STS  _calibrationB+3,R23
; 0000 049E         calibrationK=calibrationKeep[rangeIndexEep];
	LDI  R26,LOW(_rangeIndexEep)
	LDI  R27,HIGH(_rangeIndexEep)
	CALL __EEPROMRDB
	LDI  R26,LOW(_calibrationKeep)
	LDI  R27,HIGH(_calibrationKeep)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDD
	STS  _calibrationK,R30
	STS  _calibrationK+1,R31
	STS  _calibrationK+2,R22
	STS  _calibrationK+3,R23
; 0000 049F         rangeIndex=rangeIndexEep;
	LDI  R26,LOW(_rangeIndexEep)
	LDI  R27,HIGH(_rangeIndexEep)
	CALL __EEPROMRDB
	MOV  R10,R30
; 0000 04A0         }
; 0000 04A1 else
	RJMP _0xFB
_0xFA:
; 0000 04A2         {
; 0000 04A3         rangeIndexEep = 1;
	LDI  R26,LOW(_rangeIndexEep)
	LDI  R27,HIGH(_rangeIndexEep)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 04A4         rangeIndex = 1;
	MOV  R10,R30
; 0000 04A5         for (i=0; i<4; i++)
	__GETWRN 16,17,0
_0xFD:
	__CPWRN 16,17,4
	BRGE _0xFE
; 0000 04A6             {
; 0000 04A7             calibrationBeep[i]=0;
	MOVW R30,R16
	LDI  R26,LOW(_calibrationBeep)
	LDI  R27,HIGH(_calibrationBeep)
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	__GETD1N 0x0
	CALL __EEPROMWRD
; 0000 04A8             calibrationKeep[i]=1;
	MOVW R30,R16
	LDI  R26,LOW(_calibrationKeep)
	LDI  R27,HIGH(_calibrationKeep)
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	__GETD1N 0x3F800000
	CALL __EEPROMWRD
; 0000 04A9             ADC_PV_calibration_point1[i] = 0x0cc9;//0x0bc0; //0x0cc0;
	MOVW R30,R16
	LDI  R26,LOW(_ADC_PV_calibration_point1)
	LDI  R27,HIGH(_ADC_PV_calibration_point1)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(3273)
	LDI  R31,HIGH(3273)
	CALL __EEPROMWRW
; 0000 04AA             ADC_PV_calibration_point2[i] = 0xffc0;//0xe4c0; //0xf2c0;
	MOVW R30,R16
	LDI  R26,LOW(_ADC_PV_calibration_point2)
	LDI  R27,HIGH(_ADC_PV_calibration_point2)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(65472)
	LDI  R31,HIGH(65472)
	CALL __EEPROMWRW
; 0000 04AB             }
	__ADDWRN 16,17,1
	RJMP _0xFD
_0xFE:
; 0000 04AC         calibrationB=0;
	LDI  R30,LOW(0)
	STS  _calibrationB,R30
	STS  _calibrationB+1,R30
	STS  _calibrationB+2,R30
	STS  _calibrationB+3,R30
; 0000 04AD         calibrationK=1;
	__GETD1N 0x3F800000
	STS  _calibrationK,R30
	STS  _calibrationK+1,R31
	STS  _calibrationK+2,R22
	STS  _calibrationK+3,R23
; 0000 04AE         calibration_point1=0x0cc9;//0x0bc0;//0x0cc0;
	LDI  R30,LOW(3273)
	LDI  R31,HIGH(3273)
	__PUTW1R 5,6
; 0000 04AF         calibration_point2=0xffc0;//0xe4c0;//0xf2c0;
	LDI  R30,LOW(65472)
	LDI  R31,HIGH(65472)
	__PUTW1R 7,8
; 0000 04B0         }
_0xFB:
; 0000 04B1   //      #asm("sei");
; 0000 04B2 }
_0x2080001:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
;
;void main(void)
; 0000 04B5 {
_main:
; 0000 04B6 // Declare your local variables here
; 0000 04B7 //размещаем по адресу 0х00200(адрес указывается в словах, поэтому там будет в 2 раза меньше)
; 0000 04B8 
; 0000 04B9 int i,k=0;
; 0000 04BA int char_val=0x00,data, j = 0;
; 0000 04BB char dataH,dataL,crcok_flag=0;
; 0000 04BC 
; 0000 04BD //flash unsigned int* SERIAL = &serial_number;
; 0000 04BE crc = 0xffff;
	SBIW R28,7
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
;	i -> R16,R17
;	k -> R18,R19
;	char_val -> R20,R21
;	data -> Y+5
;	j -> Y+3
;	dataH -> Y+2
;	dataL -> Y+1
;	crcok_flag -> Y+0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	__PUTW1R 13,14
; 0000 04BF delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 04C0 Parameter_bank[0]=0x11;
	LDI  R26,LOW(_Parameter_bank)
	LDI  R27,HIGH(_Parameter_bank)
	LDI  R30,LOW(17)
	CALL __EEPROMWRB
; 0000 04C1 Parameter_bank[2]=0xB3;
	__POINTW2MN _Parameter_bank,2
	LDI  R30,LOW(179)
	CALL __EEPROMWRB
; 0000 04C2 //serial = 0xabcd;
; 0000 04C3 //#asm
; 0000 04C4 //    .CSEG
; 0000 04C5 //    .org    0x00080
; 0000 04C6 //    .DW 0xabcd, 0x0123
; 0000 04C7 //    .org    0x00082
; 0000 04C8 //    RET
; 0000 04C9 //    .org    0x38
; 0000 04CA //    serial1:  .BYTE 1
; 0000 04CB //    .org    0x39
; 0000 04CC //    serial2:  .BYTE 1
; 0000 04CD //    .org    0x4a
; 0000 04CE //    serial3:  .BYTE 1
; 0000 04CF    //.db 0xab, 0xcd , $ef , $77
; 0000 04D0   //   .org    0x00084
; 0000 04D1   //   RET
; 0000 04D2 //
; 0000 04D3    // .CSEG
; 0000 04D4 //#endasm
; 0000 04D5 //long serial = 0xabcdef12;
; 0000 04D6 //system_init(0);
; 0000 04D7  #asm("wdr")
	wdr
; 0000 04D8 while ((data<=65534)|(j<=16382))
_0xFF:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	CALL __LEW12U
	MOV  R0,R30
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDI  R30,LOW(16382)
	LDI  R31,HIGH(16382)
	CALL __LEW12
	OR   R30,R0
	BREQ _0x101
; 0000 04D9 {
; 0000 04DA    // if(j==0x1BDE)j+=2;//перескакиваем адрес с контрольной суммой для ПО загрузчика для ПК
; 0000 04DB     if(j==0xDEF)j++;
	CPI  R26,LOW(0xDEF)
	LDI  R30,HIGH(0xDEF)
	CPC  R27,R30
	BRNE _0x102
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ADIW R30,1
	STD  Y+3,R30
	STD  Y+3+1,R31
; 0000 04DC     data= read_program_memory (j);
_0x102:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _read_program_memory
	STD  Y+5,R30
	STD  Y+5+1,R31
; 0000 04DD     dataH = (int)data>>8;
	CALL __ASRW8
	STD  Y+2,R30
; 0000 04DE     dataL = data;
	LDD  R30,Y+5
	STD  Y+1,R30
; 0000 04DF     CRC_update(dataH);
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _CRC_update
; 0000 04E0     CRC_update(dataL);
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _CRC_update
; 0000 04E1     //crc_rtu(data);
; 0000 04E2     //j++;
; 0000 04E3     j=j+2;
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ADIW R30,2
	STD  Y+3,R30
	STD  Y+3+1,R31
; 0000 04E4 }
	RJMP _0xFF
_0x101:
; 0000 04E5 crceep = crc;
	__GETW1R 13,14
	LDI  R26,LOW(_crceep)
	LDI  R27,HIGH(_crceep)
	CALL __EEPROMWRW
; 0000 04E6 //if(crc==crcstatic)system_init(1);
; 0000 04E7 //else system_init(0);
; 0000 04E8  system_init();
	RCALL _system_init
; 0000 04E9 #asm
; 0000 04EA     in   r30,spsr
    in   r30,spsr
; 0000 04EB     in   r30,spdr
    in   r30,spdr
; 0000 04EC #endasm
; 0000 04ED //serial_address = *serial;
; 0000 04EE //normal_mode;
; 0000 04EF #asm("sei")
	sei
; 0000 04F0 
; 0000 04F1 setlevel_0_20;
	CBI  0xB,7
	SBI  0xB,6
; 0000 04F2 if(crceep==crcstatic)
	LDI  R26,LOW(_crceep)
	LDI  R27,HIGH(_crceep)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_crcstatic)
	LDI  R27,HIGH(_crcstatic)
	CALL __EEPROMRDW
	CP   R30,R0
	CPC  R31,R1
	BRNE _0x107
; 0000 04F3     {
; 0000 04F4 
; 0000 04F5        // Parameter_bank[107]=0x80;
; 0000 04F6 //        Parameter_bank[10]=0xBF;
; 0000 04F7 //        Parameter_bank[11]=0xBC;
; 0000 04F8         LoadCalibrationSettings(CalibrationConfigChanged);
	LDI  R26,LOW(_CalibrationConfigChanged)
	LDI  R27,HIGH(_CalibrationConfigChanged)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _LoadCalibrationSettings
; 0000 04F9         CalculateCalibrationRates();
	RCALL _CalculateCalibrationRates
; 0000 04FA         transmit_SPI(DAC_data,2);
	LDS  R30,_DAC_data
	LDS  R31,_DAC_data+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _transmit_SPI
; 0000 04FB         update_dynamic_vars();
	RCALL _update_dynamic_vars
; 0000 04FC         //enable_uart;
; 0000 04FD         RxEn;
	LDS  R30,193
	ANDI R30,LOW(0xC0)
	ORI  R30,0x10
	STS  193,R30
; 0000 04FE         //PORTD=0x08;
; 0000 04FF         Recieve;
	SBI  0xB,3
; 0000 0500         //disable_eints;
; 0000 0501         while (1)
_0x10A:
; 0000 0502               {
; 0000 0503                 #asm("wdr")
	wdr
; 0000 0504                 //delay_ms(20);
; 0000 0505                 //enable_SPI;
; 0000 0506 
; 0000 0507 
; 0000 0508         //        }
; 0000 0509         if(message_recieved)
	SBIS 0x1E,4
	RJMP _0x10D
; 0000 050A                 {
; 0000 050B                  transmit_HART();
	CALL _transmit_HART
; 0000 050C                 }
; 0000 050D         //else
; 0000 050E         //        {
; 0000 050F                 ADCSRA=0xcf;
_0x10D:
	LDI  R30,LOW(207)
	STS  122,R30
; 0000 0510                 update_dynamic_vars();
	RCALL _update_dynamic_vars
; 0000 0511                 PORTB.2=1;
	SBI  0x5,2
; 0000 0512                 transmit_SPI(DAC_data,2);
	LDS  R30,_DAC_data
	LDS  R31,_DAC_data+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _transmit_SPI
; 0000 0513                 PORTB.2=0;
	CBI  0x5,2
; 0000 0514                // }
; 0000 0515         }
	RJMP _0x10A
; 0000 0516     }
; 0000 0517 else
_0x107:
; 0000 0518     {
; 0000 0519         RxEn;
	LDS  R30,193
	ANDI R30,LOW(0xC0)
	ORI  R30,0x10
	STS  193,R30
; 0000 051A         //PORTD=0x08;
; 0000 051B         Recieve;
	SBI  0xB,3
; 0000 051C //               Parameter_bank[107]=0x60;
; 0000 051D //               Parameter_bank[10]=(char)crc;
; 0000 051E //               Parameter_bank[11]=(char)(crc>>8);
; 0000 051F 
; 0000 0520         while (1)
_0x115:
; 0000 0521               {
; 0000 0522               // DAC_zero_current=3.5;
; 0000 0523 
; 0000 0524                 #asm("wdr")
	wdr
; 0000 0525                 if(message_recieved)
	SBIS 0x1E,4
	RJMP _0x118
; 0000 0526                 {
; 0000 0527                  transmit_HART();
	CALL _transmit_HART
; 0000 0528                 }
; 0000 0529                 ADCSRA=0x0f;
_0x118:
	LDI  R30,LOW(15)
	STS  122,R30
; 0000 052A                 adc_data=0;
	LDI  R30,LOW(0)
	STS  _adc_data,R30
	STS  _adc_data+1,R30
	STS  _adc_data+2,R30
	STS  _adc_data+3,R30
; 0000 052B                 update_dynamic_vars();
	RCALL _update_dynamic_vars
; 0000 052C                 PORTB.2=1;
	SBI  0x5,2
; 0000 052D                 transmit_SPI(DAC_data,2);
	LDS  R30,_DAC_data
	LDS  R31,_DAC_data+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _transmit_SPI
; 0000 052E                 PORTB.2=0;
	CBI  0x5,2
; 0000 052F 
; 0000 0530         }
	RJMP _0x115
; 0000 0531     }
; 0000 0532 #asm
; 0000 0533 .CSEG
.CSEG
; 0000 0534 varlist: .DW 0x4fd1
varlist: .DW 0x4fd1
; 0000 0535 .org 0x0e6f                  //адрес, по которому будет распологаться наш CRC - 0x1BCC, длина - 2 байта , эти 2 байта для проверки со стороны МК мы исключаем, просто перескочив их
.org 0x0e6f                  //адрес, по которому будет распологаться наш CRC - 0x1BCC, длина - 2 байта , эти 2 байта для проверки со стороны МК мы исключаем, просто перескочив их
; 0000 0536 #endasm
; 0000 0537 }
	ADIW R28,7
_0x11D:
	RJMP _0x11D

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.ESEG
_Parameter_bank:
	.DB  LOW(0x4A35600),HIGH(0x4A35600),BYTE3(0x4A35600),BYTE4(0x4A35600)
	.DB  LOW(0x21010101),HIGH(0x21010101),BYTE3(0x21010101),BYTE4(0x21010101)
	.DB  LOW(0xBCBF0000),HIGH(0xBCBF0000),BYTE3(0xBCBF0000),BYTE4(0xBCBF0000)
	.DB  LOW(0x6D),HIGH(0x6D),BYTE3(0x6D),BYTE4(0x6D)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x200),HIGH(0x200),BYTE3(0x200),BYTE4(0x200)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x1000000),HIGH(0x1000000),BYTE3(0x1000000),BYTE4(0x1000000)
	.DB  LOW(0x48420302),HIGH(0x48420302),BYTE3(0x48420302),BYTE4(0x48420302)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x233C0000),HIGH(0x233C0000),BYTE3(0x233C0000),BYTE4(0x233C0000)
	.DB  LOW(0xAD7),HIGH(0xAD7),BYTE3(0xAD7),BYTE4(0xAD7)
	.DB  LOW(0x41A00000),HIGH(0x41A00000),BYTE3(0x41A00000),BYTE4(0x41A00000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0xFF0),HIGH(0xFF0),BYTE3(0xFF0),BYTE4(0xFF0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x80000000),HIGH(0x80000000),BYTE3(0x80000000),BYTE4(0x80000000)
	.DB  LOW(0xA0000040),HIGH(0xA0000040),BYTE3(0xA0000040),BYTE4(0xA0000040)
	.DB  LOW(0x41),HIGH(0x41),BYTE3(0x41),BYTE4(0x41)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DW  0x0
_Parameter_defaults:
	.DB  LOW(0x4B35611),HIGH(0x4B35611),BYTE3(0x4B35611),BYTE4(0x4B35611)
	.DB  LOW(0x21010101),HIGH(0x21010101),BYTE3(0x21010101),BYTE4(0x21010101)
	.DB  LOW(0xBCBF0000),HIGH(0xBCBF0000),BYTE3(0xBCBF0000),BYTE4(0xBCBF0000)
	.DB  LOW(0x6D),HIGH(0x6D),BYTE3(0x6D),BYTE4(0x6D)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x200),HIGH(0x200),BYTE3(0x200),BYTE4(0x200)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x1000000),HIGH(0x1000000),BYTE3(0x1000000),BYTE4(0x1000000)
	.DB  LOW(0x48420302),HIGH(0x48420302),BYTE3(0x48420302),BYTE4(0x48420302)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x233C0000),HIGH(0x233C0000),BYTE3(0x233C0000),BYTE4(0x233C0000)
	.DB  LOW(0xAD7),HIGH(0xAD7),BYTE3(0xAD7),BYTE4(0xAD7)
	.DB  LOW(0x41A00000),HIGH(0x41A00000),BYTE3(0x41A00000),BYTE4(0x41A00000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0xFF0),HIGH(0xFF0),BYTE3(0xFF0),BYTE4(0xFF0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x80000000),HIGH(0x80000000),BYTE3(0x80000000),BYTE4(0x80000000)
	.DB  LOW(0xA0000040),HIGH(0xA0000040),BYTE3(0xA0000040),BYTE4(0xA0000040)
	.DB  LOW(0x41),HIGH(0x41),BYTE3(0x41),BYTE4(0x41)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DW  0x0
_ADC_PV_calibration_point1:
	.BYTE 0x8
_ADC_PV_calibration_point2:
	.BYTE 0x8
_rangeIndexEep:
	.BYTE 0x1
_CalibrationConfigChanged:
	.BYTE 0x1
_calibrationKeep:
	.BYTE 0x10
_calibrationBeep:
	.BYTE 0x10
_crceep:
	.DW  0x0
_crcstatic:
	.DW  0x105D

	.DSEG
_calibrationK:
	.BYTE 0x4
_calibrationB:
	.BYTE 0x4
_rx_buffer0:
	.BYTE 0x40
_com_data_rx:
	.BYTE 0x19
_dynamic_variables:
	.BYTE 0xC
_com_bytes_rx:
	.BYTE 0x1
_update_args_flag:
	.BYTE 0x1
_p_bank_addr:
	.BYTE 0x1
_voidFuncPtr:
	.BYTE 0x2
_rx_wr_index0:
	.BYTE 0x1
_rx_rd_index0:
	.BYTE 0x1
_rx_counter0:
	.BYTE 0x1
_adc_data:
	.BYTE 0x4
_DAC_data:
	.BYTE 0x4
_SPI_tEnd:
	.BYTE 0x1
_checking_result:
	.BYTE 0x1
_preambula_bytes:
	.BYTE 0x1
_preambula_bytes_rec:
	.BYTE 0x1
_bytes_quantity_ans:
	.BYTE 0x1
_command_rx_val:
	.BYTE 0x1
_Command_data:
	.BYTE 0x19
_tx_buffer0:
	.BYTE 0x40
_tx_rd_index0:
	.BYTE 0x1
_tx_counter0:
	.BYTE 0x1
__seed_G101:
	.BYTE 0x4

	.CSEG

	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USB 0x9A
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ASRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __ASRD12R
__ASRD12L:
	ASR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRD12L
__ASRD12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__LTB12U:
	CP   R26,R30
	LDI  R30,1
	BRLO __LTB12U1
	CLR  R30
__LTB12U1:
	RET

__GTB12U:
	CP   R30,R26
	LDI  R30,1
	BRLO __GTB12U1
	CLR  R30
__GTB12U1:
	RET

__LEW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRGE __LEW12T
	CLR  R30
__LEW12T:
	RET

__LEW12U:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRSH __LEW12UT
	CLR  R30
__LEW12UT:
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETW2PF:
	LPM  R26,Z+
	LPM  R27,Z
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDD:
	ADIW R26,2
	RCALL __EEPROMRDW
	MOVW R22,R30
	SBIW R26,2

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRD:
	RCALL __EEPROMWRW
	ADIW R26,2
	MOVW R0,R30
	MOVW R30,R22
	RCALL __EEPROMWRW
	MOVW R30,R0
	SBIW R26,2
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
