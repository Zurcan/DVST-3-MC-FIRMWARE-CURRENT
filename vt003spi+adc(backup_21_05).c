/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 29.07.2010
Author  : 
Company : 
Comments: 


Chip type           : ATmega168P
Program type        : Application
Clock frequency     : 1 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 256
*****************************************************/

#include <mega168p.h>

#include <delay.h>

#include <stdio.h>

char rxEnable=0, txEnable=1;

//#define ADC_VREF_TYPE 0x00

#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7
//#define disable_uart UCSR0B=0xc0
//#define enable_uart UCSR0B=0xd8
//#define disable_uart UCSR0B=0x00
//#define enable_uart UCSR0B=0x18
//#define enable_transmit UCSR0B=0x08
//#define enable_recieve UCSR0B=0x10
#define alarm3_75mA 0x3c00
#define alarm22mA 0x6000
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define RxEn UCSR0B=(UCSR0B&0xc0)|0x10
#define TxEn UCSR0B=(UCSR0B&0xc0)|0x08
#define Transmit PORTD=PORTD&0xf7
#define Recieve PORTD=PORTD|0x08
#define wait_startOCD EICRA=0x03
#define wait_stopOCD EICRA=0x00
#define disable_uart UCSR0B=0xc0
#define disable_eints {EIMSK=0x00;EIFR=0x00;}
#define enable_eints {EIMSK=0x01;EIFR=0x01;}
#define enable_led PORTD=PORTD|0x40
#define disable_led PORTD=PORTD&0xbf
#define start_wait_Rx_timer {TIMSK0=0x01;TCCR0A=0x00;TCCR0B=0x04;TCNT0=0xA0;}
#define stop_wait_Rx_timer {TIMSK0=0x00;TCCR0A=0x00;TCCR0B=0x00;TCNT0=0x00;}
#define disable_SPI {SPCR=0x12;}
#define enable_SPI {SPCR=0x52;}
// USART Receiver buffer
#define RX_BUFFER_SIZE0 16
char rx_buffer0[RX_BUFFER_SIZE0];
char checking_val[RX_BUFFER_SIZE0];
char dataToSave;
void transmit_HART(void); int check_recieved_message(); 
void start_transmit(int transmit_param);
#if RX_BUFFER_SIZE0<256
unsigned char rx_wr_index0,rx_rd_index0,rx_counter0,echo;
#else
unsigned int rx_wr_index0,rx_rd_index0,rx_counter0,SPI_data;
#endif
// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow0,printflag=0,RxTx=0,new_data=0,message_recieved=0;
unsigned int SPI_tData, adc_data,pseudo_adc=0;
char SPI_tEnd=1,checking_result=0;
// USART Receiver interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
enable_eints;
wait_stopOCD;

}

// Declare your global variables here
interrupt [USART_RXC] void usart_rx_isr(void)
{

char status,data;
#asm("cli")
status=UCSR0A;

data=UDR0;
//#asm("sei")
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   //#asm("cli")
   rx_buffer0[rx_wr_index0]=data;
  // #asm("sei")
   if (++rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
   if (++rx_counter0 == RX_BUFFER_SIZE0)
      {
      rx_counter0=0;
      rx_buffer_overflow0=1;
    
     };
//   if(rx_counter0==8)
//   {message_recieved=1;
//   }
   };
 #asm("sei")   
}
  
