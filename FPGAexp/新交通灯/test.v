module test(
    clk,data,out_LED3_NS,out_LED3_WE
);
    input clk;
    output [15:0]data;
    output [2:0] out_LED3_NS,out_LED3_WE;
//分频 1Hz reg clk_1Hz;
    integer clk_1Hz_cnt; 
    always @(posedge clk)
        if(clk_1Hz_cnt==32'd25000000-1) begin 
            clk_1Hz_cnt <= 1'b0;
            clk_1Hz <= ~clk_1Hz;
        end else begin
            clk_1Hz_cnt <= clk_1Hz_cnt + 1'b1;
        end
        reg [15:0] data;
        reg [2:0] out_LED3_NS,out_LED3_WE;
        reg [3:0] Time_10=2'd2, Time_1=2'd0;
        reg [1:0] Stage=2'b00;
        always @(posedge clk_1Hz) begin
            case(Stage)
                2'b00: begin//NS pass
                    if((Time_10==0) & (Time_1==0)) begin
                        Stage<=2'b11;
                        Time_10<=4'd1;
                        Time_1 <=4'd0; 
                    end else begin if(Time_1==0) begin
                        Time_1<=4'd9;
                        Time_10<=Time_10-1;
                        end else begin
                            Time_1<=Time_1-1;
                        end
                    end
                    data[15:8]<={Time_10,Time_1};
                    data[7:0]<={Time_10,Time_1};
                    out_LED3_NS<=3'b001;
                    out_LED3_WE<=3'b100;
                    
                end

                2'b01:
                    begin//WE pass
                    if((Time_10==0) & (Time_1==0)) begin
                        Stage<=2'b10;
                        Time_10<=4'd1;
                        Time_1 <=4'd0;
                    end else begin if(Time_1==0) begin
                        Time_1<=4'd9;
                        Time_10<=Time_10-1;
                        end else begin
                            Time_1<=Time_1-1;
                        end
                    end
                    data[15:8]<={Time_10,Time_1};
                    data[7:0]<={Time_10,Time_1};
                    out_LED3_NS<=3'b100;
                    out_LED3_WE<=3'b001;
                end
                2'b10: begin
                    if((Time_10==0) & (Time_1==0)) begin
                        Stage<=2'b00;
                        Time_10<=4'd1;
                        Time_1 <=4'd0; 
                    end else begin if(Time_1==0) begin
                        Time_1<=4'd9;
                        Time_10<=Time_10-1;
                        end else begin
                            Time_1<=Time_1-1;
                        end
                    end
                    data[15:8]<={Time_10,Time_1};
                    data[7:0]<={Time_10,Time_1};
                    out_LED3_NS<=3'b010;
                    out_LED3_WE<=3'b010;
                end
                
            
            endcase

endmodule