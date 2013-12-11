
#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

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

flash char Parameter_mask[40]={
0,                 
1,                 
2,                 
3,                 
4,                 
5,                 
6,                 
7,                 
8,                 
9,                 
12,                
13,                
17,                
21,                
25,                
26,                
32,                
56,                
68,                
71,                
74,                
78,                
82,                
86,                
87,                
88,                
92,                
96,                
97,                
98,                

101,               
105,               
109,               
113,               
117,               
123,               
134,               
135,               
136,               
137                
};

eeprom char Parameter_bank[138]={0x00,                                                  
0x56,                                                  
0xA3,                                                  
0x04,                                                  
0x01,                                                  
0x01,                                                  
0x01,                                                  
0x21,                                                  
0x00,                                                  
0x00, 0xBF, 0xBC,                                      
0x6d,                                                  
0,0,0,0,                                               
0,0,0,0,                                               
0,0,0,0,                                               
0x02,                                                  
0,0,0,0,0,0,                                           
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,       
0,0,0,0,0,0,0,0,0,0,0,0,                               
0,0,0,                                                 
0x01, 0x02, 0x03,                                      
0x42, 0x48,0,0,                                        
0,0,0,0,                                               
0x3C, 0x23, 0xD7, 0x0A,                                
0,                                                     
0,                                                     
0x00,0x00,0xA0,0x41,                                   
0,0,0,0,                                               
0xf0,                                                  
0x0f,                                                  
0x00, 0x00, 0x00,                                      

0,0,0,0,                                               
0x00,0x00,0x80,0x40,                                   
0x00,0x00,0xA0,0x41,                                   
0,0,0,0,                                               
0,0,0,0,0,0,                                           
0,0,0,0,0,0,0,0,0,0,0,                                 
0,                                                     
0,                                                     
0,                                                     
0                                                      
};
eeprom char Parameter_defaults[138]={0x11,                                                  
0x56,                                                  
0xB3,                                                  
0x04,                                                  
0x01,                                                  
0x01,                                                  
0x01,                                                  
0x21,                                                  
0x00,                                                  
0x00,  0xBF, 0xBC,                                      
0x6d,                                                  
0,0,0,0,                                               
0,0,0,0,                                               
0,0,0,0,                                               
0x02,                                                  
0,0,0,0,0,0,                                           
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,       
0,0,0,0,0,0,0,0,0,0,0,0,                               
0,0,0,                                                 
0x01, 0x02, 0x03,                                      
0x42, 0x48,0,0,                                        
0,0,0,0,                                               
0x3C, 0x23, 0xD7, 0x0A,                                
0,                                                     
0,                                                     
0x00,0x00,0xA0,0x41,                                   
0,0,0,0,                                               
0xf0,                                                  
0x0f,                                                  
0x00, 0x00, 0x00,                                      

0,0,0,0,                                               
0x00,0x00,0x80,0x40,                                   
0x00,0x00,0xA0,0x41,                                   
0,0,0,0,                                               
0,0,0,0,0,0,                                           
0,0,0,0,0,0,0,0,0,0,0,                                 
0,                                                     
0,                                                     
0,                                                     
0                                                      
};                                 
flash char Command_mask [31][25]=
{                       {38, 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 9},                                                             
{10, 11, 11, 11, 11},                                                                              
{12, 12, 12, 12, 13, 13, 13, 13},                                                                  
{12, 12, 12, 12, 10, 13, 13, 13, 13},                                                              
{14},                                                                                              
{38, 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 9},                                                             
{16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16},  
{15, 15, 15, 15, 15, 15, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 18, 18, 18},              
{19, 19, 19, 10, 20, 20, 20, 20, 21, 21, 21, 21, 22, 22, 22, 22},                                  
{23, 24, 10, 25, 25, 25, 25, 26, 26, 26, 26, 39, 39, 39, 39, 27, 28},                              
{29, 29, 29},                                                                                      
{16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16},  
{15, 15, 15, 15, 15, 15, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 18, 18, 18},              
{29, 29, 29},                                                                                      
{10, 25, 25, 25, 25, 26, 26, 26, 26},                                                              
{0},                                                                                               
{0},                                                                                               
{0},                                                                                               

{30},                                                                                              
{0},                                                                                               
{0},                                                                                               
{0},                                                                                               
{10},                                                                                              
{31,31,31},                                                                                        
{32,32,32},                                                                                        
{33},                                                                                              
{34, 34, 34, 34, 34, 34, 39, 39, 39, 39, 39, 39, 39, 39, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35},  
{19, 19, 19},                                                                                      
{3},                                                                                               
{36},                                                                                              
{37},                                                                                              
};      

