/**
 * Module: bus_mux
 *
 * Description:
 *  The bus_mux takes a multi word bus and ORs each element of the each word
 *  and outputs a single word whose first element is the OR of the first
 *  element of each word in the bus.
 *
 *
 * Test bench: tester_bus_mux.v
 *
 * Created: Sat Jun  1 20:43:21 EDT 2013
 *
 * Author: Berin Martini
 */
`ifndef _bus_mux_ `define _bus_mux_


module bus_mux
  #(parameter
    DATA_WIDTH  = 16,
    DATA_NUM    = 4)
   (
    input  [DATA_NUM-1:0]               gate,
    input  [(DATA_WIDTH*DATA_NUM)-1:0]  up_data,
    output [DATA_WIDTH-1:0]             down_data
);


    /*
     * Local parameters
     */

`ifdef VERBOSE
    initial $display("\using 'bus_mux' with a %0d word bus\n", DATA_NUM);
`endif

    /*
     * Internal signals
     */

    wire [DATA_WIDTH-1:0]   multi_data      [0:DATA_NUM-1];
    wire [DATA_NUM-1:0]     inverted_data   [0:DATA_WIDTH-1];

    genvar zz, ii, jj;


    /*
     * Implementation
     */

    generate // Multi-dimensional assignment from/to flat bus
        for (zz = 0; zz < DATA_NUM; zz = zz + 1) begin: FLAT_BUS_ASSIGN_

            assign multi_data[zz] = gate[zz] ?
                up_data[(zz * DATA_WIDTH) +: DATA_WIDTH] : {DATA_WIDTH{1'b0}};

        end
    endgenerate


    generate // Invert the bus matrix and perform logic operator
        for (jj = 0; jj < DATA_WIDTH; jj = jj + 1) begin : INVERT_DATA_WIDTH_
            for (ii = 0; ii < DATA_NUM; ii = ii + 1) begin : INVERT_DATA_NUM_

                assign inverted_data[jj][ii] = multi_data[ii][jj];

            end

            assign down_data[jj] = |(inverted_data[jj]);

        end
    endgenerate


endmodule

`endif //  `ifndef _bus_mux_
