module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss); 

    wire cout_s_h;
    wire cout_m_l;
    wire cout_m_h;
    wire cout_h_l;
    wire cout_h_h;
    wire cout_pm;
    wire flag_hh_12;
    wire flag_hh_9;
    
    always @ (posedge clk) begin
        if(reset)
            ss[3:0]<=1'b0;
        else if(ena)begin
            if(ss[3:0]==4'd9)
                ss[3:0]<=4'd0;
            else
                ss[3:0]<=ss[3:0] + 1'b1;
        end
        else
            ss[3:0]<=ss[3:0];
    end
    
        assign  cout_s_h = (ss[3:0]==4'd9)?1'b1:1'b0;   
        
    always @ (posedge clk) begin
        if(reset)
            ss[7:4]<=1'b0;
        else if(cout_s_h&ena)begin
            if(ss[7:4]==4'd5)
                ss[7:4]<=4'd0;
            else
                ss[7:4]<=ss[7:4] + 1'b1;
        end
        else
            ss[7:4]<=ss[7:4];
    end        
        
        assign cout_m_l =  (ss[7:4]==4'd5&&ss[3:0]==4'd9)? 1'b1:1'b0;
        
    always @ (posedge clk) begin
        if(reset)
            mm[3:0]<=1'b0;
        else if(cout_m_l&ena)begin
            if(mm[3:0]==4'd9)
                mm[3:0]<=4'd0;
            else
                mm[3:0]<=mm[3:0] + 1'b1;
        end
        else
            mm[3:0]<=mm[3:0];
    end        
        
        assign cout_m_h = (mm[3:0]==4'd9&&cout_m_l)? 1'b1:1'b0;   
        
    always @ (posedge clk) begin
        if(reset)
            mm[7:4]<=1'b0;
        else if(cout_m_h&ena)begin
            if(mm[7:4]==4'd5)
                mm[7:4]<=4'd0;
            else
                mm[7:4]<=mm[7:4] + 1'b1;
        end
        else
            mm[7:4]<=mm[7:4];
    end          
        
        assign cout_h_l =(mm[7:4]==4'd5&&cout_m_h)?1'b1:1'b0;
        
    always @ (posedge clk) begin
        if(reset)
            hh[3:0]<=4'd2;
        else if(cout_h_l&ena)begin
            if(flag_hh_12)
                hh[3:0]<=4'd1;            
            else if(hh[3:0]==4'd9)
                hh[3:0]<=4'd0;
            else
                hh[3:0]<=hh[3:0] + 1'b1;
        end
        else
            hh[3:0]<=hh[3:0];
    end        
        
        assign flag_hh_9 =(hh[3:0]==4'd9)?1'b1:1'b0;    
    
    always @ (posedge clk) begin
        if(reset)
            hh[7:4]<=1'b1;
        else if(cout_h_l&ena)begin
            if(flag_hh_12)            
            	hh[7:4]<=4'd0;        
        	else if(flag_hh_9)
                hh[7:4]<=4'd1;
            else
                hh[7:4]<=hh[7:4];
        end
        else
            hh[7:4]<=hh[7:4];
    end         
        
    assign flag_hh_12 = (hh[7:4]==4'd1&&hh[3:0]==4'd2)?1'b1:1'b0;
    
    assign cout_pm =(hh[7:4]==4'd1&&hh[3:0]==4'd1&&cout_h_l)?1'b1:1'b0;
        
    always @ (posedge clk) begin
        if(reset)
            pm<=1'b0;
        else if(cout_pm&ena)
            pm<=pm + 1'b1;
        else
            pm<=pm;
    end            
    
endmodule