flash char Command_number [3][31] =    {
{0,1,2,3,6,11,12,13,14,15,16,17,18,19,35,36,37,38,40,41,42,43,44,45,46,47,48,49,59,108,109},           
{0,0,0,0,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1},                                       
{0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},                                       
} ;                                                                              

#pragma used+

signed char cmax(signed char a,signed char b);
int max(int a,int b);
long lmax(long a,long b);
float fmax(float a,float b);
signed char cmin(signed char a,signed char b);
int min(int a,int b);
long lmin(long a,long b);
float fmin(float a,float b);
signed char csign(signed char x);
signed char sign(int x);
signed char lsign(long x);
signed char fsign(float x);
unsigned char isqrt(unsigned int x);
unsigned int lsqrt(unsigned long x);
float sqrt(float x);
float ftrunc(float x);
float floor(float x);
float ceil(float x);
float fmod(float x,float y);
float modf(float x,float *ipart);
float ldexp(float x,int expon);
float frexp(float x,int *expon);
float exp(float x);
float log(float x);
float log10(float x);
float pow(float x,float y);
float sin(float x);
float cos(float x);
float tan(float x);
float sinh(float x);
float cosh(float x);
float tanh(float x);
float asin(float x);
float acos(float x);
float atan(float x);
float atan2(float y,float x);

#pragma used-
#pragma library math.lib

char rxEnable=0, txEnable=1;

float DAC_to_current_ratio=1;
unsigned int calibration_point1;
unsigned int calibration_point2;
eeprom unsigned int ADC_PV_calibration_point1[4];
eeprom unsigned int ADC_PV_calibration_point2[4];
eeprom char rangeIndexEep;
eeprom char CalibrationConfigChanged;
eeprom float calibrationKeep[4];
eeprom float calibrationBeep[4];
eeprom int crceep = 0x0000;
eeprom const int crcstatic = 0x105D;
eeprom char tmpEepPriValCode = 0x6d;

char rangeIndex;
float calibrationK;
float calibrationB;
unsigned int tmp_calibration, crc;
unsigned int ADC_PV_zero_val=0x0001;
char rx_buffer0[64];
char string_tmp[4];

char com_data_rx[25];
float dynamic_variables[3];         
char dataToSave,sensor_address=0x02,com_bytes_rx=0,update_args_flag=0,p_bank_addr=0;
void transmit_HART(void); int check_recieved_message(); int generate_command_data_array_answer(char command_recieved);
void update_eeprom_parameters(char update_flag);
void start_transmit(int transmit_param); void clear_buffer();
void CalculateCalibrationRates();
void ResetDeviceSettings(char notreset);
void  CRC_update(unsigned char d);
void PerformDeviceApplicationErase();
void (*voidFuncPtr)(void);
int read_program_memory (int adr);
unsigned char rx_wr_index0,rx_rd_index0,rx_counter0,echo;

