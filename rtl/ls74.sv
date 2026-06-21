module ls74
(
   input         clr,
   input         pre,
   input         clk,
   input         cen,
   input         d,
   output logic  q
);

always_ff @(posedge clk, negedge clr, negedge pre) begin
   if (!clr) q <= 1'b0;
   else if (!pre) q <= 1'b1;
   else if (cen) q <= d;
end

endmodule
