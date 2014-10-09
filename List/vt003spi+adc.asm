
;CodeVisionAVR C Compiler V3.10 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega168P
;Program type           : Application
;Clock frequency        : 0,460800 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 100 byte(s)
;Heap size              : 50 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega168P
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
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
	.EQU __DSTACK_SIZE=0x0064
	.EQU __HEAP_SIZE=0x0032
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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	.DEF _calibration_point1_msb=R6
	.DEF _calibration_point2=R7
	.DEF _calibration_point2_msb=R8
	.DEF _rangeIndex=R10
	.DEF _protectBitsChecking=R9
	.DEF _crc=R11
	.DEF _crc_msb=R12
	.DEF _ADC_PV_zero_val=R13
	.DEF _ADC_PV_zero_val_msb=R14

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

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0

;HEAP START MARKER INITIALIZATION
__HEAP_START_MARKER:
	.DW  0,0

_0x3:
	.DB  0x0,0x0,0x80,0x3F
_0x4:
	.DB  0x2
_0x5:
	.DB  0x1
_0x6:
	.DB  0x5
_0x16A:
	.DB  0x0,0x4,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0C
	.DW  0x03
	.DW  __REG_VARS*2

	.DW  0x04
	.DW  0x4CE
	.DW  __HEAP_START_MARKER*2

	.DW  0x01
	.DW  _SPI_tEnd
	.DW  _0x5*2

	.DW  0x01
	.DW  _preambula_bytes
	.DW  _0x6*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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
	.ORG 0x164

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
;__eeprom volatile unsigned int ADC_PV_calibration_point1[4];
;__eeprom volatile unsigned int ADC_PV_calibration_point2[4];
;__eeprom volatile unsigned int ADC_PV_calibration_point1_PB1[4];
;__eeprom volatile unsigned int ADC_PV_calibration_point1_PB2[4];
;__eeprom volatile unsigned int ADC_PV_calibration_point2_PB1[4];
;__eeprom volatile unsigned int ADC_PV_calibration_point2_PB2[4];
;__eeprom volatile char  rangeIndexEep;
;__eeprom volatile char  rangeIndexEepPB1;
;__eeprom volatile char  rangeIndexEepPB2;
;__eeprom volatile char CalibrationConfigChanged;
;__eeprom volatile char CalibrationConfigChangedPB1;
;__eeprom volatile char CalibrationConfigChangedPB2;
;__eeprom volatile float calibrationKeep[4];
;__eeprom volatile float calibrationBeep[4];
;__eeprom volatile float calibrationKeep_PB1[4];
;__eeprom volatile float calibrationKeep_PB2[4];
;__eeprom volatile float calibrationBeep_PB1[4];
;__eeprom volatile float calibrationBeep_PB2[4];
;__eeprom int crceep = 0x0000;
;__eeprom const int crcstatic = 0xdcea;// 0x9342 for boot0// 0x438c for dvst3_bootloader //0xdcea no boot at all
;__eeprom char tmpEepPriValCode = 0x6d;
;__eeprom char devCodePB1;       // 2, 6, 10-11,25
;__eeprom char devCodePB2;
;__eeprom char firmwareRevPB1;
;__eeprom char firmwareRevPB2;
;__eeprom int firmwareCRCPB1;
;__eeprom int firmwareCRCPB2;
;__eeprom char devAddrPB1;
;__eeprom char devAddrPB2;
;
;//__eeprom char firstPoint = 0x11;
;//__eeprom char secondPoint = 0x22;
;//__eeprom char thirdPoint = 0x33;
;
;//eeprom unsigned int serial_address=0x0000;
;//flash const unsigned long *serial @0x00100;
;char rangeIndex;
;char protectBitsChecking;
;float calibrationK;
;float calibrationB;
;unsigned int  crc;
;unsigned int ADC_PV_zero_val=0x0001;
;char rx_buffer0[RX_BUFFER_SIZE0];
;char string_tmp[4];
;//char *str[4];
;char com_data_rx[25];
;float dynamic_variables[3];         //0 - скорость, 1 - ток, 2 - %диапазона
;char dataToSave,sensor_address=0x02,com_bytes_rx=0,update_args_flag=0,p_bank_addr=0;
;void transmit_HART(void);
;int check_recieved_message();
;int generate_command_data_array_answer(char command_recieved);
;void update_eeprom_parameters(char update_flag);
;void start_transmit(int transmit_param);
;void clear_buffer();
;void checkIntegrityOfCalibrationVars(char index);
;void CalculateCalibrationRates();
;void ResetDeviceSettings(char notreset);
;void  CRC_update(unsigned char d);
;void PerformDeviceApplicationErase();
;void (*voidFuncPtr)(void);
;int read_program_memory (int adr);
;char checkCalibrationFlagValidity();
;char checkSavedRangeValidity();
;char fixIncorrectPB(char checkres);
;char fixIncorrectRIPB(char checkres);
;char checkSMTH();
;char checkCalibrationRatesValidity(char index);
;char fixIncorrectCalibrationRates(char index, char checkres);
;char fixIncorrectIDVars(char);
;void EEPROM_write(unsigned int uiAddress,unsigned char ucData) ;
;unsigned char EEPROM_read(unsigned int uiAddress) ;
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
;char SPI_tEnd=1,checking_result=0,preambula_bytes=5,preambula_bytes_rec=0,bytes_quantity_ans=0,bytes_quantity_q=0,data_q ...
;// USART Receiver interrupt service routine
;char Command_data[25];
;
;int read_program_memory (int adr)
; 0000 00D1 {

	.CSEG
_read_program_memory:
; .FSTART _read_program_memory
; 0000 00D2 unsigned int flash *data_point;
; 0000 00D3 data_point =0x0000;
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x0
;	adr -> Y+2
;	*data_point -> R16,R17
; 0000 00D4 data_point+=adr;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	MOVW R26,R16
	CALL SUBOPT_0x1
	MOVW R16,R30
; 0000 00D5 return *data_point;
	CALL __GETW1PF
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; 0000 00D6 //       #asm
; 0000 00D7 //       LPM R22,Z+;//     загрузка в регистр R23 содержимого флеш по адресу Z с постинкрементом (мл. байт)
; 0000 00D8 //       LPM R23,Z; //     загрузка в регистр R22 содержимого Flash  по адресу Z+1 (старший байт)
; 0000 00D9 //       MOV R30, R22;
; 0000 00DA //       MOV R31, R23;
; 0000 00DB //       #endasm
; 0000 00DC //      #asm
; 0000 00DD //      ld   r30,Y
; 0000 00DE //      ldd  r31,Y+1
; 0000 00DF //      clr  r0
; 0000 00E0 //      sbrc r31,7
; 0000 00E1 //      inc  r0
; 0000 00E2 //      out  RAMPZ,r0
; 0000 00E3 //      clc
; 0000 00E4 //      rol  r30
; 0000 00E5 //      rol  r31
; 0000 00E6 //      elpm r0,z+
; 0000 00E7 //      elpm r31,z
; 0000 00E8 //      mov  r30,r0
; 0000 00E9 //      #endasm
; 0000 00EA }
; .FEND
;void  CRC_update(unsigned char d)
; 0000 00EC {
_CRC_update:
; .FSTART _CRC_update
; 0000 00ED   //unsigned char uindex;
; 0000 00EE   //uindex = CRCHigh^d;
; 0000 00EF   //CRCHigh=CRCLow^((int)crctable[uindex]>>8);
; 0000 00F0   //CRCLow=crctable[uindex];
; 0000 00F1   //crc = CRCHigh;
; 0000 00F2   //crc = ((int)crc)<<8+CRCLow;
; 0000 00F3   crc = crctable[((crc>>8)^d)&0xFF] ^ (crc<<8);
	ST   -Y,R26
;	d -> Y+0
	MOV  R30,R12
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
	CALL SUBOPT_0x1
	CALL __GETW2PF
	MOV  R31,R11
	LDI  R30,LOW(0)
	EOR  R30,R26
	EOR  R31,R27
	__PUTW1R 11,12
; 0000 00F4 }
	ADIW R28,1
	RET
; .FEND
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)     //таймер, который ждет необходимое число циклов, соответствующее по€в ...
; 0000 00F7 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R30
; 0000 00F8 enable_eints;
	LDI  R30,LOW(1)
	OUT  0x1D,R30
	OUT  0x1C,R30
; 0000 00F9 wait_stopOCD;
	LDI  R30,LOW(0)
	STS  105,R30
; 0000 00FA }
	LD   R30,Y+
	RETI
