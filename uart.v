
module uart (
    input wire cpu_clk,
    input rst,
    
    input wire rx,
    input wire r_enable,
    output wire r_ready,
    output reg r_overflow,
    output [7:0] r_data_out,
    
    output wire tx,
    output wire w_ready,
    input wire w_enable,
    input [7:0] w_data_in
);

  reg [7:0] r_fifo[127:0];   // read fifo
  reg [7:0] w_fifo[127:0];   // write fifo
  reg [6:0] r_r_ptr, r_w_ptr, w_r_ptr, w_w_ptr;
  assign r_ready = (r_r_ptr != r_w_ptr);
  wire w_empty, w_full;
  assign w_full = (w_w_ptr + 1) == w_r_ptr;
  assign w_ready = !w_full;
  assign w_empty = (w_r_ptr == w_w_ptr);
  assign r_data_out = r_fifo[r_r_ptr];
  wire [7:0] uart_out;
  wire rx_done, tx_done, tx_busy;
  wire tx_enable = !w_empty;
  UART_RX rx0 (
   .i_Rst(rst),
   .i_Clock(cpu_clk),
   .i_RX_Serial(rx),
   .o_RX_DV(rx_done),
   .o_RX_Byte(uart_out)
  );
  UART_TX tx0 (
  .i_Rst(rst),
  .i_Clock(cpu_clk),
  .i_TX_DV(tx_enable),
  .i_TX_Byte(w_fifo[w_r_ptr]), 
  .o_TX_Active(tx_busy),
  .o_TX_Serial(tx),
  .o_TX_Done(tx_done)
  );
  always @(posedge cpu_clk) begin
    if (rst == 1) begin
      r_r_ptr <= 0;
      w_w_ptr <= 0;
    end else begin
      if (r_enable && r_ready) begin
        r_r_ptr <= r_r_ptr + 1;
      end
      if (w_enable && !w_full) begin
        w_fifo[w_w_ptr] <= w_data_in;
        w_w_ptr <= w_w_ptr + 1;
      end
    end
  end
  always @(posedge cpu_clk) begin
    if (rst == 1) begin
      r_w_ptr <= 0;
      r_overflow <= 0;
      w_r_ptr <= 0;
    end else begin
      if (rx_done) begin
        r_fifo[r_w_ptr] <= uart_out[7:0];
        r_overflow <= r_overflow |  (r_r_ptr == (r_w_ptr + 1));
        r_w_ptr <= r_w_ptr + 1;
      end
      if (tx_done) begin
        w_r_ptr <= w_r_ptr + 1;
      end
    end
  end
    
endmodule

//////////////////////////////////////////////////////////////////////
// Author:      Russell Merrick
//////////////////////////////////////////////////////////////////////
// Description: This file contains the UART Receiver.  This receiver is 
//              able to receive 8 bits of serial data, one start bit, one 
//              stop bit, and no parity bit.  When receive is complete 
//              o_RX_DV will be driven high for one clock cycle.
// 
// Parameters:  Set Parameter CLKS_PER_BIT as follows:
//              CLKS_PER_BIT = (Frequency of i_Clock)/(Frequency of UART)
//              Example: 25 MHz Clock, 115200 baud UART
//              (25000000)/(115200) = 217
//////////////////////////////////////////////////////////////////////////////