bit rx_buffer_overflow0,printflag=0,RxTx=0,new_data=0,message_recieved=0,answering=0,burst_mode=0;
flash  int crctable[256]= {
0x0000, 0xC1C0, 0x81C1, 0x4001, 0x01C3, 0xC003, 0x8002, 0x41C2, 0x01C6, 0xC006,
0x8007, 0x41C7, 0x0005, 0xC1C5, 0x81C4, 0x4004, 0x01CC, 0xC00C, 0x800D, 0x41CD,
0x000F, 0xC1CF, 0x81CE, 0x400E, 0x000A, 0xC1CA, 0x81CB, 0x400B, 0x01C9, 0xC009,
0x8008, 0x41C8, 0x01D8, 0xC018, 0x8019, 0x41D9, 0x001B, 0xC1DB, 0x81DA, 0x401A,
0x001E, 0xC1DE, 0x81DF, 0x401F, 0x01DD, 0xC01D, 0x801C, 0x41DC, 0x0014, 0xC1D4,
0x81D5, 0x4015, 0x01D7, 0xC017, 0x8016, 0x41D6, 0x01D2, 0xC012, 0x8013, 0x41D3,
0x0011, 0xC1D1, 0x81D0, 0x4010, 0x01F0, 0xC030, 0x8031, 0x41F1, 0x0033, 0xC1F3,
0x81F2, 0x4032, 0x0036, 0xC1F6, 0x81F7, 0x4037, 0x01F5, 0xC035, 0x8034, 0x41F4,
0x003C, 0xC1FC, 0x81FD, 0x403D, 0x01FF, 0xC03F, 0x803E, 0x41FE, 0x01FA, 0xC03A, 
0x803B, 0x41FB, 0x0039, 0xC1F9, 0x81F8, 0x4038, 0x0028, 0xC1E8, 0x81E9, 0x4029,
0x01EB, 0xC02B, 0x802A, 0x41EA, 0x01EE, 0xC02E, 0x802F, 0x41EF, 0x002D, 0xC1ED,
0x81EC, 0x402C, 0x01E4, 0xC024, 0x8025, 0x41E5, 0x0027, 0xC1E7, 0x81E6, 0x4026,
0x0022, 0xC1E2, 0x81E3, 0x4023, 0x01E1, 0xC021, 0x8020, 0x41E0, 0x01A0, 0xC060, 
0x8061, 0x41A1, 0x0063, 0xC1A3, 0x81A2, 0x4062, 0x0066, 0xC1A6, 0x81A7, 0x4067,
0x01A5, 0xC065, 0x8064, 0x41A4, 0x006C, 0xC1AC, 0x81AD, 0x406D, 0x01AF, 0xC06F,
0x806E, 0x41AE, 0x01AA, 0xC06A, 0x806B, 0x41AB, 0x0069, 0xC1A9, 0x81A8, 0x4068, 
0x0078, 0xC1B8, 0x81B9, 0x4079, 0x01BB, 0xC07B, 0x807A, 0x41BA, 0x01BE, 0xC07E,
0x807F, 0x41BF, 0x007D, 0xC1BD, 0x81BC, 0x407C, 0x01B4, 0xC074, 0x8075, 0x41B5, 
0x0077, 0xC1B7, 0x81B6, 0x4076, 0x0072, 0xC1B2, 0x81B3, 0x4073, 0x01B1, 0xC071,
0x8070, 0x41B0, 0x0050, 0xC190, 0x8191, 0x4051, 0x0193, 0xC053, 0x8052, 0x4192, 
0x0196, 0xC056, 0x8057, 0x4197, 0x0055, 0xC195, 0x8194, 0x4054, 0x019C, 0xC05C,
0x805D, 0x419D, 0x005F, 0xC19F, 0x819E, 0x405E, 0x005A, 0xC19A, 0x819B, 0x405B, 
0x0199, 0xC059, 0x8058, 0x4198, 0x0188, 0xC048, 0x8049, 0x4189, 0x004B, 0xC18B,
0x818A, 0x404A, 0x004E, 0xC18E, 0x818F, 0x404F, 0x018D, 0xC04D, 0x804C, 0x418C,
0x0044, 0xC184, 0x8185, 0x4045, 0x0187, 0xC047, 0x8046, 0x4186, 0x0182, 0xC042,
0x8043, 0x4183, 0x0041, 0xC181, 0x8180, 0x4040};
long  adc_data, DAC_data, SPI_tData ;
char SPI_tEnd=1,checking_result=0,preambula_bytes=5,preambula_bytes_rec=0,bytes_quantity_ans=0,bytes_quantity_q=0,data_q=0, command_rx_val=0;

char Command_data[25];

int read_program_memory (int adr)
{
#asm
       LPM R22,Z+;//     загрузка в регистр R23 содержимого флеш по адресу Z с постинкрементом (мл. байт)
       LPM R23,Z; //     загрузка в регистр R22 содержимого Flash  по адресу Z+1 (старший байт)
       MOV R30, R22;
       MOV R31, R23;
       #endasm
}  
void  CRC_update(unsigned char d)
{

crc = crctable[((crc>>8)^d)&0xFF] ^ (crc<<8);
}      

interrupt [17] void timer0_ovf_isr(void)     
{
{EIMSK=0x01;EIFR=0x01;};
(*(unsigned char *) 0x69)=0x00;
}

interrupt [19] void usart_rx_isr(void)
{

char status,data;
#asm("cli")
status=(*(unsigned char *) 0xc0);

data=(*(unsigned char *) 0xc6);

if ((status & ((1<<4) | (1<<2) | (1<<3)))==0)
{
rx_buffer0[rx_wr_index0]=data;
if (++rx_wr_index0 == 64) rx_wr_index0=0;
if (++rx_counter0 == 64)
{
rx_counter0=0;
rx_buffer_overflow0=1;

};
};
#asm("sei")   
}

#pragma used+
char getchar(void) 
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0];
if (++rx_rd_index0 == 64) rx_rd_index0=0;
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}
#pragma used-

char tx_buffer0[64];

unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;

interrupt [21] void usart_tx_isr(void)
{
#asm("cli")
if (tx_counter0)
{
--tx_counter0;

(*(unsigned char *) 0xc6)=tx_buffer0[tx_rd_index0];

if (++tx_rd_index0 == 64) tx_rd_index0=0;
};
#asm("sei")   
}

