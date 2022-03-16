module vga_driver (input wire clk,     // 25 MHz
                   input wire rst,     // Active high
                   input [11:0] color_in, // Pixel color data (RRRRGGGGBBB)
                   output [9:0] next_x,  // x-coordinate of NEXT pixel that will be drawn
                   output [9:0] next_y,  // y-coordinate of NEXT pixel that will be drawn
                   output wire hsync,    // HSYNC (to VGA connector)
                   output wire vsync,    // VSYNC (to VGA connctor)
                   output [3:0] red,     // RED (to resistor DAC VGA connector)
                   output [3:0] green,   // GREEN (to resistor DAC to VGA connector)
                   output [3:0] blue    // BLUE (to resistor DAC to VGA connector
                   );        // BLANK to VGA connector
  
  // Horizontal localparams (measured in clk cycles)
  localparam [9:0] H_ACTIVE = 10'd_639 ;
  localparam [9:0] H_FRONT  = 10'd_15 ;
  localparam [9:0] H_PULSE  = 10'd_95 ;
  localparam [9:0] H_BACK   = 10'd_47 ;
  
  // Vertical localparams (measured in lines)
  localparam [9:0] V_ACTIVE = 10'd_479 ;
  localparam [9:0] V_FRONT  = 10'd_9 ;
  localparam [9:0] V_PULSE  = 10'd_1 ;
  localparam [9:0] V_BACK   = 10'd_32 ;
  
  // localparams for readability
  localparam   LOW  = 1'b_0 ;
  localparam   HIGH = 1'b_1 ;
  
  // States (more readable)
  localparam   [7:0]    H_ACTIVE_STATE = 8'd_0 ;
  localparam   [7:0]   H_FRONT_STATE   = 8'd_1 ;
  localparam   [7:0]   H_PULSE_STATE   = 8'd_2 ;
  localparam   [7:0]   H_BACK_STATE    = 8'd_3 ;
  
  localparam   [7:0]    V_ACTIVE_STATE = 8'd_0 ;
  localparam   [7:0]   V_FRONT_STATE   = 8'd_1 ;
  localparam   [7:0]   V_PULSE_STATE   = 8'd_2 ;
  localparam   [7:0]   V_BACK_STATE    = 8'd_3 ;
  
  // clked registers
  reg              hysnc_reg ;
  reg              vsync_reg ;
  reg     [7:0]   red_reg ;
  reg     [7:0]   green_reg ;
  reg     [7:0]   blue_reg ;
  reg              line_done ;
  
  // Control registers
  reg     [9:0]   h_counter ;
  reg     [9:0]   v_counter ;
  
  reg     [7:0]    h_state ;
  reg     [7:0]    v_state ;
  
  // State machine
  always@(posedge clk) begin
    // At rst . . .
    if (rst) begin
      // Zero the counters
      h_counter <= 10'd_0 ;
      v_counter <= 10'd_0 ;
      // States to ACTIVE
      h_state <= H_ACTIVE_STATE  ;
      v_state <= V_ACTIVE_STATE  ;
      // Deassert line done
      line_done <= LOW ;
    end
    else begin
      //////////////////////////////////////////////////////////////////////////
      ///////////////////////// HORIZONTAL /////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////
      if (h_state == H_ACTIVE_STATE) begin
        // Iterate horizontal counter, zero at end of ACTIVE mode
        h_counter <= (h_counter == H_ACTIVE)?10'd_0:(h_counter + 10'd_1) ;
        // Set hsync
        hysnc_reg <= HIGH ;
        // Deassert line done
        line_done <= LOW ;
        // State transition
        h_state <= (h_counter == H_ACTIVE)?H_FRONT_STATE:H_ACTIVE_STATE ;
      end
        if (h_state == H_FRONT_STATE) begin
          // Iterate horizontal counter, zero at end of H_FRONT mode
          h_counter <= (h_counter == H_FRONT)?10'd_0:(h_counter + 10'd_1) ;
          // Set hsync
          hysnc_reg <= HIGH ;
          // State transition
          h_state <= (h_counter == H_FRONT)?H_PULSE_STATE:H_FRONT_STATE ;
        end
          if (h_state == H_PULSE_STATE) begin
            // Iterate horizontal counter, zero at end of H_PULSE mode
            h_counter <= (h_counter == H_PULSE)?10'd_0:(h_counter + 10'd_1) ;
            // Clear hsync
            hysnc_reg <= LOW ;
            // State transition
            h_state <= (h_counter == H_PULSE)?H_BACK_STATE:H_PULSE_STATE ;
          end
            if (h_state == H_BACK_STATE) begin
              // Iterate horizontal counter, zero at end of H_BACK mode
              h_counter <= (h_counter == H_BACK)?10'd_0:(h_counter + 10'd_1) ;
              // Set hsync
              hysnc_reg <= HIGH ;
              // State transition
              h_state <= (h_counter == H_BACK)?H_ACTIVE_STATE:H_BACK_STATE ;
              // Signal line complete at state transition (offset by 1 for synchronous state transition)
              line_done <= (h_counter == (H_BACK-1))?HIGH:LOW ;
            end
      //////////////////////////////////////////////////////////////////////////
      ///////////////////////// VERTICAL ///////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////
      if (v_state == V_ACTIVE_STATE) begin
        // increment vertical counter at end of line, zero on state transition
        v_counter<= (line_done == HIGH)?((v_counter == V_ACTIVE)?10'd_0:(v_counter+10'd_1)):v_counter ;
        // set vsync in active mode
        vsync_reg <= HIGH ;
        // state transition - only on end of lines
        v_state<= (line_done == HIGH)?((v_counter == V_ACTIVE)?V_FRONT_STATE:V_ACTIVE_STATE):V_ACTIVE_STATE ;
      end
        if (v_state == V_FRONT_STATE) begin
          // increment vertical counter at end of line, zero on state transition
          v_counter<= (line_done == HIGH)?((v_counter == V_FRONT)?10'd_0:(v_counter + 10'd_1)):v_counter ;
          // set vsync in front porch
          vsync_reg <= HIGH ;
          // state transition
          v_state<= (line_done == HIGH)?((v_counter == V_FRONT)?V_PULSE_STATE:V_FRONT_STATE):V_FRONT_STATE;
        end
          if (v_state == V_PULSE_STATE) begin
            // increment vertical counter at end of line, zero on state transition
            v_counter<= (line_done == HIGH)?((v_counter == V_PULSE)?10'd_0:(v_counter + 10'd_1)):v_counter ;
            // clear vsync in pulse
            vsync_reg <= LOW ;
            // state transition
            v_state<= (line_done == HIGH)?((v_counter == V_PULSE)?V_BACK_STATE:V_PULSE_STATE):V_PULSE_STATE;
          end
            if (v_state == V_BACK_STATE) begin
              // increment vertical counter at end of line, zero on state transition
              v_counter<= (line_done == HIGH)?((v_counter == V_BACK)?10'd_0:(v_counter + 10'd_1)):v_counter ;
              // set vsync in back porch
              vsync_reg <= HIGH ;
              // state transition
              v_state<= (line_done == HIGH)?((v_counter == V_BACK)?V_ACTIVE_STATE:V_BACK_STATE):V_BACK_STATE ;
            end
      
      //////////////////////////////////////////////////////////////////////////
      //////////////////////////////// COLOR OUT ///////////////////////////////
      //////////////////////////////////////////////////////////////////////////
      // Assign colors if in active mode
      red_reg<= (h_state == H_ACTIVE_STATE)?((v_state == V_ACTIVE_STATE)?{color_in[11:8],4'd_0}:8'd_0):8'd_0 ;
      green_reg<= (h_state == H_ACTIVE_STATE)?((v_state == V_ACTIVE_STATE)?{color_in[7:4],4'd_0}:8'd_0):8'd_0 ;
      blue_reg<= (h_state == H_ACTIVE_STATE)?((v_state == V_ACTIVE_STATE)?{color_in[3:0],4'd_0}:8'd_0):8'd_0 ;
      
    end
  end
  // Assign output values - to VGA connector
  assign hsync = hysnc_reg ;
  assign vsync = vsync_reg ;
  assign red   = red_reg[7:4] ;
  assign green = green_reg[7:4] ;
  assign blue  = blue_reg[7:4] ;
  // The x/y coordinates that should be available on the NEXT cycle
  assign next_x = (h_state == H_ACTIVE_STATE)?h_counter:10'd_0 ;
  assign next_y = (v_state == V_ACTIVE_STATE)?v_counter:10'd_0 ;
  
endmodule
