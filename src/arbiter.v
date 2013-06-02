/**
 * Module: arbiter
 *
 * Description: a look ahead, round-robing parametrized arbiter.
 *
 * request  <>  each bit is controlled by an actor and each actor can 'request'
 *              ownership of the shared resource by bring high its request bit.
 *
 * grant    <>  when an actor is to be given ownership of shared resource its
 *              'grant' bit is driven high.
 *
 *
 * Created: Sat Jun  1 20:26:44 EDT 2013
 *
 * Author:  Berin Martini // berin.martini@gmail.com
 */
`ifndef _arbiter_ `define _arbiter_

`include "bus_mux.v"

module arbiter
  #(parameter NUM_PORTS = 6)
   (input                       clk,
    input                       rst,
    input      [0:NUM_PORTS-1]  request,
//    output     [0:NUM_PORTS-1]  grant,
//    output                      active
    output reg [0:NUM_PORTS-1]  grant,
    output reg                  active
);


    /**
     * Local parameters
     */

`ifdef VERBOSE
    initial $display("Bus arbiter with %d units", NUM_PORTS);
`endif


    /**
     * Internal signals
     */

    integer                 yy;

    wire                    next;
    wire [NUM_PORTS-1:0]    order;
    wire [NUM_PORTS-1:0]    order_right;
    wire [NUM_PORTS-1:0]    order_gate;

    reg  [NUM_PORTS-1:0]    token;
    wire [NUM_PORTS-1:0]    token_possibles [NUM_PORTS-1:0];

    wire [(NUM_PORTS*NUM_PORTS)-1:0]    token_select;
    wire [NUM_PORTS-1:0]                token_selected;


    bus_mux #(
        .DATA_WIDTH (NUM_PORTS),
        .DATA_NUM   (NUM_PORTS))
    token_mux (
        .gate       (order_gate),
        .up_data    (token_select),
        .down_data  (token_selected)
    );


    /**
     * Implementation
     */

    always @(posedge clk)
        grant <= token & request;

    always @(posedge clk)
        active <= |(token & request);

    assign next         = ~|(token & request);

    assign order_right  = (order_right>>1) | order;

    assign order_gate   = (order_right>>1) ^ order_right;


//    always @(posedge clk)
//        if      (rst) token <= 'b1;
//        else if (next) begin
//
//            for (yy = 0; yy < NUM_PORTS; yy = yy + 1) begin : TOKEN_
//
//                if (order_gate[yy]) begin
//                    token <= token_possibles[yy];
//                end
//            end
//        end


    always @(posedge clk)
        if      (rst)                   token <= 'b1;
        else if (next & |(order_gate))  token <= token_selected;


    genvar xx;
    generate
        for (xx = 0; xx < NUM_PORTS; xx = xx + 1) begin : ORDER_

            assign token_select[(((xx + 1) * NUM_PORTS) -1):(xx * NUM_PORTS)] = token_possibles[xx];

            assign token_possibles[xx]  = {token, token[NUM_PORTS-1:xx]};

            assign order[xx]            = |(token_possibles[xx] & request);

        end
    endgenerate


//    assign grant        = token & request;
//    assign active       = |(grant);
//    assign next         = ~active;
//    // Ring counter
//    always @(posedge clk)
//        if      (rst)               token <= 'b1;
//        else if (next & |(request)) token <= {token, token[NUM_PORTS-1]};


endmodule

`endif //  `ifndef _arbiter_