#pragma used+
void putchar(char c)                                       
{

while (((*(unsigned char *) 0xc0) & (1<<5))==0)
(*(unsigned char *) 0xc6)=c;

}

interrupt [2] void ext_int0_isr(void)

{

if((*(unsigned char *) 0x69)==0x03)                    
{
PORTD.3=1;
(*(unsigned char *) 0xc1)=((*(unsigned char *) 0xc1)&0xc0)|0x10;

(*(unsigned char *) 0x69)=0x00;           
message_recieved=0;

}
else 
{

(*(unsigned char *) 0x69)=0x03;            
(*(unsigned char *) 0xc1)=0xc0;             
message_recieved=1;

}

}

#pragma used-

interrupt [22] void adc_isr(void)
{

delay_us(10);
adc_data=(*(unsigned int *) 0x78) ;
printflag=1;
(*(unsigned char *) 0x7c)=0x20;
(*(unsigned char *) 0x7a)=0x4f;

}

interrupt [18] void spi_isr(void)       
{                                              

if(SPI_tEnd==0){
SPDR=0xff;
SPI_tEnd=1;
}
else PORTB.2=0;
(*(unsigned char *) 0x7a)=0xcf;

}

void transmit_SPI(unsigned int SPI_data,char SPI_mode){

delay_us(10);
PORTB.2=0;
if(SPI_mode<2)
{
SPDR=SPI_mode;
if(SPI_mode==0)SPI_data=0x3c00;
else SPI_data=0x6000;
while(SPSR<0x80){;}
}
if(SPI_mode==3){
SPI_data=0;}
if(SPI_mode==2)
{
SPDR=(long)(DAC_data>>16);
while(SPSR<0x80){;}
}
SPDR=SPI_data>>8;
PORTB.2=0;
while(SPSR<0x80){;}
SPDR=SPI_data;
while(SPSR<0x80){;}

}

void transmit_HART(void)
{
int error_log;
error_log=check_recieved_message();    
if(answering)                         
{
if (!error_log)               
{
checking_result=0;                
rx_wr_index0=0;
rx_buffer_overflow0=0;
error_log=error_log|(generate_command_data_array_answer(command_rx_val));
start_transmit(error_log);
}
else
{ 

PORTD.3=1;
rx_buffer_overflow0=0;
checking_result=0;
rx_wr_index0=0;
message_recieved=0;
start_transmit(error_log);
}
}
else                              
{
rx_buffer_overflow0=0;
checking_result=0;
rx_wr_index0=0;
(*(unsigned char *) 0xc1)=((*(unsigned char *) 0xc1)&0xc0)|0x10;
PORTD.3=1;
} 
clear_buffer();        
}

void start_transmit(int transmit_param)
{
char i=0,j=0;
char check_sum_tx=0;
while((*(unsigned char *) 0xc0)<0x20){;}

preambula_bytes=Parameter_bank[3];
delay_ms(25);
PORTD.3=0;
(*(unsigned char *) 0xc1)=((*(unsigned char *) 0xc1)&0xc0)|0x08;
delay_ms(15);
for (i=0;i<preambula_bytes;i++)
{
tx_buffer0[i]=0xff;
tx_counter0++;
}

if(burst_mode)tx_buffer0[i]=0x01;
else tx_buffer0[i]=0x06;
check_sum_tx=check_sum_tx^tx_buffer0[i];
i++; 
tx_buffer0[i]=rx_buffer0[preambula_bytes_rec-preambula_bytes+i];
check_sum_tx=check_sum_tx^tx_buffer0[i];
i++; 
tx_buffer0[i]=rx_buffer0[preambula_bytes_rec-preambula_bytes+i];
check_sum_tx=check_sum_tx^tx_buffer0[i];
i++; 
if(!transmit_param)
{
tx_buffer0[i]=bytes_quantity_ans+2;                                                  
check_sum_tx=check_sum_tx^tx_buffer0[i];
i++; 
tx_buffer0[i]=p_bank_addr;                                             
check_sum_tx=check_sum_tx^tx_buffer0[i]; 
i++;      
tx_buffer0[i]=0x00;                                             
check_sum_tx=check_sum_tx^tx_buffer0[i];
i++; 
for(j=0;j<bytes_quantity_ans;j++)
{
tx_buffer0[i]=Command_data[j];                                                
check_sum_tx=check_sum_tx^tx_buffer0[i];
i++;
}
}        
else {
tx_buffer0[i]=com_bytes_rx+2;       

check_sum_tx=check_sum_tx^tx_buffer0[i];
i++;
tx_buffer0[i]=transmit_param>>8;                                       
check_sum_tx=check_sum_tx^tx_buffer0[i];
i++;      
tx_buffer0[i]=transmit_param;                                          
check_sum_tx=check_sum_tx^tx_buffer0[i];
i++;
j=i;
for(i=j;i<com_bytes_rx+j;i++)
{
tx_buffer0[i]=rx_buffer0[preambula_bytes_rec-preambula_bytes+i-2];                                                
check_sum_tx=check_sum_tx^tx_buffer0[i];

}
}

tx_buffer0[i]=check_sum_tx;
tx_rd_index0=1;

tx_counter0=i;
(*(unsigned char *) 0xc6)=tx_buffer0[0];
while(tx_counter0){;}
delay_ms(15);

PORTD.3=1;
message_recieved=0;
rx_counter0=0;

}

