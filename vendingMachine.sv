// ELEX 7660 2020 Assigneent 2 Problem 2  
// keeps track of the amount of money pit into a vending mashine
// output valid will go high for one cycle once $1 or more is received 
// Yanming Bu 2020/2/6
module vendingMachine(
    output logic valid,
    input logic nickel, dime, quarter,
    input logic clk, reset_n
);
    logic autoReset = 0;//autoRest goes high after valid is high 
    logic [2:0] coins;
    int nickelCount = 0;
    int dimeCount = 0;
    int quarCount = 0;
    int amount = 0;
    
    //concatenate nickel dime and quarter together 
    assign coins = {nickel,dime,quarter};

    //update coin amount at a falling edge of the clk
    always_ff @(negedge clk, negedge reset_n) begin
        if (~reset_n) begin //reset trigger by a reset button 
            nickelCount = 0;
            dimeCount = 0;
            quarCount = 0;
        end else if (autoReset)begin // reset after one valid 
            nickelCount = 0;
            dimeCount = 0;
            quarCount = 0;
        end
        //else update coins amount 
        else begin
            case (coins)
                3'b000:begin//no coins 
                    nickelCount <= nickelCount;
                    dimeCount <= dimeCount;
                    quarCount <= quarCount;
                end
                3'b001:begin //one quarter 
                    nickelCount <= nickelCount;
                    dimeCount <= dimeCount;
                    quarCount <= quarCount+1;
                end
                3'b010:begin//one dime
                    nickelCount <= nickelCount;
                    dimeCount <= dimeCount+1;
                    quarCount <= quarCount;
                end
                3'b011:begin//one dime, one quarter
                    nickelCount <= nickelCount;
                    dimeCount <= dimeCount+1;
                    quarCount <= quarCount+1;
                end
                3'b100:begin//one nickel 
                    nickelCount <= nickelCount+1;
                    dimeCount <= dimeCount;
                    quarCount <= quarCount;
                end
                3'b101:begin//one nickel, one quarter
                    nickelCount <= nickelCount+1;
                    dimeCount <= dimeCount;
                    quarCount <= quarCount+1;
                end
                3'b110:begin//one nickel, one dime 
                    nickelCount <= nickelCount+1;
                    dimeCount <= dimeCount+1;
                    quarCount <= quarCount;
                end
                3'b111:begin//one dime, one nickel, one quarter
                    nickelCount <= nickelCount+1;
                    dimeCount <= dimeCount+1;
                    quarCount <= quarCount+1;
                end
            endcase
        end
    end

    //updates the valid and autoRest at a possitive edge clk 
    always_ff @(posedge clk, negedge reset_n) begin
        if (~reset_n) begin//reset by a hard reset 
            valid <= 0;
        end
        //else if amount is more than 100 which is $1 
        //set valid high and autoRest 
        else if (amount>=100) begin
            valid <= 1;
            autoReset <= 1;
        end  
        //else valid and autoRest stays low 
        else begin
            valid <= 0;
            autoReset <= 0;
        end
    end

    //calc the amount according to the coin amount 
    always_comb begin
        amount = 5*nickelCount+10*dime+25*quarCount;
    end
endmodule