#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0];
if (++rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE0 16
char tx_buffer0[TX_BUFFER_SIZE0];

#if TX_BUFFER_SIZE0<256
unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
#else
unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
#asm("cli")
if (tx_counter0)
   {
   --tx_counter0;
   
   UDR0=tx_buffer0[tx_rd_index0];

   if (++tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
   };
   #asm("sei")   
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
//while (tx_counter0 == TX_BUFFER_SIZE0);
//#asm("cli")
//if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
//   {
//   tx_buffer0[tx_wr_index0]=c;
//   if (++tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
//   ++tx_counter0;
//   }
//else
while ((UCSR0A & DATA_REGISTER_EMPTY)==0)
   UDR0=c;
//#asm("sei")
}


// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)//первоначально прерывание работает по нарастающему уровню (set_rising_edge_int), а затем ловим низкий (set_falling_edge_int), это устанавливаем уже в таймере, с последующим запуском нашего любимого таймера.1-прием, 0- передача.
{
//RxTx=!RxTx;//RxTx=0 =>no recieve ||RxTx=1 => recieve||
//if(RxTx)Recieve;
if(EICRA==0x03)
                {
                Recieve;
                RxEn;
                //wait_stopOCD;
                //start_wait_Rx_timer;
                //disable_eints;
                wait_stopOCD;
                //message_recieved=0;
                //mono_channel_mode;
                }
else 
                {
                //Transmit;
                
                stop_wait_Rx_timer;
                wait_startOCD;
                disable_uart;
                message_recieved=1;
                
                }
//start_check_OCD_timer;//стартуем таймер отсчитывающий задержку 3.33 мс (4 цикла при минимальной частоте 1200√ц)

}


#pragma used-
#endif
// ADC interrupt service routine
interrupt [ADC_INT] void adc_isr(void)
{
#asm("cli")
adc_data=ADCW;
printflag=1;
ADMUX=0x20;
ADCSRA=0xcb;
#asm("sei")
}

void transmit_HART(void){
if (check_recieved_message()==8){
//delay_ms(15);
checking_result=0;
rx_wr_index0=0;
//message_recieved=0;
rx_buffer_overflow0=0;
start_transmit(0);
}
else{
//PORTD=0x08;
rx_buffer_overflow0=0;
checking_result=0;
rx_wr_index0=0;
//message_recieved=0;
start_transmit(1);
}
}

// SPI interrupt service routine
interrupt [SPI_STC] void spi_isr(void)
{

//#asm
  //  in   r30,spsr
  //  in   r30,spdr
//#endasm
//data=SPDR;
//SPCR=0xD0;
//SPSR=0x00;
// Place your code here
if(SPI_tEnd==0){
SPDR=0xff;
SPI_tEnd=1;
}
else PORTB.2=0;
ADCSRA=0xcb;

}

void transmit_SPI(unsigned int SPI_data,char SPI_mode){//4 режима работы: 2-норма, 0-авари€ 3.75мј, 1-авари€ 22мј, 3-моноканал
//#asm ("cli")                                          //прерывани€ мы здесь не используем, потому как с ними получаетс€ какой-то гемор
delay_us(10);
PORTB.2=0;
if(SPI_mode<2)
{
SPDR=SPI_mode;
if(SPI_mode==0)SPI_data=alarm3_75mA;
else SPI_data=alarm22mA;
while(SPSR<0x80){;}
}
if(SPI_mode==3){
SPI_data=0;}
SPDR=SPI_data>>8;
PORTB.2=0;
while(SPSR<0x80){;}
SPDR=SPI_data;
while(SPSR<0x80){;}
//#asm ("sei")
}

void start_transmit(int transmit_param)
{
while(UCSR0A<0x20){;}
//if(!RxTx){

delay_ms(25);
Transmit;
TxEn;
delay_ms(15);
if(!transmit_param){
for (tx_rd_index0=0;tx_rd_index0<3;tx_rd_index0++)tx_buffer0[tx_rd_index0]=0xff;
for (tx_rd_index0=3;tx_rd_index0<8;tx_rd_index0++)tx_buffer0[tx_rd_index0]=tx_rd_index0;}
else {for (tx_rd_index0=0;tx_rd_index0<8;tx_rd_index0++)tx_buffer0[tx_rd_index0]=rx_buffer0[tx_rd_index0];}
tx_rd_index0=1;
tx_counter0=7;
UDR0=tx_buffer0[0];
while(tx_counter0){;}
delay_ms(15);
Recieve;
//disable_uart;
message_recieved=0;
//delay_ms(120);
//delay_ms(120);
//}
}
int check_recieved_message(){
int i;

for (i=0;i<8;i++)
{
checking_val[i]=0x30+i;
if(rx_buffer0[i]==checking_val[i])checking_result++;
//rx_buffer0[i]=0;
}
return checking_result;
}


// Declare your global variables here
void system_init(){
// Crystal Oscillator division factor: 1 
/*#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif
  */
// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=Out Func4=In Func3=Out Func2=Out Func1=In Func0=In 
// State7=T State6=T State5=0 State4=T State3=0 State2=0 State1=T State0=T 
PORTB=0x00;
DDRB=0x2c;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x48;
PORTD.3=1;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
//TCCR0A=0x00;
//TCCR0B=0x04;
//TCNT0=0xA5;
//OCR0A=0x00;
//OCR0B=0x00;
stop_wait_Rx_timer;
/*USART predefinition: 1200 baud rate, tx enable, all interrutpts enabled 8bit buffer*/
UCSR0A=0x00;
UCSR0B=0xc0;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x33;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer 1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2A output: Disconnected
// OC2B output: Disconnected
ASSR=0x00;
TCCR2A=0x00;
TCCR2B=0x00;
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Any change
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: Off
wait_startOCD;
EIMSK=0x01;
EIFR=0x01;
PCICR=0x00;


// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x00;
// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=0x00;
// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
ADCSRB=0x00;

// ADC initialization
// ADC Clock frequency: 230,400 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: Free Running
// Digital input buffers on ADC0: On, ADC1: Off, ADC2: Off, ADC3: Off
// ADC4: Off, ADC5: Off
DIDR0=0x3f;
ADMUX=0x20;
ADCSRA=0xcb;
ADCSRB=ADCSRB||0x00;

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 2*115,200 kHz
// SPI Clock Phase: Cycle Half
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=0x52;
SPSR=0x00;
//SPDR=0x00;
//enable_SPI;
}



void main(void)
{
// Declare your local variables here
int i,k=0;
int char_val=0x00;
system_init();
#asm
    in   r30,spsr
    in   r30,spdr
#endasm
//normal_mode;
#asm("sei")
//enable_uart;
RxEn;
//PORTD=0x08;
Recieve;
//disable_eints;
while (1)
      {

        //delay_ms(20);
        //enable_SPI;


//        }
if(message_recieved)
        {
         transmit_HART();
        }
else
        {
        PORTB.2=1;
        transmit_SPI(adc_data,2);
        PORTB.2=0;
        }        
}
}
