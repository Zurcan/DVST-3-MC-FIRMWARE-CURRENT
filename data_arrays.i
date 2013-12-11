
#pragma used+
sfrb PINB=3;
sfrb DDRB=4;
sfrb PORTB=5;
sfrb PINC=6;
sfrb DDRC=7;
sfrb PORTC=8;
sfrb PIND=9;
sfrb DDRD=0xa;
sfrb PORTD=0xb;
sfrb TIFR0=0x15;
sfrb TIFR1=0x16;
sfrb TIFR2=0x17;
sfrb PCIFR=0x1b;
sfrb EIFR=0x1c;
sfrb EIMSK=0x1d;
sfrb GPIOR0=0x1e;
sfrb EECR=0x1f;
sfrb EEDR=0x20;
sfrb EEARL=0x21;
sfrb EEARH=0x22;
sfrw EEAR=0x21;   
sfrb GTCCR=0x23;
sfrb TCCR0A=0x24;
sfrb TCCR0B=0x25;
sfrb TCNT0=0x26;
sfrb OCR0A=0x27;
sfrb OCR0B=0x28;
sfrb GPIOR1=0x2a;
sfrb GPIOR2=0x2b;
sfrb SPCR=0x2c;
sfrb SPSR=0x2d;
sfrb SPDR=0x2e;
sfrb ACSR=0x30;
sfrb SMCR=0x33;
sfrb MCUSR=0x34;
sfrb MCUCR=0x35;
sfrb SPMCSR=0x37;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
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
#endasm

eeprom char Parameter_bank[44][24]=
{
{0x00},                 
{0x56},                 
{0x03},                 
{0x03},                 
{0x01},                 
{0x01},                 
{0x01},                 
{0x21},                 
{0x02},                 
{0x14, 0x06, 0x0b},     
{0x6d},                 
{0x00},                 
{0x00},                 
{0x00},                 
{0x02},                 
{0x00},                 
{0x00},                 
{0x00},                 
{0x00},                 
{0x01, 0x02, 0x03},     
{0x42, 0x48},           
{0x00},                 
{0x3C, 0x23, 0xD7, 0x0A},
{0x00},                  
{0x00},                  
{0x41, 0xA0},            
{0x00},                  
{0xf0},                  
{0x0f},                  
{0x15, 0x06, 0x0b},      
{0x00},                  
{0x00},                  
{0x00},                  
{0x00},                  
{0x00},                  
{0x00},                  
{0x00},                  
{0x00},                  
{0x00},                  
{0x00},                  
{0x00},                  
{0x00},                  
{0x00},                  
{0x00},                  
};

char Command_mask [32][25]=
{                                
{42, 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 9, 43, 43, 43, 43},                                             
{10, 11, 11, 11, 11},                                                                              
{12, 12, 12, 12, 13, 13, 13, 13},                                                                  
{12, 12, 12, 12, 10, 13, 13, 13, 13},                                                              
{14},                                                                                              
{42, 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 9, 43, 43, 43, 43},                                             
{16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16},  
{15, 15, 15, 15, 15, 15, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 18, 18, 18},              
{19, 19, 19, 10, 20, 20, 20, 20, 21, 21, 21, 21, 22, 22, 22, 22},                                  
{23, 24, 10, 25, 25, 25, 25, 26, 26, 26, 26, 43, 43, 43, 43, 27, 28},                              
{29, 29, 29},                                                                                      
{16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16},  
{15, 15, 15, 15, 15, 15, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 18, 18, 18},              
{29, 29, 29},                                                                                      
{10, 25, 25, 25, 25, 26, 26, 26, 26},                                                              
{0},                                                                                               
{0},                                                                                               
{0},                                                                                               
{30},                                                                                              
{31},                                                                                              
{0},                                                                                               
{0},                                                                                               
{0},                                                                                               
{10},                                                                                              
{32,32,32},                                                                                        
{33,33,33},                                                                                        
{34},                                                                                              
{35, 35, 35, 35, 35, 35, 43, 43, 43, 43, 43, 43, 43, 43, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36},  
{19, 19, 19},                                                                                      
{3},                                                                                               
{40},                                                                                              
{41},                                                                                              
};                                             