int generate_command_data_array_answer(char command_recieved)
{
char i=0,j=0,k=0;
char dynamic_parameter=0, writing_command=0, error=1, parameter_tmp=0,parameter_tmp_length=0,tmp_command_number=0;
union ieeesender      
{
float value;
char byte[4];
}floatsend;  

for (i=0;i<31;i++)
{
if(Command_number[0][i]==command_recieved)
{
error=0;
tmp_command_number=i;
}
}
if(!error)      {
writing_command=Command_number[1][tmp_command_number];
dynamic_parameter=Command_number[2][tmp_command_number];
if(writing_command)
{
for(j=0;j<com_bytes_rx+1;j++)
{
Command_data[j]=com_data_rx[j];

}
update_args_flag=tmp_command_number;
update_eeprom_parameters(tmp_command_number);               
j=0;                                         
}
else    
{

parameter_tmp=Command_mask[tmp_command_number][j];

for(j=0;j<24;j++)
{
if(parameter_tmp!=Command_mask[tmp_command_number][j])
{
for(k=(j-parameter_tmp_length);k<j;k++)
{
if((parameter_tmp<11)|(parameter_tmp>13))                                                                        
{
Command_data[k]=Parameter_bank[Parameter_mask[parameter_tmp]+(k+parameter_tmp_length-j)];
}
else 
{

#asm ("cli")
floatsend.value=dynamic_variables[parameter_tmp-11];

Command_data[k]=floatsend.byte[k+parameter_tmp_length-j]; 
#asm("sei")
}
}
parameter_tmp_length=0;
}          
parameter_tmp=Command_mask[tmp_command_number][j];                                                                                                        
parameter_tmp_length++;
if(!Command_mask[tmp_command_number][j])j=24;     
}
bytes_quantity_ans=k;
k=0;
}       
}

return error;
}         

void update_eeprom_parameters(char update_flag)
{
char i=0,j=0,k=0,parameter_tmp=0,parameter_tmp_length=0;
parameter_tmp=Command_mask[update_flag][0];

for(j=0;j<com_bytes_rx+1;j++)
{
if(parameter_tmp!=Command_mask[update_flag][j])
{
for(k=(j-parameter_tmp_length);k<j;k++)
{
Parameter_bank[Parameter_mask[parameter_tmp]+(k+parameter_tmp_length-j)]=Command_data[k];
}
parameter_tmp_length=0;                                 
}

parameter_tmp=Command_mask[update_flag][j];                                                                                                        
parameter_tmp_length++;
if(!Command_mask[update_flag][j])j=com_bytes_rx+1;
}
}        

int check_recieved_message(){
char i=0,j=0,k=0,l=0, tmp_i=0;

int check_sum=0; 
checking_result=0;
answering=1; 
while ((rx_buffer0[j])==0xff)
{
if(8<j)
{checking_result=0x90;

return checking_result;
}
j++;        
}
preambula_bytes_rec=j;
i=j;
if ((rx_buffer0[j])!=0x02)

{
checking_result=0x02;

}

check_sum=check_sum^rx_buffer0[i];

i++;         
if (((rx_buffer0[i])&0x30)!=0x00)
{checking_result=0x90;

}

if((rx_buffer0[i]&0x0f)==Parameter_bank[25])answering=1;       
else answering=0;
check_sum=check_sum^rx_buffer0[i];  
i++;
command_rx_val=rx_buffer0[i];
if(command_rx_val==35)
{            

for(l=0;l<4;l++)
{
Parameter_bank[88+l]=rx_buffer0[i+3+l];
Parameter_bank[92+l]=rx_buffer0[i+7+l];
}
}        

if(command_rx_val==38)ResetDeviceSettings(0);
if(command_rx_val==42)
{
if((rx_buffer0[i+2]==0x45)&(rx_buffer0[i+3]==0x52)&(rx_buffer0[i+4]==0x41)&(rx_buffer0[i+5]==0x53)&(rx_buffer0[i+6]==0x45)) 
PerformDeviceApplicationErase();                                                                                                                                     
}
if(command_rx_val==43){
#asm ("cli")            
ADC_PV_calibration_point1[rangeIndex]=adc_data;
calibration_point1=adc_data;
CalibrationConfigChanged=1;
#asm ("sei")
CalculateCalibrationRates();
}
if(command_rx_val==45)for(l=0;l<4;l++)Parameter_bank[105+l]=rx_buffer0[i+2+l];    
if(command_rx_val==46)for(l=0;l<4;l++)Parameter_bank[109+l]=rx_buffer0[i+2+l];

if(command_rx_val==111){
#asm ("cli")
ADC_PV_calibration_point2[rangeIndex]=adc_data;
calibration_point2=adc_data;
CalibrationConfigChanged=1;
#asm ("sei")
CalculateCalibrationRates();
}
check_sum=check_sum^rx_buffer0[i];
i++; 
com_bytes_rx=rx_buffer0[i];                    
check_sum=check_sum^rx_buffer0[i];
i++;
tmp_i=i;
j=tmp_i;
for (i=tmp_i;i<tmp_i+com_bytes_rx;i++)
{
j++;
com_data_rx[k]=rx_buffer0[i];
check_sum=check_sum^rx_buffer0[i];
k++;
}

if (j!=i)
{checking_result=0x90;

}

if(rx_buffer0[i]!=check_sum)
{
checking_result=0x88;

}                
return checking_result;
}

