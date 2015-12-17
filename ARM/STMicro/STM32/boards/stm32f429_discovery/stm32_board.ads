------------------------------------------------------------------------------
--                                                                          --
--                    Copyright (C) 2015, AdaCore                           --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of STMicroelectronics nor the names of its       --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
--                                                                          --
--  This file is based on:                                                  --
--                                                                          --
--   @file    stm32f429i_discovery.h                                        --
--   @author  MCD Application Team                                          --
--   @version V1.1.0                                                        --
--   @date    19-June-2014                                                  --
--   @brief   This file contains definitions for STM32F429I-Discovery Kit   --
--            LEDs, push-buttons hardware resources.                        --
--                                                                          --
--   COPYRIGHT(c) 2014 STMicroelectronics                                   --
------------------------------------------------------------------------------

--  This file provides declarations for devices on the STM32F429 Discovery kits
--  manufactured by ST Microelectronics.

with STM32.Device;

with STM32.GPIO;    use STM32.GPIO;
with STM32.ADC;     use STM32.ADC;
with STM32.DMA;     use STM32.DMA;
with STM32.USARTs;  use STM32.USARTs;
with STM32.I2C;     use STM32.I2C;
with STM32.SPI;     use STM32.SPI;
with STM32.Timers;  use STM32.Timers;
with STM32.L3DG20;  use STM32.L3DG20;
with STM32.DAC;     use STM32.DAC;

with Ada.Interrupts.Names;  use Ada.Interrupts;

use STM32;  -- for base addresses

