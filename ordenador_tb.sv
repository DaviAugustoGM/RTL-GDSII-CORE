`timescale 1ns/1ns

`include "ordenador.sv"

module tb_ordenador();

  logic clk = 0;
  logic reset = 0;
  logic start = 0;

  logic [7:0][7:0] n;
  logic [7:0][7:0] ns;

  logic ready, done;
  integer i;

  // Instancia o módulo
  ordenador uut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .n(n),
    .ready(ready),
    .done(done),
    .ns(ns)
  );

  // Clock
  always #1 clk = ~clk;

  // Inicialização das entradas
  initial begin
    $dumpfile("ordenador.vcd");       // Nome do arquivo de waveform
    $dumpvars(0, tb_ordenador);       // Dumpar todos os sinais do testbench

    // Valores iniciais
    n[0] = 70; n[1] = 60; n[2] = 50; n[3] = 40;
    n[4] = 30; n[5] = 20; n[6] = 10; n[7] = 5;

    $display("----- Entrada ------");
    for (i = 0; i < 8; i++) $display("n[%0d] = %0d", i, n[i]);

    reset = 1;
    start = 0;

    #4 reset = 0;          // Desativa reset após 4 unidades de tempo

    @(posedge clk);
    wait (ready);
    @(posedge clk);
    start = 1;             // Pulso de start com 1 ciclo de clock
    @(posedge clk);
    start = 0;

  end

  // Monitor de saída e controle da simulação
  always @(posedge clk) begin
    $display("time=%0t | state=%0d | ready=%b | done=%b", $time, uut.state, ready, done);
  end

  // Mostrar resultado quando done
  always @(posedge done) begin
    $display("------ Saída Ordenada ------");
    for (i = 0; i < 8; i++) $display("ns[%0d] = %0d", i, ns[i]);
    #10 $finish;
  end

endmodule