void clear_buffer()
{
char i=0;
for (i=0;i<64;i++)
{
rx_buffer0[i]=0;
tx_buffer0[i]=0;
}
for (i=0;i<25;i++)
{
com_data_rx[i]=0;
Command_data[i]=0;
}
}        

void system_init_(char initVar){
#asm("wdr")
(*(unsigned char *) 0x60)=0x38;
(*(unsigned char *) 0x60)=0x0E;

PORTB=0x00;
DDRB=0x2c;

PORTC=0x00;
DDRC=0x00;

DDRD.3=1;
PORTD.3=1;
DDRD.6=1;
DDRD.7=1;
PORTD.6=0;
PORTD.7=0;

{(*(unsigned char *) 0x6e)=0x00;TCCR0A=0x00;TCCR0B=0x00;TCNT0=0x00;};

(*(unsigned char *) 0xc0)=0x00;
(*(unsigned char *) 0xc1)=0xc0;
(*(unsigned char *) 0xc2)=0x06;
(*(unsigned char *) 0xc5)=0x00;
(*(unsigned char *) 0xc4)=0x17;

(*(unsigned char *) 0x80)=0x00;
(*(unsigned char *) 0x81)=0x00;
(*(unsigned char *) 0x85)=0x00;
(*(unsigned char *) 0x84)=0x00;
(*(unsigned char *) 0x87)=0x00;
(*(unsigned char *) 0x86)=0x00;
(*(unsigned char *) 0x89)=0x00;
(*(unsigned char *) 0x88)=0x00;
(*(unsigned char *) 0x8b)=0x00;
(*(unsigned char *) 0x8a)=0x00;

(*(unsigned char *) 0xb6)=0x00;
(*(unsigned char *) 0xb0)=0x00;
(*(unsigned char *) 0xb1)=0x00;
(*(unsigned char *) 0xb2)=0x00;
(*(unsigned char *) 0xb3)=0x00;
(*(unsigned char *) 0xb4)=0x00;

(*(unsigned char *) 0x69)=0x03;
EIMSK=0x01;
EIFR=0x01;
(*(unsigned char *) 0x68)=0x00;

(*(unsigned char *) 0x6e)=0x00;

(*(unsigned char *) 0x6f)=0x00;

(*(unsigned char *) 0x70)=0x00;

ACSR=0x80;
(*(unsigned char *) 0x7b)=0x00;

if(initVar==1)
{
(*(unsigned char *) 0x7e)=0x3f;
(*(unsigned char *) 0x7c)=0x20;
(*(unsigned char *) 0x7a)=0xcf;
(*(unsigned char *) 0x7b)=(*(unsigned char *) 0x7b)||0x00;
}
else
{
(*(unsigned char *) 0x7e)=0x3f;
(*(unsigned char *) 0x7c)=0x00;
(*(unsigned char *) 0x7a)=0x0f;
(*(unsigned char *) 0x7b)=(*(unsigned char *) 0x7b)||0x00;

}

SPCR=0x53;
SPSR=0x00;

}