; .FEND
;
;// Declare your global variables here
;interrupt [USART_RXC] void usart_rx_isr(void)//прием по USART
; 0000 00FE {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00FF 
; 0000 0100 char status,data;
; 0000 0101 #asm("cli")
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	cli
; 0000 0102 status=UCSR0A;
	LDS  R17,192
; 0000 0103 
; 0000 0104 data=UDR0;
	LDS  R16,198
; 0000 0105 //#asm("sei")
; 0000 0106 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)//если нет ошибок, то читаем данные в буфере USART
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x7
; 0000 0107    {
; 0000 0108    rx_buffer0[rx_wr_index0]=data;
	LDS  R30,_rx_wr_index0
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0109    if (++rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDS  R26,_rx_wr_index0
	SUBI R26,-LOW(1)
	STS  _rx_wr_index0,R26
	CPI  R26,LOW(0x40)
	BRNE _0x8
	LDI  R30,LOW(0)
	STS  _rx_wr_index0,R30
; 0000 010A    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x8:
	LDS  R26,_rx_counter0
	SUBI R26,-LOW(1)
	STS  _rx_counter0,R26
	CPI  R26,LOW(0x40)
	BRNE _0x9
; 0000 010B       {
; 0000 010C       rx_counter0=0;
	LDI  R30,LOW(0)
	STS  _rx_counter0,R30
; 0000 010D       rx_buffer_overflow0=1;
	SBI  0x1E,0
; 0000 010E 
; 0000 010F      };
_0x9:
; 0000 0110    };
_0x7:
; 0000 0111  #asm("sei")
	sei
; 0000 0112 }
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x19A
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void) //не используетс€
; 0000 0119 {
; 0000 011A char data;
; 0000 011B while (rx_counter0==0);
;	data -> R17
; 0000 011C data=rx_buffer0[rx_rd_index0];
; 0000 011D if (++rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
; 0000 011E #asm("cli")
; 0000 011F --rx_counter0;
; 0000 0120 #asm("sei")
; 0000 0121 return data;
; 0000 0122 }
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
; 0000 0132 {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0133 #asm("cli")
	cli
; 0000 0134 if (tx_counter0)
	LDS  R30,_tx_counter0
	CPI  R30,0
	BREQ _0x10
; 0000 0135    {
; 0000 0136    --tx_counter0;
	SUBI R30,LOW(1)
	STS  _tx_counter0,R30
; 0000 0137 
; 0000 0138    UDR0=tx_buffer0[tx_rd_index0];
	LDS  R30,_tx_rd_index0
	CALL SUBOPT_0x2
	STS  198,R30
; 0000 0139 
; 0000 013A    if (++tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDS  R26,_tx_rd_index0
	SUBI R26,-LOW(1)
	STS  _tx_rd_index0,R26
	CPI  R26,LOW(0x40)
	BRNE _0x11
	LDI  R30,LOW(0)
	STS  _tx_rd_index0,R30
; 0000 013B    };
_0x11:
_0x10:
; 0000 013C    #asm("sei")
	sei
; 0000 013D }
_0x19A:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)                                       //не используетс€
; 0000 0144 {
; 0000 0145 //while (tx_counter0 == TX_BUFFER_SIZE0);
; 0000 0146 //#asm("cli")
; 0000 0147 //if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
; 0000 0148 //   {
; 0000 0149 //   tx_buffer0[tx_wr_index0]=c;
; 0000 014A //   if (++tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
; 0000 014B //   ++tx_counter0;
; 0000 014C //   }
; 0000 014D //else
; 0000 014E while ((UCSR0A & DATA_REGISTER_EMPTY)==0)
;	c -> Y+0
; 0000 014F    UDR0=c;
; 0000 0151 }
;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)//первоначально прерывание работает по нарастающему уровню (set_rising_edge_ ...
; 0000 0156 //изменено, таймер, отсчитывающий задержку, сейчас не активен, пользуемс€ только OCD ногой модема
; 0000 0157 {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0158 //RxTx=!RxTx;//RxTx=0 =>no recieve ||RxTx=1 => recieve||
; 0000 0159 //if(RxTx)Recieve;
; 0000 015A if(EICRA==0x03)                    //если сработало прерывание по верхнему уровню, то переключаемс€ на отлов нижнего уро ...
	LDS  R26,105
	CPI  R26,LOW(0x3)
	BRNE _0x15
; 0000 015B                 {
; 0000 015C                 Recieve;
	SBI  0xB,3
; 0000 015D                 RxEn;
	CALL SUBOPT_0x3
; 0000 015E                 //wait_stopOCD;
; 0000 015F                 //start_wait_Rx_timer;
; 0000 0160                 //disable_eints;
; 0000 0161                 wait_stopOCD;           //EICRA=0x00
	LDI  R30,LOW(0)
	STS  105,R30
; 0000 0162                 message_recieved=0;
	CBI  0x1E,4
; 0000 0163                 //mono_channel_mode;
; 0000 0164                 }
; 0000 0165 else
	RJMP _0x1A
_0x15:
; 0000 0166                 {
; 0000 0167                 //Transmit;
; 0000 0168 
; 0000 0169                 //stop_wait_Rx_timer;
; 0000 016A                 wait_startOCD;            //EICRA=0x03
	LDI  R30,LOW(3)
	STS  105,R30
; 0000 016B                 disable_uart;             //отключаем USART, переходим в режим приема
	LDI  R30,LOW(192)
	STS  193,R30
; 0000 016C                 message_recieved=1;
	SBI  0x1E,4
; 0000 016D 
; 0000 016E                 }
_0x1A:
; 0000 016F //start_check_OCD_timer;//стартуем таймер отсчитывающий задержку 3.33 мс (4 цикла при минимальной частоте 1200√ц)
; 0000 0170 
; 0000 0171 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;
;#pragma used-
;#endif
;// ADC interrupt service routine
;interrupt [ADC_INT] void adc_isr(void)//прерывани€ ацп по завершению преобразовани€
; 0000 0178 {
_adc_isr:
; .FSTART _adc_isr
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0179 //#asm("cli")
; 0000 017A delay_us(10);
	__DELAY_USB 2
; 0000 017B adc_data=ADCW;
	LDS  R30,120
	LDS  R31,120+1
	CLR  R22
	CLR  R23
	STS  _adc_data,R30
	STS  _adc_data+1,R31
	STS  _adc_data+2,R22
	STS  _adc_data+3,R23
; 0000 017C printflag=1;
	SBI  0x1E,1
; 0000 017D ADMUX=0x20;
	LDI  R30,LOW(32)
	STS  124,R30
; 0000 017E ADCSRA=0x4f;
	LDI  R30,LOW(79)
	STS  122,R30
; 0000 017F //#asm("sei")
; 0000 0180 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
; .FEND
;
;
;// SPI interrupt service routine
;interrupt [SPI_STC] void spi_isr(void)       //прерывание по SPI, в случае, если один фрейм SPI отправлен, оно срабатыва ...
; 0000 0185 {                                              // в случае необходимости, либо продлевает фрейм, либо финализирует
_spi_isr:
; .FSTART _spi_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0186 
; 0000 0187 //#asm
; 0000 0188   //  in   r30,spsr
; 0000 0189   //  in   r30,spdr
; 0000 018A //#endasm
; 0000 018B //data=SPDR;
; 0000 018C //SPCR=0xD0;
; 0000 018D //SPSR=0x00;
; 0000 018E // Place your code here
; 0000 018F if(SPI_tEnd==0){
	LDS  R30,_SPI_tEnd
	CPI  R30,0
	BRNE _0x1F
; 0000 0190 SPDR=0xff;
	LDI  R30,LOW(255)
	OUT  0x2E,R30
; 0000 0191 SPI_tEnd=1;
	LDI  R30,LOW(1)
	STS  _SPI_tEnd,R30
; 0000 0192 }
; 0000 0193 else PORTB.2=0;
	RJMP _0x20
_0x1F:
	CBI  0x5,2
; 0000 0194 ADCSRA=0xcf;
_0x20:
	LDI  R30,LOW(207)
	STS  122,R30
; 0000 0195 
; 0000 0196 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;void transmit_SPI(unsigned int SPI_data,char SPI_mode){//4 режима работы: 2-норма, 0-авари€ 3.75мј, 1-авари€ 22мј, 3-мон ...
; 0000 0198 void transmit_SPI(unsigned int SPI_data,char SPI_mode){
_transmit_SPI:
; .FSTART _transmit_SPI
; 0000 0199 //#asm ("cli")                                          //прерывани€ мы здесь не используем, потому как с ними получаетс ...
; 0000 019A delay_us(10);
	ST   -Y,R26
;	SPI_data -> Y+1
;	SPI_mode -> Y+0
	__DELAY_USB 2
; 0000 019B PORTB.2=0;
	CBI  0x5,2
; 0000 019C if(SPI_mode<2)
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRSH _0x25
; 0000 019D {
; 0000 019E SPDR=SPI_mode;
	LD   R30,Y
	OUT  0x2E,R30
; 0000 019F if(SPI_mode==0)SPI_data=alarm3_75mA;
	CPI  R30,0
	BRNE _0x26
	LDI  R30,LOW(15360)
	LDI  R31,HIGH(15360)
	RJMP _0x193
; 0000 01A0 else SPI_data=alarm22mA;
_0x26:
	LDI  R30,LOW(24576)
	LDI  R31,HIGH(24576)
_0x193:
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0000 01A1 while(SPSR<0x80){;}
_0x28:
	IN   R30,0x2D
	CPI  R30,LOW(0x80)
	BRLO _0x28
; 0000 01A2 }
; 0000 01A3 if(SPI_mode==3){
_0x25:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x2B
; 0000 01A4 SPI_data=0;}
	LDI  R30,LOW(0)
	STD  Y+1,R30
	STD  Y+1+1,R30
; 0000 01A5 if(SPI_mode==2)
_0x2B:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x2C
; 0000 01A6 {
; 0000 01A7 SPDR=(long)(DAC_data>>16);
	CALL SUBOPT_0x4
	LDI  R30,LOW(16)
	CALL __ASRD12
	OUT  0x2E,R30
; 0000 01A8 while(SPSR<0x80){;}
_0x2D:
	IN   R30,0x2D
	CPI  R30,LOW(0x80)
	BRLO _0x2D
; 0000 01A9 }
; 0000 01AA SPDR=SPI_data>>8;
_0x2C:
	LDD  R30,Y+2
	ANDI R31,HIGH(0x0)
	OUT  0x2E,R30
; 0000 01AB PORTB.2=0;
	CBI  0x5,2
; 0000 01AC while(SPSR<0x80){;}
_0x32:
	IN   R30,0x2D
	CPI  R30,LOW(0x80)
	BRLO _0x32
; 0000 01AD SPDR=SPI_data;
	LDD  R30,Y+1
	OUT  0x2E,R30
; 0000 01AE while(SPSR<0x80){;}
_0x35:
	IN   R30,0x2D
	CPI  R30,LOW(0x80)
	BRLO _0x35
; 0000 01AF //#asm ("sei")
; 0000 01B0 }
	ADIW R28,3
	RET
; .FEND
;
;
;void transmit_HART(void)//подпрограмма передачи в по HART
; 0000 01B4 {
_transmit_HART:
; .FSTART _transmit_HART
; 0000 01B5 int error_log;
; 0000 01B6 error_log=check_recieved_message();    //здесь провер€ем корректность прин€того сообщени€ и устанавливаем значение перем ...
	ST   -Y,R17
	ST   -Y,R16
;	error_log -> R16,R17
	RCALL _check_recieved_message
	MOVW R16,R30
; 0000 01B7 if(answering)                         //если нужен ответ
	SBIS 0x1E,5
	RJMP _0x38
; 0000 01B8         {
; 0000 01B9         if (!error_log)               //ошибок нет
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x39
; 0000 01BA                 {
; 0000 01BB                 checking_result=0;                //сбрасываем "результат проверки"
	CALL SUBOPT_0x5
; 0000 01BC                 rx_wr_index0=0;
; 0000 01BD                 rx_buffer_overflow0=0;
	CBI  0x1E,0
; 0000 01BE                 error_log=error_log|(generate_command_data_array_answer(command_rx_val));//здесь обращаемс€ в генератор  ...
	LDS  R26,_command_rx_val
	RCALL _generate_command_data_array_answer
	__ORWRR 16,17,30,31
; 0000 01BF                 start_transmit(error_log);
	RJMP _0x194
; 0000 01C0                 }
; 0000 01C1         else
_0x39:
; 0000 01C2                 { //соответственно, если ошибки есть
; 0000 01C3                 //PORTD=0x08;
; 0000 01C4                 Recieve;
	SBI  0xB,3
; 0000 01C5                 rx_buffer_overflow0=0;
	CBI  0x1E,0
; 0000 01C6                 checking_result=0;
	CALL SUBOPT_0x5
; 0000 01C7                 rx_wr_index0=0;
; 0000 01C8                 message_recieved=0;
	CBI  0x1E,4
; 0000 01C9                 start_transmit(error_log);
_0x194:
	MOVW R26,R16
	RCALL _start_transmit
; 0000 01CA                 }
; 0000 01CB         }
; 0000 01CC else                              //ответ по HART не нужен
	RJMP _0x43
_0x38:
; 0000 01CD         {
; 0000 01CE         rx_buffer_overflow0=0;
	CBI  0x1E,0
; 0000 01CF         checking_result=0;
	CALL SUBOPT_0x5
; 0000 01D0         rx_wr_index0=0;
; 0000 01D1         RxEn;
	CALL SUBOPT_0x3
; 0000 01D2         Recieve;
	SBI  0xB,3
; 0000 01D3         }
_0x43:
; 0000 01D4 clear_buffer();
	RCALL _clear_buffer
; 0000 01D5 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;void start_transmit(int transmit_param)
; 0000 01D8 {
_start_transmit:
; .FSTART _start_transmit
; 0000 01D9 char i=0,j=0;
; 0000 01DA char check_sum_tx=0;
; 0000 01DB while(UCSR0A<0x20){;}
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	transmit_param -> Y+4
;	i -> R17
;	j -> R16
;	check_sum_tx -> R19
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
_0x48:
	LDS  R26,192
	CPI  R26,LOW(0x20)
	BRLO _0x48
; 0000 01DC //if(!RxTx){
; 0000 01DD preambula_bytes=Parameter_bank[3];
	__POINTW2MN _Parameter_bank,3
	CALL __EEPROMRDB
	STS  _preambula_bytes,R30
; 0000 01DE delay_ms(25);
	LDI  R26,LOW(25)
	LDI  R27,0
	CALL _delay_ms
; 0000 01DF Transmit;
	CBI  0xB,3
; 0000 01E0 TxEn;
	LDS  R30,193
	ANDI R30,LOW(0xC0)
	ORI  R30,8
	STS  193,R30
; 0000 01E1 delay_ms(15);
	LDI  R26,LOW(15)
	LDI  R27,0
	CALL _delay_ms
; 0000 01E2 for (i=0;i<preambula_bytes;i++)
	LDI  R17,LOW(0)
_0x4E:
	LDS  R30,_preambula_bytes
	CP   R17,R30
	BRSH _0x4F
; 0000 01E3         {
; 0000 01E4         tx_buffer0[i]=0xff;
	CALL SUBOPT_0x6
	LDI  R26,LOW(255)
	STD  Z+0,R26
; 0000 01E5         tx_counter0++;
	LDS  R30,_tx_counter0
	SUBI R30,-LOW(1)
	STS  _tx_counter0,R30
; 0000 01E6         }
	SUBI R17,-1
	RJMP _0x4E
_0x4F:
; 0000 01E7 //i++;
; 0000 01E8 if(burst_mode)tx_buffer0[i]=0x01;//стартовый байт
	SBIS 0x1E,6
	RJMP _0x50
	CALL SUBOPT_0x6
	LDI  R26,LOW(1)
	RJMP _0x195
; 0000 01E9 else tx_buffer0[i]=0x06;
_0x50:
	CALL SUBOPT_0x6
	LDI  R26,LOW(6)
_0x195:
	STD  Z+0,R26
; 0000 01EA check_sum_tx=check_sum_tx^tx_buffer0[i];
	MOV  R30,R17
	CALL SUBOPT_0x2
	CALL SUBOPT_0x7
; 0000 01EB i++;
; 0000 01EC tx_buffer0[i]=rx_buffer0[preambula_bytes_rec-preambula_bytes+i];//адрес
	CALL SUBOPT_0x8
; 0000 01ED check_sum_tx=check_sum_tx^tx_buffer0[i];
	CALL SUBOPT_0x7
; 0000 01EE i++;
; 0000 01EF tx_buffer0[i]=rx_buffer0[preambula_bytes_rec-preambula_bytes+i];//команда
	CALL SUBOPT_0x8
; 0000 01F0 check_sum_tx=check_sum_tx^tx_buffer0[i];
	EOR  R19,R30
; 0000 01F1 i++;
	SUBI R17,-1
; 0000 01F2 //secondPoint = transmit_param;
; 0000 01F3 //thirdPoint = command_rx_val;
; 0000 01F4 if(command_rx_val == 0x23)
	LDS  R26,_command_rx_val
	CPI  R26,LOW(0x23)
	BRNE _0x52
; 0000 01F5     bytes_quantity_ans = 9;
	LDI  R30,LOW(9)
	STS  _bytes_quantity_ans,R30
; 0000 01F6 if(!transmit_param)
_0x52:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x53
; 0000 01F7         {
; 0000 01F8         tx_buffer0[i]=bytes_quantity_ans+2;                                                  //число байт  //нужно созда ...
	CALL SUBOPT_0x9
	LDS  R30,_bytes_quantity_ans
	SUBI R30,-LOW(2)
	CALL SUBOPT_0xA
; 0000 01F9         check_sum_tx=check_sum_tx^tx_buffer0[i];
	CALL SUBOPT_0x7
; 0000 01FA         i++;
; 0000 01FB         tx_buffer0[i]=p_bank_addr;                                             //статус 1й байт
	LDS  R26,_p_bank_addr
	CALL SUBOPT_0xB
; 0000 01FC         check_sum_tx=check_sum_tx^tx_buffer0[i];
	CALL SUBOPT_0x7
; 0000 01FD         i++;
; 0000 01FE         tx_buffer0[i]=0x00;                                             //статус 2й байт
	LDI  R26,LOW(0)
	CALL SUBOPT_0xB
; 0000 01FF         check_sum_tx=check_sum_tx^tx_buffer0[i];
	EOR  R19,R30
; 0000 0200         i++;
	SUBI R17,-1
; 0000 0201         for(j=0;j<bytes_quantity_ans;j++)
	LDI  R16,LOW(0)
_0x55:
	LDS  R30,_bytes_quantity_ans
	CP   R16,R30
	BRSH _0x56
; 0000 0202                 {
; 0000 0203                 tx_buffer0[i]=Command_data[j];                                                //данные //здесь нужно соз ...
	CALL SUBOPT_0x9
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_Command_data)
	SBCI R31,HIGH(-_Command_data)
	LD   R30,Z
	CALL SUBOPT_0xA
; 0000 0204                 check_sum_tx=check_sum_tx^tx_buffer0[i];
	EOR  R19,R30
; 0000 0205                 i++;
	SUBI R17,-1
; 0000 0206                 }
	SUBI R16,-1
	RJMP _0x55
_0x56:
; 0000 0207         }
; 0000 0208 else {
	RJMP _0x57
_0x53:
; 0000 0209         tx_buffer0[i]=com_bytes_rx+2;       //здесь просто берем количество байт из прин€того сообщени€                  ...
	CALL SUBOPT_0x9
	LDS  R30,_com_bytes_rx
	SUBI R30,-LOW(2)
	CALL SUBOPT_0xA
; 0000 020A         //bytes_quantity_ans=rx_buffer0[preambula_bytes_rec-preambula_bytes+i]+2;  //эту величину все же нужно сохранить ...
; 0000 020B         check_sum_tx=check_sum_tx^tx_buffer0[i];
	EOR  R19,R30
; 0000 020C         i++;
	SUBI R17,-1
; 0000 020D         tx_buffer0[i]=transmit_param>>8;                                       //статус 1й байт
	CALL SUBOPT_0x9
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL __ASRW8
	CALL SUBOPT_0xA
; 0000 020E         check_sum_tx=check_sum_tx^tx_buffer0[i];
	CALL SUBOPT_0x7
; 0000 020F         i++;
; 0000 0210         tx_buffer0[i]=transmit_param;                                          //статус 2й байт
	LDD  R26,Y+4
	CALL SUBOPT_0xB
; 0000 0211         check_sum_tx=check_sum_tx^tx_buffer0[i];
	EOR  R19,R30
; 0000 0212         i++;
	SUBI R17,-1
; 0000 0213         j=i;
	MOV  R16,R17
; 0000 0214         for(i=j;i<com_bytes_rx+j;i++)
	MOV  R17,R16
_0x59:
	LDS  R26,_com_bytes_rx
	CLR  R27
	CALL SUBOPT_0xC
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x5A
; 0000 0215                 {
; 0000 0216                 tx_buffer0[i]=rx_buffer0[preambula_bytes_rec-preambula_bytes+i-2];                                       ...
	CALL SUBOPT_0x6
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
	CALL SUBOPT_0xD
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	MOVW R26,R22
	CALL SUBOPT_0xA
; 0000 0217                 check_sum_tx=check_sum_tx^tx_buffer0[i];
	EOR  R19,R30
; 0000 0218                 //i++;
; 0000 0219                 }
	SUBI R17,-1
	RJMP _0x59
_0x5A:
; 0000 021A 
; 0000 021B         }
_0x57:
; 0000 021C         //i++;
; 0000 021D tx_buffer0[i]=check_sum_tx;
	CALL SUBOPT_0x6
	ST   Z,R19
; 0000 021E tx_rd_index0=1;
	LDI  R30,LOW(1)
	STS  _tx_rd_index0,R30
; 0000 021F //if(!transmit_param){
; 0000 0220 //for(i=0;i<=rx_counter0;i++)tx_buffer0[i]=rx_buffer0[i]; }
; 0000 0221 //tx_rd_index0=1;
; 0000 0222 tx_counter0=i;
	STS  _tx_counter0,R17
; 0000 0223 UDR0=tx_buffer0[0];
	LDS  R30,_tx_buffer0
	STS  198,R30
; 0000 0224 while(tx_counter0){;}
_0x5B:
	LDS  R30,_tx_counter0
	CPI  R30,0
	BRNE _0x5B
; 0000 0225 delay_ms(15);
	LDI  R26,LOW(15)
	LDI  R27,0
	CALL _delay_ms
; 0000 0226 //RxEn;
; 0000 0227 Recieve;
	SBI  0xB,3
; 0000 0228 message_recieved=0;
	CBI  0x1E,4
; 0000 0229 rx_counter0=0;
	LDI  R30,LOW(0)
	STS  _rx_counter0,R30
; 0000 022A 
; 0000 022B }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;
;int generate_command_data_array_answer(char command_recieved)//загружаем из эсппзу сохраненный массив параметров (Parame ...
; 0000 022E {
_generate_command_data_array_answer:
; .FSTART _generate_command_data_array_answer
; 0000 022F char i=0,j=0,k=0,m=0;
; 0000 0230 char dynamic_parameter=0, writing_command=0, error=1, parameter_tmp=0,parameter_tmp_length=0,tmp_command_number=0;
; 0000 0231 union ieeesender      //это объединение создано специально дл€ передачи числа в формате плавающей точки в виде 4х байт
; 0000 0232         {
; 0000 0233         float value;
; 0000 0234         char byte[4];
; 0000 0235         }floatsend;
; 0000 0236 //for (i=0;i<4;i++)
; 0000 0237 //        {
; 0000 0238 //        str[i]=&string_tmp[i];
; 0000 0239 //        }
; 0000 023A //        i=0;
; 0000 023B 
; 0000 023C for (i=0;i<31;i++)//счетчик є команды
	ST   -Y,R26
	SBIW R28,8
	CALL SUBOPT_0xE
	LDI  R30,LOW(1)
	STD  Y+7,R30
	CALL SUBOPT_0xF
;	command_recieved -> Y+14
;	i -> R17
;	j -> R16
;	k -> R19
;	m -> R18
;	dynamic_parameter -> R21
;	writing_command -> R20
;	error -> Y+13
;	parameter_tmp -> Y+12
;	parameter_tmp_length -> Y+11
;	tmp_command_number -> Y+10
;	ieeesender -> Y+14
;	floatsend -> Y+6
	LDI  R20,0
	LDI  R17,LOW(0)
_0x63:
	CPI  R17,31
	BRSH _0x64
; 0000 023D                 {
; 0000 023E                 if(Command_number[0][i]==command_recieved)
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_Command_number*2)
	SBCI R31,HIGH(-_Command_number*2)
	LPM  R26,Z
	LDD  R30,Y+14
	CP   R30,R26
	BRNE _0x65
; 0000 023F                                 {
; 0000 0240                                 error=0;//отсутствие совпадений соответствует ошибке "команда не поддерживаетс€"
	LDI  R30,LOW(0)
	STD  Y+13,R30
; 0000 0241                                 tmp_command_number=i;
	__PUTBSR 17,10
; 0000 0242 
; 0000 0243                                 }
; 0000 0244                 }
_0x65:
	SUBI R17,-1
	RJMP _0x63
_0x64:
; 0000 0245 if(!error)      {//если ошибок нет, формируем команду
	LDD  R30,Y+13
	CPI  R30,0
	BREQ PC+2
	RJMP _0x66
; 0000 0246                 writing_command=Command_number[1][tmp_command_number];//команда записи=1
	__POINTW2FN _Command_number,31
	LDD  R30,Y+10
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R20,Z
; 0000 0247                 dynamic_parameter=Command_number[2][tmp_command_number];//динамический параметр=2
	__POINTW2FN _Command_number,62
	LDD  R30,Y+10
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R21,Z
; 0000 0248 //                firstPoint = tmp_command_number;
; 0000 0249                         if(writing_command)
	CPI  R20,0
	BREQ _0x67
; 0000 024A                                 {
; 0000 024B                                 for(j=0;j<com_bytes_rx+1;j++)
	LDI  R16,LOW(0)
_0x69:
	CALL SUBOPT_0x10
	BRGE _0x6A
; 0000 024C                                         {
; 0000 024D                                         Command_data[j]=com_data_rx[j];
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
; 0000 024E                                         //Parameter_bank[Parameter_mask[parameter_tmp]+(k+parameter_tmp_length-j)];//Com ...
; 0000 024F                                         }
	SUBI R16,-1
	RJMP _0x69
_0x6A:
; 0000 0250                                 update_args_flag=tmp_command_number;
	LDD  R30,Y+10
	STS  _update_args_flag,R30
; 0000 0251                                 update_eeprom_parameters(tmp_command_number);
	LDD  R26,Y+10
	RCALL _update_eeprom_parameters
; 0000 0252                                 j=0;
	LDI  R16,LOW(0)
; 0000 0253                                 }
; 0000 0254                         else
	RJMP _0x6B
_0x67:
; 0000 0255                                 {
; 0000 0256                                  //представленный ниже код работает только дл€ команд чтени€, нединамических и динамичес ...
; 0000 0257                                  /* приведенный ниже код работает следующим образом: сперва мы обращаемс€ к массиву Comm ...
; 0000 0258                                  с помощью которого получаем представление о том, какой параметр соответствует какому ба ...
; 0000 0259                                  а также какова его длина в байтах, затем поочередно перезагружаем из массива Parameter_ ...
; 0000 025A                                  массив Command_data, использу€ дл€ этого массив Parameter_mask (в этом массиве каждому  ...
; 0000 025B                                 , который мы берем из массива Command_mask, а содержимое каждой €чейки определ€ет, с как ...
; 0000 025C                                  parameter_tmp=Command_mask[tmp_command_number][j];
	CALL SUBOPT_0x11
	LPM  R0,Z
	STD  Y+12,R0
; 0000 025D 
; 0000 025E                                  for(j=0;j<24;j++)
	LDI  R16,LOW(0)
_0x6D:
	CPI  R16,24
	BRLO PC+2
	RJMP _0x6E
; 0000 025F                                          {
; 0000 0260                                          if(parameter_tmp!=Command_mask[tmp_command_number][j])
	CALL SUBOPT_0x11
	LPM  R30,Z
	LDD  R26,Y+12
	CP   R30,R26
	BRNE PC+2
	RJMP _0x6F
; 0000 0261                                                      {
; 0000 0262                                                      for(k=(j-parameter_tmp_length);k<j;k++)
	LDD  R26,Y+11
	MOV  R30,R16
	SUB  R30,R26
	MOV  R19,R30
_0x71:
	CP   R19,R16
	BRLO PC+2
	RJMP _0x72
; 0000 0263                                                                 {
; 0000 0264 //                                                                secondPoint = parameter_tmp_length;
; 0000 0265                                                                 if((parameter_tmp<11)|(parameter_tmp>13))
	LDD  R26,Y+12
	LDI  R30,LOW(11)
	CALL __LTB12U
	MOV  R0,R30
	LDI  R30,LOW(13)
	CALL __GTB12U
	OR   R30,R0
	BREQ _0x73
; 0000 0266                                                                         {
; 0000 0267                                                                             if(tmp_command_number==26)  // вот здесь фор ...
	LDD  R26,Y+10
	CPI  R26,LOW(0x1A)
	BRNE _0x74
; 0000 0268                                                                             {
; 0000 0269                                                                                 if((k < 6)|(k>13))
	MOV  R26,R19
	LDI  R30,LOW(6)
	CALL __LTB12U
	MOV  R0,R30
	LDI  R30,LOW(13)
	CALL __GTB12U
	OR   R30,R0
	BREQ _0x75
; 0000 026A                                                                                     Command_data[k]=Parameter_bank[Param ...
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	RJMP _0x196
; 0000 026B                                                                                 else
_0x75:
; 0000 026C                                                                                 {
; 0000 026D                                                                                         if(k<10)
	CPI  R19,10
	BRSH _0x77
; 0000 026E                                                                                         {
; 0000 026F                                                                                             floatsend.value = calibratio ...
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0270                                                                                             Command_data[k] = floatsend. ...
	MOVW R0,R30
	MOV  R30,R19
	LDI  R31,0
	SBIW R30,6
	RJMP _0x197
; 0000 0271                                                                                         }
; 0000 0272                                                                                         else
_0x77:
; 0000 0273                                                                                         {
; 0000 0274                                                                                             floatsend.value = calibratio ...
	CALL SUBOPT_0x15
	CALL SUBOPT_0x18
	CALL SUBOPT_0x17
; 0000 0275                                                                                             Command_data[k] = floatsend. ...
	MOVW R0,R30
	MOV  R30,R19
	LDI  R31,0
	SBIW R30,10
_0x197:
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
_0x196:
	ST   X,R30
; 0000 0276                                                                                         }
; 0000 0277                                                                                 }
; 0000 0278                                                                             }
; 0000 0279                                                                             else
	RJMP _0x79
_0x74:
; 0000 027A                                                                                 Command_data[k]=Parameter_bank[Parameter ...
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	ST   X,R30
; 0000 027B                                                                         }
_0x79:
; 0000 027C                                                                 else
	RJMP _0x7A
_0x73:
; 0000 027D                                                                         {
; 0000 027E                                                                          //ttest=(long)dynamic_variables[0];
; 0000 027F                                                                         #asm ("cli")
	cli
; 0000 0280                                                                         floatsend.value=dynamic_variables[parameter_tmp- ...
	LDD  R30,Y+12
	LDI  R31,0
	SBIW R30,11
	LDI  R26,LOW(_dynamic_variables)
	LDI  R27,HIGH(_dynamic_variables)
	CALL SUBOPT_0x19
	CALL __GETD1P
	CALL SUBOPT_0x17
; 0000 0281                                                                         //test=*str[k-1];
; 0000 0282                                                                         Command_data[k]=floatsend.byte[k+parameter_tmp_l ...
	MOVW R22,R30
	MOV  R26,R19
	CLR  R27
	LDD  R30,Y+11
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R16
	LDI  R31,0
	CALL SUBOPT_0xD
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R22
	ST   X,R30
; 0000 0283                                                                         #asm("sei")
	sei
; 0000 0284                                                                         }
_0x7A:
; 0000 0285                                                                 }
	SUBI R19,-1
	RJMP _0x71
_0x72:
; 0000 0286                                                       parameter_tmp_length=0;
	LDI  R30,LOW(0)
	STD  Y+11,R30
; 0000 0287                                                      }
; 0000 0288                                          parameter_tmp=Command_mask[tmp_command_number][j];
_0x6F:
	CALL SUBOPT_0x11
	LPM  R0,Z
	STD  Y+12,R0
; 0000 0289                                          parameter_tmp_length++;
	LDD  R30,Y+11
	SUBI R30,-LOW(1)
	STD  Y+11,R30
; 0000 028A                                          if(!Command_mask[tmp_command_number][j])j=24;
	CALL SUBOPT_0x11
	LPM  R30,Z
	CPI  R30,0
	BRNE _0x7B
	LDI  R16,LOW(24)
; 0000 028B                                          }
_0x7B:
	SUBI R16,-1
	RJMP _0x6D
_0x6E:
; 0000 028C                                  bytes_quantity_ans=k;
	STS  _bytes_quantity_ans,R19
; 0000 028D                                  k=0;
	LDI  R19,LOW(0)
; 0000 028E //                                 thirdPoint =bytes_quantity_ans;
; 0000 028F                                 }
_0x6B:
; 0000 0290                         }
; 0000 0291 
; 0000 0292 return error;
_0x66:
	LDD  R30,Y+13
	LDI  R31,0
	CALL __LOADLOCR6
	ADIW R28,15
	RET
; 0000 0293 }
; .FEND
;
;void update_eeprom_parameters(char update_flag)
; 0000 0296 {
_update_eeprom_parameters:
; .FSTART _update_eeprom_parameters
; 0000 0297 char i=0,j=0,k=0,parameter_tmp=0,parameter_tmp_length=0;
; 0000 0298 parameter_tmp=Command_mask[update_flag][0];
	ST   -Y,R26
	CALL SUBOPT_0xF
;	update_flag -> Y+6
;	i -> R17
;	j -> R16
;	k -> R19
;	parameter_tmp -> R18
;	parameter_tmp_length -> R21
	CALL SUBOPT_0x1A
	LPM  R18,Z
; 0000 0299 
; 0000 029A for(j=0;j<com_bytes_rx+1;j++)
	LDI  R16,LOW(0)
_0x7D:
	CALL SUBOPT_0x10
	BRGE _0x7E
; 0000 029B         {
; 0000 029C                     if(parameter_tmp!=Command_mask[update_flag][j])
	CALL SUBOPT_0x1A
	MOVW R26,R30
	CALL SUBOPT_0xC
	LPM  R30,Z
	CP   R30,R18
	BREQ _0x7F
; 0000 029D                              {
; 0000 029E                              for(k=(j-parameter_tmp_length);k<j;k++)
	MOV  R30,R16
	SUB  R30,R21
	MOV  R19,R30
_0x81:
	CP   R19,R16
	BRSH _0x82
; 0000 029F                                     {
; 0000 02A0                                     Parameter_bank[Parameter_mask[parameter_tmp]+(k+parameter_tmp_length-j)]=Command_dat ...
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
	CALL SUBOPT_0xD
	ADD  R30,R22
	ADC  R31,R23
	SUBI R30,LOW(-_Parameter_bank)
	SBCI R31,HIGH(-_Parameter_bank)
	MOVW R26,R30
	CALL SUBOPT_0x12
	LD   R30,Z
	CALL __EEPROMWRB
; 0000 02A1                                     }
	SUBI R19,-1
	RJMP _0x81
_0x82:
; 0000 02A2                                parameter_tmp_length=0;
	LDI  R21,LOW(0)
; 0000 02A3                              }
; 0000 02A4 
; 0000 02A5                     parameter_tmp=Command_mask[update_flag][j];
_0x7F:
	CALL SUBOPT_0x1A
	MOVW R26,R30
	CALL SUBOPT_0xC
	LPM  R18,Z
; 0000 02A6                     parameter_tmp_length++;
	SUBI R21,-1
; 0000 02A7                     if(!Command_mask[update_flag][j])j=com_bytes_rx+1;
	CALL SUBOPT_0x1A
	MOVW R26,R30
	CALL SUBOPT_0xC
	LPM  R30,Z
	CPI  R30,0
	BRNE _0x83
	LDS  R30,_com_bytes_rx
	SUBI R30,-LOW(1)
	MOV  R16,R30
; 0000 02A8         }
_0x83:
	SUBI R16,-1
	RJMP _0x7D
_0x7E:
; 0000 02A9 }
	CALL __LOADLOCR6
	ADIW R28,7
	RET
; .FEND
;
;
;
;int check_recieved_message(){
; 0000 02AD int check_recieved_message(){
_check_recieved_message:
; .FSTART _check_recieved_message
; 0000 02AE char i=0,j=0,k=0,l=0, tmp_i=0;//здесь i - счетчик всех байт j- счетчик байт преамбул
; 0000 02AF 
; 0000 02B0 int check_sum=0;
; 0000 02B1 checking_result=0;
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	CALL SUBOPT_0xF
;	i -> R17
;	j -> R16
;	k -> R19
;	l -> R18
;	tmp_i -> R21
;	check_sum -> Y+6
	LDI  R30,LOW(0)
	STS  _checking_result,R30
; 0000 02B2 answering=1;
	SBI  0x1E,5
; 0000 02B3 while ((rx_buffer0[j])==0xff)
_0x86:
	MOV  R30,R16
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0xFF)
	BRNE _0x88
; 0000 02B4         {
; 0000 02B5         if(8<j)
	CPI  R16,9
	BRLO _0x89
; 0000 02B6                 {checking_result=0x90;//ошибка формировани€ фрейма, если количество преамбул больше либо равно количеств ...
	LDI  R30,LOW(144)
	STS  _checking_result,R30
; 0000 02B7                  //rx_buffer0[i+1]=0x00;
; 0000 02B8                  return checking_result;
	RJMP _0x2080005
; 0000 02B9                  }
; 0000 02BA          j++;
_0x89:
	SUBI R16,-1
; 0000 02BB         }
	RJMP _0x86
_0x88:
; 0000 02BC         preambula_bytes_rec=j;
	STS  _preambula_bytes_rec,R16
; 0000 02BD         i=j;
	MOV  R17,R16
; 0000 02BE if ((rx_buffer0[j])!=0x02)
	MOV  R30,R16
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x2)
	BREQ _0x8A
; 0000 02BF //if ((rx_buffer0[i])!=0x02)
; 0000 02C0         {
; 0000 02C1         checking_result=0x02;
	LDI  R30,LOW(2)
	STS  _checking_result,R30
; 0000 02C2         //return checking_result;
; 0000 02C3         }//диагностируем ошибку команд "неверный выбор", если не от главного устройства
; 0000 02C4 //else    {
; 0000 02C5         check_sum=check_sum^rx_buffer0[i];
_0x8A:
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
; 0000 02C6 //        }
; 0000 02C7 i++;
; 0000 02C8 if (((rx_buffer0[i])&0x30)!=0x00)
	ANDI R30,LOW(0x30)
	BREQ _0x8B
; 0000 02C9         {checking_result=0x90;
	LDI  R30,LOW(144)
	STS  _checking_result,R30
; 0000 02CA         //return checking_result;
; 0000 02CB         }
; 0000 02CC //burst_mode=(rx_buffer0[i]&0x40)>>6;                          //burst_mode нужно вообще-то прописывать в команде
; 0000 02CD if((rx_buffer0[i]&0x0f)==Parameter_bank[25])answering=1;       //это проверка адреса, если адрес не тот, датчик молчит
_0x8B:
	CALL SUBOPT_0x1C
	ANDI R30,LOW(0xF)
	MOV  R0,R30
	__POINTW2MN _Parameter_bank,25
	CALL __EEPROMRDB
	CP   R30,R0
	BRNE _0x8C
	SBI  0x1E,5
; 0000 02CE else answering=0;
	RJMP _0x8F
_0x8C:
	CBI  0x1E,5
; 0000 02CF check_sum=check_sum^rx_buffer0[i];
_0x8F:
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
; 0000 02D0 i++;
; 0000 02D1 command_rx_val=rx_buffer0[i];// здесь сделаем проверку команды: если она состоит в листе команд, то ошибку не выдаем, ес ...
	STS  _command_rx_val,R30
; 0000 02D2 if(command_rx_val==35)
	LDS  R26,_command_rx_val
	CPI  R26,LOW(0x23)
	BRNE _0x92
; 0000 02D3         {
; 0000 02D4 //        tmpEepPriValCode = rx_buffer0[i+2];
; 0000 02D5 //       Parameter_bank[12]= (char)rx_buffer0[i+2];
; 0000 02D6         for(l=0;l<4;l++)
	LDI  R18,LOW(0)
_0x94:
	CPI  R18,4
	BRSH _0x95
; 0000 02D7                 {
; 0000 02D8                 Parameter_bank[88+l]=rx_buffer0[i+3+l];
	MOV  R30,R18
	LDI  R31,0
	__ADDW1MN _Parameter_bank,88
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,3
	CALL SUBOPT_0x1E
; 0000 02D9                 Parameter_bank[92+l]=rx_buffer0[i+7+l];
	MOV  R30,R18
	LDI  R31,0
	__ADDW1MN _Parameter_bank,92
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,7
	CALL SUBOPT_0x1E
; 0000 02DA                 }
	SUBI R18,-1
	RJMP _0x94
_0x95:
; 0000 02DB         }
; 0000 02DC //if(command_rx_val==36)for(l=0;l<4;l++)Parameter_bank[88+l]=rx_buffer0[i+2+l];
; 0000 02DD //if(command_rx_val==37)for(l=0;l<4;l++)Parameter_bank[92+l]=rx_buffer0[i+2+l];
; 0000 02DE //if(command_rx_val==38)configuration_changed_flag=0;
; 0000 02DF //if(command_rx_val==40)enter_fixed_current_mode(float(rx_buffer0[i+2])||float(rx_buffer0[i+3]<<8)||float(rx_buffer0[i+4 ...
; 0000 02E0 //if(command_rx_val==41)perform_device_self_test();
; 0000 02E1 //if(command_rx_val==42)perform_device_reset();
; 0000 02E2 if(command_rx_val==38)ResetDeviceSettings(0);
_0x92:
	LDS  R26,_command_rx_val
	CPI  R26,LOW(0x26)
	BRNE _0x96
	LDI  R26,LOW(0)
	CALL _ResetDeviceSettings
; 0000 02E3 if(command_rx_val==42)
_0x96:
	LDS  R26,_command_rx_val
	CPI  R26,LOW(0x2A)
	BRNE _0x97
; 0000 02E4                                 {
; 0000 02E5                                 if((rx_buffer0[i+2]==0x45)&(rx_buffer0[i+3]==0x52)&(rx_buffer0[i+4]==0x41)&(rx_buffer0[i ...
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _rx_buffer0,2
	LD   R26,Z
	LDI  R30,LOW(69)
	CALL __EQB12
	MOV  R0,R30
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _rx_buffer0,3
	LD   R26,Z
	LDI  R30,LOW(82)
	CALL SUBOPT_0x1F
	__ADDW1MN _rx_buffer0,4
	LD   R26,Z
	LDI  R30,LOW(65)
	CALL SUBOPT_0x1F
	__ADDW1MN _rx_buffer0,5
	LD   R26,Z
	LDI  R30,LOW(83)
	CALL SUBOPT_0x1F
	__ADDW1MN _rx_buffer0,6
	LD   R26,Z
	LDI  R30,LOW(69)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x98
; 0000 02E6                                 PerformDeviceApplicationErase();                                                         ...
	CALL _PerformDeviceApplicationErase
; 0000 02E7                                 }
_0x98:
; 0000 02E8 if(command_rx_val==43){                    //запись ацп значени€ 1й точки калибровки первичной переменной в еепром
_0x97:
	LDS  R26,_command_rx_val
	CPI  R26,LOW(0x2B)
	BRNE _0x99
; 0000 02E9                         #asm ("cli")
	cli
; 0000 02EA                         ADC_PV_calibration_point1[rangeIndex]=adc_data;//ADC_PV_zero_val=adc_data;
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
; 0000 02EB                         ADC_PV_calibration_point1_PB1[rangeIndex]=adc_data;
	CALL SUBOPT_0x22
	CALL SUBOPT_0x21
; 0000 02EC                         ADC_PV_calibration_point1_PB2[rangeIndex]=adc_data;
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
; 0000 02ED                         calibration_point1=adc_data;
	__GETWRMN 5,6,0,_adc_data
; 0000 02EE                         CalibrationConfigChanged=1;
	CALL SUBOPT_0x25
; 0000 02EF                         CalibrationConfigChangedPB1=1;
; 0000 02F0                         CalibrationConfigChangedPB2=1;
; 0000 02F1                         #asm ("sei")
	sei
; 0000 02F2                         CalculateCalibrationRates();
	RCALL _CalculateCalibrationRates
; 0000 02F3                         }
; 0000 02F4 if(command_rx_val==45)for(l=0;l<4;l++)Parameter_bank[105+l]=rx_buffer0[i+2+l];    //записываем соответствующий току бито ...
_0x99:
	LDS  R26,_command_rx_val
	CPI  R26,LOW(0x2D)
	BRNE _0x9A
	LDI  R18,LOW(0)
_0x9C:
	CPI  R18,4
	BRSH _0x9D
	MOV  R30,R18
	LDI  R31,0
	__ADDW1MN _Parameter_bank,105
	CALL SUBOPT_0x26
	SUBI R18,-1
	RJMP _0x9C
_0x9D:
; 0000 02F5 if(command_rx_val==46)for(l=0;l<4;l++)Parameter_bank[109+l]=rx_buffer0[i+2+l];
_0x9A:
	LDS  R26,_command_rx_val
	CPI  R26,LOW(0x2E)
	BRNE _0x9E
	LDI  R18,LOW(0)
_0xA0:
	CPI  R18,4
	BRSH _0xA1
	MOV  R30,R18
	LDI  R31,0
	__ADDW1MN _Parameter_bank,109
	CALL SUBOPT_0x26
	SUBI R18,-1
	RJMP _0xA0
_0xA1:
; 0000 02F7 if(command_rx_val==111){
_0x9E:
	LDS  R26,_command_rx_val
	CPI  R26,LOW(0x6F)
	BRNE _0xA2
; 0000 02F8                         #asm ("cli")
	cli
; 0000 02F9                         ADC_PV_calibration_point2[rangeIndex]=adc_data;
	CALL SUBOPT_0x27
	CALL SUBOPT_0x21
; 0000 02FA                         ADC_PV_calibration_point2_PB1[rangeIndex]=adc_data;
	CALL SUBOPT_0x28
	CALL SUBOPT_0x21
; 0000 02FB                         ADC_PV_calibration_point2_PB2[rangeIndex]=adc_data;
	CALL SUBOPT_0x29
	CALL SUBOPT_0x24
; 0000 02FC                         calibration_point2=adc_data;
	__GETWRMN 7,8,0,_adc_data
; 0000 02FD                         CalibrationConfigChanged=1;
	CALL SUBOPT_0x25
; 0000 02FE                         CalibrationConfigChangedPB1=1;
; 0000 02FF                         CalibrationConfigChangedPB2=1;
; 0000 0300                         #asm ("sei")
	sei
; 0000 0301                         CalculateCalibrationRates();
	RCALL _CalculateCalibrationRates
; 0000 0302                         }
; 0000 0303 check_sum=check_sum^rx_buffer0[i];
_0xA2:
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
; 0000 0304 i++;
; 0000 0305 com_bytes_rx=rx_buffer0[i];                    //количество байт, зна€ их провер€ем число байт данных и если оно не совп ...
	STS  _com_bytes_rx,R30
; 0000 0306 check_sum=check_sum^rx_buffer0[i];
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x2A
; 0000 0307 i++;
	SUBI R17,-1
; 0000 0308 tmp_i=i;
	MOV  R21,R17
; 0000 0309 j=tmp_i;
	MOV  R16,R21
; 0000 030A for (i=tmp_i;i<tmp_i+com_bytes_rx;i++)
	MOV  R17,R21
_0xA4:
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
	BRGE _0xA5
; 0000 030B        {
; 0000 030C        j++;
	SUBI R16,-1
; 0000 030D        com_data_rx[k]=rx_buffer0[i];
	MOV  R26,R19
	LDI  R27,0
	SUBI R26,LOW(-_com_data_rx)
	SBCI R27,HIGH(-_com_data_rx)
	CALL SUBOPT_0x1C
	ST   X,R30
; 0000 030E        check_sum=check_sum^rx_buffer0[i];
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x2A
; 0000 030F        k++;
	SUBI R19,-1
; 0000 0310        }
	SUBI R17,-1
	RJMP _0xA4
_0xA5:
; 0000 0311                 //j++;
; 0000 0312 //        if(com_bytes_rx!=0)i--;
; 0000 0313 if (j!=i)
	CP   R17,R16
	BREQ _0xA6
; 0000 0314        {checking_result=0x90;
	LDI  R30,LOW(144)
	STS  _checking_result,R30
; 0000 0315        //return checking_result;
; 0000 0316        }
; 0000 0317 //i++;
; 0000 0318 if(rx_buffer0[i]!=check_sum)
_0xA6:
	MOV  R30,R17
	CALL SUBOPT_0x1B
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0xA7
; 0000 0319         {
; 0000 031A         checking_result=0x88;
	LDI  R30,LOW(136)
	STS  _checking_result,R30
; 0000 031B         //return checking_result;
; 0000 031C         }
; 0000 031D return checking_result;
_0xA7:
_0x2080005:
	LDS  R30,_checking_result
	LDI  R31,0
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; 0000 031E }
; .FEND
;char checkSavedRangeValidity()
; 0000 0320 {
; 0000 0321  //#asm("wdr")
; 0000 0322 
; 0000 0323          char tmpRI, tmpRIPB1, tmpRIPB2;
; 0000 0324          tmpRI =  rangeIndexEep;
;	tmpRI -> R17
;	tmpRIPB1 -> R16
;	tmpRIPB2 -> R19
; 0000 0325          tmpRIPB1 = rangeIndexEepPB1;
; 0000 0326          tmpRIPB2 =rangeIndexEepPB2;
; 0000 0327 //              firstPoint = 0xCE;
; 0000 0328 //        if(tmpRIPB1==tmpRIPB2)
; 0000 0329 //        {
; 0000 032A //            firstPoint = 0xEE;
; 0000 032B //            rangeIndexEep =tmpRIPB1 ;
; 0000 032C //            return 1;
; 0000 032D //        }
; 0000 032E //        if(tmpRI == tmpRIPB2)
; 0000 032F //        {
; 0000 0330 //            firstPoint = 0xCC;
; 0000 0331 //            rangeIndexEepPB1 =rangeIndexEepPB2 ;
; 0000 0332 //            return 2;
; 0000 0333 //        }
; 0000 0334 //        if(tmpRI == tmpRIPB1)
; 0000 0335 //        {
; 0000 0336 //            firstPoint = 0xE7;
; 0000 0337 //            rangeIndexEepPB2 =tmpRI ;
; 0000 0338 //            return 3;
; 0000 0339 //        }
; 0000 033A 
; 0000 033B          if(rangeIndexEepPB2!= rangeIndexEepPB1)      //одна из €чеек 1 или 2 содержит ошибочную информацию
; 0000 033C         {
; 0000 033D 
; 0000 033E         if(rangeIndexEep==rangeIndexEepPB2)
; 0000 033F             return 1;           //0€ и 2€ €чейки верные, а 1€ - неверна€
; 0000 0340         if(rangeIndexEep==rangeIndexEepPB1)
; 0000 0341             return 2;           //0€ и 1€ €чейки верные, а 2€ €чейка некорректна
; 0000 0342             return 3;           //самый печальный исход, все 3 €чейки убитые
; 0000 0343         }
; 0000 0344 //        secondPoint = 0x23;
; 0000 0345        return 0;
; 0000 0346 
; 0000 0347 }
;char fixIncorrectRIPB(char checkres)
; 0000 0349 {
; 0000 034A 
; 0000 034B     switch(checkres)
;	checkres -> Y+0
; 0000 034C     {
; 0000 034D         case 0:
; 0000 034E                 {
; 0000 034F //                    thirdPoint = rangeIndexEepPB1;
; 0000 0350                     rangeIndexEep = rangeIndexEepPB1;
; 0000 0351                     break;
; 0000 0352                 }
; 0000 0353         case 1:
; 0000 0354                 {
; 0000 0355                     rangeIndexEepPB1 = rangeIndexEepPB2;
; 0000 0356                     break;
; 0000 0357                 }
; 0000 0358         case 2:
; 0000 0359                 {
; 0000 035A                     rangeIndexEepPB2 =  rangeIndexEep;
; 0000 035B                     break;
; 0000 035C                 }
; 0000 035D         case 3:
; 0000 035E                 {
; 0000 035F                      rangeIndexEep=1;
; 0000 0360                     break;
; 0000 0361                 }
; 0000 0362         default: break;
; 0000 0363     }
; 0000 0364     return 0;
; 0000 0365 }
;char fixIncorrectPB(char checkres)
; 0000 0367 {
_fixIncorrectPB:
; .FSTART _fixIncorrectPB
; 0000 0368 
; 0000 0369     switch(checkres)
	ST   -Y,R26
;	checkres -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0000 036A     {
; 0000 036B         case 0:
	SBIW R30,0
	BRNE _0xB6
; 0000 036C                 {
; 0000 036D //                    thirdPoint = 0xAB;
; 0000 036E                     CalibrationConfigChanged = CalibrationConfigChangedPB1;
	CALL SUBOPT_0x2B
	LDI  R26,LOW(_CalibrationConfigChanged)
	LDI  R27,HIGH(_CalibrationConfigChanged)
	CALL __EEPROMWRB
; 0000 036F                     break;
	RJMP _0xB5
; 0000 0370                 }
; 0000 0371         case 1:
_0xB6:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xB7
; 0000 0372                 {
; 0000 0373                     CalibrationConfigChangedPB1 = CalibrationConfigChangedPB2;
	CALL SUBOPT_0x2C
	LDI  R26,LOW(_CalibrationConfigChangedPB1)
	LDI  R27,HIGH(_CalibrationConfigChangedPB1)
	CALL __EEPROMWRB
; 0000 0374                     break;
	RJMP _0xB5
; 0000 0375                 }
; 0000 0376         case 2:
_0xB7:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xB8
; 0000 0377                 {
; 0000 0378                     CalibrationConfigChangedPB2 =  CalibrationConfigChanged;
	CALL SUBOPT_0x2D
	LDI  R26,LOW(_CalibrationConfigChangedPB2)
	LDI  R27,HIGH(_CalibrationConfigChangedPB2)
	CALL __EEPROMWRB
; 0000 0379                     break;
	RJMP _0xB5
; 0000 037A                 }
; 0000 037B         case 3:
_0xB8:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xBA
; 0000 037C                 {
; 0000 037D                      CalibrationConfigChanged=0xff;
	LDI  R26,LOW(_CalibrationConfigChanged)
	LDI  R27,HIGH(_CalibrationConfigChanged)
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
; 0000 037E                     break;
; 0000 037F                 }
; 0000 0380         default: break;
_0xBA:
; 0000 0381     }
_0xB5:
; 0000 0382     return 0;
	RJMP _0x2080004
; 0000 0383 }
; .FEND
;
;char checkCalibrationFlagValidity()              //приходим сюда уже зна€, что калибровка была
; 0000 0386 {
_checkCalibrationFlagValidity:
; .FSTART _checkCalibrationFlagValidity
; 0000 0387 //         char *tmpCCC, *tmpCCCPB1, *tmpCCCPB2;
; 0000 0388 //         tmpCCC =  (char*)&CalibrationConfigChanged;
; 0000 0389 //         tmpCCCPB1 = (char*)&CalibrationConfigChangedPB1;
; 0000 038A //         tmpCCCPB2 = (char*)&CalibrationConfigChangedPB2;
; 0000 038B         if(CalibrationConfigChangedPB2!= CalibrationConfigChangedPB1)      //одна из €чеек 1 или 2 содержит ошибочную ин ...
	CALL SUBOPT_0x2C
	MOV  R0,R30
	CALL SUBOPT_0x2B
	CP   R30,R0
	BREQ _0xBB
; 0000 038C         {
; 0000 038D 
; 0000 038E             if(CalibrationConfigChanged==CalibrationConfigChangedPB2)
	CALL SUBOPT_0x2D
	MOV  R0,R30
	CALL SUBOPT_0x2C
	CP   R30,R0
	BRNE _0xBC
; 0000 038F                 return 1;           //0€ и 2€ €чейки верные, а 1€ - неверна€
	LDI  R30,LOW(1)
	RET
; 0000 0390             if(CalibrationConfigChanged==CalibrationConfigChangedPB1)
_0xBC:
	CALL SUBOPT_0x2D
	MOV  R0,R30
	CALL SUBOPT_0x2B
	CP   R30,R0
	BRNE _0xBD
; 0000 0391                 return 2;           //0€ и 1€ €чейки верные, а 2€ €чейка некорректна
	LDI  R30,LOW(2)
	RET
; 0000 0392                 return 3;           //самый печальный исход, все 3 €чейки убитые
_0xBD:
	LDI  R30,LOW(3)
	RET
; 0000 0393         }
; 0000 0394 //        secondPoint = 0x23;
; 0000 0395        return 0;                  //2€ и 1€ €чейки корректны
_0xBB:
	RJMP _0x2080002
; 0000 0396 }
; .FEND
;
;char checkCalibrationRatesValidity(char index)
; 0000 0399 {
_checkCalibrationRatesValidity:
; .FSTART _checkCalibrationRatesValidity
; 0000 039A               if(ADC_PV_calibration_point1[index]==ADC_PV_calibration_point1_PB1[index])                //провер€ем 1ю т ...
	ST   -Y,R26
;	index -> Y+0
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x22
	CALL SUBOPT_0x2F
	BRNE _0xBE
; 0000 039B         {
; 0000 039C                 if(ADC_PV_calibration_point1[index]!=ADC_PV_calibration_point1_PB2[index])//неисправна €чейка ≈≈ѕ–ќћ PB2
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x23
	CALL SUBOPT_0x2F
	BREQ _0xBF
; 0000 039D                        return 1;
	LDI  R30,LOW(1)
	RJMP _0x2080003
; 0000 039E         }
_0xBF:
; 0000 039F         else
	RJMP _0xC0
_0xBE:
; 0000 03A0         {
; 0000 03A1                 if(ADC_PV_calibration_point1[index]==ADC_PV_calibration_point1_PB2[index])
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x23
	CALL SUBOPT_0x2F
	BRNE _0xC1
; 0000 03A2                         return 2;    //неисправна €чейка ≈≈ѕ–ќћ PB1
	LDI  R30,LOW(2)
	RJMP _0x2080003
; 0000 03A3                 else if(ADC_PV_calibration_point1_PB1[index]==ADC_PV_calibration_point1_PB2[index])
_0xC1:
	LD   R30,Y
	CALL SUBOPT_0x22
	CALL SUBOPT_0x30
	CALL SUBOPT_0x23
	CALL SUBOPT_0x2F
	BRNE _0xC3
; 0000 03A4                 {
; 0000 03A5                                return 3;// ADC_PV_calibration_point1[index] = ADC_PV_calibration_point1_PB1[index];      ...
	LDI  R30,LOW(3)
	RJMP _0x2080003
; 0000 03A6                              //   CalculateCalibrationRates();
; 0000 03A7                 }
; 0000 03A8           }
_0xC3:
_0xC0:
; 0000 03A9         if(ADC_PV_calibration_point2[index]==ADC_PV_calibration_point2_PB1[index])                //провер€ем 2ю точку к ...
	CALL SUBOPT_0x31
	CALL SUBOPT_0x28
	CALL SUBOPT_0x2F
	BRNE _0xC4
; 0000 03AA         {
; 0000 03AB                 if(ADC_PV_calibration_point2[index]!=ADC_PV_calibration_point2_PB2[index])//неисправна €чейка ≈≈ѕ–ќћ PB2
	CALL SUBOPT_0x31
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2F
	BREQ _0xC5
; 0000 03AC                        return 4;
	LDI  R30,LOW(4)
	RJMP _0x2080003
; 0000 03AD         }
_0xC5:
; 0000 03AE         else
	RJMP _0xC6
_0xC4:
; 0000 03AF         {
; 0000 03B0                 if(ADC_PV_calibration_point2[index]==ADC_PV_calibration_point2_PB2[index])
	CALL SUBOPT_0x31
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2F
	BRNE _0xC7
; 0000 03B1                        return 5;    //неисправна €чейка ≈≈ѕ–ќћ PB1
	LDI  R30,LOW(5)
	RJMP _0x2080003
; 0000 03B2                 else if(ADC_PV_calibration_point2_PB1[index]==ADC_PV_calibration_point2_PB2[index])
_0xC7:
	LD   R30,Y
	CALL SUBOPT_0x28
	CALL SUBOPT_0x30
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2F
	BRNE _0xC9
; 0000 03B3                 {
; 0000 03B4                                 return 6;      //неисправна €чейка ≈≈ѕ–ќћ point1
	LDI  R30,LOW(6)
	RJMP _0x2080003
; 0000 03B5                                // CalculateCalibrationRates();
; 0000 03B6                 }
; 0000 03B7         }
_0xC9:
_0xC6:
; 0000 03B8 
; 0000 03B9         if(calibrationKeep[index]==calibrationKeep_PB1[index])                                        //провер€ем калибр ...
	LD   R30,Y
	CALL SUBOPT_0x16
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x32
	CALL __EEPROMRDD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0xCA
; 0000 03BA         {
; 0000 03BB                 if(calibrationKeep[index]!=calibrationKeep_PB2[index])//неисправна €чейка ≈≈ѕ–ќћ PB2
	LD   R30,Y
	CALL SUBOPT_0x16
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x33
	CALL __EEPROMRDD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BREQ _0xCB
; 0000 03BC                         return 7;
	LDI  R30,LOW(7)
	RJMP _0x2080003
; 0000 03BD         }
_0xCB:
; 0000 03BE         else
	RJMP _0xCC
_0xCA:
; 0000 03BF         {
; 0000 03C0                 if(calibrationKeep[index]==calibrationKeep_PB2[index])
	LD   R30,Y
	CALL SUBOPT_0x16
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x33
	CALL __EEPROMRDD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0xCD
; 0000 03C1                         return 8;    //неисправна €чейка ≈≈ѕ–ќћ PB1
	LDI  R30,LOW(8)
	RJMP _0x2080003
; 0000 03C2                 else if(calibrationKeep_PB1[index]==calibrationKeep_PB2[index])
_0xCD:
	CALL SUBOPT_0x32
	CALL __EEPROMRDD
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x33
	CALL __EEPROMRDD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0xCF
; 0000 03C3                 {
; 0000 03C4                                 return 9;      //неисправна €чейка ≈≈ѕ–ќћ point1
	LDI  R30,LOW(9)
	RJMP _0x2080003
; 0000 03C5                                 //CalculateCalibrationRates();
; 0000 03C6                 }
; 0000 03C7         }
_0xCF:
_0xCC:
; 0000 03C8 
; 0000 03C9         if(calibrationBeep[index]==calibrationBeep_PB1[index])                                        //провер€ем калибр ...
	LD   R30,Y
	CALL SUBOPT_0x18
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x34
	CALL __EEPROMRDD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0xD0
; 0000 03CA         {
; 0000 03CB                 if(calibrationBeep[index]!=calibrationBeep_PB2[index])//неисправна €чейка ≈≈ѕ–ќћ PB2
	LD   R30,Y
	CALL SUBOPT_0x18
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x35
	CALL __EEPROMRDD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BREQ _0xD1
; 0000 03CC                        return 10;
	LDI  R30,LOW(10)
	RJMP _0x2080003
; 0000 03CD         }
_0xD1:
; 0000 03CE         else
	RJMP _0xD2
_0xD0:
; 0000 03CF         {
; 0000 03D0                 if(calibrationBeep[index]==calibrationBeep_PB2[index])
	LD   R30,Y
	CALL SUBOPT_0x18
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x35
	CALL __EEPROMRDD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0xD3
; 0000 03D1                         return 11;    //неисправна €чейка ≈≈ѕ–ќћ PB1
	LDI  R30,LOW(11)
	RJMP _0x2080003
; 0000 03D2                 else if(calibrationBeep_PB1[index]==calibrationBeep_PB2[index])
_0xD3:
	CALL SUBOPT_0x34
	CALL __EEPROMRDD
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x35
	CALL __EEPROMRDD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0xD5
; 0000 03D3                 {
; 0000 03D4                                 return 12;      //неисправна €чейка ≈≈ѕ–ќћ point1
	LDI  R30,LOW(12)
	RJMP _0x2080003
; 0000 03D5                                 //CalculateCalibrationRates();
; 0000 03D6                 }
; 0000 03D7         }
_0xD5:
_0xD2:
; 0000 03D8         return 0;
_0x2080004:
	LDI  R30,LOW(0)
_0x2080003:
	ADIW R28,1
	RET
; 0000 03D9 }
; .FEND
;//
;//void fillIDVars()
;//{
;//    int tmpcrc = 0;
;//     tmpcrc = (int)(Parameter_bank[10]<<8)|Parameter_bank[11];
;//    devCodePB1 = Parameter_bank[2];       // 2, 6, 10-11,25
;//    devCodePB2= Parameter_bank[2];
;//    firmwareRevPB1 = Parameter_bank[6];
;//    firmwareRevPB2 = Parameter_bank[6];
;//    firmwareCRCPB1= tmpcrc ;
;//    firmwareCRCPB2= tmpcrc ;
;//    devAddrPB1 = Parameter_bank[25];
;//    devAddrPB2 =  Parameter_bank[25];
;//}
;char checkIDVarsValidity()
; 0000 03E9 {
_checkIDVarsValidity:
; .FSTART _checkIDVarsValidity
; 0000 03EA if(Parameter_bank[2]!=0xb3)//код тип устройства производител€
	__POINTW2MN _Parameter_bank,2
	CALL __EEPROMRDB
	CPI  R30,LOW(0xB3)
	BREQ _0xD6
; 0000 03EB       Parameter_bank[2]=0xb3;
	__POINTW2MN _Parameter_bank,2
	LDI  R30,LOW(179)
	CALL __EEPROMWRB
; 0000 03EC if(Parameter_bank[6]!=0x01)//верси€
_0xD6:
	__POINTW2MN _Parameter_bank,6
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BREQ _0xD7
; 0000 03ED     Parameter_bank[6]=0x01;
	__POINTW2MN _Parameter_bank,6
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 03EE if(Parameter_bank[11]!=0xBC)//старший бит  —
_0xD7:
	__POINTW2MN _Parameter_bank,11
	CALL __EEPROMRDB
	CPI  R30,LOW(0xBC)
	BREQ _0xD8
; 0000 03EF     Parameter_bank[11]=0xBC;
	__POINTW2MN _Parameter_bank,11
	LDI  R30,LOW(188)
	CALL __EEPROMWRB
; 0000 03F0 if(Parameter_bank[10]!=0xBF)//младший бит  —
_0xD8:
	__POINTW2MN _Parameter_bank,10
	CALL __EEPROMRDB
	CPI  R30,LOW(0xBF)
	BREQ _0xD9
; 0000 03F1     Parameter_bank[10]=0xBF;
	__POINTW2MN _Parameter_bank,10
	LDI  R30,LOW(191)
	CALL __EEPROMWRB
; 0000 03F2 if( Parameter_bank[25]>15)
_0xD9:
	__POINTW2MN _Parameter_bank,25
	CALL __EEPROMRDB
	CPI  R30,LOW(0x10)
	BRLO _0xDA
; 0000 03F3      Parameter_bank[25] = 0x02;
	__POINTW2MN _Parameter_bank,25
	LDI  R30,LOW(2)
	CALL __EEPROMWRB
; 0000 03F4 //int tmpcrc = 0;
; 0000 03F5 //char tmpDevCode = Parameter_bank[2];
; 0000 03F6 //char tmpDevCodePB1 = EEPROM_read(0x001AE);
; 0000 03F7 //char tmpDevCodePB2 = EEPROM_read(0x001AF);
; 0000 03F8 //
; 0000 03F9 //char tmpFirmwareRev = Parameter_bank[6];
; 0000 03FA //char tmpFirmwareRevPB1 = EEPROM_read(0x001B0);
; 0000 03FB //char tmpFirmwareRevPB2 = EEPROM_read(0x001B1);
; 0000 03FC //       tmpcrc = (int)(Parameter_bank[10]<<8)|Parameter_bank[11];
; 0000 03FD //         if(tmpDevCode==tmpDevCodePB1)                //провер€ем 1ю точку калибровки выбранного диапазона
; 0000 03FE //        {
; 0000 03FF //                if(tmpDevCode!=tmpDevCodePB2)//неисправна €чейка ≈≈ѕ–ќћ PB2
; 0000 0400 //                          EEPROM_write(0x001AF, tmpDevCode);//     devCodePB2 = Parameter_bank[2];
; 0000 0401 //        }
; 0000 0402 //        else
; 0000 0403 //        {
; 0000 0404 //                if(tmpDevCode==tmpDevCodePB2)
; 0000 0405 //                        EEPROM_write(0x001AE, tmpDevCode);//devCodePB1 = Parameter_bank[2];    //неисправна €чейка ≈≈ѕ ...
; 0000 0406 //                else if(tmpDevCodePB1==tmpDevCodePB2)
; 0000 0407 //                {
; 0000 0408 //                                Parameter_bank[2] = tmpDevCodePB1;      //неисправна €чейка ≈≈ѕ–ќћ point1
; 0000 0409 //                               // CalculateCalibrationRates();
; 0000 040A //                }
; 0000 040B //          }
; 0000 040C //        if(Parameter_bank[6]==firmwareRevPB1)                //провер€ем 2ю точку калибровки выбранного диапазона
; 0000 040D //        {
; 0000 040E //                if(Parameter_bank[6]!=firmwareRevPB2)//неисправна €чейка ≈≈ѕ–ќћ PB2
; 0000 040F //                        firmwareRevPB2 = Parameter_bank[6];
; 0000 0410 //        }
; 0000 0411 //        else
; 0000 0412 //        {
; 0000 0413 //                if(Parameter_bank[6]==firmwareRevPB2)
; 0000 0414 //                       firmwareRevPB1 = Parameter_bank[6];    //неисправна €чейка ≈≈ѕ–ќћ PB1
; 0000 0415 //                else if(firmwareRevPB1==firmwareRevPB2)
; 0000 0416 //                {
; 0000 0417 //                                Parameter_bank[6] = firmwareRevPB1;      //неисправна €чейка ≈≈ѕ–ќћ point1
; 0000 0418 //
; 0000 0419 //                }
; 0000 041A //        }
; 0000 041B 
; 0000 041C //
; 0000 041D //        if(tmpcrc==firmwareCRCPB1)          //                              провер€ем калибровочный коэффициент  
; 0000 041E //        {
; 0000 041F //                if(tmpcrc!=firmwareCRCPB2)//неисправна €чейка ≈≈ѕ–ќћ PB2
; 0000 0420 //                        firmwareCRCPB2= tmpcrc;
; 0000 0421 //        }
; 0000 0422 //        else
; 0000 0423 //        {
; 0000 0424 //                if(tmpcrc==firmwareCRCPB2)
; 0000 0425 //                        firmwareCRCPB1 = tmpcrc;    //неисправна €чейка ≈≈ѕ–ќћ PB1
; 0000 0426 //                else if(firmwareCRCPB1==firmwareCRCPB2)
; 0000 0427 //                {
; 0000 0428 //
; 0000 0429 //                                tmpcrc =firmwareCRCPB1;//      неисправна €чейка ≈≈ѕ–ќћ point1
; 0000 042A //
; 0000 042B //                }
; 0000 042C //        }
; 0000 042D //
; 0000 042E //        if(tmpPar==devAddrPB1)                                        //провер€ем калибровочный коэффициент B
; 0000 042F //        {
; 0000 0430 //                if(tmpPar!=devAddrPB2)//неисправна €чейка ≈≈ѕ–ќћ PB2
; 0000 0431 //                        devAddrPB2=tmpPar;
; 0000 0432 //        }
; 0000 0433 //        else
; 0000 0434 //        {
; 0000 0435 //                if(tmpPar==devAddrPB2)
; 0000 0436 //                        devAddrPB1 = tmpPar;    //неисправна €чейка ≈≈ѕ–ќћ PB1
; 0000 0437 //                else if(devAddrPB1==devAddrPB2)
; 0000 0438 //                {
; 0000 0439 //                                Parameter_bank[25] = devAddrPB1;      //неисправна €чейка ≈≈ѕ–ќћ point1
; 0000 043A //
; 0000 043B //                }
; 0000 043C //        }
; 0000 043D      return 0;
_0xDA:
_0x2080002:
	LDI  R30,LOW(0)
	RET
; 0000 043E }
; .FEND
;
;//char fixIncorrectIDVars(char res)
;//{
;//return 0;
;//int tmpcrc = 0;
;// __eeprom char devCodePB1;       // 2, 6, 10-11,25
;//__eeprom char devCodePB2;
;//__eeprom char firmwareRevPB1;
;//__eeprom char firmwareRevPB2;
;//__eeprom int firmwareCRCPB1;
;//__eeprom int firmwareCRCPB2;
;//__eeprom char devAddrPB1;
;//__eeprom char devAddrPB2;
;// tmpcrc = (int)(Parameter_bank[10]<<8)|Parameter_bank[11];
;//         if(Parameter_bank[2]==devCodePB1)                //провер€ем 1ю точку калибровки выбранного диапазона
;//        {
;//                if(Parameter_bank[2]!=devCodePB2)//неисправна €чейка ≈≈ѕ–ќћ PB2
;//                        devCodePB2 = Parameter_bank[2];
;//        }
;//        else
;//        {
;//                if(Parameter_bank[2]==devCodePB2)
;//                        devCodePB1 = Parameter_bank[2];    //неисправна €чейка ≈≈ѕ–ќћ PB1
;//                else if(devCodePB1==devCodePB2)
;//                {
;//                                Parameter_bank[2] = devCodePB1;      //неисправна €чейка ≈≈ѕ–ќћ point1
;//                               // CalculateCalibrationRates();
;//                }
;//          }
;//          #asm("wdr")
;//        if(Parameter_bank[6]==firmwareRevPB1)                //провер€ем 2ю точку калибровки выбранного диапазона
;//        {
;//                if(Parameter_bank[6]!=firmwareRevPB2)//неисправна €чейка ≈≈ѕ–ќћ PB2
;//                        firmwareRevPB2 = Parameter_bank[6];
;//        }
;//        else
;//        {
;//                if(Parameter_bank[6]==firmwareRevPB2)
;//                       firmwareRevPB1 = Parameter_bank[6];    //неисправна €чейка ≈≈ѕ–ќћ PB1
;//                else if(firmwareRevPB1==firmwareRevPB2)
;//                {
;//                                Parameter_bank[6] = firmwareRevPB1;      //неисправна €чейка ≈≈ѕ–ќћ point1
;//
;//                }
;//        }
;//
;//        if(tmpcrc==firmwareCRCPB1)                                        провер€ем калибровочный коэффициент  
;//        {
;//                if(tmpcrc!=firmwareCRCPB2)неисправна €чейка ≈≈ѕ–ќћ PB2
;//                        firmwareCRCPB2= tmpcrc;
;//        }
;//        else
;//        {
;//                if(tmpcrc==firmwareCRCPB2)
;//                        firmwareCRCPB1 = tmpcrc;    неисправна €чейка ≈≈ѕ–ќћ PB1
;//                else if(firmwareCRCPB1==firmwareCRCPB2)
;//                {
;//                                tmpcrc =firmwareCRCPB1;      неисправна €чейка ≈≈ѕ–ќћ point1
;//
;//                }
;//        }
;
;//        if(Parameter_bank[25]==devAddrPB1)                                        //провер€ем калибровочный коэффициен ...
;//        {
;//                if(Parameter_bank[25]!=devAddrPB2)//неисправна €чейка ≈≈ѕ–ќћ PB2
;//                        devAddrPB2= Parameter_bank[25];
;//        }
;//        else
;//        {
;//                if(Parameter_bank[25]==devAddrPB2)
;//                        devAddrPB1 = Parameter_bank[25];    //неисправна €чейка ≈≈ѕ–ќћ PB1
;//                else if(devAddrPB1==devAddrPB2)
;//                {
;//                                Parameter_bank[25] = devAddrPB1;      //неисправна €чейка ≈≈ѕ–ќћ point1
;//
;//                }
;//        }
;//        return 0;
;//}
;
;//char fixCRC()
;//{
;//int tmpcrc = 0;
;// tmpcrc = (int)(Parameter_bank[10]<<8)|Parameter_bank[11];
;//            if(tmpcrc==firmwareCRCPB1)                                        //провер€ем калибровочный коэффициент  
;//        {
;//                if(tmpcrc!=firmwareCRCPB2)//неисправна €чейка ≈≈ѕ–ќћ PB2
;//                        firmwareCRCPB2= tmpcrc;
;//        }
;//        else
;//        {
;//                if(tmpcrc==firmwareCRCPB2)
;//                        firmwareCRCPB1 = tmpcrc;    //неисправна €чейка ≈≈ѕ–ќћ PB1
;//                else if(firmwareCRCPB1==firmwareCRCPB2)
;//                {
;//                                tmpcrc =firmwareCRCPB1;      //неисправна €чейка ≈≈ѕ–ќћ point1
;//
;//                }
;//        }
;//}
;char fixIncorrectCalibrationRates(char index, char checkres)
; 0000 04A4 {
_fixIncorrectCalibrationRates:
; .FSTART _fixIncorrectCalibrationRates
; 0000 04A5          switch(checkres)
	ST   -Y,R26
;	index -> Y+1
;	checkres -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0000 04A6     {
; 0000 04A7         case 0:
	SBIW R30,0
	BRNE _0xDE
; 0000 04A8                 {
; 0000 04A9 //                    thirdPoint = 0xAB;
; 0000 04AA                    // ADC_PV_calibration_point1_PB2[index] = CalibrationConfigChangedPB1;
; 0000 04AB                     break;
	RJMP _0xDD
; 0000 04AC                 }
; 0000 04AD         case 1:
_0xDE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xDF
; 0000 04AE                 {
; 0000 04AF                    ADC_PV_calibration_point1_PB2[index]= ADC_PV_calibration_point1[index];
	LDD  R30,Y+1
	LDI  R26,LOW(_ADC_PV_calibration_point1_PB2)
	LDI  R27,HIGH(_ADC_PV_calibration_point1_PB2)
	LDI  R31,0
	CALL SUBOPT_0x1
	CALL SUBOPT_0x36
; 0000 04B0                     break;
	RJMP _0xDD
; 0000 04B1                 }
; 0000 04B2         case 2:
_0xDF:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xE0
; 0000 04B3                 {
; 0000 04B4                     ADC_PV_calibration_point1_PB1[index] =  ADC_PV_calibration_point1[index];
	LDD  R30,Y+1
	LDI  R26,LOW(_ADC_PV_calibration_point1_PB1)
	LDI  R27,HIGH(_ADC_PV_calibration_point1_PB1)
	LDI  R31,0
	CALL SUBOPT_0x1
	CALL SUBOPT_0x36
; 0000 04B5                     break;
	RJMP _0xDD
; 0000 04B6                 }
; 0000 04B7         case 3:
_0xE0:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xE1
; 0000 04B8                 {
; 0000 04B9                      ADC_PV_calibration_point1[index] =ADC_PV_calibration_point1_PB1[index] ;
	LDD  R30,Y+1
	LDI  R26,LOW(_ADC_PV_calibration_point1)
	LDI  R27,HIGH(_ADC_PV_calibration_point1)
	LDI  R31,0
	CALL SUBOPT_0x1
	MOVW R0,R30
	LDD  R30,Y+1
	CALL SUBOPT_0x22
	CALL SUBOPT_0x37
; 0000 04BA                     break;
	RJMP _0xDD
; 0000 04BB                 }
; 0000 04BC        case 4:
_0xE1:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xE2
; 0000 04BD                 {
; 0000 04BE                    ADC_PV_calibration_point2_PB2[index]= ADC_PV_calibration_point2[index];
	LDD  R30,Y+1
	LDI  R26,LOW(_ADC_PV_calibration_point2_PB2)
	LDI  R27,HIGH(_ADC_PV_calibration_point2_PB2)
	LDI  R31,0
	CALL SUBOPT_0x1
	CALL SUBOPT_0x38
; 0000 04BF                     break;
	RJMP _0xDD
; 0000 04C0                 }
; 0000 04C1         case 5:
_0xE2:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xE3
; 0000 04C2                 {
; 0000 04C3                     ADC_PV_calibration_point2_PB1[index] =  ADC_PV_calibration_point2[index];
	LDD  R30,Y+1
	LDI  R26,LOW(_ADC_PV_calibration_point2_PB1)
	LDI  R27,HIGH(_ADC_PV_calibration_point2_PB1)
	LDI  R31,0
	CALL SUBOPT_0x1
	CALL SUBOPT_0x38
; 0000 04C4                     break;
	RJMP _0xDD
; 0000 04C5                 }
; 0000 04C6         case 6:
_0xE3:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xE4
; 0000 04C7                 {
; 0000 04C8                      ADC_PV_calibration_point2[index] =ADC_PV_calibration_point2_PB1[index] ;
	LDD  R30,Y+1
	LDI  R26,LOW(_ADC_PV_calibration_point2)
	LDI  R27,HIGH(_ADC_PV_calibration_point2)
	LDI  R31,0
	CALL SUBOPT_0x1
	MOVW R0,R30
	LDD  R30,Y+1
	CALL SUBOPT_0x28
	CALL SUBOPT_0x37
; 0000 04C9                     break;
	RJMP _0xDD
; 0000 04CA                 }
; 0000 04CB         case 7:
_0xE4:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xE5
; 0000 04CC                 {
; 0000 04CD                    calibrationKeep_PB2[index]= calibrationKeep[index];
	LDD  R30,Y+1
	LDI  R26,LOW(_calibrationKeep_PB2)
	LDI  R27,HIGH(_calibrationKeep_PB2)
	CALL SUBOPT_0x39
	MOVW R26,R0
	CALL __EEPROMWRD
; 0000 04CE                     break;
	RJMP _0xDD
; 0000 04CF                 }
; 0000 04D0         case 8:
_0xE5:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xE6
; 0000 04D1                 {
; 0000 04D2                     calibrationKeep_PB1[index] =  calibrationKeep[index];
	LDD  R30,Y+1
	LDI  R26,LOW(_calibrationKeep_PB1)
	LDI  R27,HIGH(_calibrationKeep_PB1)
	CALL SUBOPT_0x39
	MOVW R26,R0
	CALL __EEPROMWRD
; 0000 04D3                     break;
	RJMP _0xDD
; 0000 04D4                 }
; 0000 04D5         case 9:
_0xE6:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xE7
; 0000 04D6                 {
; 0000 04D7                      calibrationKeep[index] =calibrationKeep_PB1[index] ;
	LDD  R30,Y+1
	LDI  R26,LOW(_calibrationKeep)
	LDI  R27,HIGH(_calibrationKeep)
	CALL SUBOPT_0x3A
	LDI  R26,LOW(_calibrationKeep_PB1)
	LDI  R27,HIGH(_calibrationKeep_PB1)
	LDI  R31,0
	CALL SUBOPT_0x19
	CALL __EEPROMRDD
	MOVW R26,R0
	CALL __EEPROMWRD
; 0000 04D8                     break;
	RJMP _0xDD
; 0000 04D9                 }
; 0000 04DA         case 10:
_0xE7:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xE8
; 0000 04DB                 {
; 0000 04DC                    calibrationBeep_PB2[index]= calibrationBeep[index];
	LDD  R30,Y+1
	LDI  R26,LOW(_calibrationBeep_PB2)
	LDI  R27,HIGH(_calibrationBeep_PB2)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x18
	MOVW R26,R0
	CALL __EEPROMWRD
; 0000 04DD                     break;
	RJMP _0xDD
; 0000 04DE                 }
; 0000 04DF         case 11:
_0xE8:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xE9
; 0000 04E0                 {
; 0000 04E1                     calibrationBeep_PB1[index] =  calibrationBeep[index];
	LDD  R30,Y+1
	LDI  R26,LOW(_calibrationBeep_PB1)
	LDI  R27,HIGH(_calibrationBeep_PB1)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x18
	MOVW R26,R0
	CALL __EEPROMWRD
; 0000 04E2                     break;
	RJMP _0xDD
; 0000 04E3                 }
; 0000 04E4         case 12:
_0xE9:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xEB
; 0000 04E5                 {
; 0000 04E6                      calibrationBeep[index] =calibrationBeep_PB1[index] ;
	LDD  R30,Y+1
	LDI  R26,LOW(_calibrationBeep)
	LDI  R27,HIGH(_calibrationBeep)
	CALL SUBOPT_0x3A
	LDI  R26,LOW(_calibrationBeep_PB1)
	LDI  R27,HIGH(_calibrationBeep_PB1)
	LDI  R31,0
	CALL SUBOPT_0x19
	CALL __EEPROMRDD
	MOVW R26,R0
	CALL __EEPROMWRD
; 0000 04E7                     break;
; 0000 04E8                 }
; 0000 04E9         default: break;
_0xEB:
; 0000 04EA     }
_0xDD:
; 0000 04EB     return 0;
	LDI  R30,LOW(0)
	ADIW R28,2
	RET
; 0000 04EC }
; .FEND
;void checkIntegrityOfCalibrationVars(char index)                               //проверка целостности еепром данных
; 0000 04EE {
; 0000 04EF 
; 0000 04F0 for(index = 0; index < 4; index++)
;	index -> Y+0
; 0000 04F1 {
; 0000 04F2           if(ADC_PV_calibration_point1[index]==ADC_PV_calibration_point1_PB1[index])                //провер€ем 1ю точку ...
; 0000 04F3         {
; 0000 04F4                 if(ADC_PV_calibration_point1[index]!=ADC_PV_calibration_point1_PB2[index])//неисправна €чейка ≈≈ѕ–ќћ PB2
; 0000 04F5                         ADC_PV_calibration_point1_PB2[index] = ADC_PV_calibration_point1[index];
; 0000 04F6         }
; 0000 04F7         else
; 0000 04F8         {
; 0000 04F9                 if(ADC_PV_calibration_point1[index]==ADC_PV_calibration_point1_PB2[index])
; 0000 04FA                         ADC_PV_calibration_point1_PB1[index] = ADC_PV_calibration_point1[index];    //неисправна €чейка  ...
; 0000 04FB                 else if(ADC_PV_calibration_point1_PB1[index]==ADC_PV_calibration_point1_PB2[index])
; 0000 04FC                 {
; 0000 04FD                                 ADC_PV_calibration_point1[index] = ADC_PV_calibration_point1_PB1[index];      //неисправ ...
; 0000 04FE                                 CalculateCalibrationRates();
; 0000 04FF                 }
; 0000 0500           }
; 0000 0501         if(ADC_PV_calibration_point2[index]==ADC_PV_calibration_point2_PB1[index])                //провер€ем 2ю точку к ...
; 0000 0502         {
; 0000 0503                 if(ADC_PV_calibration_point2[index]!=ADC_PV_calibration_point2_PB2[index])//неисправна €чейка ≈≈ѕ–ќћ PB2
; 0000 0504                         ADC_PV_calibration_point2_PB2[index] = ADC_PV_calibration_point2[index];
; 0000 0505         }
; 0000 0506         else
; 0000 0507         {
; 0000 0508                 if(ADC_PV_calibration_point2[index]==ADC_PV_calibration_point2_PB2[index])
; 0000 0509                         ADC_PV_calibration_point2_PB1[index] = ADC_PV_calibration_point2[index];    //неисправна €чейка  ...
; 0000 050A                 else if(ADC_PV_calibration_point2_PB1[index]==ADC_PV_calibration_point2_PB2[index])
; 0000 050B                 {
; 0000 050C                                 ADC_PV_calibration_point2[index] = ADC_PV_calibration_point2_PB1[index];      //неисправ ...
; 0000 050D                                 CalculateCalibrationRates();
; 0000 050E                 }
; 0000 050F         }
; 0000 0510 
; 0000 0511         if(calibrationKeep[index]==calibrationKeep_PB1[index])                                        //провер€ем калибр ...
; 0000 0512         {
; 0000 0513                 if(calibrationKeep[index]!=calibrationKeep_PB2[index])//неисправна €чейка ≈≈ѕ–ќћ PB2
; 0000 0514                         calibrationKeep_PB2[index] = calibrationKeep[index];
; 0000 0515         }
; 0000 0516         else
; 0000 0517         {
; 0000 0518                 if(calibrationKeep[index]==calibrationKeep_PB2[index])
; 0000 0519                         calibrationKeep_PB1[index] = calibrationKeep[index];    //неисправна €чейка ≈≈ѕ–ќћ PB1
; 0000 051A                 else if(calibrationKeep_PB1[index]==calibrationKeep_PB2[index])
; 0000 051B                 {
; 0000 051C                                 calibrationKeep[index] = calibrationKeep_PB1[index];      //неисправна €чейка ≈≈ѕ–ќћ poi ...
; 0000 051D                                 CalculateCalibrationRates();
; 0000 051E                 }
; 0000 051F         }
; 0000 0520 
; 0000 0521         if(calibrationBeep[index]==calibrationBeep_PB1[index])                                        //провер€ем калибр ...
; 0000 0522         {
; 0000 0523                 if(calibrationBeep[index]!=calibrationBeep_PB2[index])//неисправна €чейка ≈≈ѕ–ќћ PB2
; 0000 0524                         calibrationBeep_PB2[index] = calibrationBeep[index];
; 0000 0525         }
; 0000 0526         else
; 0000 0527         {
; 0000 0528                 if(calibrationBeep[index]==calibrationBeep_PB2[index])
; 0000 0529                         calibrationBeep_PB1[index] = calibrationBeep[index];    //неисправна €чейка ≈≈ѕ–ќћ PB1
; 0000 052A                 else if(calibrationBeep_PB1[index]==calibrationBeep_PB2[index])
; 0000 052B                 {
; 0000 052C                                 calibrationBeep[index] = calibrationBeep_PB1[index];      //неисправна €чейка ≈≈ѕ–ќћ poi ...
; 0000 052D                                 CalculateCalibrationRates();
; 0000 052E                 }
; 0000 052F         }
; 0000 0530 }
; 0000 0531 
; 0000 0532 }
;void clear_buffer()
; 0000 0534 {
_clear_buffer:
; .FSTART _clear_buffer
; 0000 0535 char i=0;
; 0000 0536 for (i=0;i<RX_BUFFER_SIZE0;i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	LDI  R17,LOW(0)
_0x108:
	CPI  R17,64
	BRSH _0x109
; 0000 0537         {
; 0000 0538         rx_buffer0[i]=0;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0539         tx_buffer0[i]=0;
	CALL SUBOPT_0x6
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 053A         }
	SUBI R17,-1
	RJMP _0x108
_0x109:
; 0000 053B for (i=0;i<25;i++)
	LDI  R17,LOW(0)
_0x10B:
	CPI  R17,25
	BRSH _0x10C
; 0000 053C         {
; 0000 053D         com_data_rx[i]=0;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_com_data_rx)
	SBCI R31,HIGH(-_com_data_rx)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 053E         Command_data[i]=0;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_Command_data)
	SBCI R31,HIGH(-_Command_data)
	STD  Z+0,R26
; 0000 053F         }
	SUBI R17,-1
	RJMP _0x10B
_0x10C:
; 0000 0540 }
	LD   R17,Y+
	RET
; .FEND
;// Declare your global variables here
;void system_init_(char initVar){
; 0000 0542 void system_init_(char initVar){
; 0000 0543 #asm("wdr")
;	initVar -> Y+0
; 0000 0544 WDTCSR=0x38;
; 0000 0545 WDTCSR=0x0E;
; 0000 0546 // Crystal Oscillator division factor: 1
; 0000 0547 /*#pragma optsize-
; 0000 0548 CLKPR=0x80;
; 0000 0549 CLKPR=0x00;
; 0000 054A #ifdef _OPTIMIZE_SIZE_
; 0000 054B #pragma optsize+
; 0000 054C #endif
; 0000 054D   */
; 0000 054E // Input/Output Ports initialization
; 0000 054F // Port B initialization
; 0000 0550 // Func7=In Func6=In Func5=Out Func4=In Func3=Out Func2=Out Func1=In Func0=In
; 0000 0551 // State7=T State6=T State5=0 State4=T State3=0 State2=0 State1=T State0=T
; 0000 0552 PORTB=0x00;
; 0000 0553 DDRB=0x2c;
; 0000 0554 
; 0000 0555 // Port C initialization
; 0000 0556 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0557 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0558 PORTC=0x00;
; 0000 0559 DDRC=0x00;
; 0000 055A 
; 0000 055B // Port D initialization
; 0000 055C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 055D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 055E //PORTD=0x00;
; 0000 055F DDRD.3=1;
; 0000 0560 PORTD.3=1;
; 0000 0561 DDRD.6=1;
; 0000 0562 DDRD.7=1;
; 0000 0563 PORTD.6=0;
; 0000 0564 PORTD.7=0;
; 0000 0565 // Timer/Counter 0 initialization
; 0000 0566 // Clock source: System Clock
; 0000 0567 // Clock value: Timer 0 Stopped
; 0000 0568 // Mode: Normal top=FFh
; 0000 0569 // OC0A output: Disconnected
; 0000 056A // OC0B output: Disconnected
; 0000 056B //TCCR0A=0x00;
; 0000 056C //TCCR0B=0x04;
; 0000 056D //TCNT0=0xA5;
; 0000 056E //OCR0A=0x00;
; 0000 056F //OCR0B=0x00;
; 0000 0570 stop_wait_Rx_timer;
; 0000 0571 /*USART predefinition: 1200 baud rate, tx enable, all interrutpts enabled 8bit buffer*/
; 0000 0572 UCSR0A=0x00;
; 0000 0573 UCSR0B=0xc0;
; 0000 0574 UCSR0C=0x06;
; 0000 0575 UBRR0H=0x00;
; 0000 0576 UBRR0L=0x17;
; 0000 0577 
; 0000 0578 // Timer/Counter 1 initialization
; 0000 0579 // Clock source: System Clock
; 0000 057A // Clock value: Timer 1 Stopped
; 0000 057B // Mode: Normal top=FFFFh
; 0000 057C // OC1A output: Discon.
; 0000 057D // OC1B output: Discon.
; 0000 057E // Noise Canceler: Off
; 0000 057F // Input Capture on Falling Edge
; 0000 0580 // Timer 1 Overflow Interrupt: Off
; 0000 0581 // Input Capture Interrupt: Off
; 0000 0582 // Compare A Match Interrupt: Off
; 0000 0583 // Compare B Match Interrupt: Off
; 0000 0584 TCCR1A=0x00;
; 0000 0585 TCCR1B=0x00;
; 0000 0586 TCNT1H=0x00;
; 0000 0587 TCNT1L=0x00;
; 0000 0588 ICR1H=0x00;
; 0000 0589 ICR1L=0x00;
; 0000 058A OCR1AH=0x00;
; 0000 058B OCR1AL=0x00;
; 0000 058C OCR1BH=0x00;
; 0000 058D OCR1BL=0x00;
; 0000 058E 
; 0000 058F // Timer/Counter 2 initialization
; 0000 0590 // Clock source: System Clock
; 0000 0591 // Clock value: Timer 2 Stopped
; 0000 0592 // Mode: Normal top=FFh
; 0000 0593 // OC2A output: Disconnected
; 0000 0594 // OC2B output: Disconnected
; 0000 0595 ASSR=0x00;
; 0000 0596 TCCR2A=0x00;
; 0000 0597 TCCR2B=0x00;
; 0000 0598 TCNT2=0x00;
; 0000 0599 OCR2A=0x00;
; 0000 059A OCR2B=0x00;
; 0000 059B 
; 0000 059C // External Interrupt(s) initialization
; 0000 059D // INT0: On
; 0000 059E // INT0 Mode: Any change
; 0000 059F // INT1: Off
; 0000 05A0 // Interrupt on any change on pins PCINT0-7: Off
; 0000 05A1 // Interrupt on any change on pins PCINT8-14: Off
; 0000 05A2 // Interrupt on any change on pins PCINT16-23: Off
; 0000 05A3 wait_startOCD;
; 0000 05A4 EIMSK=0x01;
; 0000 05A5 EIFR=0x01;
; 0000 05A6 PCICR=0x00;
; 0000 05A7 
; 0000 05A8 
; 0000 05A9 // Timer/Counter 0 Interrupt(s) initialization
; 0000 05AA TIMSK0=0x00;
; 0000 05AB // Timer/Counter 1 Interrupt(s) initialization
; 0000 05AC TIMSK1=0x00;
; 0000 05AD // Timer/Counter 2 Interrupt(s) initialization
; 0000 05AE TIMSK2=0x00;
; 0000 05AF 
; 0000 05B0 // Analog Comparator initialization
; 0000 05B1 // Analog Comparator: Off
; 0000 05B2 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 05B3 ACSR=0x80;
; 0000 05B4 ADCSRB=0x00;
; 0000 05B5 
; 0000 05B6 // ADC initialization
; 0000 05B7 // ADC Clock frequency: 230,400 kHz
; 0000 05B8 // ADC Voltage Reference: AREF pin
; 0000 05B9 // ADC Auto Trigger Source: Free Running
; 0000 05BA // Digital input buffers on ADC0: On, ADC1: Off, ADC2: Off, ADC3: Off
; 0000 05BB // ADC4: Off, ADC5: Off
; 0000 05BC if(initVar==1)
; 0000 05BD {
; 0000 05BE DIDR0=0x3f;
; 0000 05BF ADMUX=0x20;
; 0000 05C0 ADCSRA=0xcf;
; 0000 05C1 ADCSRB=ADCSRB||0x00;
; 0000 05C2 }
; 0000 05C3 else
; 0000 05C4 {
; 0000 05C5 DIDR0=0x3f;
; 0000 05C6 ADMUX=0x00;
; 0000 05C7 ADCSRA=0x0f;
; 0000 05C8 ADCSRB=ADCSRB||0x00;
; 0000 05C9 
; 0000 05CA }
; 0000 05CB // SPI initialization
; 0000 05CC // SPI Type: Master
; 0000 05CD // SPI Clock Rate: 2*115,200 kHz
; 0000 05CE // SPI Clock Phase: Cycle Half
; 0000 05CF // SPI Clock Polarity: Low
; 0000 05D0 // SPI Data Order: MSB First
; 0000 05D1 SPCR=0x53;
; 0000 05D2 SPSR=0x00;
; 0000 05D3 //SPDR=0x00;
; 0000 05D4 //enable_SPI;
; 0000 05D5 }
;
;void system_init(){
; 0000 05D7 void system_init(){
_system_init:
; .FSTART _system_init
; 0000 05D8 #asm("wdr")
	wdr
; 0000 05D9 WDTCSR=0x38;
	LDI  R30,LOW(56)
	STS  96,R30
; 0000 05DA WDTCSR=0x0E;
	LDI  R30,LOW(14)
	STS  96,R30
; 0000 05DB // Crystal Oscillator division factor: 1
; 0000 05DC /*#pragma optsize-
; 0000 05DD CLKPR=0x80;
; 0000 05DE CLKPR=0x00;
; 0000 05DF #ifdef _OPTIMIZE_SIZE_
; 0000 05E0 #pragma optsize+
; 0000 05E1 #endif
; 0000 05E2   */
; 0000 05E3 // Input/Output Ports initialization
; 0000 05E4 // Port B initialization
; 0000 05E5 // Func7=In Func6=In Func5=Out Func4=In Func3=Out Func2=Out Func1=In Func0=In
; 0000 05E6 // State7=T State6=T State5=0 State4=T State3=0 State2=0 State1=T State0=T
; 0000 05E7 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 05E8 DDRB=0x2c;
	LDI  R30,LOW(44)
	OUT  0x4,R30
; 0000 05E9 
; 0000 05EA // Port C initialization
; 0000 05EB // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 05EC // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 05ED PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 05EE DDRC=0x00;
	OUT  0x7,R30
; 0000 05EF 
; 0000 05F0 // Port D initialization
; 0000 05F1 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 05F2 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 05F3 //PORTD=0x00;
; 0000 05F4 DDRD.3=1;
	SBI  0xA,3
; 0000 05F5 PORTD.3=1;
	SBI  0xB,3
; 0000 05F6 DDRD.6=1;
	SBI  0xA,6
; 0000 05F7 DDRD.7=1;
	SBI  0xA,7
; 0000 05F8 PORTD.6=0;
	CBI  0xB,6
; 0000 05F9 PORTD.7=0;
	CBI  0xB,7
; 0000 05FA // Timer/Counter 0 initialization
; 0000 05FB // Clock source: System Clock
; 0000 05FC // Clock value: Timer 0 Stopped
; 0000 05FD // Mode: Normal top=FFh
; 0000 05FE // OC0A output: Disconnected
; 0000 05FF // OC0B output: Disconnected
; 0000 0600 //TCCR0A=0x00;
; 0000 0601 //TCCR0B=0x04;
; 0000 0602 //TCNT0=0xA5;
; 0000 0603 //OCR0A=0x00;
; 0000 0604 //OCR0B=0x00;
; 0000 0605 stop_wait_Rx_timer;
	STS  110,R30
	OUT  0x24,R30
	OUT  0x25,R30
	OUT  0x26,R30
; 0000 0606 /*USART predefinition: 1200 baud rate, tx enable, all interrutpts enabled 8bit buffer*/
; 0000 0607 UCSR0A=0x00;
	STS  192,R30
; 0000 0608 UCSR0B=0xc0;
	LDI  R30,LOW(192)
	STS  193,R30
; 0000 0609 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 060A UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 060B UBRR0L=0x17;
	LDI  R30,LOW(23)
	STS  196,R30
; 0000 060C 
; 0000 060D // Timer/Counter 1 initialization
; 0000 060E // Clock source: System Clock
; 0000 060F // Clock value: Timer 1 Stopped
; 0000 0610 // Mode: Normal top=FFFFh
; 0000 0611 // OC1A output: Discon.
; 0000 0612 // OC1B output: Discon.
; 0000 0613 // Noise Canceler: Off
; 0000 0614 // Input Capture on Falling Edge
; 0000 0615 // Timer 1 Overflow Interrupt: Off
; 0000 0616 // Input Capture Interrupt: Off
; 0000 0617 // Compare A Match Interrupt: Off
; 0000 0618 // Compare B Match Interrupt: Off
; 0000 0619 TCCR1A=0x00;
	LDI  R30,LOW(0)
	STS  128,R30
; 0000 061A TCCR1B=0x00;
	STS  129,R30
; 0000 061B TCNT1H=0x00;
	STS  133,R30
; 0000 061C TCNT1L=0x00;
	STS  132,R30
; 0000 061D ICR1H=0x00;
	STS  135,R30
; 0000 061E ICR1L=0x00;
	STS  134,R30
; 0000 061F OCR1AH=0x00;
	STS  137,R30
; 0000 0620 OCR1AL=0x00;
	STS  136,R30
; 0000 0621 OCR1BH=0x00;
	STS  139,R30
; 0000 0622 OCR1BL=0x00;
	STS  138,R30
; 0000 0623 
; 0000 0624 // Timer/Counter 2 initialization
; 0000 0625 // Clock source: System Clock
; 0000 0626 // Clock value: Timer 2 Stopped
; 0000 0627 // Mode: Normal top=FFh
; 0000 0628 // OC2A output: Disconnected
; 0000 0629 // OC2B output: Disconnected
; 0000 062A ASSR=0x00;
	STS  182,R30
; 0000 062B TCCR2A=0x00;
	STS  176,R30
; 0000 062C TCCR2B=0x00;
	STS  177,R30
; 0000 062D TCNT2=0x00;
	STS  178,R30
; 0000 062E OCR2A=0x00;
	STS  179,R30
; 0000 062F OCR2B=0x00;
	STS  180,R30
; 0000 0630 
; 0000 0631 // External Interrupt(s) initialization
; 0000 0632 // INT0: On
; 0000 0633 // INT0 Mode: Any change
; 0000 0634 // INT1: Off
; 0000 0635 // Interrupt on any change on pins PCINT0-7: Off
; 0000 0636 // Interrupt on any change on pins PCINT8-14: Off
; 0000 0637 // Interrupt on any change on pins PCINT16-23: Off
; 0000 0638 wait_startOCD;
	LDI  R30,LOW(3)
	STS  105,R30
; 0000 0639 EIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x1D,R30
; 0000 063A EIFR=0x01;
	OUT  0x1C,R30
; 0000 063B PCICR=0x00;
	LDI  R30,LOW(0)
	STS  104,R30
; 0000 063C 
; 0000 063D 
; 0000 063E // Timer/Counter 0 Interrupt(s) initialization
; 0000 063F TIMSK0=0x00;
	STS  110,R30
; 0000 0640 // Timer/Counter 1 Interrupt(s) initialization
; 0000 0641 TIMSK1=0x00;
	STS  111,R30
; 0000 0642 // Timer/Counter 2 Interrupt(s) initialization
; 0000 0643 TIMSK2=0x00;
	STS  112,R30
; 0000 0644 
; 0000 0645 // Analog Comparator initialization
; 0000 0646 // Analog Comparator: Off
; 0000 0647 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0648 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0649 ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 064A 
; 0000 064B // ADC initialization
; 0000 064C // ADC Clock frequency: 230,400 kHz
; 0000 064D // ADC Voltage Reference: AREF pin
; 0000 064E // ADC Auto Trigger Source: Free Running
; 0000 064F // Digital input buffers on ADC0: On, ADC1: Off, ADC2: Off, ADC3: Off
; 0000 0650 // ADC4: Off, ADC5: Off
; 0000 0651 DIDR0=0x3f;
	LDI  R30,LOW(63)
	STS  126,R30
; 0000 0652 ADMUX=0x20;
	LDI  R30,LOW(32)
	STS  124,R30
; 0000 0653 ADCSRA=0xcf;
	LDI  R30,LOW(207)
	STS  122,R30
; 0000 0654 ADCSRB=ADCSRB||0x00;
	LDS  R30,123
	CPI  R30,0
	BRNE _0x12B
	LDI  R30,LOW(0)
	CPI  R30,0
	BRNE _0x12B
	LDI  R30,0
	RJMP _0x12C
_0x12B:
	LDI  R30,1
_0x12C:
	STS  123,R30
; 0000 0655 
; 0000 0656 // SPI initialization
; 0000 0657 // SPI Type: Master
; 0000 0658 // SPI Clock Rate: 2*115,200 kHz
; 0000 0659 // SPI Clock Phase: Cycle Half
; 0000 065A // SPI Clock Polarity: Low
; 0000 065B // SPI Data Order: MSB First
; 0000 065C SPCR=0x53;
	LDI  R30,LOW(83)
	OUT  0x2C,R30
; 0000 065D SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 065E //SPDR=0x00;
; 0000 065F //enable_SPI;
; 0000 0660 }
	RET
; .FEND
;
;void update_dynamic_vars()
; 0000 0663 {
_update_dynamic_vars:
; .FSTART _update_dynamic_vars
; 0000 0664 float DAC_zero_current, DAC_measured_current, Lower_Range_value, Upper_Range_value,tmp;
; 0000 0665 char i,j=0;
; 0000 0666 long tmp_adc=0;
; 0000 0667 
; 0000 0668 union DAC_char_to_float
; 0000 0669         {
; 0000 066A         float value_float;
; 0000 066B         char value_char[4];
; 0000 066C         }DAC_val;
; 0000 066D 
; 0000 066E for (i=0;i<4;i++)
	SBIW R28,28
	CALL SUBOPT_0xE
	LDI  R30,LOW(0)
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
_0x12E:
	CPI  R17,4
	BRSH _0x12F
; 0000 066F         {
; 0000 0670          DAC_val.value_char[i]=Parameter_bank[88+i];
	CALL SUBOPT_0x3B
	__ADDW1MN _Parameter_bank,88
	CALL SUBOPT_0x3C
; 0000 0671          if(i==3)
	BRNE _0x130
; 0000 0672                 {
; 0000 0673                 Upper_Range_value=DAC_val.value_float;
	CALL SUBOPT_0x3D
	__PUTD1S 14
; 0000 0674                 }
; 0000 0675         }
_0x130:
	SUBI R17,-1
	RJMP _0x12E
_0x12F:
; 0000 0676 for (i=0;i<4;i++)
	LDI  R17,LOW(0)
_0x132:
	CPI  R17,4
	BRSH _0x133
; 0000 0677         {
; 0000 0678          DAC_val.value_char[i]=Parameter_bank[92+i];
	CALL SUBOPT_0x3B
	__ADDW1MN _Parameter_bank,92
	CALL SUBOPT_0x3C
; 0000 0679          if(i==3)
	BRNE _0x134
; 0000 067A                 {
; 0000 067B                 Lower_Range_value=DAC_val.value_float;
	CALL SUBOPT_0x3D
	__PUTD1S 18
; 0000 067C                 }
; 0000 067D         }
_0x134:
	SUBI R17,-1
	RJMP _0x132
_0x133:
; 0000 067E 
; 0000 067F for (i=0;i<4;i++)
	LDI  R17,LOW(0)
_0x136:
	CPI  R17,4
	BRSH _0x137
; 0000 0680         {
; 0000 0681          DAC_val.value_char[i]=Parameter_bank[105+i];
	CALL SUBOPT_0x3B
	__ADDW1MN _Parameter_bank,105
	CALL SUBOPT_0x3C
; 0000 0682          if(i==3)
	BRNE _0x138
; 0000 0683                 {
; 0000 0684                 DAC_zero_current=DAC_val.value_float;
	CALL SUBOPT_0x3D
	__PUTD1S 26
; 0000 0685                 }
; 0000 0686         }
_0x138:
	SUBI R17,-1
	RJMP _0x136
_0x137:
; 0000 0687 for (i=0;i<4;i++)
	LDI  R17,LOW(0)
_0x13A:
	CPI  R17,4
	BRSH _0x13B
; 0000 0688         {
; 0000 0689          DAC_val.value_char[i]=Parameter_bank[109+i];
	CALL SUBOPT_0x3B
	__ADDW1MN _Parameter_bank,109
	CALL SUBOPT_0x3C
; 0000 068A          if(i==3)
	BRNE _0x13C
; 0000 068B                 {
; 0000 068C                 DAC_measured_current=DAC_val.value_float;
	CALL SUBOPT_0x3D
	__PUTD1S 22
; 0000 068D                 }
; 0000 068E         }
_0x13C:
	SUBI R17,-1
	RJMP _0x13A
_0x13B:
; 0000 068F //коэффициент преобразовани€ кода ÷јѕ в ток, равен отношению приращени€ тока к приращению битового кода ј÷ѕ
; 0000 0690 if(adc_data<=0)tmp_adc=0;
	LDS  R26,_adc_data
	LDS  R27,_adc_data+1
	LDS  R24,_adc_data+2
	LDS  R25,_adc_data+3
	CALL __CPD02
	BRGE _0x199
; 0000 0691 //if(adc_data>ADC_PV_calibration_point1)//дл€ калиброванного значени€ на 4.8 мј
; 0000 0692 //else
; 0000 0693 else
; 0000 0694 {
; 0000 0695 //CalculateCalibrationRates();
; 0000 0696 tmp_adc=(long)((float)((float)(adc_data)/calibrationK) - (float)calibrationB);
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
	LDS  R22,_adc_data+2
	LDS  R23,_adc_data+3
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x3E
	CALL __DIVF21
	LDS  R26,_calibrationB
	LDS  R27,_calibrationB+1
	LDS  R24,_calibrationB+2
	LDS  R25,_calibrationB+3
	CALL __SUBF12
	CALL __CFD1
	__PUTD1S 6
; 0000 0697 //tmp_adc=(long)((float)tmp_adc*1.118);
; 0000 0698 if(tmp_adc>0xffc0)tmp_adc=0xffc0;
	__GETD2S 6
	__CPD2N 0xFFC1
	BRLT _0x13F
	__GETD1N 0xFFC0
	__PUTD1S 6
; 0000 0699 if(tmp_adc<0x0000)tmp_adc=0x0000;
_0x13F:
	LDD  R26,Y+9
	TST  R26
	BRPL _0x140
_0x199:
	LDI  R30,LOW(0)
	__CLRD1S 6
; 0000 069A }
_0x140:
; 0000 069B /*        {
; 0000 069C         tmp_adc=(long)(adc_data-calibration_point1)*((float)(calibration_point2/(calibration_point2-calibration_point1)) ...
; 0000 069D         DAC_zero_current = 4.8;
; 0000 069E         DAC_data=((long)(tmp_adc*((DAC_measured_current-DAC_zero_current)/16))+(signed int)((DAC_zero_current)/mamps_toD ...
; 0000 069F         }
; 0000 06A0 else
; 0000 06A1         {
; 0000 06A2          if(adc_data<=ADC_PV_zero_val)adc_data=0;
; 0000 06A3          else
; 0000 06A4                 {
; 0000 06A5                 tmp_adc=(long)(adc_data-ADC_PV_zero_val)*((float)(calibration_point2/(calibration_point2-ADC_PV_zero_val ...
; 0000 06A6                 }
; 0000 06A7 
; 0000 06A8         }
; 0000 06A9         */
; 0000 06AA DAC_data=((long)(tmp_adc*((DAC_measured_current-DAC_zero_current)/16))+(signed int)((DAC_zero_current)/mamps_toDAC_defau ...
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x40
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
	CALL SUBOPT_0x3F
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
; 0000 06AB if(DAC_data<=DAC_zero_current)DAC_data=DAC_zero_current;
	__GETD1S 26
	CALL SUBOPT_0x4
	CALL __CDF2
	CALL __CMPF12
	BREQ PC+3
	BRCS PC+2
	RJMP _0x141
	__GETD1S 26
	LDI  R26,LOW(_DAC_data)
	LDI  R27,HIGH(_DAC_data)
	CALL __CFD1
	CALL __PUTDP1
; 0000 06AC dynamic_variables[1]=(float)DAC_data*mamps_toDAC_default_ratio;//adc_data*mamps_toDAC_default_ratio;//current, mA - ток
_0x141:
	LDS  R30,_DAC_data
	LDS  R31,_DAC_data+1
	LDS  R22,_DAC_data+2
	LDS  R23,_DAC_data+3
	CALL __CDF1
	__GETD2N 0x39802008
	CALL __MULF12
	__PUTD1MN _dynamic_variables,4
; 0000 06AD dynamic_variables[2]=(float)(100*(dynamic_variables[1]-DAC_zero_current)/(DAC_measured_current-DAC_zero_current));
	__GETD1MN _dynamic_variables,4
	CALL SUBOPT_0x3F
	CALL __SUBF12
	__GETD2N 0x42C80000
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x40
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	__PUTD1MN _dynamic_variables,8
; 0000 06AE tmp = Upper_Range_value-Lower_Range_value;
	__GETD2S 18
	__GETD1S 14
	CALL __SUBF12
	__PUTD1S 10
; 0000 06AF if(tmp==10)
	CALL SUBOPT_0x41
	__CPD2N 0x41200000
	BRNE _0x142
; 0000 06B0     {
; 0000 06B1     Parameter_bank[12]= 10;
	__POINTW2MN _Parameter_bank,12
	LDI  R30,LOW(10)
	CALL __EEPROMWRB
; 0000 06B2     setlevel_0_10;
	CBI  0xB,7
	CBI  0xB,6
; 0000 06B3     rangeIndex = 0;
	CLR  R10
; 0000 06B4     }
; 0000 06B5 if(tmp==20)
_0x142:
	CALL SUBOPT_0x41
	__CPD2N 0x41A00000
	BRNE _0x147
; 0000 06B6     {
; 0000 06B7     Parameter_bank[12]= 20;
	__POINTW2MN _Parameter_bank,12
	LDI  R30,LOW(20)
	CALL __EEPROMWRB
; 0000 06B8     setlevel_0_20;
	CBI  0xB,7
	SBI  0xB,6
; 0000 06B9     rangeIndex = 1;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 06BA     }
; 0000 06BB if(tmp==30)
_0x147:
	CALL SUBOPT_0x41
	__CPD2N 0x41F00000
	BRNE _0x14C
; 0000 06BC     {
; 0000 06BD     Parameter_bank[12]=30;
	__POINTW2MN _Parameter_bank,12
	LDI  R30,LOW(30)
	CALL __EEPROMWRB
; 0000 06BE    setlevel_0_30;
	SBI  0xB,7
	CBI  0xB,6
; 0000 06BF    rangeIndex = 2;
	LDI  R30,LOW(2)
	MOV  R10,R30
; 0000 06C0     }
; 0000 06C1 if(tmp==50)
_0x14C:
	CALL SUBOPT_0x41
	__CPD2N 0x42480000
	BRNE _0x151
; 0000 06C2     {
; 0000 06C3     Parameter_bank[12]= 50;
	__POINTW2MN _Parameter_bank,12
	LDI  R30,LOW(50)
	CALL __EEPROMWRB
; 0000 06C4     setlevel_0_50;
	SBI  0xB,7
	SBI  0xB,6
; 0000 06C5     rangeIndex = 3;
	LDI  R30,LOW(3)
	MOV  R10,R30
; 0000 06C6     }
; 0000 06C7 if(rangeIndexEep!=rangeIndex)
_0x151:
	CALL SUBOPT_0x15
	CP   R10,R30
	BREQ _0x156
; 0000 06C8         {
; 0000 06C9          //CalculateCalibrationRates();
; 0000 06CA         calibrationB=calibrationBeep[rangeIndex];
	MOV  R30,R10
	CALL SUBOPT_0x18
	CALL SUBOPT_0x42
; 0000 06CB         calibrationK=calibrationKeep[rangeIndex];
	CALL SUBOPT_0x16
	CALL SUBOPT_0x43
; 0000 06CC         rangeIndexEep=rangeIndex;
	LDI  R26,LOW(_rangeIndexEep)
	LDI  R27,HIGH(_rangeIndexEep)
	CALL __EEPROMWRB
; 0000 06CD         rangeIndexEepPB1 = rangeIndex;
	MOV  R30,R10
	LDI  R26,LOW(_rangeIndexEepPB1)
	LDI  R27,HIGH(_rangeIndexEepPB1)
	CALL __EEPROMWRB
; 0000 06CE         rangeIndexEepPB2 = rangeIndex;
	LDI  R26,LOW(_rangeIndexEepPB2)
	LDI  R27,HIGH(_rangeIndexEepPB2)
	CALL __EEPROMWRB
; 0000 06CF         }
; 0000 06D0 dynamic_variables[0]=(float)dynamic_variables[2]*(float)((tmp)/100);//100;////primary variable (PV) - виброскорость
_0x156:
	CALL SUBOPT_0x41
	__GETD1N 0x42C80000
	CALL __DIVF21
	__GETD2MN _dynamic_variables,8
	CALL __MULF12
	STS  _dynamic_variables,R30
	STS  _dynamic_variables+1,R31
	STS  _dynamic_variables+2,R22
	STS  _dynamic_variables+3,R23
; 0000 06D1 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,30
	RET
; .FEND
;
;void CalculateCalibrationRates()
; 0000 06D4 {
_CalculateCalibrationRates:
; .FSTART _CalculateCalibrationRates
; 0000 06D5 
; 0000 06D6 unsigned int calibration_div = 0xf2f7;//0xe4c0;//0xe600;
; 0000 06D7 unsigned int calibrationBasic5val = 0x0cc9;
; 0000 06D8 unsigned int tmp_calibration;
; 0000 06D9 //unsigned int calibrationBasic95val = 0xe4c0;
; 0000 06DA //#asm("cli");
; 0000 06DB tmp_calibration =ADC_PV_calibration_point2[rangeIndex] - ADC_PV_calibration_point1[rangeIndex];
	CALL __SAVELOCR6
;	calibration_div -> R16,R17
;	calibrationBasic5val -> R18,R19
;	tmp_calibration -> R20,R21
	__GETWRN 16,17,-3337
	__GETWRN 18,19,3273
	CALL SUBOPT_0x27
	CALL SUBOPT_0x44
	MOVW R0,R30
	CALL SUBOPT_0x20
	CALL SUBOPT_0x44
	MOVW R26,R0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R20,R26
; 0000 06DC calibrationK = (float)(tmp_calibration/62199.00);//58560.00);//58880.00);
	MOVW R30,R20
	CALL SUBOPT_0x45
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4772F700
	CALL __DIVF21
	CALL SUBOPT_0x43
; 0000 06DD calibrationKeep[rangeIndex] =  calibrationK;
	LDI  R26,LOW(_calibrationKeep)
	LDI  R27,HIGH(_calibrationKeep)
	CALL SUBOPT_0x46
; 0000 06DE calibrationKeep_PB1[rangeIndex] = calibrationK;
	LDI  R26,LOW(_calibrationKeep_PB1)
	LDI  R27,HIGH(_calibrationKeep_PB1)
	CALL SUBOPT_0x46
; 0000 06DF calibrationKeep_PB2[rangeIndex] = calibrationK;
	LDI  R26,LOW(_calibrationKeep_PB2)
	LDI  R27,HIGH(_calibrationKeep_PB2)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0x3E
	CALL __EEPROMWRD
; 0000 06E0 //calibrK = ((tmp_calibration*1000/calibration_div)) ;
; 0000 06E1 tmp_calibration = ADC_PV_calibration_point1[rangeIndex];
	CALL SUBOPT_0x20
	CALL SUBOPT_0x44
	MOVW R20,R30
; 0000 06E2 //calibrationB = (float)((float)calibration_point1-(float)(calibrationK*calibrationBasic5val)) ;
; 0000 06E3 calibrationB = (float)((float)tmp_calibration-(float)(calibrationK*calibrationBasic5val)) ;
	CALL SUBOPT_0x45
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R18
	LDS  R26,_calibrationK
	LDS  R27,_calibrationK+1
	LDS  R24,_calibrationK+2
	LDS  R25,_calibrationK+3
	CALL SUBOPT_0x45
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __SWAPD12
	CALL __SUBF12
	CALL SUBOPT_0x42
; 0000 06E4 calibrationBeep[rangeIndex] = calibrationB;
	LDI  R26,LOW(_calibrationBeep)
	LDI  R27,HIGH(_calibrationBeep)
	CALL SUBOPT_0x47
; 0000 06E5 calibrationBeep_PB1[rangeIndex] = calibrationB;
	LDI  R26,LOW(_calibrationBeep_PB1)
	LDI  R27,HIGH(_calibrationBeep_PB1)
	CALL SUBOPT_0x47
; 0000 06E6 calibrationBeep_PB2[rangeIndex] = calibrationB;
	LDI  R26,LOW(_calibrationBeep_PB2)
	LDI  R27,HIGH(_calibrationBeep_PB2)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_calibrationB
	LDS  R31,_calibrationB+1
	LDS  R22,_calibrationB+2
	LDS  R23,_calibrationB+3
	CALL __EEPROMWRD
; 0000 06E7 //#asm("sei");
; 0000 06E8 }
	CALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND
;
;//void setDefaultEepromPB()
;//{
;//         int i = 0;
;//         for(i = 0; i < 4; i++)
;//         {
;//
;//         }
;//}
;
;void ResetDeviceSettings(char notreset)
; 0000 06F4 {
_ResetDeviceSettings:
; .FSTART _ResetDeviceSettings
; 0000 06F5 int i=0;
; 0000 06F6 for(i =0; i<139;i++)
	ST   -Y,R26
	CALL SUBOPT_0x0
;	notreset -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x158:
	__CPWRN 16,17,139
	BRGE _0x159
; 0000 06F7         {
; 0000 06F8         if (i==98)i=100;
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x15A
	__GETWRN 16,17,100
; 0000 06F9         else Parameter_bank[i]=Parameter_defaults[i];
	RJMP _0x15B
_0x15A:
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
; 0000 06FA         }
_0x15B:
	__ADDWRN 16,17,1
	RJMP _0x158
_0x159:
; 0000 06FB         for (i=0; i<4; i++)
	__GETWRN 16,17,0
_0x15D:
	__CPWRN 16,17,4
	BRGE _0x15E
; 0000 06FC         {
; 0000 06FD                 calibrationBeep[i]=0;
	MOVW R30,R16
	LDI  R26,LOW(_calibrationBeep)
	LDI  R27,HIGH(_calibrationBeep)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x48
; 0000 06FE                 calibrationKeep[i]=1;
	LDI  R26,LOW(_calibrationKeep)
	LDI  R27,HIGH(_calibrationKeep)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x49
; 0000 06FF                 ADC_PV_calibration_point1[i] = 0x0cc9;//0x0bc0; //0x0cc0;
	CALL SUBOPT_0x4A
; 0000 0700                 ADC_PV_calibration_point2[i] = 0xffc0;//0xe4c0; //0xf2c0;
; 0000 0701                 ADC_PV_calibration_point1_PB1[i] =  0x0cc9;
; 0000 0702                 ADC_PV_calibration_point1_PB2[i] =  0x0cc9;
; 0000 0703                 ADC_PV_calibration_point2_PB1[i] =  0xffc0;
; 0000 0704                 ADC_PV_calibration_point2_PB2[i] =  0xffc0;
; 0000 0705                 calibrationBeep_PB1[i] = 0;
	CALL SUBOPT_0x48
; 0000 0706                 calibrationBeep_PB2[i] = 0;
	LDI  R26,LOW(_calibrationBeep_PB2)
	LDI  R27,HIGH(_calibrationBeep_PB2)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x48
; 0000 0707                 calibrationKeep_PB1[i] = 1;
	LDI  R26,LOW(_calibrationKeep_PB1)
	LDI  R27,HIGH(_calibrationKeep_PB1)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x49
; 0000 0708                 calibrationKeep_PB2[i] = 1;
	LDI  R26,LOW(_calibrationKeep_PB2)
	LDI  R27,HIGH(_calibrationKeep_PB2)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x4B
	CALL __EEPROMWRD
; 0000 0709         }
	__ADDWRN 16,17,1
	RJMP _0x15D
_0x15E:
; 0000 070A         calibrationB=0;
	CALL SUBOPT_0x4C
; 0000 070B         calibrationK=1;
; 0000 070C         calibration_point1=0x0cc9;//0x0bc0;//0x0cc0;
; 0000 070D         calibration_point2=0xffc0;//0xe4c0;//0xf2c0;
; 0000 070E         rangeIndexEep=1;
	CALL SUBOPT_0x4D
; 0000 070F         rangeIndexEepPB1 = 1;
; 0000 0710         rangeIndexEepPB2 = 1;
; 0000 0711         rangeIndex=rangeIndexEep;
	CALL SUBOPT_0x15
	MOV  R10,R30
; 0000 0712         //Upper_Range_value = 20;
; 0000 0713         //Lower_Range_value = 0;
; 0000 0714 }
	RJMP _0x2080001
; .FEND
;
;void PerformDeviceApplicationErase()
; 0000 0717 {
_PerformDeviceApplicationErase:
; .FSTART _PerformDeviceApplicationErase
; 0000 0718 MCUCR = 0x01;
	LDI  R30,LOW(1)
	OUT  0x35,R30
; 0000 0719 MCUCR = 0x02;
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 071A Parameter_bank[0]=0xee;
	LDI  R26,LOW(_Parameter_bank)
	LDI  R27,HIGH(_Parameter_bank)
	LDI  R30,LOW(238)
	CALL __EEPROMWRB
; 0000 071B Parameter_bank[2]=0xa3;
	__POINTW2MN _Parameter_bank,2
	LDI  R30,LOW(163)
	CALL __EEPROMWRB
; 0000 071C voidFuncPtr=(void(*)(void))0x1C00;   //адресс куда переходим
	LDI  R30,LOW(7168)
	LDI  R31,HIGH(7168)
	STS  _voidFuncPtr,R30
	STS  _voidFuncPtr+1,R31
; 0000 071D voidFuncPtr();
	__CALL1MN _voidFuncPtr,0
; 0000 071E }
	RET
; .FEND
;
;
;void LoadCalibrationSettings(char flag)                    //загрузка калибровочных настроек
; 0000 0722 {
_LoadCalibrationSettings:
; .FSTART _LoadCalibrationSettings
; 0000 0723 //#asm("cli");
; 0000 0724 int i=0;
; 0000 0725 // if((CalibrationConfigChangedPB1==0xff)&(CalibrationConfigChangedPB2==0xff))
; 0000 0726 // {
; 0000 0727     if(flag==0x01)//флаг = 1, означает, что калибровка уже была
	ST   -Y,R26
	CALL SUBOPT_0x0
;	flag -> Y+2
;	i -> R16,R17
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRNE _0x15F
; 0000 0728             {
; 0000 0729             //checkIntegrityFlags();
; 0000 072A             calibration_point1=ADC_PV_calibration_point1[rangeIndexEep];
	CALL SUBOPT_0x15
	LDI  R26,LOW(_ADC_PV_calibration_point1)
	LDI  R27,HIGH(_ADC_PV_calibration_point1)
	LDI  R31,0
	LSL  R30
	ROL  R31
	CALL SUBOPT_0x44
	__PUTW1R 5,6
; 0000 072B             calibration_point2=ADC_PV_calibration_point2[rangeIndexEep];
	CALL SUBOPT_0x15
	LDI  R26,LOW(_ADC_PV_calibration_point2)
	LDI  R27,HIGH(_ADC_PV_calibration_point2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	CALL SUBOPT_0x44
	__PUTW1R 7,8
; 0000 072C             calibrationB=calibrationBeep[rangeIndexEep];
	CALL SUBOPT_0x15
	CALL SUBOPT_0x18
	STS  _calibrationB,R30
	STS  _calibrationB+1,R31
	STS  _calibrationB+2,R22
	STS  _calibrationB+3,R23
; 0000 072D             calibrationK=calibrationKeep[rangeIndexEep];
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	STS  _calibrationK,R30
	STS  _calibrationK+1,R31
	STS  _calibrationK+2,R22
	STS  _calibrationK+3,R23
; 0000 072E             rangeIndex=rangeIndexEep;
	CALL SUBOPT_0x15
	MOV  R10,R30
; 0000 072F             }
; 0000 0730     else  //если калибровки не было, загружаем настройки по умолчанию
	RJMP _0x160
_0x15F:
; 0000 0731             {
; 0000 0732             //checkIntegrityFlags();
; 0000 0733             rangeIndexEep = 1;
	CALL SUBOPT_0x4D
; 0000 0734             rangeIndexEepPB1 = 1;
; 0000 0735             rangeIndexEepPB2 = 1;
; 0000 0736             rangeIndex = 1;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 0737             for (i=0; i<4; i++)
	__GETWRN 16,17,0
_0x162:
	__CPWRN 16,17,4
	BRGE _0x163
; 0000 0738                 {
; 0000 0739                 calibrationBeep[i]=0;
	MOVW R30,R16
	LDI  R26,LOW(_calibrationBeep)
	LDI  R27,HIGH(_calibrationBeep)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x48
; 0000 073A                 calibrationKeep[i]=1;
	LDI  R26,LOW(_calibrationKeep)
	LDI  R27,HIGH(_calibrationKeep)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x49
; 0000 073B                 ADC_PV_calibration_point1[i] = 0x0cc9;//0x0bc0; //0x0cc0;
	CALL SUBOPT_0x4A
; 0000 073C                 ADC_PV_calibration_point2[i] = 0xffc0;//0xe4c0; //0xf2c0;
; 0000 073D                 ADC_PV_calibration_point1_PB1[i] =  0x0cc9;
; 0000 073E                 ADC_PV_calibration_point1_PB2[i] =  0x0cc9;
; 0000 073F                 ADC_PV_calibration_point2_PB1[i] =  0xffc0;
; 0000 0740                 ADC_PV_calibration_point2_PB2[i] =  0xffc0;
; 0000 0741                 calibrationBeep_PB1[i] = 0;
	CALL SUBOPT_0x48
; 0000 0742                 calibrationBeep_PB2[i] = 0;
	LDI  R26,LOW(_calibrationBeep_PB2)
	LDI  R27,HIGH(_calibrationBeep_PB2)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x48
; 0000 0743                 calibrationKeep_PB1[i] = 1;
	LDI  R26,LOW(_calibrationKeep_PB1)
	LDI  R27,HIGH(_calibrationKeep_PB1)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x49
; 0000 0744                 calibrationKeep_PB2[i] = 1;
	LDI  R26,LOW(_calibrationKeep_PB2)
	LDI  R27,HIGH(_calibrationKeep_PB2)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x4B
	CALL __EEPROMWRD
; 0000 0745 
; 0000 0746                 }
	__ADDWRN 16,17,1
	RJMP _0x162
_0x163:
; 0000 0747             calibrationB=0;
	CALL SUBOPT_0x4C
; 0000 0748             calibrationK=1;
; 0000 0749             calibration_point1=0x0cc9;//0x0bc0;//0x0cc0;
; 0000 074A             calibration_point2=0xffc0;//0xe4c0;//0xf2c0;
; 0000 074B             }
_0x160:
; 0000 074C   //      #asm("sei");
; 0000 074D //  }
; 0000 074E }
_0x2080001:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
; void EEPROM_write(unsigned int uiAddress,unsigned char ucData)
; 0000 0750 {
; 0000 0751 while( EECR & 0b00000010) //wait until EEPE==0
;	uiAddress -> Y+1
;	ucData -> Y+0
; 0000 0752 ;
; 0000 0753 EEAR=uiAddress;
; 0000 0754 EEDR=ucData;
; 0000 0755 
; 0000 0756 EECR |=0b00000100; //write EEMPE=1
; 0000 0757 EECR |=0b00000010; //write EEWE=1
; 0000 0758 }
;
;
;
;
;unsigned char EEPROM_read(unsigned int uiAddress)
; 0000 075E {
; 0000 075F while(EECR & 0b00000010) //wait until EEWE==0
;	uiAddress -> Y+0
; 0000 0760 ;
; 0000 0761 EEAR=uiAddress;
; 0000 0762 EECR|=0b00000001; //write EERE=1
; 0000 0763 
; 0000 0764 return EEDR;
; 0000 0765 }
;
;
;
;void main(void)
; 0000 076A {
_main:
; .FSTART _main
; 0000 076B // Declare your local variables here
; 0000 076C //размещаем по адресу 0х00200(адрес указываетс€ в словах, поэтому там будет в 2 раза меньше)
; 0000 076D 
; 0000 076E int i,k=0;
; 0000 076F int char_val=0x00,data, j = 0,tmp=0;
; 0000 0770 flash int *tmp1;
; 0000 0771 char dataH,dataL,crcok_flag=0,checkRes=4,tmpindex = 0;
; 0000 0772 char tmpCalibrationFlagPB1 =  CalibrationConfigChangedPB1;
; 0000 0773 char tmpCalibrationFlagPB2 =  CalibrationConfigChangedPB2;
; 0000 0774 
; 0000 0775 //unsigned int tmpCP1_PB1 =      ADC_PV_calibration_point1_PB1[rangeIndex];
; 0000 0776 //unsigned int tmpCP1_PB2 =      ADC_PV_calibration_point1_PB2[rangeIndex];
; 0000 0777 rangeIndex = 0;
	SBIW R28,15
	LDI  R24,11
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	LDI  R30,LOW(_0x16A*2)
	LDI  R31,HIGH(_0x16A*2)
	CALL __INITLOCB
;	i -> R16,R17
;	k -> R18,R19
;	char_val -> R20,R21
;	data -> Y+13
;	j -> Y+11
;	tmp -> Y+9
;	*tmp1 -> Y+7
;	dataH -> Y+6
;	dataL -> Y+5
;	crcok_flag -> Y+4
;	checkRes -> Y+3
;	tmpindex -> Y+2
;	tmpCalibrationFlagPB1 -> Y+1
;	tmpCalibrationFlagPB2 -> Y+0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	CALL SUBOPT_0x2B
	STD  Y+1,R30
	CALL SUBOPT_0x2C
	ST   Y,R30
	CLR  R10
; 0000 0778 //flash unsigned int* SERIAL = &serial_number;
; 0000 0779 crc = 0xffff;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	__PUTW1R 11,12
; 0000 077A delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 077B Parameter_bank[0]=0x11;
	LDI  R26,LOW(_Parameter_bank)
	LDI  R27,HIGH(_Parameter_bank)
	LDI  R30,LOW(17)
	CALL __EEPROMWRB
; 0000 077C Parameter_bank[2]=0xB3;
	__POINTW2MN _Parameter_bank,2
	LDI  R30,LOW(179)
	CALL __EEPROMWRB
; 0000 077D //serial = 0xabcd;
; 0000 077E //#asm
; 0000 077F //    .CSEG
; 0000 0780 //    .org    0x00080
; 0000 0781 //    .DW 0xabcd, 0x0123
; 0000 0782 //    .org    0x00082
; 0000 0783 //    RET
; 0000 0784 //    .org    0x38
; 0000 0785 //    serial1:  .BYTE 1
; 0000 0786 //    .org    0x39
; 0000 0787 //    serial2:  .BYTE 1
; 0000 0788 //    .org    0x4a
; 0000 0789 //    serial3:  .BYTE 1
; 0000 078A    //.db 0xab, 0xcd , $ef , $77
; 0000 078B   //   .org    0x00084
; 0000 078C   //   RET
; 0000 078D //
; 0000 078E    // .CSEG
; 0000 078F //#endasm
; 0000 0790 //long serial = 0xabcdef12;
; 0000 0791 //system_init(0);
; 0000 0792  #asm("wdr")
	wdr
; 0000 0793 while ((data<=65534)|(j<=16382))
_0x16B:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	CALL __LEW12U
	MOV  R0,R30
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDI  R30,LOW(16382)
	LDI  R31,HIGH(16382)
	CALL __LEW12
	OR   R30,R0
	BREQ _0x16D
; 0000 0794 {
; 0000 0795    // if(j==0x1BDE)j+=2;//перескакиваем адрес с контрольной суммой дл€ ѕќ загрузчика дл€ ѕ 
; 0000 0796     if(j==0xDEF)j++;
	CPI  R26,LOW(0xDEF)
	LDI  R30,HIGH(0xDEF)
	CPC  R27,R30
	BRNE _0x16E
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ADIW R30,1
	STD  Y+11,R30
	STD  Y+11+1,R31
; 0000 0797     data= read_program_memory (j);
_0x16E:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CALL _read_program_memory
	STD  Y+13,R30
	STD  Y+13+1,R31
; 0000 0798     dataH = (int)data>>8;
	CALL __ASRW8
	STD  Y+6,R30
; 0000 0799     dataL = data;
	LDD  R30,Y+13
	STD  Y+5,R30
; 0000 079A     CRC_update(dataH);
	LDD  R26,Y+6
	CALL _CRC_update
; 0000 079B     CRC_update(dataL);
	LDD  R26,Y+5
	CALL _CRC_update
; 0000 079C     //crc_rtu(data);
; 0000 079D     //j++;
; 0000 079E     j=j+2;
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ADIW R30,2
	STD  Y+11,R30
	STD  Y+11+1,R31
; 0000 079F }
	RJMP _0x16B
_0x16D:
; 0000 07A0 crceep = crc;
	__GETW1R 11,12
	LDI  R26,LOW(_crceep)
	LDI  R27,HIGH(_crceep)
	CALL __EEPROMWRW
; 0000 07A1 //tmp = read_program_memory (0);
; 0000 07A2 ////tmp1 = &Parameter_mask[0];
; 0000 07A3 //devCodePB1 = tmp;
; 0000 07A4 //devCodePB2 = tmp>>8;
; 0000 07A5 //if(crc==crcstatic)system_init(1);
; 0000 07A6 //else system_init(0);
; 0000 07A7  system_init();
	RCALL _system_init
; 0000 07A8 #asm
; 0000 07A9     in   r30,spsr
    in   r30,spsr
; 0000 07AA     in   r30,spdr
    in   r30,spdr
; 0000 07AB #endasm
; 0000 07AC //serial_address = *serial;
; 0000 07AD //normal_mode;
; 0000 07AE #asm("sei")
	sei
; 0000 07AF  protectBitsChecking = 0;
	CLR  R9
; 0000 07B0 setlevel_0_20;
	CBI  0xB,7
	SBI  0xB,6
; 0000 07B1 
; 0000 07B2 //           if((devCodePB1==0xff)&(devCodePB2==0xff))
; 0000 07B3 //        {
; 0000 07B4 //               fillIDVars();
; 0000 07B5 //        }
; 0000 07B6 //        else
; 0000 07B7 //        {
; 0000 07B8                  checkIDVarsValidity();
	RCALL _checkIDVarsValidity
; 0000 07B9 //    //            fixIncorrectIDVars(checkRes);
; 0000 07BA //           // fixCRC();
; 0000 07BB //        }
; 0000 07BC 
; 0000 07BD 
; 0000 07BE if(crceep==crcstatic)
	LDI  R26,LOW(_crceep)
	LDI  R27,HIGH(_crceep)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_crcstatic)
	LDI  R27,HIGH(_crcstatic)
	CALL __EEPROMRDW
	CP   R30,R0
	CPC  R31,R1
	BRNE _0x173
; 0000 07BF     {
; 0000 07C0     #asm("wdr")
	wdr
; 0000 07C1 
; 0000 07C2 
; 0000 07C3        if((tmpCalibrationFlagPB1!=0xff)|(tmpCalibrationFlagPB2!=0xff))
	LDD  R26,Y+1
	LDI  R30,LOW(255)
	CALL __NEB12
	MOV  R0,R30
	LD   R26,Y
	LDI  R30,LOW(255)
	CALL __NEB12
	OR   R30,R0
	BREQ _0x174
; 0000 07C4        {
; 0000 07C5             checkRes = checkCalibrationFlagValidity();
	CALL _checkCalibrationFlagValidity
	STD  Y+3,R30
; 0000 07C6             fixIncorrectPB(checkRes) ;
	LDD  R26,Y+3
	CALL _fixIncorrectPB
; 0000 07C7        }
; 0000 07C8 
; 0000 07C9 //       if((rangeIndexEepPB1!=0xff)|(rangeIndexEepPB2!=0xff))
; 0000 07CA //       {
; 0000 07CB //           checkRes = checkSavedRangeValidity();
; 0000 07CC //           fixIncorrectRIPB(checkRes);
; 0000 07CD //       }
; 0000 07CE         LoadCalibrationSettings(CalibrationConfigChanged);
_0x174:
	CALL SUBOPT_0x2D
	MOV  R26,R30
	RCALL _LoadCalibrationSettings
; 0000 07CF         update_dynamic_vars();
	RCALL _update_dynamic_vars
; 0000 07D0         CalculateCalibrationRates();
	RCALL _CalculateCalibrationRates
; 0000 07D1         transmit_SPI(DAC_data,2);
	CALL SUBOPT_0x4E
; 0000 07D2 
; 0000 07D3 
; 0000 07D4         //enable_uart;
; 0000 07D5         RxEn;
	CALL SUBOPT_0x3
; 0000 07D6         //PORTD=0x08;
; 0000 07D7         Recieve;
	SBI  0xB,3
; 0000 07D8         //disable_eints;
; 0000 07D9 
; 0000 07DA         while (1)
_0x177:
; 0000 07DB               {
; 0000 07DC                 #asm("wdr")
	wdr
; 0000 07DD                 //delay_ms(20);
; 0000 07DE                 //enable_SPI;
; 0000 07DF 
; 0000 07E0 
; 0000 07E1         //        }
; 0000 07E2         if(message_recieved)
	SBIS 0x1E,4
	RJMP _0x17A
; 0000 07E3                 {
; 0000 07E4                  transmit_HART();
	CALL _transmit_HART
; 0000 07E5                 }
; 0000 07E6         //else
; 0000 07E7         //        {
; 0000 07E8                  if(protectBitsChecking ==50)
_0x17A:
	LDI  R30,LOW(50)
	CP   R30,R9
	BRNE _0x17B
; 0000 07E9                 {
; 0000 07EA                       protectBitsChecking = 0;
	CLR  R9
; 0000 07EB                     for(tmpindex = 0; tmpindex < 4; tmpindex++)
	LDI  R30,LOW(0)
	STD  Y+2,R30
_0x17D:
	LDD  R26,Y+2
	CPI  R26,LOW(0x4)
	BRSH _0x17E
; 0000 07EC                     {
; 0000 07ED                          checkRes =  checkCalibrationRatesValidity(tmpindex);
	CALL SUBOPT_0x4F
; 0000 07EE                          fixIncorrectCalibrationRates(tmpindex,checkRes);
; 0000 07EF 
; 0000 07F0                     }
	LDD  R30,Y+2
	SUBI R30,-LOW(1)
	STD  Y+2,R30
	RJMP _0x17D
_0x17E:
; 0000 07F1                     CalculateCalibrationRates();
	RCALL _CalculateCalibrationRates
; 0000 07F2 //                     checkRes = checkIDVarsValidity();
; 0000 07F3                      //  fixCRC();
; 0000 07F4 //                   checkIntegrityOfCalibrationVars(1);
; 0000 07F5 //                    CalculateCalibrationRates();
; 0000 07F6                 }
; 0000 07F7 //                if(protectBitsChecking == 100)
; 0000 07F8 //                {
; 0000 07F9 //
; 0000 07FA ////                                checkRes = checkIDVarsValidity();
; 0000 07FB ////                                fixIncorrectIDVars(checkRes);
; 0000 07FC //                }
; 0000 07FD                  update_dynamic_vars();
_0x17B:
	RCALL _update_dynamic_vars
; 0000 07FE                 ADCSRA=0xcf;
	LDI  R30,LOW(207)
	STS  122,R30
; 0000 07FF                 PORTB.2=1;
	SBI  0x5,2
; 0000 0800                 transmit_SPI(DAC_data,2);
	CALL SUBOPT_0x4E
; 0000 0801                 PORTB.2=0;
	CBI  0x5,2
; 0000 0802                 protectBitsChecking++;
	INC  R9
; 0000 0803 
; 0000 0804                // }
; 0000 0805         }
	RJMP _0x177
; 0000 0806     }
; 0000 0807 else
_0x173:
; 0000 0808     {
; 0000 0809         RxEn;
	CALL SUBOPT_0x3
; 0000 080A         //PORTD=0x08;
; 0000 080B         Recieve;
	SBI  0xB,3
; 0000 080C //               Parameter_bank[107]=0x60;
; 0000 080D //               Parameter_bank[10]=(char)crc;
; 0000 080E //               Parameter_bank[11]=(char)(crc>>8);
; 0000 080F 
; 0000 0810         while (1)
_0x186:
; 0000 0811               {
; 0000 0812               // DAC_zero_current=3.5;
; 0000 0813 
; 0000 0814                 #asm("wdr")
	wdr
; 0000 0815                 if(message_recieved)
	SBIS 0x1E,4
	RJMP _0x189
; 0000 0816                 {
; 0000 0817                  transmit_HART();
	CALL _transmit_HART
; 0000 0818                 }
; 0000 0819                 if(protectBitsChecking ==50)
_0x189:
	LDI  R30,LOW(50)
	CP   R30,R9
	BRNE _0x18A
; 0000 081A                 {
; 0000 081B                     protectBitsChecking = 0;
	CLR  R9
; 0000 081C                      for(tmpindex = 0; tmpindex < 4; tmpindex++)
	LDI  R30,LOW(0)
	STD  Y+2,R30
_0x18C:
	LDD  R26,Y+2
	CPI  R26,LOW(0x4)
	BRSH _0x18D
; 0000 081D                     {
; 0000 081E                          checkRes =  checkCalibrationRatesValidity(tmpindex);
	CALL SUBOPT_0x4F
; 0000 081F                          fixIncorrectCalibrationRates(tmpindex,checkRes);
; 0000 0820 
; 0000 0821                     }
	LDD  R30,Y+2
	SUBI R30,-LOW(1)
	STD  Y+2,R30
	RJMP _0x18C
_0x18D:
; 0000 0822                      CalculateCalibrationRates();
	RCALL _CalculateCalibrationRates
; 0000 0823                      // fixIncorrectIDVars();;
; 0000 0824 //                        checkIntegrityOfCalibrationVars(1);
; 0000 0825 //                        CalculateCalibrationRates();
; 0000 0826                 }
; 0000 0827                 update_dynamic_vars();
_0x18A:
	RCALL _update_dynamic_vars
; 0000 0828                 ADCSRA=0x0f;
	LDI  R30,LOW(15)
	STS  122,R30
; 0000 0829                 adc_data=0;
	LDI  R30,LOW(0)
	STS  _adc_data,R30
	STS  _adc_data+1,R30
	STS  _adc_data+2,R30
	STS  _adc_data+3,R30
; 0000 082A                 PORTB.2=1;
	SBI  0x5,2
; 0000 082B                 transmit_SPI(DAC_data,2);
	CALL SUBOPT_0x4E
; 0000 082C                 PORTB.2=0;
	CBI  0x5,2
; 0000 082D                 protectBitsChecking++;
	INC  R9
; 0000 082E         }
	RJMP _0x186
; 0000 082F     }
; 0000 0830 #asm
; 0000 0831 .CSEG
.CSEG
; 0000 0832 varlist: .DW 0x4fd1
varlist: .DW 0x4fd1
; 0000 0833 .org 0x0e6f                  //адрес, по которому будет распологатьс€ наш CRC - 0x1BCC, длина - 2 байта , эти 2 байта дл€ проверки со стороны ћ  мы исключаем, просто перескочив их
.org 0x0e6f                  //адрес, по которому будет распологатьс€ наш CRC - 0x1BCC, длина - 2 байта , эти 2 байта дл€ проверки со стороны ћ  мы исключаем, просто перескочив их
; 0000 0834 #endasm
; 0000 0835 }
	ADIW R28,15
_0x192:
	RJMP _0x192
; .FEND

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.ESEG
_Parameter_bank:
	.DB  0x0,0x56,0xA3,0x4
	.DB  0x1,0x1,0x1,0x21
	.DB  0x0,0x0,0xBF,0xBC
	.DB  0x6D,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x2,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x1
	.DB  0x2,0x3,0x42,0x48
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x3C,0x23
	.DB  0xD7,0xA,0x0,0x0
	.DB  0x0,0x0,0xA0,0x41
	.DB  0x0,0x0,0x0,0x0
	.DB  0xF0,0xF,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x80
	.DB  0x40,0x0,0x0,0xA0
	.DB  0x41,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_Parameter_defaults:
	.DB  0x11,0x56,0xB3,0x4
	.DB  0x1,0x1,0x1,0x21
	.DB  0x0,0x0,0xBF,0xBC
	.DB  0x6D,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x2,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x1
	.DB  0x2,0x3,0x42,0x48
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x3C,0x23
	.DB  0xD7,0xA,0x0,0x0
	.DB  0x0,0x0,0xA0,0x41
	.DB  0x0,0x0,0x0,0x0
	.DB  0xF0,0xF,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x80
	.DB  0x40,0x0,0x0,0xA0
	.DB  0x41,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_ADC_PV_calibration_point1:
	.BYTE 0x8
_ADC_PV_calibration_point2:
	.BYTE 0x8
_ADC_PV_calibration_point1_PB1:
	.BYTE 0x8
_ADC_PV_calibration_point1_PB2:
	.BYTE 0x8
_ADC_PV_calibration_point2_PB1:
	.BYTE 0x8
_ADC_PV_calibration_point2_PB2:
	.BYTE 0x8
_rangeIndexEep:
	.BYTE 0x1
_rangeIndexEepPB1:
	.BYTE 0x1
_rangeIndexEepPB2:
	.BYTE 0x1
_CalibrationConfigChanged:
	.BYTE 0x1
_CalibrationConfigChangedPB1:
	.BYTE 0x1
_CalibrationConfigChangedPB2:
	.BYTE 0x1
_calibrationKeep:
	.BYTE 0x10
_calibrationBeep:
	.BYTE 0x10
_calibrationKeep_PB1:
	.BYTE 0x10
_calibrationKeep_PB2:
	.BYTE 0x10
_calibrationBeep_PB1:
	.BYTE 0x10
_calibrationBeep_PB2:
	.BYTE 0x10
_crceep:
	.DB  0x0,0x0
_crcstatic:
	.DB  0xEA,0xDC

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
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1:
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x2:
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	LDS  R30,193
	ANDI R30,LOW(0xC0)
	ORI  R30,0x10
	STS  193,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDS  R26,_DAC_data
	LDS  R27,_DAC_data+1
	LDS  R24,_DAC_data+2
	LDS  R25,_DAC_data+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	STS  _checking_result,R30
	STS  _rx_wr_index0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x6:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	EOR  R19,R30
	SUBI R17,-1
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x8:
	MOVW R0,R30
	LDS  R26,_preambula_bytes_rec
	CLR  R27
	LDS  R30,_preambula_bytes
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOV  R30,R17
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	MOVW R26,R0
	ST   X,R30
	MOV  R30,R17
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_tx_buffer0)
	SBCI R27,HIGH(-_tx_buffer0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	ST   X,R30
	MOV  R30,R17
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	STD  Z+0,R26
	MOV  R30,R17
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xC:
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+5,R30
	STD  Y+6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF:
	CALL __SAVELOCR6
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	LDI  R18,0
	LDI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDS  R30,_com_bytes_rx
	LDI  R31,0
	ADIW R30,1
	MOV  R26,R16
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x11:
	LDD  R30,Y+10
	LDI  R26,LOW(25)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_Command_mask*2)
	SBCI R31,HIGH(-_Command_mask*2)
	MOVW R26,R30
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
	MOV  R30,R19
	LDI  R31,0
	SUBI R30,LOW(-_Command_data)
	SBCI R31,HIGH(-_Command_data)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x13:
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
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	ADD  R30,R22
	ADC  R31,R23
	SUBI R30,LOW(-_Parameter_bank)
	SBCI R31,HIGH(-_Parameter_bank)
	MOVW R26,R30
	CALL __EEPROMRDB
	MOVW R26,R24
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x15:
	LDI  R26,LOW(_rangeIndexEep)
	LDI  R27,HIGH(_rangeIndexEep)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x16:
	LDI  R26,LOW(_calibrationKeep)
	LDI  R27,HIGH(_calibrationKeep)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	__PUTD1S 6
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(_calibrationBeep)
	LDI  R27,HIGH(_calibrationBeep)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x19:
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+6
	LDI  R26,LOW(25)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_Command_mask*2)
	SBCI R31,HIGH(-_Command_mask*2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x1C:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	EOR  R30,R26
	EOR  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	SUBI R17,-1
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x1E:
	MOVW R26,R30
	MOV  R30,R18
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R30,Z
	MOVW R26,R0
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	CALL __EQB12
	AND  R0,R30
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	MOV  R30,R10
	LDI  R26,LOW(_ADC_PV_calibration_point1)
	LDI  R27,HIGH(_ADC_PV_calibration_point1)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x21:
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
	CALL __EEPROMWRW
	MOV  R30,R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x22:
	LDI  R26,LOW(_ADC_PV_calibration_point1_PB1)
	LDI  R27,HIGH(_ADC_PV_calibration_point1_PB1)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x23:
	LDI  R26,LOW(_ADC_PV_calibration_point1_PB2)
	LDI  R27,HIGH(_ADC_PV_calibration_point1_PB2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x25:
	LDI  R26,LOW(_CalibrationConfigChanged)
	LDI  R27,HIGH(_CalibrationConfigChanged)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	LDI  R26,LOW(_CalibrationConfigChangedPB1)
	LDI  R27,HIGH(_CalibrationConfigChangedPB1)
	CALL __EEPROMWRB
	LDI  R26,LOW(_CalibrationConfigChangedPB2)
	LDI  R27,HIGH(_CalibrationConfigChangedPB2)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,2
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	MOV  R30,R10
	LDI  R26,LOW(_ADC_PV_calibration_point2)
	LDI  R27,HIGH(_ADC_PV_calibration_point2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x28:
	LDI  R26,LOW(_ADC_PV_calibration_point2_PB1)
	LDI  R27,HIGH(_ADC_PV_calibration_point2_PB1)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x29:
	LDI  R26,LOW(_ADC_PV_calibration_point2_PB2)
	LDI  R27,HIGH(_ADC_PV_calibration_point2_PB2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2A:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	EOR  R30,R26
	EOR  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	LDI  R26,LOW(_CalibrationConfigChangedPB1)
	LDI  R27,HIGH(_CalibrationConfigChangedPB1)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	LDI  R26,LOW(_CalibrationConfigChangedPB2)
	LDI  R27,HIGH(_CalibrationConfigChangedPB2)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	LDI  R26,LOW(_CalibrationConfigChanged)
	LDI  R27,HIGH(_CalibrationConfigChanged)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2E:
	LD   R30,Y
	LDI  R26,LOW(_ADC_PV_calibration_point1)
	LDI  R27,HIGH(_ADC_PV_calibration_point1)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	MOVW R0,R30
	LD   R30,Y
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x2F:
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	CP   R30,R0
	CPC  R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x30:
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	MOVW R0,R30
	LD   R30,Y
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x31:
	LD   R30,Y
	LDI  R26,LOW(_ADC_PV_calibration_point2)
	LDI  R27,HIGH(_ADC_PV_calibration_point2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	LD   R30,Y
	LDI  R26,LOW(_calibrationKeep_PB1)
	LDI  R27,HIGH(_calibrationKeep_PB1)
	LDI  R31,0
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x33:
	LD   R30,Y
	LDI  R26,LOW(_calibrationKeep_PB2)
	LDI  R27,HIGH(_calibrationKeep_PB2)
	LDI  R31,0
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	LD   R30,Y
	LDI  R26,LOW(_calibrationBeep_PB1)
	LDI  R27,HIGH(_calibrationBeep_PB1)
	LDI  R31,0
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	LD   R30,Y
	LDI  R26,LOW(_calibrationBeep_PB2)
	LDI  R27,HIGH(_calibrationBeep_PB2)
	LDI  R31,0
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x36:
	MOVW R0,R30
	LDD  R30,Y+1
	LDI  R26,LOW(_ADC_PV_calibration_point1)
	LDI  R27,HIGH(_ADC_PV_calibration_point1)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	MOVW R26,R0
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x37:
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	MOVW R26,R0
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x38:
	MOVW R0,R30
	LDD  R30,Y+1
	LDI  R26,LOW(_ADC_PV_calibration_point2)
	LDI  R27,HIGH(_ADC_PV_calibration_point2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RJMP SUBOPT_0x37

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x39:
	LDI  R31,0
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDD  R30,Y+1
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3A:
	LDI  R31,0
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDD  R30,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x3B:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3C:
	MOVW R26,R30
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
	CPI  R17,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3E:
	LDS  R30,_calibrationK
	LDS  R31,_calibrationK+1
	LDS  R22,_calibrationK+2
	LDS  R23,_calibrationK+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3F:
	__GETD2S 26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	__GETD1S 22
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x41:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x42:
	STS  _calibrationB,R30
	STS  _calibrationB+1,R31
	STS  _calibrationB+2,R22
	STS  _calibrationB+3,R23
	MOV  R30,R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x43:
	STS  _calibrationK,R30
	STS  _calibrationK+1,R31
	STS  _calibrationK+2,R22
	STS  _calibrationK+3,R23
	MOV  R30,R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x44:
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x46:
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL SUBOPT_0x3E
	CALL __EEPROMWRD
	MOV  R30,R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x47:
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_calibrationB
	LDS  R31,_calibrationB+1
	LDS  R22,_calibrationB+2
	LDS  R23,_calibrationB+3
	CALL __EEPROMWRD
	MOV  R30,R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x48:
	__GETD1N 0x0
	CALL __EEPROMWRD
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x49:
	__GETD1N 0x3F800000
	CALL __EEPROMWRD
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x4A:
	LDI  R26,LOW(_ADC_PV_calibration_point1)
	LDI  R27,HIGH(_ADC_PV_calibration_point1)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(3273)
	LDI  R31,HIGH(3273)
	CALL __EEPROMWRW
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
	MOVW R30,R16
	LDI  R26,LOW(_ADC_PV_calibration_point1_PB1)
	LDI  R27,HIGH(_ADC_PV_calibration_point1_PB1)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(3273)
	LDI  R31,HIGH(3273)
	CALL __EEPROMWRW
	MOVW R30,R16
	LDI  R26,LOW(_ADC_PV_calibration_point1_PB2)
	LDI  R27,HIGH(_ADC_PV_calibration_point1_PB2)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(3273)
	LDI  R31,HIGH(3273)
	CALL __EEPROMWRW
	MOVW R30,R16
	LDI  R26,LOW(_ADC_PV_calibration_point2_PB1)
	LDI  R27,HIGH(_ADC_PV_calibration_point2_PB1)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(65472)
	LDI  R31,HIGH(65472)
	CALL __EEPROMWRW
	MOVW R30,R16
	LDI  R26,LOW(_ADC_PV_calibration_point2_PB2)
	LDI  R27,HIGH(_ADC_PV_calibration_point2_PB2)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(65472)
	LDI  R31,HIGH(65472)
	CALL __EEPROMWRW
	MOVW R30,R16
	LDI  R26,LOW(_calibrationBeep_PB1)
	LDI  R27,HIGH(_calibrationBeep_PB1)
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4B:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x4C:
	LDI  R30,LOW(0)
	STS  _calibrationB,R30
	STS  _calibrationB+1,R30
	STS  _calibrationB+2,R30
	STS  _calibrationB+3,R30
	RCALL SUBOPT_0x4B
	STS  _calibrationK,R30
	STS  _calibrationK+1,R31
	STS  _calibrationK+2,R22
	STS  _calibrationK+3,R23
	LDI  R30,LOW(3273)
	LDI  R31,HIGH(3273)
	__PUTW1R 5,6
	LDI  R30,LOW(65472)
	LDI  R31,HIGH(65472)
	__PUTW1R 7,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x4D:
	LDI  R26,LOW(_rangeIndexEep)
	LDI  R27,HIGH(_rangeIndexEep)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	LDI  R26,LOW(_rangeIndexEepPB1)
	LDI  R27,HIGH(_rangeIndexEepPB1)
	CALL __EEPROMWRB
	LDI  R26,LOW(_rangeIndexEepPB2)
	LDI  R27,HIGH(_rangeIndexEepPB2)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x4E:
	LDS  R30,_DAC_data
	LDS  R31,_DAC_data+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	JMP  _transmit_SPI

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4F:
	LDD  R26,Y+2
	CALL _checkCalibrationRatesValidity
	STD  Y+3,R30
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+4
	JMP  _fixIncorrectCalibrationRates


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USB 0x9A
	wdr
	sbiw r26,1
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

__NEB12:
	CP   R30,R26
	LDI  R30,1
	BRNE __NEB12T
	CLR  R30
__NEB12T:
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

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
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

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
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

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
