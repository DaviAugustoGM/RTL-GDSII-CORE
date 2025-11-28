module ordenador(
  input  logic clk,
  input  logic reset,
  input  logic start,
  
  input  logic [7:0][7:0] n,
  
  output logic ready,
  output logic done,
  
  output logic [7:0][7:0] ns
);

  logic [7:0][7:0] ns_aux;
  logic [7:0][7:0] result_bubble;
  logic [7:0] aux;
  logic [2:0] loop_count;
  
  typedef enum {IDLE, START, SORT, DONE} state_t;
  
  state_t state, next_state;
  

  one_bubble b1 (
    .entrada(ns_aux),
    .saida(result_bubble)
  );

  
  always_comb begin
    
    case(state)
      
      IDLE: begin
        
        if(start) next_state = START;
        else next_state = IDLE;
        
      end
      
      START: begin
        
        next_state = SORT;
        
      end      
      
      SORT: begin
        
        if(loop_count == 7) next_state = DONE;
        else next_state = SORT;
        
      end
      
      DONE: begin
        
        next_state = IDLE;
        
      end
      
    endcase
    
  end

  always_ff @(posedge clk) begin
    
    if (reset) begin
      ns_aux <= '0;
      aux <= '0;
      loop_count <= 0;
      state <= IDLE;
      
    end
    
    else begin
      
      if(state == START) begin
        ns_aux <= n;
      end
      
      if( state == IDLE ) begin
        
        ns_aux <= '0;
        aux <= '0;
        loop_count <= 0; 
        
      end
    
      else if( state == SORT ) begin
        
        // Uma passada do bubble sort
        ns_aux <= result_bubble;
        loop_count <= loop_count + 1;
        
      end
      
      state <= next_state;
      
    end
    
  end
  
  always_comb begin
    
    case(state)
      
      IDLE: begin
        
        ready = 1;
        done = 0;
        ns = '0;

      end
      
      START: begin
        
        ready = 1;
        done = 0;
        ns = '0;
        
      end
      
      
      SORT: begin
        
        ready = 0;
        done = 0;
        ns = '0;
        
      end
      
      DONE: begin
        
        ready = 0;
        done = 1;
        ns = ns_aux;
        
      end
      
    endcase
    
  end


endmodule


module one_bubble(
  input  logic [7:0][7:0] entrada,
  output logic [7:0][7:0] saida
);

  logic [7:0][7:0] temp;
  logic [7:0] aux;

  always_comb begin
    temp = entrada;

    if (temp[0] > temp[1]) begin aux = temp[0]; temp[0] = temp[1]; temp[1] = aux; end
    if (temp[1] > temp[2]) begin aux = temp[1]; temp[1] = temp[2]; temp[2] = aux; end
    if (temp[2] > temp[3]) begin aux = temp[2]; temp[2] = temp[3]; temp[3] = aux; end
    if (temp[3] > temp[4]) begin aux = temp[3]; temp[3] = temp[4]; temp[4] = aux; end
    if (temp[4] > temp[5]) begin aux = temp[4]; temp[4] = temp[5]; temp[5] = aux; end
    if (temp[5] > temp[6]) begin aux = temp[5]; temp[5] = temp[6]; temp[6] = aux; end
    if (temp[6] > temp[7]) begin aux = temp[6]; temp[6] = temp[7]; temp[7] = aux; end

    saida = temp;
  end

endmodule