package STM32_Board is
   pragma Elaborate_Body;

   subtype User_LED is GPIO_Pin;

   Green : User_LED renames Pin_13;
   Red   : User_LED renames Pin_14;

   LED3  : User_LED renames Green;
   LED4  : User_LED renames Red;

   All_LEDs  : constant GPIO_Pins := LED3 & LED4;

   procedure Initialize_LEDs;
   --  MUST be called prior to any use of the LEDs

   procedure Turn_On (This : User_LED) with Inline;
   procedure Turn_Off (This : User_LED) with Inline;
   procedure Toggle (This : User_LED) with Inline;

   procedure Toggle_LEDs (These : GPIO_Pins) with Inline;
   procedure All_LEDs_Off with Inline;
   procedure All_LEDs_On  with Inline;

   LED_Port : GPIO_Port renames STM32.Device.GPIO_G;
   --  Available for clients requiring a reference. Note that Initialize_LEDs
   --  will configure the GPIO port/pins for LED usage, specifically.

   Gyro : Three_Axis_Gyroscope;

   GPIO_A : GPIO_Port renames STM32.Device.GPIO_A;
   GPIO_B : GPIO_Port renames STM32.Device.GPIO_B;
   GPIO_C : GPIO_Port renames STM32.Device.GPIO_C;
   GPIO_D : GPIO_Port renames STM32.Device.GPIO_D;
   GPIO_E : GPIO_Port renames STM32.Device.GPIO_E;
   GPIO_F : GPIO_Port renames STM32.Device.GPIO_F;
   GPIO_G : GPIO_Port renames STM32.Device.GPIO_G;
   GPIO_H : GPIO_Port renames STM32.Device.GPIO_H;
   GPIO_I : GPIO_Port renames STM32.Device.GPIO_I;
   GPIO_J : GPIO_Port renames STM32.Device.GPIO_J;
   GPIO_K : GPIO_Port renames STM32.Device.GPIO_K;

   procedure Enable_Clock (This : aliased in out GPIO_Port)
      renames STM32.Device.Enable_Clock;

   procedure Reset (This : aliased in out GPIO_Port)
     renames STM32.Device.Reset;

   User_Button_Port      : GPIO_Port renames GPIO_A;
   User_Button_Pin       : constant GPIO_Pin := Pin_0;
   User_Button_Interrupt : constant Interrupt_Id := Names.EXTI0_Interrupt;

   procedure Configure_User_Button_GPIO;
   --  Configures the GPIO port/pin for the user button. Sufficient for polling
   --  the button, and necessary for having the button generate interrupts.

   ADC_1 : Analog_To_Digital_Converter renames STM32.Device.ADC_1;
   ADC_2 : Analog_To_Digital_Converter renames STM32.Device.ADC_2;
   ADC_3 : Analog_To_Digital_Converter renames STM32.Device.ADC_3;

   VBat               : ADC_Point renames STM32.Device.VBat;
   Temperature_Sensor : ADC_Point renames STM32.Device.Temperature_Sensor;

   VBat_Bridge_Divisor : constant := STM32.Device.VBat_Bridge_Divisor;

   procedure Enable_Clock (This : aliased in out Analog_To_Digital_Converter)
      renames STM32.Device.Enable_Clock;

   procedure Reset_All_ADC_Units
     renames STM32.Device.Reset_All_ADC_Units;

   DAC_1 : Digital_To_Analog_Converter renames STM32.Device.DAC_1;

   DAC_Channel_1_IO : GPIO_Point renames STM32.Device.DAC_Channel_1_IO;
   DAC_Channel_2_IO : GPIO_Point renames STM32.Device.DAC_Channel_2_IO;

   procedure Enable_Clock (This : aliased in out Digital_To_Analog_Converter)
     renames STM32.Device.Enable_Clock;

   procedure Reset (This : aliased in out Digital_To_Analog_Converter)
     renames STM32.Device.Reset;

   --  Note that some of these are really UARTs, not USARTs
   USART_1 : USART renames STM32.Device.USART_1;
   USART_2 : USART renames STM32.Device.USART_2;
   USART_3 : USART renames STM32.Device.USART_3;
   UART_4  : USART renames STM32.Device.UART_4;
   UART_5  : USART renames STM32.Device.UART_5;
   USART_6 : USART renames STM32.Device.USART_6;
   UART_7  : USART renames STM32.Device.UART_7;
   UART_8  : USART renames STM32.Device.UART_8;

   procedure Enable_Clock (This : aliased in out USART)
      renames STM32.Device.Enable_Clock;

   procedure Reset (This : aliased in out USART)
     renames STM32.Device.Reset;

   DMA_1 : DMA_Controller renames STM32.Device.DMA_1;
   DMA_2 : DMA_Controller renames STM32.Device.DMA_2;

   procedure Enable_Clock (This : aliased in out DMA_Controller)
      renames STM32.Device.Enable_Clock;

   procedure Reset (This : aliased in out DMA_Controller)
     renames STM32.Device.Reset;

   I2C_1 : I2C_Port renames STM32.Device.I2C_1;
   I2C_2 : I2C_Port renames STM32.Device.I2C_2;
   I2C_3 : I2C_Port renames STM32.Device.I2C_3;

   procedure Enable_Clock (This : aliased in out I2C_Port)
      renames STM32.Device.Enable_Clock;

   procedure Reset (This : in out I2C_Port)
      renames STM32.Device.Reset;

   SPI_1 : SPI_Port renames STM32.Device.SPI_1;
   SPI_2 : SPI_Port renames STM32.Device.SPI_2;
   SPI_3 : SPI_Port renames STM32.Device.SPI_3;
   SPI_4 : SPI_Port renames STM32.Device.SPI_4;
   SPI_5 : SPI_Port renames STM32.Device.SPI_5;
   SPI_6 : SPI_Port renames STM32.Device.SPI_6;

   procedure Enable_Clock (This : aliased in out SPI_Port)
      renames STM32.Device.Enable_Clock;

   procedure Reset (This : in out SPI_Port)
      renames STM32.Device.Reset;

   Timer_1  : Timer renames STM32.Device.Timer_1;
   Timer_2  : Timer renames STM32.Device.Timer_2;
   Timer_3  : Timer renames STM32.Device.Timer_3;
   Timer_4  : Timer renames STM32.Device.Timer_4;
   Timer_5  : Timer renames STM32.Device.Timer_5;
   Timer_6  : Timer renames STM32.Device.Timer_6;
   Timer_7  : Timer renames STM32.Device.Timer_7;
   Timer_8  : Timer renames STM32.Device.Timer_8;
   Timer_9  : Timer renames STM32.Device.Timer_9;
   Timer_10 : Timer renames STM32.Device.Timer_10;
   Timer_11 : Timer renames STM32.Device.Timer_11;
   Timer_12 : Timer renames STM32.Device.Timer_12;
   Timer_13 : Timer renames STM32.Device.Timer_13;
   Timer_14 : Timer renames STM32.Device.Timer_14;

   procedure Enable_Clock (This : in out Timer)
      renames STM32.Device.Enable_Clock;

   procedure Reset (This : in out Timer)
      renames STM32.Device.Reset;

end STM32_Board;