void system_init(){
#asm("wdr")
(*(unsigned char *) 0x60)=0x38;
(*(unsigned char *) 0x60)=0x0E;

PORTB=0x00;
DDRB=0x2c;

PORTC=0x00;
DDRC=0x00;

DDRD.3=1;
PORTD.3=1;
DDRD.6=1;
DDRD.7=1;
PORTD.6=0;
PORTD.7=0;

{(*(unsigned char *) 0x6e)=0x00;TCCR0A=0x00;TCCR0B=0x00;TCNT0=0x00;};

(*(unsigned char *) 0xc0)=0x00;
(*(unsigned char *) 0xc1)=0xc0;
(*(unsigned char *) 0xc2)=0x06;
(*(unsigned char *) 0xc5)=0x00;
(*(unsigned char *) 0xc4)=0x17;

(*(unsigned char *) 0x80)=0x00;
(*(unsigned char *) 0x81)=0x00;
(*(unsigned char *) 0x85)=0x00;
(*(unsigned char *) 0x84)=0x00;
(*(unsigned char *) 0x87)=0x00;
(*(unsigned char *) 0x86)=0x00;
(*(unsigned char *) 0x89)=0x00;
(*(unsigned char *) 0x88)=0x00;
(*(unsigned char *) 0x8b)=0x00;
(*(unsigned char *) 0x8a)=0x00;

(*(unsigned char *) 0xb6)=0x00;
(*(unsigned char *) 0xb0)=0x00;
(*(unsigned char *) 0xb1)=0x00;
(*(unsigned char *) 0xb2)=0x00;
(*(unsigned char *) 0xb3)=0x00;
(*(unsigned char *) 0xb4)=0x00;

(*(unsigned char *) 0x69)=0x03;
EIMSK=0x01;
EIFR=0x01;
(*(unsigned char *) 0x68)=0x00;

(*(unsigned char *) 0x6e)=0x00;

(*(unsigned char *) 0x6f)=0x00;

(*(unsigned char *) 0x70)=0x00;

ACSR=0x80;
(*(unsigned char *) 0x7b)=0x00;

(*(unsigned char *) 0x7e)=0x3f;
(*(unsigned char *) 0x7c)=0x20;
(*(unsigned char *) 0x7a)=0xcf;
(*(unsigned char *) 0x7b)=(*(unsigned char *) 0x7b)||0x00;

SPCR=0x53;
SPSR=0x00;

}

void update_dynamic_vars()
{
float DAC_zero_current, DAC_measured_current, Lower_Range_value, Upper_Range_value,tmp;
char i,j=0;
long tmp_adc=0;

union DAC_char_to_float 
{
float value_float;
char value_char[4];
}DAC_val;

for (i=0;i<4;i++)
{
DAC_val.value_char[i]=Parameter_bank[88+i];
if(i==3)
{
Upper_Range_value=DAC_val.value_float;
}
} 
for (i=0;i<4;i++)
{
DAC_val.value_char[i]=Parameter_bank[92+i];
if(i==3)
{
Lower_Range_value=DAC_val.value_float;
}
} 

for (i=0;i<4;i++)
{
DAC_val.value_char[i]=Parameter_bank[105+i];
if(i==3)
{
DAC_zero_current=DAC_val.value_float;
}
} 
for (i=0;i<4;i++)
{
DAC_val.value_char[i]=Parameter_bank[109+i];
if(i==3)
{
DAC_measured_current=DAC_val.value_float;
}
}                      

if(adc_data<=0)tmp_adc=0;

else 
{

tmp_adc=(long)((float)((float)(adc_data)/calibrationK) - (float)calibrationB);

if(tmp_adc>0xffc0)tmp_adc=0xffc0;
if(tmp_adc<0x0000)tmp_adc=0x0000;
} 

DAC_data=((long)(tmp_adc*((DAC_measured_current-DAC_zero_current)/16))+(signed int)((DAC_zero_current)/0.00024437928));
if(DAC_data<=DAC_zero_current)DAC_data=DAC_zero_current;
dynamic_variables[1]=(float)DAC_data*0.00024437928;
dynamic_variables[2]=(float)(100*(dynamic_variables[1]-DAC_zero_current)/(DAC_measured_current-DAC_zero_current));
tmp = Upper_Range_value-Lower_Range_value;
if(tmp==10)
{
Parameter_bank[12]= 10;
{PORTD.7=0;PORTD.6=0;};       
rangeIndex = 0;
}
if(tmp==20)
{
Parameter_bank[12]= 20;
{PORTD.7=0;PORTD.6=1;};      
rangeIndex = 1;
}
if(tmp==30)
{
Parameter_bank[12]=30;
{PORTD.7=1;PORTD.6=0;};  
rangeIndex = 2;
}
if(tmp==50)
{
Parameter_bank[12]= 50;
{PORTD.7=1;PORTD.6=1;}; 
rangeIndex = 3;
}
if(rangeIndexEep!=rangeIndex)
{

calibrationB=calibrationBeep[rangeIndex];
calibrationK=calibrationKeep[rangeIndex];
rangeIndexEep=rangeIndex;

}   
dynamic_variables[0]=(float)dynamic_variables[2]*(float)((tmp)/100);
}

