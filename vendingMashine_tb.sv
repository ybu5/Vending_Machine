module vendingMashine_tb();
    logic valid;
    logic nickel = 0, dime=0, quarter=0;
    logic clk = 0, reset_n;

    logic [9:0] nickelIn = 10'b1111110110;
    logic [9:0] dimeIn = 10'b1111011011;
    logic [9:0] quarIn = 10'b1111011001;

    //device under test 
    vendingMachine dut(.*);

    initial begin
        //reset for two cycles
        reset_n = 0;
	    repeat(2) @(posedge clk);
	    reset_n = 1;

        for (int i = 9; i>=0; i--)	begin
			//wait for a possitive edge clk 
            //shift nickelIn, dimeIn and quaIn 
			@(posedge clk);
            nickel = nickelIn[i];
            dime = dimeIn[i];
			quarter = quarIn[i];

            //throw in a reset for one cycle 
            if (i == 5) begin
                reset_n = 0;
                repeat(1) @(posedge clk);
                reset_n = 1;
            end
		end
        repeat(3) @(posedge clk);
        $stop;
    end

    // generate clock
    always
	    #1ms clk = ~clk;
endmodule