module UART_RX
  #(parameter CLKS_PER_BIT = 87)
  (
   input            i_Rst,
   input            i_Clock,
   input            i_RX_Serial,
   output reg       o_RX_DV,
   output reg [7:0] o_RX_Byte
   );
   
  localparam IDLE         = 3'b000;
  localparam RX_START_BIT = 3'b001;
  localparam RX_DATA_BITS = 3'b010;
  localparam RX_STOP_BIT  = 3'b011;
  localparam CLEANUP      = 3'b100;
  
  reg [$clog2(CLKS_PER_BIT)-1:0] r_Clock_Count;
  reg [2:0] r_Bit_Index; //8 bits total
  reg [2:0] r_SM_Main;
  
  
  // Purpose: Control RX state machine
  always @(posedge i_Clock)
  begin
    if (i_Rst)
    begin
      r_SM_Main <= 3'b000;
      o_RX_DV   <= 1'b0;
    end
    else
    begin
      case (r_SM_Main)
      IDLE :
        begin
          o_RX_DV       <= 1'b0;
          r_Clock_Count <= 0;
          r_Bit_Index   <= 0;
          
          if (i_RX_Serial == 1'b0)          // Start bit detected
            r_SM_Main <= RX_START_BIT;
          else
            r_SM_Main <= IDLE;
        end
      
      // Check middle of start bit to make sure it's still low
      RX_START_BIT :
        begin
          if (r_Clock_Count == (CLKS_PER_BIT-1)/2)
          begin
            if (i_RX_Serial == 1'b0)
            begin
              r_Clock_Count <= 0;  // reset counter, found the middle
              r_SM_Main     <= RX_DATA_BITS;
            end
            else
              r_SM_Main <= IDLE;
          end
          else
          begin
            r_Clock_Count <= r_Clock_Count + 1;
            r_SM_Main     <= RX_START_BIT;
          end
        end // case: RX_START_BIT
      
      
      // Wait CLKS_PER_BIT-1 clock cycles to sample serial data
      RX_DATA_BITS :
        begin
          if (r_Clock_Count < CLKS_PER_BIT-1)
          begin
            r_Clock_Count <= r_Clock_Count + 1;
            r_SM_Main     <= RX_DATA_BITS;
          end
          else
          begin
            r_Clock_Count          <= 0;
            o_RX_Byte[r_Bit_Index] <= i_RX_Serial;
            
            // Check if we have received all bits
            if (r_Bit_Index < 7)
            begin
              r_Bit_Index <= r_Bit_Index + 1;
              r_SM_Main   <= RX_DATA_BITS;
            end
            else
            begin
              r_Bit_Index <= 0;
              r_SM_Main   <= RX_STOP_BIT;
            end
          end
        end // case: RX_DATA_BITS
      
      
      // Receive Stop bit.  Stop bit = 1
      RX_STOP_BIT :
        begin
          // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
          if (r_Clock_Count < CLKS_PER_BIT-1)
          begin
            r_Clock_Count <= r_Clock_Count + 1;
            r_SM_Main     <= RX_STOP_BIT;
          end
          else
          begin
            o_RX_DV       <= 1'b1;
            r_Clock_Count <= 0;
            r_SM_Main     <= CLEANUP;
          end
        end // case: RX_STOP_BIT
      
      
      // Stay here 1 clock
      CLEANUP :
        begin
          r_SM_Main <= IDLE;
          o_RX_DV   <= 1'b0;
        end
      
      
      default :
        r_SM_Main <= IDLE;
      
    endcase
    end // else: !if(~i_Rst_L)
  end // always @ (posedge i_Clock or negedge i_Rst_L)
  
endmodule // UART_RX


//////////////////////////////////////////////////////////////////////
// Author: Russell Merrick
//////////////////////////////////////////////////////////////////////
// This file contains the UART Transmitter.  This transmitter is able
// to transmit 8 bits of serial data, one start bit, one stop bit,
// and no parity bit.  When transmit is complete o_Tx_done will be
// driven high for one clock cycle.
//
// Set Parameter CLKS_PER_BIT as follows:
// CLKS_PER_BIT = (Frequency of i_Clock)/(Frequency of UART)
// Example: 25 MHz Clock, 115200 baud UART
// (25000000)/(115200) = 217
 
module UART_TX 
  #(parameter CLKS_PER_BIT = 87)
  (
   input       i_Rst,
   input       i_Clock,
   input       i_TX_DV,
   input [7:0] i_TX_Byte, 
   output reg  o_TX_Active,
   output reg  o_TX_Serial,
   output reg  o_TX_Done
   );
 
  localparam IDLE         = 3'b000;
  localparam TX_START_BIT = 3'b001;
  localparam TX_DATA_BITS = 3'b010;
  localparam TX_STOP_BIT  = 3'b011;
  localparam CLEANUP      = 3'b100;
  
  reg [2:0] r_SM_Main;
  reg [$clog2(CLKS_PER_BIT):0] r_Clock_Count;
  reg [2:0] r_Bit_Index;
  reg [7:0] r_TX_Data;


  // Purpose: Control TX state machine
  always @(posedge i_Clock)
  begin
    if (i_Rst)
    begin
      r_SM_Main <= 3'b000;
      o_TX_Done <= 1'b0;
    end
    else
    begin
      case (r_SM_Main)
      IDLE :
        begin
          o_TX_Serial   <= 1'b1;         // Drive Line High for Idle
          o_TX_Done     <= 1'b0;
          r_Clock_Count <= 0;
          r_Bit_Index   <= 0;
          
          if (i_TX_DV == 1'b1)
          begin
            o_TX_Active <= 1'b1;
            r_TX_Data   <= i_TX_Byte;
            r_SM_Main   <= TX_START_BIT;
          end
          else
            r_SM_Main <= IDLE;
        end // case: IDLE
      
      
      // Send out Start Bit. Start bit = 0
      TX_START_BIT :
        begin
          o_TX_Serial <= 1'b0;
          
          // Wait CLKS_PER_BIT-1 clock cycles for start bit to finish
          if (r_Clock_Count < CLKS_PER_BIT-1)
          begin
            r_Clock_Count <= r_Clock_Count + 1;
            r_SM_Main     <= TX_START_BIT;
          end
          else
          begin
            r_Clock_Count <= 0;
            r_SM_Main     <= TX_DATA_BITS;
          end
        end // case: TX_START_BIT
      
      
      // Wait CLKS_PER_BIT-1 clock cycles for data bits to finish         
      TX_DATA_BITS :
        begin
          o_TX_Serial <= r_TX_Data[r_Bit_Index];
          
          if (r_Clock_Count < CLKS_PER_BIT-1)
          begin
            r_Clock_Count <= r_Clock_Count + 1;
            r_SM_Main     <= TX_DATA_BITS;
          end
          else
          begin
            r_Clock_Count <= 0;
            
            // Check if we have sent out all bits
            if (r_Bit_Index < 7)
            begin
              r_Bit_Index <= r_Bit_Index + 1;
              r_SM_Main   <= TX_DATA_BITS;
            end
            else
            begin
              r_Bit_Index <= 0;
              r_SM_Main   <= TX_STOP_BIT;
            end
          end 
        end // case: TX_DATA_BITS
      
      
      // Send out Stop bit.  Stop bit = 1
      TX_STOP_BIT :
        begin
          o_TX_Serial <= 1'b1;
          
          // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
          if (r_Clock_Count < CLKS_PER_BIT-1)
          begin
            r_Clock_Count <= r_Clock_Count + 1;
            r_SM_Main     <= TX_STOP_BIT;
          end
          else
          begin
            o_TX_Done     <= 1'b1;
            r_Clock_Count <= 0;
            r_SM_Main     <= CLEANUP;
            o_TX_Active   <= 1'b0;
          end 
        end // case: TX_STOP_BIT
      
      
      // Stay here 1 clock
      CLEANUP :
        begin
          r_SM_Main <= IDLE;
          o_TX_Done     <= 1'b0;
        end
      
      
      default :
        r_SM_Main <= IDLE;
      
    endcase
    end // else: !if(~i_Rst_L)
  end // always @ (posedge i_Clock or negedge i_Rst_L)

  
endmodule