void CalculateCalibrationRates()
{

unsigned int calibration_div = 0xf2f7;
unsigned int calibrationBasic5val = 0x0cc9;

tmp_calibration =calibration_point2 - calibration_point1;
calibrationK = (float)(tmp_calibration/62199.00);
calibrationKeep[rangeIndex] =  calibrationK;

calibrationB = (float)((float)calibration_point1-(float)(calibrationK*calibrationBasic5val)) ;
calibrationBeep[rangeIndex] = calibrationB;

}

void ResetDeviceSettings(char notreset)
{
int i=0;
for(i =0; i<139;i++)
{
if (i==98)i=100;
else Parameter_bank[i]=Parameter_defaults[i];
}                                                                                   
for (i=0; i<4; i++)
{
calibrationBeep[i]=0;
calibrationKeep[i]=1;
ADC_PV_calibration_point1[i] = 0x0cc9;
ADC_PV_calibration_point2[i] = 0xffc0;
}
calibrationB=0;
calibrationK=1;
calibration_point1=0x0cc9;
calibration_point2=0xffc0;
rangeIndexEep=1;
rangeIndex=rangeIndexEep;

}

void PerformDeviceApplicationErase()
{
MCUCR = 0x01;
MCUCR = 0x02;
Parameter_bank[0]=0xee;
Parameter_bank[2]=0xa3;
voidFuncPtr=(void(*)(void))0x1C00;   
voidFuncPtr();
}

void LoadCalibrationSettings(char flag)
{

int i=0;
if(flag==0x01)
{
calibration_point1=ADC_PV_calibration_point1[rangeIndexEep];
calibration_point2=ADC_PV_calibration_point2[rangeIndexEep];
calibrationB=calibrationBeep[rangeIndexEep];
calibrationK=calibrationKeep[rangeIndexEep];
rangeIndex=rangeIndexEep;
}     
else
{
rangeIndexEep = 1;
rangeIndex = 1;    
for (i=0; i<4; i++)
{
calibrationBeep[i]=0;
calibrationKeep[i]=1;
ADC_PV_calibration_point1[i] = 0x0cc9;
ADC_PV_calibration_point2[i] = 0xffc0;
} 
calibrationB=0;
calibrationK=1;
calibration_point1=0x0cc9;
calibration_point2=0xffc0;
}   

}

void main(void)
{

int i,k=0;
int char_val=0x00,data, j = 0;
char dataH,dataL,crcok_flag=0;

crc = 0xffff;
delay_ms(100);
Parameter_bank[0]=0x11;
Parameter_bank[2]=0xB3;

#asm("wdr")
while ((data<=65534)|(j<=16382))
{

if(j==0xDEF)j++;
data= read_program_memory (j);
dataH = (int)data>>8;
dataL = data;
CRC_update(dataH);
CRC_update(dataL);

j=j+2;
}
crceep = crc;

system_init();
#asm
    in   r30,spsr
    in   r30,spdr
#endasm

#asm("sei")

{PORTD.7=0;PORTD.6=1;};
if(crceep==crcstatic)
{

LoadCalibrationSettings(CalibrationConfigChanged);
CalculateCalibrationRates();
transmit_SPI(DAC_data,2);
update_dynamic_vars();

(*(unsigned char *) 0xc1)=((*(unsigned char *) 0xc1)&0xc0)|0x10;

PORTD.3=1;

while (1)
{
#asm("wdr")

if(message_recieved)
{
transmit_HART();
}

(*(unsigned char *) 0x7a)=0xcf;
update_dynamic_vars();
PORTB.2=1;
transmit_SPI(DAC_data,2);
PORTB.2=0;

}
}
else 
{
(*(unsigned char *) 0xc1)=((*(unsigned char *) 0xc1)&0xc0)|0x10;

PORTD.3=1;

while (1)
{

#asm("wdr")
if(message_recieved)
{
transmit_HART();
}
(*(unsigned char *) 0x7a)=0x0f;
adc_data=0;
update_dynamic_vars();
PORTB.2=1;
transmit_SPI(DAC_data,2);
PORTB.2=0;

}
}     
#asm
.CSEG
varlist: .DW 0x4fd1
.org 0x0e6f                  //адрес, по которому будет распологаться наш CRC - 0x1BCC, длина - 2 байта , эти 2 байта для проверки со стороны МК мы исключаем, просто перескочив их
#endasm
}
