--megafunction wizard: %Altera SOPC Builder%
--GENERATION: STANDARD
--VERSION: WM1.0


--Legal Notice: (C)2022 Altera Corporation. All rights reserved.  Your
--use of Altera Corporation's design tools, logic functions and other
--software and tools, and its AMPP partner logic functions, and any
--output files any of the foregoing (including device programming or
--simulation files), and any associated documentation or information are
--expressly subject to the terms and conditions of the Altera Program
--License Subscription Agreement or other applicable license agreement,
--including, without limitation, that your use is for the sole purpose
--of programming logic devices manufactured by Altera and sold by Altera
--or its authorized distributors.  Please refer to the applicable
--agreement for further details.


-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity CPU_MEM_s1_arbitrator is 
        port (
              -- inputs:
                 signal CPU_MEM_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_instruction_master_latency_counter : IN STD_LOGIC;
                 signal cpu_instruction_master_read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal CPU_MEM_s1_address : OUT STD_LOGIC_VECTOR (14 DOWNTO 0);
                 signal CPU_MEM_s1_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal CPU_MEM_s1_chipselect : OUT STD_LOGIC;
                 signal CPU_MEM_s1_clken : OUT STD_LOGIC;
                 signal CPU_MEM_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal CPU_MEM_s1_write : OUT STD_LOGIC;
                 signal CPU_MEM_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_data_master_granted_CPU_MEM_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_CPU_MEM_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_CPU_MEM_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_CPU_MEM_s1 : OUT STD_LOGIC;
                 signal cpu_instruction_master_granted_CPU_MEM_s1 : OUT STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_CPU_MEM_s1 : OUT STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_CPU_MEM_s1 : OUT STD_LOGIC;
                 signal cpu_instruction_master_requests_CPU_MEM_s1 : OUT STD_LOGIC;
                 signal d1_CPU_MEM_s1_end_xfer : OUT STD_LOGIC;
                 signal registered_cpu_data_master_read_data_valid_CPU_MEM_s1 : OUT STD_LOGIC
              );
end entity CPU_MEM_s1_arbitrator;


architecture europa of CPU_MEM_s1_arbitrator is
                signal CPU_MEM_s1_allgrants :  STD_LOGIC;
                signal CPU_MEM_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal CPU_MEM_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal CPU_MEM_s1_any_continuerequest :  STD_LOGIC;
                signal CPU_MEM_s1_arb_addend :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal CPU_MEM_s1_arb_counter_enable :  STD_LOGIC;
                signal CPU_MEM_s1_arb_share_counter :  STD_LOGIC;
                signal CPU_MEM_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal CPU_MEM_s1_arb_share_set_values :  STD_LOGIC;
                signal CPU_MEM_s1_arb_winner :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal CPU_MEM_s1_arbitration_holdoff_internal :  STD_LOGIC;
                signal CPU_MEM_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal CPU_MEM_s1_begins_xfer :  STD_LOGIC;
                signal CPU_MEM_s1_chosen_master_double_vector :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal CPU_MEM_s1_chosen_master_rot_left :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal CPU_MEM_s1_end_xfer :  STD_LOGIC;
                signal CPU_MEM_s1_firsttransfer :  STD_LOGIC;
                signal CPU_MEM_s1_grant_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal CPU_MEM_s1_in_a_read_cycle :  STD_LOGIC;
                signal CPU_MEM_s1_in_a_write_cycle :  STD_LOGIC;
                signal CPU_MEM_s1_master_qreq_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal CPU_MEM_s1_non_bursting_master_requests :  STD_LOGIC;
                signal CPU_MEM_s1_reg_firsttransfer :  STD_LOGIC;
                signal CPU_MEM_s1_saved_chosen_master_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal CPU_MEM_s1_slavearbiterlockenable :  STD_LOGIC;
                signal CPU_MEM_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal CPU_MEM_s1_unreg_firsttransfer :  STD_LOGIC;
                signal CPU_MEM_s1_waits_for_read :  STD_LOGIC;
                signal CPU_MEM_s1_waits_for_write :  STD_LOGIC;
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_CPU_MEM_s1_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_CPU_MEM_s1_shift_register_in :  STD_LOGIC;
                signal cpu_data_master_saved_grant_CPU_MEM_s1 :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_instruction_master_continuerequest :  STD_LOGIC;
                signal cpu_instruction_master_read_data_valid_CPU_MEM_s1_shift_register :  STD_LOGIC;
                signal cpu_instruction_master_read_data_valid_CPU_MEM_s1_shift_register_in :  STD_LOGIC;
                signal cpu_instruction_master_saved_grant_CPU_MEM_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_CPU_MEM_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_CPU_MEM_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_CPU_MEM_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_CPU_MEM_s1 :  STD_LOGIC;
                signal internal_cpu_instruction_master_granted_CPU_MEM_s1 :  STD_LOGIC;
                signal internal_cpu_instruction_master_qualified_request_CPU_MEM_s1 :  STD_LOGIC;
                signal internal_cpu_instruction_master_requests_CPU_MEM_s1 :  STD_LOGIC;
                signal last_cycle_cpu_data_master_granted_slave_CPU_MEM_s1 :  STD_LOGIC;
                signal last_cycle_cpu_instruction_master_granted_slave_CPU_MEM_s1 :  STD_LOGIC;
                signal p1_cpu_data_master_read_data_valid_CPU_MEM_s1_shift_register :  STD_LOGIC;
                signal p1_cpu_instruction_master_read_data_valid_CPU_MEM_s1_shift_register :  STD_LOGIC;
                signal shifted_address_to_CPU_MEM_s1_from_cpu_data_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal shifted_address_to_CPU_MEM_s1_from_cpu_instruction_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal wait_for_CPU_MEM_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT CPU_MEM_s1_end_xfer;
      end if;
    end if;

  end process;

  CPU_MEM_s1_begins_xfer <= NOT d1_reasons_to_wait AND ((internal_cpu_data_master_qualified_request_CPU_MEM_s1 OR internal_cpu_instruction_master_qualified_request_CPU_MEM_s1));
  --assign CPU_MEM_s1_readdata_from_sa = CPU_MEM_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  CPU_MEM_s1_readdata_from_sa <= CPU_MEM_s1_readdata;
  internal_cpu_data_master_requests_CPU_MEM_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(18 DOWNTO 17) & std_logic_vector'("00000000000000000")) = std_logic_vector'("0100000000000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --registered rdv signal_name registered_cpu_data_master_read_data_valid_CPU_MEM_s1 assignment, which is an e_assign
  registered_cpu_data_master_read_data_valid_CPU_MEM_s1 <= cpu_data_master_read_data_valid_CPU_MEM_s1_shift_register_in;
  --CPU_MEM_s1_arb_share_counter set values, which is an e_mux
  CPU_MEM_s1_arb_share_set_values <= std_logic'('1');
  --CPU_MEM_s1_non_bursting_master_requests mux, which is an e_mux
  CPU_MEM_s1_non_bursting_master_requests <= ((internal_cpu_data_master_requests_CPU_MEM_s1 OR internal_cpu_instruction_master_requests_CPU_MEM_s1) OR internal_cpu_data_master_requests_CPU_MEM_s1) OR internal_cpu_instruction_master_requests_CPU_MEM_s1;
  --CPU_MEM_s1_any_bursting_master_saved_grant mux, which is an e_mux
  CPU_MEM_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --CPU_MEM_s1_arb_share_counter_next_value assignment, which is an e_assign
  CPU_MEM_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(CPU_MEM_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(CPU_MEM_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(CPU_MEM_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(CPU_MEM_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --CPU_MEM_s1_allgrants all slave grants, which is an e_mux
  CPU_MEM_s1_allgrants <= ((or_reduce(CPU_MEM_s1_grant_vector) OR or_reduce(CPU_MEM_s1_grant_vector)) OR or_reduce(CPU_MEM_s1_grant_vector)) OR or_reduce(CPU_MEM_s1_grant_vector);
  --CPU_MEM_s1_end_xfer assignment, which is an e_assign
  CPU_MEM_s1_end_xfer <= NOT ((CPU_MEM_s1_waits_for_read OR CPU_MEM_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_CPU_MEM_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_CPU_MEM_s1 <= CPU_MEM_s1_end_xfer AND (((NOT CPU_MEM_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --CPU_MEM_s1_arb_share_counter arbitration counter enable, which is an e_assign
  CPU_MEM_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_CPU_MEM_s1 AND CPU_MEM_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_CPU_MEM_s1 AND NOT CPU_MEM_s1_non_bursting_master_requests));
  --CPU_MEM_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      CPU_MEM_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(CPU_MEM_s1_arb_counter_enable) = '1' then 
        CPU_MEM_s1_arb_share_counter <= CPU_MEM_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --CPU_MEM_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      CPU_MEM_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((or_reduce(CPU_MEM_s1_master_qreq_vector) AND end_xfer_arb_share_counter_term_CPU_MEM_s1)) OR ((end_xfer_arb_share_counter_term_CPU_MEM_s1 AND NOT CPU_MEM_s1_non_bursting_master_requests)))) = '1' then 
        CPU_MEM_s1_slavearbiterlockenable <= CPU_MEM_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master CPU_MEM/s1 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= CPU_MEM_s1_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --CPU_MEM_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  CPU_MEM_s1_slavearbiterlockenable2 <= CPU_MEM_s1_arb_share_counter_next_value;
  --cpu/data_master CPU_MEM/s1 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= CPU_MEM_s1_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --cpu/instruction_master CPU_MEM/s1 arbiterlock, which is an e_assign
  cpu_instruction_master_arbiterlock <= CPU_MEM_s1_slavearbiterlockenable AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master CPU_MEM/s1 arbiterlock2, which is an e_assign
  cpu_instruction_master_arbiterlock2 <= CPU_MEM_s1_slavearbiterlockenable2 AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master granted CPU_MEM/s1 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_instruction_master_granted_slave_CPU_MEM_s1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        last_cycle_cpu_instruction_master_granted_slave_CPU_MEM_s1 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_instruction_master_saved_grant_CPU_MEM_s1) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((CPU_MEM_s1_arbitration_holdoff_internal OR NOT internal_cpu_instruction_master_requests_CPU_MEM_s1))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_instruction_master_granted_slave_CPU_MEM_s1))))));
      end if;
    end if;

  end process;

  --cpu_instruction_master_continuerequest continued request, which is an e_mux
  cpu_instruction_master_continuerequest <= last_cycle_cpu_instruction_master_granted_slave_CPU_MEM_s1 AND internal_cpu_instruction_master_requests_CPU_MEM_s1;
  --CPU_MEM_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  CPU_MEM_s1_any_continuerequest <= cpu_instruction_master_continuerequest OR cpu_data_master_continuerequest;
  internal_cpu_data_master_qualified_request_CPU_MEM_s1 <= internal_cpu_data_master_requests_CPU_MEM_s1 AND NOT (((((cpu_data_master_read AND (cpu_data_master_read_data_valid_CPU_MEM_s1_shift_register))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))) OR cpu_instruction_master_arbiterlock));
  --cpu_data_master_read_data_valid_CPU_MEM_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  cpu_data_master_read_data_valid_CPU_MEM_s1_shift_register_in <= ((internal_cpu_data_master_granted_CPU_MEM_s1 AND cpu_data_master_read) AND NOT CPU_MEM_s1_waits_for_read) AND NOT (cpu_data_master_read_data_valid_CPU_MEM_s1_shift_register);
  --shift register p1 cpu_data_master_read_data_valid_CPU_MEM_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  p1_cpu_data_master_read_data_valid_CPU_MEM_s1_shift_register <= Vector_To_Std_Logic(Std_Logic_Vector'(A_ToStdLogicVector(cpu_data_master_read_data_valid_CPU_MEM_s1_shift_register) & A_ToStdLogicVector(cpu_data_master_read_data_valid_CPU_MEM_s1_shift_register_in)));
  --cpu_data_master_read_data_valid_CPU_MEM_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_data_master_read_data_valid_CPU_MEM_s1_shift_register <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        cpu_data_master_read_data_valid_CPU_MEM_s1_shift_register <= p1_cpu_data_master_read_data_valid_CPU_MEM_s1_shift_register;
      end if;
    end if;

  end process;

  --local readdatavalid cpu_data_master_read_data_valid_CPU_MEM_s1, which is an e_mux
  cpu_data_master_read_data_valid_CPU_MEM_s1 <= cpu_data_master_read_data_valid_CPU_MEM_s1_shift_register;
  --CPU_MEM_s1_writedata mux, which is an e_mux
  CPU_MEM_s1_writedata <= cpu_data_master_writedata;
  --mux CPU_MEM_s1_clken, which is an e_mux
  CPU_MEM_s1_clken <= std_logic'('1');
  internal_cpu_instruction_master_requests_CPU_MEM_s1 <= ((to_std_logic(((Std_Logic_Vector'(cpu_instruction_master_address_to_slave(18 DOWNTO 17) & std_logic_vector'("00000000000000000")) = std_logic_vector'("0100000000000000000")))) AND (cpu_instruction_master_read))) AND cpu_instruction_master_read;
  --cpu/data_master granted CPU_MEM/s1 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_data_master_granted_slave_CPU_MEM_s1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        last_cycle_cpu_data_master_granted_slave_CPU_MEM_s1 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_data_master_saved_grant_CPU_MEM_s1) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((CPU_MEM_s1_arbitration_holdoff_internal OR NOT internal_cpu_data_master_requests_CPU_MEM_s1))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_data_master_granted_slave_CPU_MEM_s1))))));
      end if;
    end if;

  end process;

  --cpu_data_master_continuerequest continued request, which is an e_mux
  cpu_data_master_continuerequest <= last_cycle_cpu_data_master_granted_slave_CPU_MEM_s1 AND internal_cpu_data_master_requests_CPU_MEM_s1;
  internal_cpu_instruction_master_qualified_request_CPU_MEM_s1 <= internal_cpu_instruction_master_requests_CPU_MEM_s1 AND NOT ((((cpu_instruction_master_read AND to_std_logic(((std_logic_vector'("00000000000000000000000000000001")<(std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_latency_counter)))))))) OR cpu_data_master_arbiterlock));
  --cpu_instruction_master_read_data_valid_CPU_MEM_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  cpu_instruction_master_read_data_valid_CPU_MEM_s1_shift_register_in <= (internal_cpu_instruction_master_granted_CPU_MEM_s1 AND cpu_instruction_master_read) AND NOT CPU_MEM_s1_waits_for_read;
  --shift register p1 cpu_instruction_master_read_data_valid_CPU_MEM_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  p1_cpu_instruction_master_read_data_valid_CPU_MEM_s1_shift_register <= Vector_To_Std_Logic(Std_Logic_Vector'(A_ToStdLogicVector(cpu_instruction_master_read_data_valid_CPU_MEM_s1_shift_register) & A_ToStdLogicVector(cpu_instruction_master_read_data_valid_CPU_MEM_s1_shift_register_in)));
  --cpu_instruction_master_read_data_valid_CPU_MEM_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_instruction_master_read_data_valid_CPU_MEM_s1_shift_register <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        cpu_instruction_master_read_data_valid_CPU_MEM_s1_shift_register <= p1_cpu_instruction_master_read_data_valid_CPU_MEM_s1_shift_register;
      end if;
    end if;

  end process;

  --local readdatavalid cpu_instruction_master_read_data_valid_CPU_MEM_s1, which is an e_mux
  cpu_instruction_master_read_data_valid_CPU_MEM_s1 <= cpu_instruction_master_read_data_valid_CPU_MEM_s1_shift_register;
  --allow new arb cycle for CPU_MEM/s1, which is an e_assign
  CPU_MEM_s1_allow_new_arb_cycle <= NOT cpu_data_master_arbiterlock AND NOT cpu_instruction_master_arbiterlock;
  --cpu/instruction_master assignment into master qualified-requests vector for CPU_MEM/s1, which is an e_assign
  CPU_MEM_s1_master_qreq_vector(0) <= internal_cpu_instruction_master_qualified_request_CPU_MEM_s1;
  --cpu/instruction_master grant CPU_MEM/s1, which is an e_assign
  internal_cpu_instruction_master_granted_CPU_MEM_s1 <= CPU_MEM_s1_grant_vector(0);
  --cpu/instruction_master saved-grant CPU_MEM/s1, which is an e_assign
  cpu_instruction_master_saved_grant_CPU_MEM_s1 <= CPU_MEM_s1_arb_winner(0) AND internal_cpu_instruction_master_requests_CPU_MEM_s1;
  --cpu/data_master assignment into master qualified-requests vector for CPU_MEM/s1, which is an e_assign
  CPU_MEM_s1_master_qreq_vector(1) <= internal_cpu_data_master_qualified_request_CPU_MEM_s1;
  --cpu/data_master grant CPU_MEM/s1, which is an e_assign
  internal_cpu_data_master_granted_CPU_MEM_s1 <= CPU_MEM_s1_grant_vector(1);
  --cpu/data_master saved-grant CPU_MEM/s1, which is an e_assign
  cpu_data_master_saved_grant_CPU_MEM_s1 <= CPU_MEM_s1_arb_winner(1) AND internal_cpu_data_master_requests_CPU_MEM_s1;
  --CPU_MEM/s1 chosen-master double-vector, which is an e_assign
  CPU_MEM_s1_chosen_master_double_vector <= A_EXT (((std_logic_vector'("0") & ((CPU_MEM_s1_master_qreq_vector & CPU_MEM_s1_master_qreq_vector))) AND (((std_logic_vector'("0") & (Std_Logic_Vector'(NOT CPU_MEM_s1_master_qreq_vector & NOT CPU_MEM_s1_master_qreq_vector))) + (std_logic_vector'("000") & (CPU_MEM_s1_arb_addend))))), 4);
  --stable onehot encoding of arb winner
  CPU_MEM_s1_arb_winner <= A_WE_StdLogicVector((std_logic'(((CPU_MEM_s1_allow_new_arb_cycle AND or_reduce(CPU_MEM_s1_grant_vector)))) = '1'), CPU_MEM_s1_grant_vector, CPU_MEM_s1_saved_chosen_master_vector);
  --saved CPU_MEM_s1_grant_vector, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      CPU_MEM_s1_saved_chosen_master_vector <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(CPU_MEM_s1_allow_new_arb_cycle) = '1' then 
        CPU_MEM_s1_saved_chosen_master_vector <= A_WE_StdLogicVector((std_logic'(or_reduce(CPU_MEM_s1_grant_vector)) = '1'), CPU_MEM_s1_grant_vector, CPU_MEM_s1_saved_chosen_master_vector);
      end if;
    end if;

  end process;

  --onehot encoding of chosen master
  CPU_MEM_s1_grant_vector <= Std_Logic_Vector'(A_ToStdLogicVector(((CPU_MEM_s1_chosen_master_double_vector(1) OR CPU_MEM_s1_chosen_master_double_vector(3)))) & A_ToStdLogicVector(((CPU_MEM_s1_chosen_master_double_vector(0) OR CPU_MEM_s1_chosen_master_double_vector(2)))));
  --CPU_MEM/s1 chosen master rotated left, which is an e_assign
  CPU_MEM_s1_chosen_master_rot_left <= A_EXT (A_WE_StdLogicVector((((A_SLL(CPU_MEM_s1_arb_winner,std_logic_vector'("00000000000000000000000000000001")))) /= std_logic_vector'("00")), (std_logic_vector'("000000000000000000000000000000") & ((A_SLL(CPU_MEM_s1_arb_winner,std_logic_vector'("00000000000000000000000000000001"))))), std_logic_vector'("00000000000000000000000000000001")), 2);
  --CPU_MEM/s1's addend for next-master-grant
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      CPU_MEM_s1_arb_addend <= std_logic_vector'("01");
    elsif clk'event and clk = '1' then
      if std_logic'(or_reduce(CPU_MEM_s1_grant_vector)) = '1' then 
        CPU_MEM_s1_arb_addend <= A_WE_StdLogicVector((std_logic'(CPU_MEM_s1_end_xfer) = '1'), CPU_MEM_s1_chosen_master_rot_left, CPU_MEM_s1_grant_vector);
      end if;
    end if;

  end process;

  CPU_MEM_s1_chipselect <= internal_cpu_data_master_granted_CPU_MEM_s1 OR internal_cpu_instruction_master_granted_CPU_MEM_s1;
  --CPU_MEM_s1_firsttransfer first transaction, which is an e_assign
  CPU_MEM_s1_firsttransfer <= A_WE_StdLogic((std_logic'(CPU_MEM_s1_begins_xfer) = '1'), CPU_MEM_s1_unreg_firsttransfer, CPU_MEM_s1_reg_firsttransfer);
  --CPU_MEM_s1_unreg_firsttransfer first transaction, which is an e_assign
  CPU_MEM_s1_unreg_firsttransfer <= NOT ((CPU_MEM_s1_slavearbiterlockenable AND CPU_MEM_s1_any_continuerequest));
  --CPU_MEM_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      CPU_MEM_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(CPU_MEM_s1_begins_xfer) = '1' then 
        CPU_MEM_s1_reg_firsttransfer <= CPU_MEM_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --CPU_MEM_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  CPU_MEM_s1_beginbursttransfer_internal <= CPU_MEM_s1_begins_xfer;
  --CPU_MEM_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  CPU_MEM_s1_arbitration_holdoff_internal <= CPU_MEM_s1_begins_xfer AND CPU_MEM_s1_firsttransfer;
  --CPU_MEM_s1_write assignment, which is an e_mux
  CPU_MEM_s1_write <= internal_cpu_data_master_granted_CPU_MEM_s1 AND cpu_data_master_write;
  shifted_address_to_CPU_MEM_s1_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --CPU_MEM_s1_address mux, which is an e_mux
  CPU_MEM_s1_address <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_CPU_MEM_s1)) = '1'), (A_SRL(shifted_address_to_CPU_MEM_s1_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010"))), (A_SRL(shifted_address_to_CPU_MEM_s1_from_cpu_instruction_master,std_logic_vector'("00000000000000000000000000000010")))), 15);
  shifted_address_to_CPU_MEM_s1_from_cpu_instruction_master <= cpu_instruction_master_address_to_slave;
  --d1_CPU_MEM_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_CPU_MEM_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_CPU_MEM_s1_end_xfer <= CPU_MEM_s1_end_xfer;
      end if;
    end if;

  end process;

  --CPU_MEM_s1_waits_for_read in a cycle, which is an e_mux
  CPU_MEM_s1_waits_for_read <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(CPU_MEM_s1_in_a_read_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --CPU_MEM_s1_in_a_read_cycle assignment, which is an e_assign
  CPU_MEM_s1_in_a_read_cycle <= ((internal_cpu_data_master_granted_CPU_MEM_s1 AND cpu_data_master_read)) OR ((internal_cpu_instruction_master_granted_CPU_MEM_s1 AND cpu_instruction_master_read));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= CPU_MEM_s1_in_a_read_cycle;
  --CPU_MEM_s1_waits_for_write in a cycle, which is an e_mux
  CPU_MEM_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(CPU_MEM_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --CPU_MEM_s1_in_a_write_cycle assignment, which is an e_assign
  CPU_MEM_s1_in_a_write_cycle <= internal_cpu_data_master_granted_CPU_MEM_s1 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= CPU_MEM_s1_in_a_write_cycle;
  wait_for_CPU_MEM_s1_counter <= std_logic'('0');
  --CPU_MEM_s1_byteenable byte enable port mux, which is an e_mux
  CPU_MEM_s1_byteenable <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_CPU_MEM_s1)) = '1'), (std_logic_vector'("0000000000000000000000000000") & (cpu_data_master_byteenable)), -SIGNED(std_logic_vector'("00000000000000000000000000000001"))), 4);
  --vhdl renameroo for output signals
  cpu_data_master_granted_CPU_MEM_s1 <= internal_cpu_data_master_granted_CPU_MEM_s1;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_CPU_MEM_s1 <= internal_cpu_data_master_qualified_request_CPU_MEM_s1;
  --vhdl renameroo for output signals
  cpu_data_master_requests_CPU_MEM_s1 <= internal_cpu_data_master_requests_CPU_MEM_s1;
  --vhdl renameroo for output signals
  cpu_instruction_master_granted_CPU_MEM_s1 <= internal_cpu_instruction_master_granted_CPU_MEM_s1;
  --vhdl renameroo for output signals
  cpu_instruction_master_qualified_request_CPU_MEM_s1 <= internal_cpu_instruction_master_qualified_request_CPU_MEM_s1;
  --vhdl renameroo for output signals
  cpu_instruction_master_requests_CPU_MEM_s1 <= internal_cpu_instruction_master_requests_CPU_MEM_s1;
--synthesis translate_off
    --CPU_MEM/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

    --grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_data_master_granted_CPU_MEM_s1))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_instruction_master_granted_CPU_MEM_s1))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line, now);
          write(write_line, string'(": "));
          write(write_line, string'("> 1 of grant signals are active simultaneously"));
          write(output, write_line.all);
          deallocate (write_line);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --saved_grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line1 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_data_master_saved_grant_CPU_MEM_s1))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_saved_grant_CPU_MEM_s1))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line1, now);
          write(write_line1, string'(": "));
          write(write_line1, string'("> 1 of saved_grant signals are active simultaneously"));
          write(output, write_line1.all);
          deallocate (write_line1);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity HEX0_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal HEX0_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal HEX0_s1_chipselect : OUT STD_LOGIC;
                 signal HEX0_s1_reset_n : OUT STD_LOGIC;
                 signal HEX0_s1_write_n : OUT STD_LOGIC;
                 signal HEX0_s1_writedata : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
                 signal cpu_data_master_granted_HEX0_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_HEX0_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_HEX0_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_HEX0_s1 : OUT STD_LOGIC;
                 signal d1_HEX0_s1_end_xfer : OUT STD_LOGIC
              );
end entity HEX0_s1_arbitrator;


architecture europa of HEX0_s1_arbitrator is
                signal HEX0_s1_allgrants :  STD_LOGIC;
                signal HEX0_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal HEX0_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal HEX0_s1_any_continuerequest :  STD_LOGIC;
                signal HEX0_s1_arb_counter_enable :  STD_LOGIC;
                signal HEX0_s1_arb_share_counter :  STD_LOGIC;
                signal HEX0_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal HEX0_s1_arb_share_set_values :  STD_LOGIC;
                signal HEX0_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal HEX0_s1_begins_xfer :  STD_LOGIC;
                signal HEX0_s1_end_xfer :  STD_LOGIC;
                signal HEX0_s1_firsttransfer :  STD_LOGIC;
                signal HEX0_s1_grant_vector :  STD_LOGIC;
                signal HEX0_s1_in_a_read_cycle :  STD_LOGIC;
                signal HEX0_s1_in_a_write_cycle :  STD_LOGIC;
                signal HEX0_s1_master_qreq_vector :  STD_LOGIC;
                signal HEX0_s1_non_bursting_master_requests :  STD_LOGIC;
                signal HEX0_s1_reg_firsttransfer :  STD_LOGIC;
                signal HEX0_s1_slavearbiterlockenable :  STD_LOGIC;
                signal HEX0_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal HEX0_s1_unreg_firsttransfer :  STD_LOGIC;
                signal HEX0_s1_waits_for_read :  STD_LOGIC;
                signal HEX0_s1_waits_for_write :  STD_LOGIC;
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_HEX0_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_HEX0_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_HEX0_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_HEX0_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_HEX0_s1 :  STD_LOGIC;
                signal shifted_address_to_HEX0_s1_from_cpu_data_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal wait_for_HEX0_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT HEX0_s1_end_xfer;
      end if;
    end if;

  end process;

  HEX0_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_HEX0_s1);
  internal_cpu_data_master_requests_HEX0_s1 <= ((to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(18 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000001000010000000")))) AND ((cpu_data_master_read OR cpu_data_master_write)))) AND cpu_data_master_write;
  --HEX0_s1_arb_share_counter set values, which is an e_mux
  HEX0_s1_arb_share_set_values <= std_logic'('1');
  --HEX0_s1_non_bursting_master_requests mux, which is an e_mux
  HEX0_s1_non_bursting_master_requests <= internal_cpu_data_master_requests_HEX0_s1;
  --HEX0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  HEX0_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --HEX0_s1_arb_share_counter_next_value assignment, which is an e_assign
  HEX0_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(HEX0_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(HEX0_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(HEX0_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(HEX0_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --HEX0_s1_allgrants all slave grants, which is an e_mux
  HEX0_s1_allgrants <= HEX0_s1_grant_vector;
  --HEX0_s1_end_xfer assignment, which is an e_assign
  HEX0_s1_end_xfer <= NOT ((HEX0_s1_waits_for_read OR HEX0_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_HEX0_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_HEX0_s1 <= HEX0_s1_end_xfer AND (((NOT HEX0_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --HEX0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  HEX0_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_HEX0_s1 AND HEX0_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_HEX0_s1 AND NOT HEX0_s1_non_bursting_master_requests));
  --HEX0_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      HEX0_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(HEX0_s1_arb_counter_enable) = '1' then 
        HEX0_s1_arb_share_counter <= HEX0_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --HEX0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      HEX0_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((HEX0_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_HEX0_s1)) OR ((end_xfer_arb_share_counter_term_HEX0_s1 AND NOT HEX0_s1_non_bursting_master_requests)))) = '1' then 
        HEX0_s1_slavearbiterlockenable <= HEX0_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master HEX0/s1 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= HEX0_s1_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --HEX0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  HEX0_s1_slavearbiterlockenable2 <= HEX0_s1_arb_share_counter_next_value;
  --cpu/data_master HEX0/s1 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= HEX0_s1_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --HEX0_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  HEX0_s1_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_HEX0_s1 <= internal_cpu_data_master_requests_HEX0_s1 AND NOT (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write));
  --HEX0_s1_writedata mux, which is an e_mux
  HEX0_s1_writedata <= cpu_data_master_writedata (6 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_data_master_granted_HEX0_s1 <= internal_cpu_data_master_qualified_request_HEX0_s1;
  --cpu/data_master saved-grant HEX0/s1, which is an e_assign
  cpu_data_master_saved_grant_HEX0_s1 <= internal_cpu_data_master_requests_HEX0_s1;
  --allow new arb cycle for HEX0/s1, which is an e_assign
  HEX0_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  HEX0_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  HEX0_s1_master_qreq_vector <= std_logic'('1');
  --HEX0_s1_reset_n assignment, which is an e_assign
  HEX0_s1_reset_n <= reset_n;
  HEX0_s1_chipselect <= internal_cpu_data_master_granted_HEX0_s1;
  --HEX0_s1_firsttransfer first transaction, which is an e_assign
  HEX0_s1_firsttransfer <= A_WE_StdLogic((std_logic'(HEX0_s1_begins_xfer) = '1'), HEX0_s1_unreg_firsttransfer, HEX0_s1_reg_firsttransfer);
  --HEX0_s1_unreg_firsttransfer first transaction, which is an e_assign
  HEX0_s1_unreg_firsttransfer <= NOT ((HEX0_s1_slavearbiterlockenable AND HEX0_s1_any_continuerequest));
  --HEX0_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      HEX0_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(HEX0_s1_begins_xfer) = '1' then 
        HEX0_s1_reg_firsttransfer <= HEX0_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --HEX0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  HEX0_s1_beginbursttransfer_internal <= HEX0_s1_begins_xfer;
  --~HEX0_s1_write_n assignment, which is an e_mux
  HEX0_s1_write_n <= NOT ((internal_cpu_data_master_granted_HEX0_s1 AND cpu_data_master_write));
  shifted_address_to_HEX0_s1_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --HEX0_s1_address mux, which is an e_mux
  HEX0_s1_address <= A_EXT (A_SRL(shifted_address_to_HEX0_s1_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_HEX0_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_HEX0_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_HEX0_s1_end_xfer <= HEX0_s1_end_xfer;
      end if;
    end if;

  end process;

  --HEX0_s1_waits_for_read in a cycle, which is an e_mux
  HEX0_s1_waits_for_read <= HEX0_s1_in_a_read_cycle AND HEX0_s1_begins_xfer;
  --HEX0_s1_in_a_read_cycle assignment, which is an e_assign
  HEX0_s1_in_a_read_cycle <= internal_cpu_data_master_granted_HEX0_s1 AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= HEX0_s1_in_a_read_cycle;
  --HEX0_s1_waits_for_write in a cycle, which is an e_mux
  HEX0_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(HEX0_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --HEX0_s1_in_a_write_cycle assignment, which is an e_assign
  HEX0_s1_in_a_write_cycle <= internal_cpu_data_master_granted_HEX0_s1 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= HEX0_s1_in_a_write_cycle;
  wait_for_HEX0_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_HEX0_s1 <= internal_cpu_data_master_granted_HEX0_s1;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_HEX0_s1 <= internal_cpu_data_master_qualified_request_HEX0_s1;
  --vhdl renameroo for output signals
  cpu_data_master_requests_HEX0_s1 <= internal_cpu_data_master_requests_HEX0_s1;
--synthesis translate_off
    --HEX0/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity HEX1_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal HEX1_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal HEX1_s1_chipselect : OUT STD_LOGIC;
                 signal HEX1_s1_reset_n : OUT STD_LOGIC;
                 signal HEX1_s1_write_n : OUT STD_LOGIC;
                 signal HEX1_s1_writedata : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
                 signal cpu_data_master_granted_HEX1_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_HEX1_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_HEX1_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_HEX1_s1 : OUT STD_LOGIC;
                 signal d1_HEX1_s1_end_xfer : OUT STD_LOGIC
              );
end entity HEX1_s1_arbitrator;


architecture europa of HEX1_s1_arbitrator is
                signal HEX1_s1_allgrants :  STD_LOGIC;
                signal HEX1_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal HEX1_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal HEX1_s1_any_continuerequest :  STD_LOGIC;
                signal HEX1_s1_arb_counter_enable :  STD_LOGIC;
                signal HEX1_s1_arb_share_counter :  STD_LOGIC;
                signal HEX1_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal HEX1_s1_arb_share_set_values :  STD_LOGIC;
                signal HEX1_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal HEX1_s1_begins_xfer :  STD_LOGIC;
                signal HEX1_s1_end_xfer :  STD_LOGIC;
                signal HEX1_s1_firsttransfer :  STD_LOGIC;
                signal HEX1_s1_grant_vector :  STD_LOGIC;
                signal HEX1_s1_in_a_read_cycle :  STD_LOGIC;
                signal HEX1_s1_in_a_write_cycle :  STD_LOGIC;
                signal HEX1_s1_master_qreq_vector :  STD_LOGIC;
                signal HEX1_s1_non_bursting_master_requests :  STD_LOGIC;
                signal HEX1_s1_reg_firsttransfer :  STD_LOGIC;
                signal HEX1_s1_slavearbiterlockenable :  STD_LOGIC;
                signal HEX1_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal HEX1_s1_unreg_firsttransfer :  STD_LOGIC;
                signal HEX1_s1_waits_for_read :  STD_LOGIC;
                signal HEX1_s1_waits_for_write :  STD_LOGIC;
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_HEX1_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_HEX1_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_HEX1_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_HEX1_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_HEX1_s1 :  STD_LOGIC;
                signal shifted_address_to_HEX1_s1_from_cpu_data_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal wait_for_HEX1_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT HEX1_s1_end_xfer;
      end if;
    end if;

  end process;

  HEX1_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_HEX1_s1);
  internal_cpu_data_master_requests_HEX1_s1 <= ((to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(18 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000001000010010000")))) AND ((cpu_data_master_read OR cpu_data_master_write)))) AND cpu_data_master_write;
  --HEX1_s1_arb_share_counter set values, which is an e_mux
  HEX1_s1_arb_share_set_values <= std_logic'('1');
  --HEX1_s1_non_bursting_master_requests mux, which is an e_mux
  HEX1_s1_non_bursting_master_requests <= internal_cpu_data_master_requests_HEX1_s1;
  --HEX1_s1_any_bursting_master_saved_grant mux, which is an e_mux
  HEX1_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --HEX1_s1_arb_share_counter_next_value assignment, which is an e_assign
  HEX1_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(HEX1_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(HEX1_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(HEX1_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(HEX1_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --HEX1_s1_allgrants all slave grants, which is an e_mux
  HEX1_s1_allgrants <= HEX1_s1_grant_vector;
  --HEX1_s1_end_xfer assignment, which is an e_assign
  HEX1_s1_end_xfer <= NOT ((HEX1_s1_waits_for_read OR HEX1_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_HEX1_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_HEX1_s1 <= HEX1_s1_end_xfer AND (((NOT HEX1_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --HEX1_s1_arb_share_counter arbitration counter enable, which is an e_assign
  HEX1_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_HEX1_s1 AND HEX1_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_HEX1_s1 AND NOT HEX1_s1_non_bursting_master_requests));
  --HEX1_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      HEX1_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(HEX1_s1_arb_counter_enable) = '1' then 
        HEX1_s1_arb_share_counter <= HEX1_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --HEX1_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      HEX1_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((HEX1_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_HEX1_s1)) OR ((end_xfer_arb_share_counter_term_HEX1_s1 AND NOT HEX1_s1_non_bursting_master_requests)))) = '1' then 
        HEX1_s1_slavearbiterlockenable <= HEX1_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master HEX1/s1 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= HEX1_s1_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --HEX1_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  HEX1_s1_slavearbiterlockenable2 <= HEX1_s1_arb_share_counter_next_value;
  --cpu/data_master HEX1/s1 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= HEX1_s1_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --HEX1_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  HEX1_s1_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_HEX1_s1 <= internal_cpu_data_master_requests_HEX1_s1 AND NOT (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write));
  --HEX1_s1_writedata mux, which is an e_mux
  HEX1_s1_writedata <= cpu_data_master_writedata (6 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_data_master_granted_HEX1_s1 <= internal_cpu_data_master_qualified_request_HEX1_s1;
  --cpu/data_master saved-grant HEX1/s1, which is an e_assign
  cpu_data_master_saved_grant_HEX1_s1 <= internal_cpu_data_master_requests_HEX1_s1;
  --allow new arb cycle for HEX1/s1, which is an e_assign
  HEX1_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  HEX1_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  HEX1_s1_master_qreq_vector <= std_logic'('1');
  --HEX1_s1_reset_n assignment, which is an e_assign
  HEX1_s1_reset_n <= reset_n;
  HEX1_s1_chipselect <= internal_cpu_data_master_granted_HEX1_s1;
  --HEX1_s1_firsttransfer first transaction, which is an e_assign
  HEX1_s1_firsttransfer <= A_WE_StdLogic((std_logic'(HEX1_s1_begins_xfer) = '1'), HEX1_s1_unreg_firsttransfer, HEX1_s1_reg_firsttransfer);
  --HEX1_s1_unreg_firsttransfer first transaction, which is an e_assign
  HEX1_s1_unreg_firsttransfer <= NOT ((HEX1_s1_slavearbiterlockenable AND HEX1_s1_any_continuerequest));
  --HEX1_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      HEX1_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(HEX1_s1_begins_xfer) = '1' then 
        HEX1_s1_reg_firsttransfer <= HEX1_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --HEX1_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  HEX1_s1_beginbursttransfer_internal <= HEX1_s1_begins_xfer;
  --~HEX1_s1_write_n assignment, which is an e_mux
  HEX1_s1_write_n <= NOT ((internal_cpu_data_master_granted_HEX1_s1 AND cpu_data_master_write));
  shifted_address_to_HEX1_s1_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --HEX1_s1_address mux, which is an e_mux
  HEX1_s1_address <= A_EXT (A_SRL(shifted_address_to_HEX1_s1_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_HEX1_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_HEX1_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_HEX1_s1_end_xfer <= HEX1_s1_end_xfer;
      end if;
    end if;

  end process;

  --HEX1_s1_waits_for_read in a cycle, which is an e_mux
  HEX1_s1_waits_for_read <= HEX1_s1_in_a_read_cycle AND HEX1_s1_begins_xfer;
  --HEX1_s1_in_a_read_cycle assignment, which is an e_assign
  HEX1_s1_in_a_read_cycle <= internal_cpu_data_master_granted_HEX1_s1 AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= HEX1_s1_in_a_read_cycle;
  --HEX1_s1_waits_for_write in a cycle, which is an e_mux
  HEX1_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(HEX1_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --HEX1_s1_in_a_write_cycle assignment, which is an e_assign
  HEX1_s1_in_a_write_cycle <= internal_cpu_data_master_granted_HEX1_s1 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= HEX1_s1_in_a_write_cycle;
  wait_for_HEX1_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_HEX1_s1 <= internal_cpu_data_master_granted_HEX1_s1;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_HEX1_s1 <= internal_cpu_data_master_qualified_request_HEX1_s1;
  --vhdl renameroo for output signals
  cpu_data_master_requests_HEX1_s1 <= internal_cpu_data_master_requests_HEX1_s1;
--synthesis translate_off
    --HEX1/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity HEX2_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal HEX2_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal HEX2_s1_chipselect : OUT STD_LOGIC;
                 signal HEX2_s1_reset_n : OUT STD_LOGIC;
                 signal HEX2_s1_write_n : OUT STD_LOGIC;
                 signal HEX2_s1_writedata : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
                 signal cpu_data_master_granted_HEX2_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_HEX2_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_HEX2_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_HEX2_s1 : OUT STD_LOGIC;
                 signal d1_HEX2_s1_end_xfer : OUT STD_LOGIC
              );
end entity HEX2_s1_arbitrator;


architecture europa of HEX2_s1_arbitrator is
                signal HEX2_s1_allgrants :  STD_LOGIC;
                signal HEX2_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal HEX2_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal HEX2_s1_any_continuerequest :  STD_LOGIC;
                signal HEX2_s1_arb_counter_enable :  STD_LOGIC;
                signal HEX2_s1_arb_share_counter :  STD_LOGIC;
                signal HEX2_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal HEX2_s1_arb_share_set_values :  STD_LOGIC;
                signal HEX2_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal HEX2_s1_begins_xfer :  STD_LOGIC;
                signal HEX2_s1_end_xfer :  STD_LOGIC;
                signal HEX2_s1_firsttransfer :  STD_LOGIC;
                signal HEX2_s1_grant_vector :  STD_LOGIC;
                signal HEX2_s1_in_a_read_cycle :  STD_LOGIC;
                signal HEX2_s1_in_a_write_cycle :  STD_LOGIC;
                signal HEX2_s1_master_qreq_vector :  STD_LOGIC;
                signal HEX2_s1_non_bursting_master_requests :  STD_LOGIC;
                signal HEX2_s1_reg_firsttransfer :  STD_LOGIC;
                signal HEX2_s1_slavearbiterlockenable :  STD_LOGIC;
                signal HEX2_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal HEX2_s1_unreg_firsttransfer :  STD_LOGIC;
                signal HEX2_s1_waits_for_read :  STD_LOGIC;
                signal HEX2_s1_waits_for_write :  STD_LOGIC;
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_HEX2_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_HEX2_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_HEX2_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_HEX2_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_HEX2_s1 :  STD_LOGIC;
                signal shifted_address_to_HEX2_s1_from_cpu_data_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal wait_for_HEX2_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT HEX2_s1_end_xfer;
      end if;
    end if;

  end process;

  HEX2_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_HEX2_s1);
  internal_cpu_data_master_requests_HEX2_s1 <= ((to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(18 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000001000010100000")))) AND ((cpu_data_master_read OR cpu_data_master_write)))) AND cpu_data_master_write;
  --HEX2_s1_arb_share_counter set values, which is an e_mux
  HEX2_s1_arb_share_set_values <= std_logic'('1');
  --HEX2_s1_non_bursting_master_requests mux, which is an e_mux
  HEX2_s1_non_bursting_master_requests <= internal_cpu_data_master_requests_HEX2_s1;
  --HEX2_s1_any_bursting_master_saved_grant mux, which is an e_mux
  HEX2_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --HEX2_s1_arb_share_counter_next_value assignment, which is an e_assign
  HEX2_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(HEX2_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(HEX2_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(HEX2_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(HEX2_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --HEX2_s1_allgrants all slave grants, which is an e_mux
  HEX2_s1_allgrants <= HEX2_s1_grant_vector;
  --HEX2_s1_end_xfer assignment, which is an e_assign
  HEX2_s1_end_xfer <= NOT ((HEX2_s1_waits_for_read OR HEX2_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_HEX2_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_HEX2_s1 <= HEX2_s1_end_xfer AND (((NOT HEX2_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --HEX2_s1_arb_share_counter arbitration counter enable, which is an e_assign
  HEX2_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_HEX2_s1 AND HEX2_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_HEX2_s1 AND NOT HEX2_s1_non_bursting_master_requests));
  --HEX2_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      HEX2_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(HEX2_s1_arb_counter_enable) = '1' then 
        HEX2_s1_arb_share_counter <= HEX2_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --HEX2_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      HEX2_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((HEX2_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_HEX2_s1)) OR ((end_xfer_arb_share_counter_term_HEX2_s1 AND NOT HEX2_s1_non_bursting_master_requests)))) = '1' then 
        HEX2_s1_slavearbiterlockenable <= HEX2_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master HEX2/s1 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= HEX2_s1_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --HEX2_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  HEX2_s1_slavearbiterlockenable2 <= HEX2_s1_arb_share_counter_next_value;
  --cpu/data_master HEX2/s1 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= HEX2_s1_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --HEX2_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  HEX2_s1_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_HEX2_s1 <= internal_cpu_data_master_requests_HEX2_s1 AND NOT (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write));
  --HEX2_s1_writedata mux, which is an e_mux
  HEX2_s1_writedata <= cpu_data_master_writedata (6 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_data_master_granted_HEX2_s1 <= internal_cpu_data_master_qualified_request_HEX2_s1;
  --cpu/data_master saved-grant HEX2/s1, which is an e_assign
  cpu_data_master_saved_grant_HEX2_s1 <= internal_cpu_data_master_requests_HEX2_s1;
  --allow new arb cycle for HEX2/s1, which is an e_assign
  HEX2_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  HEX2_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  HEX2_s1_master_qreq_vector <= std_logic'('1');
  --HEX2_s1_reset_n assignment, which is an e_assign
  HEX2_s1_reset_n <= reset_n;
  HEX2_s1_chipselect <= internal_cpu_data_master_granted_HEX2_s1;
  --HEX2_s1_firsttransfer first transaction, which is an e_assign
  HEX2_s1_firsttransfer <= A_WE_StdLogic((std_logic'(HEX2_s1_begins_xfer) = '1'), HEX2_s1_unreg_firsttransfer, HEX2_s1_reg_firsttransfer);
  --HEX2_s1_unreg_firsttransfer first transaction, which is an e_assign
  HEX2_s1_unreg_firsttransfer <= NOT ((HEX2_s1_slavearbiterlockenable AND HEX2_s1_any_continuerequest));
  --HEX2_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      HEX2_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(HEX2_s1_begins_xfer) = '1' then 
        HEX2_s1_reg_firsttransfer <= HEX2_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --HEX2_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  HEX2_s1_beginbursttransfer_internal <= HEX2_s1_begins_xfer;
  --~HEX2_s1_write_n assignment, which is an e_mux
  HEX2_s1_write_n <= NOT ((internal_cpu_data_master_granted_HEX2_s1 AND cpu_data_master_write));
  shifted_address_to_HEX2_s1_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --HEX2_s1_address mux, which is an e_mux
  HEX2_s1_address <= A_EXT (A_SRL(shifted_address_to_HEX2_s1_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_HEX2_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_HEX2_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_HEX2_s1_end_xfer <= HEX2_s1_end_xfer;
      end if;
    end if;

  end process;

  --HEX2_s1_waits_for_read in a cycle, which is an e_mux
  HEX2_s1_waits_for_read <= HEX2_s1_in_a_read_cycle AND HEX2_s1_begins_xfer;
  --HEX2_s1_in_a_read_cycle assignment, which is an e_assign
  HEX2_s1_in_a_read_cycle <= internal_cpu_data_master_granted_HEX2_s1 AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= HEX2_s1_in_a_read_cycle;
  --HEX2_s1_waits_for_write in a cycle, which is an e_mux
  HEX2_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(HEX2_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --HEX2_s1_in_a_write_cycle assignment, which is an e_assign
  HEX2_s1_in_a_write_cycle <= internal_cpu_data_master_granted_HEX2_s1 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= HEX2_s1_in_a_write_cycle;
  wait_for_HEX2_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_HEX2_s1 <= internal_cpu_data_master_granted_HEX2_s1;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_HEX2_s1 <= internal_cpu_data_master_qualified_request_HEX2_s1;
  --vhdl renameroo for output signals
  cpu_data_master_requests_HEX2_s1 <= internal_cpu_data_master_requests_HEX2_s1;
--synthesis translate_off
    --HEX2/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity HEX3_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal HEX3_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal HEX3_s1_chipselect : OUT STD_LOGIC;
                 signal HEX3_s1_reset_n : OUT STD_LOGIC;
                 signal HEX3_s1_write_n : OUT STD_LOGIC;
                 signal HEX3_s1_writedata : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
                 signal cpu_data_master_granted_HEX3_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_HEX3_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_HEX3_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_HEX3_s1 : OUT STD_LOGIC;
                 signal d1_HEX3_s1_end_xfer : OUT STD_LOGIC
              );
end entity HEX3_s1_arbitrator;


architecture europa of HEX3_s1_arbitrator is
                signal HEX3_s1_allgrants :  STD_LOGIC;
                signal HEX3_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal HEX3_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal HEX3_s1_any_continuerequest :  STD_LOGIC;
                signal HEX3_s1_arb_counter_enable :  STD_LOGIC;
                signal HEX3_s1_arb_share_counter :  STD_LOGIC;
                signal HEX3_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal HEX3_s1_arb_share_set_values :  STD_LOGIC;
                signal HEX3_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal HEX3_s1_begins_xfer :  STD_LOGIC;
                signal HEX3_s1_end_xfer :  STD_LOGIC;
                signal HEX3_s1_firsttransfer :  STD_LOGIC;
                signal HEX3_s1_grant_vector :  STD_LOGIC;
                signal HEX3_s1_in_a_read_cycle :  STD_LOGIC;
                signal HEX3_s1_in_a_write_cycle :  STD_LOGIC;
                signal HEX3_s1_master_qreq_vector :  STD_LOGIC;
                signal HEX3_s1_non_bursting_master_requests :  STD_LOGIC;
                signal HEX3_s1_reg_firsttransfer :  STD_LOGIC;
                signal HEX3_s1_slavearbiterlockenable :  STD_LOGIC;
                signal HEX3_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal HEX3_s1_unreg_firsttransfer :  STD_LOGIC;
                signal HEX3_s1_waits_for_read :  STD_LOGIC;
                signal HEX3_s1_waits_for_write :  STD_LOGIC;
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_HEX3_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_HEX3_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_HEX3_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_HEX3_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_HEX3_s1 :  STD_LOGIC;
                signal shifted_address_to_HEX3_s1_from_cpu_data_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal wait_for_HEX3_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT HEX3_s1_end_xfer;
      end if;
    end if;

  end process;

  HEX3_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_HEX3_s1);
  internal_cpu_data_master_requests_HEX3_s1 <= ((to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(18 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000001000010110000")))) AND ((cpu_data_master_read OR cpu_data_master_write)))) AND cpu_data_master_write;
  --HEX3_s1_arb_share_counter set values, which is an e_mux
  HEX3_s1_arb_share_set_values <= std_logic'('1');
  --HEX3_s1_non_bursting_master_requests mux, which is an e_mux
  HEX3_s1_non_bursting_master_requests <= internal_cpu_data_master_requests_HEX3_s1;
  --HEX3_s1_any_bursting_master_saved_grant mux, which is an e_mux
  HEX3_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --HEX3_s1_arb_share_counter_next_value assignment, which is an e_assign
  HEX3_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(HEX3_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(HEX3_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(HEX3_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(HEX3_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --HEX3_s1_allgrants all slave grants, which is an e_mux
  HEX3_s1_allgrants <= HEX3_s1_grant_vector;
  --HEX3_s1_end_xfer assignment, which is an e_assign
  HEX3_s1_end_xfer <= NOT ((HEX3_s1_waits_for_read OR HEX3_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_HEX3_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_HEX3_s1 <= HEX3_s1_end_xfer AND (((NOT HEX3_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --HEX3_s1_arb_share_counter arbitration counter enable, which is an e_assign
  HEX3_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_HEX3_s1 AND HEX3_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_HEX3_s1 AND NOT HEX3_s1_non_bursting_master_requests));
  --HEX3_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      HEX3_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(HEX3_s1_arb_counter_enable) = '1' then 
        HEX3_s1_arb_share_counter <= HEX3_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --HEX3_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      HEX3_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((HEX3_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_HEX3_s1)) OR ((end_xfer_arb_share_counter_term_HEX3_s1 AND NOT HEX3_s1_non_bursting_master_requests)))) = '1' then 
        HEX3_s1_slavearbiterlockenable <= HEX3_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master HEX3/s1 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= HEX3_s1_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --HEX3_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  HEX3_s1_slavearbiterlockenable2 <= HEX3_s1_arb_share_counter_next_value;
  --cpu/data_master HEX3/s1 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= HEX3_s1_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --HEX3_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  HEX3_s1_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_HEX3_s1 <= internal_cpu_data_master_requests_HEX3_s1 AND NOT (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write));
  --HEX3_s1_writedata mux, which is an e_mux
  HEX3_s1_writedata <= cpu_data_master_writedata (6 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_data_master_granted_HEX3_s1 <= internal_cpu_data_master_qualified_request_HEX3_s1;
  --cpu/data_master saved-grant HEX3/s1, which is an e_assign
  cpu_data_master_saved_grant_HEX3_s1 <= internal_cpu_data_master_requests_HEX3_s1;
  --allow new arb cycle for HEX3/s1, which is an e_assign
  HEX3_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  HEX3_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  HEX3_s1_master_qreq_vector <= std_logic'('1');
  --HEX3_s1_reset_n assignment, which is an e_assign
  HEX3_s1_reset_n <= reset_n;
  HEX3_s1_chipselect <= internal_cpu_data_master_granted_HEX3_s1;
  --HEX3_s1_firsttransfer first transaction, which is an e_assign
  HEX3_s1_firsttransfer <= A_WE_StdLogic((std_logic'(HEX3_s1_begins_xfer) = '1'), HEX3_s1_unreg_firsttransfer, HEX3_s1_reg_firsttransfer);
  --HEX3_s1_unreg_firsttransfer first transaction, which is an e_assign
  HEX3_s1_unreg_firsttransfer <= NOT ((HEX3_s1_slavearbiterlockenable AND HEX3_s1_any_continuerequest));
  --HEX3_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      HEX3_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(HEX3_s1_begins_xfer) = '1' then 
        HEX3_s1_reg_firsttransfer <= HEX3_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --HEX3_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  HEX3_s1_beginbursttransfer_internal <= HEX3_s1_begins_xfer;
  --~HEX3_s1_write_n assignment, which is an e_mux
  HEX3_s1_write_n <= NOT ((internal_cpu_data_master_granted_HEX3_s1 AND cpu_data_master_write));
  shifted_address_to_HEX3_s1_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --HEX3_s1_address mux, which is an e_mux
  HEX3_s1_address <= A_EXT (A_SRL(shifted_address_to_HEX3_s1_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_HEX3_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_HEX3_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_HEX3_s1_end_xfer <= HEX3_s1_end_xfer;
      end if;
    end if;

  end process;

  --HEX3_s1_waits_for_read in a cycle, which is an e_mux
  HEX3_s1_waits_for_read <= HEX3_s1_in_a_read_cycle AND HEX3_s1_begins_xfer;
  --HEX3_s1_in_a_read_cycle assignment, which is an e_assign
  HEX3_s1_in_a_read_cycle <= internal_cpu_data_master_granted_HEX3_s1 AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= HEX3_s1_in_a_read_cycle;
  --HEX3_s1_waits_for_write in a cycle, which is an e_mux
  HEX3_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(HEX3_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --HEX3_s1_in_a_write_cycle assignment, which is an e_assign
  HEX3_s1_in_a_write_cycle <= internal_cpu_data_master_granted_HEX3_s1 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= HEX3_s1_in_a_write_cycle;
  wait_for_HEX3_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_HEX3_s1 <= internal_cpu_data_master_granted_HEX3_s1;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_HEX3_s1 <= internal_cpu_data_master_qualified_request_HEX3_s1;
  --vhdl renameroo for output signals
  cpu_data_master_requests_HEX3_s1 <= internal_cpu_data_master_requests_HEX3_s1;
--synthesis translate_off
    --HEX3/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity HEX4_to_HEX7_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal HEX4_to_HEX7_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal HEX4_to_HEX7_s1_chipselect : OUT STD_LOGIC;
                 signal HEX4_to_HEX7_s1_reset_n : OUT STD_LOGIC;
                 signal HEX4_to_HEX7_s1_write_n : OUT STD_LOGIC;
                 signal HEX4_to_HEX7_s1_writedata : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
                 signal cpu_data_master_granted_HEX4_to_HEX7_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_HEX4_to_HEX7_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_HEX4_to_HEX7_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_HEX4_to_HEX7_s1 : OUT STD_LOGIC;
                 signal d1_HEX4_to_HEX7_s1_end_xfer : OUT STD_LOGIC
              );
end entity HEX4_to_HEX7_s1_arbitrator;


architecture europa of HEX4_to_HEX7_s1_arbitrator is
                signal HEX4_to_HEX7_s1_allgrants :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_any_continuerequest :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_arb_counter_enable :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_arb_share_counter :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_arb_share_set_values :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_begins_xfer :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_end_xfer :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_firsttransfer :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_grant_vector :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_in_a_read_cycle :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_in_a_write_cycle :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_master_qreq_vector :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_non_bursting_master_requests :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_reg_firsttransfer :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_slavearbiterlockenable :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_unreg_firsttransfer :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_waits_for_read :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_waits_for_write :  STD_LOGIC;
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_HEX4_to_HEX7_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_HEX4_to_HEX7_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_HEX4_to_HEX7_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_HEX4_to_HEX7_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_HEX4_to_HEX7_s1 :  STD_LOGIC;
                signal shifted_address_to_HEX4_to_HEX7_s1_from_cpu_data_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal wait_for_HEX4_to_HEX7_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT HEX4_to_HEX7_s1_end_xfer;
      end if;
    end if;

  end process;

  HEX4_to_HEX7_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_HEX4_to_HEX7_s1);
  internal_cpu_data_master_requests_HEX4_to_HEX7_s1 <= ((to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(18 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000001000011000000")))) AND ((cpu_data_master_read OR cpu_data_master_write)))) AND cpu_data_master_write;
  --HEX4_to_HEX7_s1_arb_share_counter set values, which is an e_mux
  HEX4_to_HEX7_s1_arb_share_set_values <= std_logic'('1');
  --HEX4_to_HEX7_s1_non_bursting_master_requests mux, which is an e_mux
  HEX4_to_HEX7_s1_non_bursting_master_requests <= internal_cpu_data_master_requests_HEX4_to_HEX7_s1;
  --HEX4_to_HEX7_s1_any_bursting_master_saved_grant mux, which is an e_mux
  HEX4_to_HEX7_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --HEX4_to_HEX7_s1_arb_share_counter_next_value assignment, which is an e_assign
  HEX4_to_HEX7_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(HEX4_to_HEX7_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(HEX4_to_HEX7_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(HEX4_to_HEX7_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(HEX4_to_HEX7_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --HEX4_to_HEX7_s1_allgrants all slave grants, which is an e_mux
  HEX4_to_HEX7_s1_allgrants <= HEX4_to_HEX7_s1_grant_vector;
  --HEX4_to_HEX7_s1_end_xfer assignment, which is an e_assign
  HEX4_to_HEX7_s1_end_xfer <= NOT ((HEX4_to_HEX7_s1_waits_for_read OR HEX4_to_HEX7_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_HEX4_to_HEX7_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_HEX4_to_HEX7_s1 <= HEX4_to_HEX7_s1_end_xfer AND (((NOT HEX4_to_HEX7_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --HEX4_to_HEX7_s1_arb_share_counter arbitration counter enable, which is an e_assign
  HEX4_to_HEX7_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_HEX4_to_HEX7_s1 AND HEX4_to_HEX7_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_HEX4_to_HEX7_s1 AND NOT HEX4_to_HEX7_s1_non_bursting_master_requests));
  --HEX4_to_HEX7_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      HEX4_to_HEX7_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(HEX4_to_HEX7_s1_arb_counter_enable) = '1' then 
        HEX4_to_HEX7_s1_arb_share_counter <= HEX4_to_HEX7_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --HEX4_to_HEX7_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      HEX4_to_HEX7_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((HEX4_to_HEX7_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_HEX4_to_HEX7_s1)) OR ((end_xfer_arb_share_counter_term_HEX4_to_HEX7_s1 AND NOT HEX4_to_HEX7_s1_non_bursting_master_requests)))) = '1' then 
        HEX4_to_HEX7_s1_slavearbiterlockenable <= HEX4_to_HEX7_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master HEX4_to_HEX7/s1 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= HEX4_to_HEX7_s1_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --HEX4_to_HEX7_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  HEX4_to_HEX7_s1_slavearbiterlockenable2 <= HEX4_to_HEX7_s1_arb_share_counter_next_value;
  --cpu/data_master HEX4_to_HEX7/s1 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= HEX4_to_HEX7_s1_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --HEX4_to_HEX7_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  HEX4_to_HEX7_s1_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_HEX4_to_HEX7_s1 <= internal_cpu_data_master_requests_HEX4_to_HEX7_s1 AND NOT (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write));
  --HEX4_to_HEX7_s1_writedata mux, which is an e_mux
  HEX4_to_HEX7_s1_writedata <= cpu_data_master_writedata (27 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_data_master_granted_HEX4_to_HEX7_s1 <= internal_cpu_data_master_qualified_request_HEX4_to_HEX7_s1;
  --cpu/data_master saved-grant HEX4_to_HEX7/s1, which is an e_assign
  cpu_data_master_saved_grant_HEX4_to_HEX7_s1 <= internal_cpu_data_master_requests_HEX4_to_HEX7_s1;
  --allow new arb cycle for HEX4_to_HEX7/s1, which is an e_assign
  HEX4_to_HEX7_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  HEX4_to_HEX7_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  HEX4_to_HEX7_s1_master_qreq_vector <= std_logic'('1');
  --HEX4_to_HEX7_s1_reset_n assignment, which is an e_assign
  HEX4_to_HEX7_s1_reset_n <= reset_n;
  HEX4_to_HEX7_s1_chipselect <= internal_cpu_data_master_granted_HEX4_to_HEX7_s1;
  --HEX4_to_HEX7_s1_firsttransfer first transaction, which is an e_assign
  HEX4_to_HEX7_s1_firsttransfer <= A_WE_StdLogic((std_logic'(HEX4_to_HEX7_s1_begins_xfer) = '1'), HEX4_to_HEX7_s1_unreg_firsttransfer, HEX4_to_HEX7_s1_reg_firsttransfer);
  --HEX4_to_HEX7_s1_unreg_firsttransfer first transaction, which is an e_assign
  HEX4_to_HEX7_s1_unreg_firsttransfer <= NOT ((HEX4_to_HEX7_s1_slavearbiterlockenable AND HEX4_to_HEX7_s1_any_continuerequest));
  --HEX4_to_HEX7_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      HEX4_to_HEX7_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(HEX4_to_HEX7_s1_begins_xfer) = '1' then 
        HEX4_to_HEX7_s1_reg_firsttransfer <= HEX4_to_HEX7_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --HEX4_to_HEX7_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  HEX4_to_HEX7_s1_beginbursttransfer_internal <= HEX4_to_HEX7_s1_begins_xfer;
  --~HEX4_to_HEX7_s1_write_n assignment, which is an e_mux
  HEX4_to_HEX7_s1_write_n <= NOT ((internal_cpu_data_master_granted_HEX4_to_HEX7_s1 AND cpu_data_master_write));
  shifted_address_to_HEX4_to_HEX7_s1_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --HEX4_to_HEX7_s1_address mux, which is an e_mux
  HEX4_to_HEX7_s1_address <= A_EXT (A_SRL(shifted_address_to_HEX4_to_HEX7_s1_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_HEX4_to_HEX7_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_HEX4_to_HEX7_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_HEX4_to_HEX7_s1_end_xfer <= HEX4_to_HEX7_s1_end_xfer;
      end if;
    end if;

  end process;

  --HEX4_to_HEX7_s1_waits_for_read in a cycle, which is an e_mux
  HEX4_to_HEX7_s1_waits_for_read <= HEX4_to_HEX7_s1_in_a_read_cycle AND HEX4_to_HEX7_s1_begins_xfer;
  --HEX4_to_HEX7_s1_in_a_read_cycle assignment, which is an e_assign
  HEX4_to_HEX7_s1_in_a_read_cycle <= internal_cpu_data_master_granted_HEX4_to_HEX7_s1 AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= HEX4_to_HEX7_s1_in_a_read_cycle;
  --HEX4_to_HEX7_s1_waits_for_write in a cycle, which is an e_mux
  HEX4_to_HEX7_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(HEX4_to_HEX7_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --HEX4_to_HEX7_s1_in_a_write_cycle assignment, which is an e_assign
  HEX4_to_HEX7_s1_in_a_write_cycle <= internal_cpu_data_master_granted_HEX4_to_HEX7_s1 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= HEX4_to_HEX7_s1_in_a_write_cycle;
  wait_for_HEX4_to_HEX7_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_HEX4_to_HEX7_s1 <= internal_cpu_data_master_granted_HEX4_to_HEX7_s1;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_HEX4_to_HEX7_s1 <= internal_cpu_data_master_qualified_request_HEX4_to_HEX7_s1;
  --vhdl renameroo for output signals
  cpu_data_master_requests_HEX4_to_HEX7_s1 <= internal_cpu_data_master_requests_HEX4_to_HEX7_s1;
--synthesis translate_off
    --HEX4_to_HEX7/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity KEYS_s1_arbitrator is 
        port (
              -- inputs:
                 signal KEYS_s1_readdata : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal KEYS_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal KEYS_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal KEYS_s1_reset_n : OUT STD_LOGIC;
                 signal cpu_data_master_granted_KEYS_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_KEYS_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_KEYS_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_KEYS_s1 : OUT STD_LOGIC;
                 signal d1_KEYS_s1_end_xfer : OUT STD_LOGIC
              );
end entity KEYS_s1_arbitrator;


architecture europa of KEYS_s1_arbitrator is
                signal KEYS_s1_allgrants :  STD_LOGIC;
                signal KEYS_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal KEYS_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal KEYS_s1_any_continuerequest :  STD_LOGIC;
                signal KEYS_s1_arb_counter_enable :  STD_LOGIC;
                signal KEYS_s1_arb_share_counter :  STD_LOGIC;
                signal KEYS_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal KEYS_s1_arb_share_set_values :  STD_LOGIC;
                signal KEYS_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal KEYS_s1_begins_xfer :  STD_LOGIC;
                signal KEYS_s1_end_xfer :  STD_LOGIC;
                signal KEYS_s1_firsttransfer :  STD_LOGIC;
                signal KEYS_s1_grant_vector :  STD_LOGIC;
                signal KEYS_s1_in_a_read_cycle :  STD_LOGIC;
                signal KEYS_s1_in_a_write_cycle :  STD_LOGIC;
                signal KEYS_s1_master_qreq_vector :  STD_LOGIC;
                signal KEYS_s1_non_bursting_master_requests :  STD_LOGIC;
                signal KEYS_s1_reg_firsttransfer :  STD_LOGIC;
                signal KEYS_s1_slavearbiterlockenable :  STD_LOGIC;
                signal KEYS_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal KEYS_s1_unreg_firsttransfer :  STD_LOGIC;
                signal KEYS_s1_waits_for_read :  STD_LOGIC;
                signal KEYS_s1_waits_for_write :  STD_LOGIC;
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_KEYS_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_KEYS_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_KEYS_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_KEYS_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_KEYS_s1 :  STD_LOGIC;
                signal shifted_address_to_KEYS_s1_from_cpu_data_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal wait_for_KEYS_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT KEYS_s1_end_xfer;
      end if;
    end if;

  end process;

  KEYS_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_KEYS_s1);
  --assign KEYS_s1_readdata_from_sa = KEYS_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  KEYS_s1_readdata_from_sa <= KEYS_s1_readdata;
  internal_cpu_data_master_requests_KEYS_s1 <= ((to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(18 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000001000001100000")))) AND ((cpu_data_master_read OR cpu_data_master_write)))) AND cpu_data_master_read;
  --KEYS_s1_arb_share_counter set values, which is an e_mux
  KEYS_s1_arb_share_set_values <= std_logic'('1');
  --KEYS_s1_non_bursting_master_requests mux, which is an e_mux
  KEYS_s1_non_bursting_master_requests <= internal_cpu_data_master_requests_KEYS_s1;
  --KEYS_s1_any_bursting_master_saved_grant mux, which is an e_mux
  KEYS_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --KEYS_s1_arb_share_counter_next_value assignment, which is an e_assign
  KEYS_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(KEYS_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(KEYS_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(KEYS_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(KEYS_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --KEYS_s1_allgrants all slave grants, which is an e_mux
  KEYS_s1_allgrants <= KEYS_s1_grant_vector;
  --KEYS_s1_end_xfer assignment, which is an e_assign
  KEYS_s1_end_xfer <= NOT ((KEYS_s1_waits_for_read OR KEYS_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_KEYS_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_KEYS_s1 <= KEYS_s1_end_xfer AND (((NOT KEYS_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --KEYS_s1_arb_share_counter arbitration counter enable, which is an e_assign
  KEYS_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_KEYS_s1 AND KEYS_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_KEYS_s1 AND NOT KEYS_s1_non_bursting_master_requests));
  --KEYS_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      KEYS_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(KEYS_s1_arb_counter_enable) = '1' then 
        KEYS_s1_arb_share_counter <= KEYS_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --KEYS_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      KEYS_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((KEYS_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_KEYS_s1)) OR ((end_xfer_arb_share_counter_term_KEYS_s1 AND NOT KEYS_s1_non_bursting_master_requests)))) = '1' then 
        KEYS_s1_slavearbiterlockenable <= KEYS_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master KEYS/s1 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= KEYS_s1_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --KEYS_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  KEYS_s1_slavearbiterlockenable2 <= KEYS_s1_arb_share_counter_next_value;
  --cpu/data_master KEYS/s1 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= KEYS_s1_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --KEYS_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  KEYS_s1_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_KEYS_s1 <= internal_cpu_data_master_requests_KEYS_s1;
  --master is always granted when requested
  internal_cpu_data_master_granted_KEYS_s1 <= internal_cpu_data_master_qualified_request_KEYS_s1;
  --cpu/data_master saved-grant KEYS/s1, which is an e_assign
  cpu_data_master_saved_grant_KEYS_s1 <= internal_cpu_data_master_requests_KEYS_s1;
  --allow new arb cycle for KEYS/s1, which is an e_assign
  KEYS_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  KEYS_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  KEYS_s1_master_qreq_vector <= std_logic'('1');
  --KEYS_s1_reset_n assignment, which is an e_assign
  KEYS_s1_reset_n <= reset_n;
  --KEYS_s1_firsttransfer first transaction, which is an e_assign
  KEYS_s1_firsttransfer <= A_WE_StdLogic((std_logic'(KEYS_s1_begins_xfer) = '1'), KEYS_s1_unreg_firsttransfer, KEYS_s1_reg_firsttransfer);
  --KEYS_s1_unreg_firsttransfer first transaction, which is an e_assign
  KEYS_s1_unreg_firsttransfer <= NOT ((KEYS_s1_slavearbiterlockenable AND KEYS_s1_any_continuerequest));
  --KEYS_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      KEYS_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(KEYS_s1_begins_xfer) = '1' then 
        KEYS_s1_reg_firsttransfer <= KEYS_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --KEYS_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  KEYS_s1_beginbursttransfer_internal <= KEYS_s1_begins_xfer;
  shifted_address_to_KEYS_s1_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --KEYS_s1_address mux, which is an e_mux
  KEYS_s1_address <= A_EXT (A_SRL(shifted_address_to_KEYS_s1_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_KEYS_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_KEYS_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_KEYS_s1_end_xfer <= KEYS_s1_end_xfer;
      end if;
    end if;

  end process;

  --KEYS_s1_waits_for_read in a cycle, which is an e_mux
  KEYS_s1_waits_for_read <= KEYS_s1_in_a_read_cycle AND KEYS_s1_begins_xfer;
  --KEYS_s1_in_a_read_cycle assignment, which is an e_assign
  KEYS_s1_in_a_read_cycle <= internal_cpu_data_master_granted_KEYS_s1 AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= KEYS_s1_in_a_read_cycle;
  --KEYS_s1_waits_for_write in a cycle, which is an e_mux
  KEYS_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(KEYS_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --KEYS_s1_in_a_write_cycle assignment, which is an e_assign
  KEYS_s1_in_a_write_cycle <= internal_cpu_data_master_granted_KEYS_s1 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= KEYS_s1_in_a_write_cycle;
  wait_for_KEYS_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_KEYS_s1 <= internal_cpu_data_master_granted_KEYS_s1;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_KEYS_s1 <= internal_cpu_data_master_qualified_request_KEYS_s1;
  --vhdl renameroo for output signals
  cpu_data_master_requests_KEYS_s1 <= internal_cpu_data_master_requests_KEYS_s1;
--synthesis translate_off
    --KEYS/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SWITCHS_s1_arbitrator is 
        port (
              -- inputs:
                 signal SWITCHS_s1_readdata : IN STD_LOGIC_VECTOR (17 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal SWITCHS_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal SWITCHS_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                 signal SWITCHS_s1_reset_n : OUT STD_LOGIC;
                 signal cpu_data_master_granted_SWITCHS_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_SWITCHS_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_SWITCHS_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_SWITCHS_s1 : OUT STD_LOGIC;
                 signal d1_SWITCHS_s1_end_xfer : OUT STD_LOGIC
              );
end entity SWITCHS_s1_arbitrator;


architecture europa of SWITCHS_s1_arbitrator is
                signal SWITCHS_s1_allgrants :  STD_LOGIC;
                signal SWITCHS_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal SWITCHS_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal SWITCHS_s1_any_continuerequest :  STD_LOGIC;
                signal SWITCHS_s1_arb_counter_enable :  STD_LOGIC;
                signal SWITCHS_s1_arb_share_counter :  STD_LOGIC;
                signal SWITCHS_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal SWITCHS_s1_arb_share_set_values :  STD_LOGIC;
                signal SWITCHS_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal SWITCHS_s1_begins_xfer :  STD_LOGIC;
                signal SWITCHS_s1_end_xfer :  STD_LOGIC;
                signal SWITCHS_s1_firsttransfer :  STD_LOGIC;
                signal SWITCHS_s1_grant_vector :  STD_LOGIC;
                signal SWITCHS_s1_in_a_read_cycle :  STD_LOGIC;
                signal SWITCHS_s1_in_a_write_cycle :  STD_LOGIC;
                signal SWITCHS_s1_master_qreq_vector :  STD_LOGIC;
                signal SWITCHS_s1_non_bursting_master_requests :  STD_LOGIC;
                signal SWITCHS_s1_reg_firsttransfer :  STD_LOGIC;
                signal SWITCHS_s1_slavearbiterlockenable :  STD_LOGIC;
                signal SWITCHS_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal SWITCHS_s1_unreg_firsttransfer :  STD_LOGIC;
                signal SWITCHS_s1_waits_for_read :  STD_LOGIC;
                signal SWITCHS_s1_waits_for_write :  STD_LOGIC;
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_SWITCHS_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_SWITCHS_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_SWITCHS_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_SWITCHS_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_SWITCHS_s1 :  STD_LOGIC;
                signal shifted_address_to_SWITCHS_s1_from_cpu_data_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal wait_for_SWITCHS_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT SWITCHS_s1_end_xfer;
      end if;
    end if;

  end process;

  SWITCHS_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_SWITCHS_s1);
  --assign SWITCHS_s1_readdata_from_sa = SWITCHS_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  SWITCHS_s1_readdata_from_sa <= SWITCHS_s1_readdata;
  internal_cpu_data_master_requests_SWITCHS_s1 <= ((to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(18 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000001000001110000")))) AND ((cpu_data_master_read OR cpu_data_master_write)))) AND cpu_data_master_read;
  --SWITCHS_s1_arb_share_counter set values, which is an e_mux
  SWITCHS_s1_arb_share_set_values <= std_logic'('1');
  --SWITCHS_s1_non_bursting_master_requests mux, which is an e_mux
  SWITCHS_s1_non_bursting_master_requests <= internal_cpu_data_master_requests_SWITCHS_s1;
  --SWITCHS_s1_any_bursting_master_saved_grant mux, which is an e_mux
  SWITCHS_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --SWITCHS_s1_arb_share_counter_next_value assignment, which is an e_assign
  SWITCHS_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(SWITCHS_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(SWITCHS_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(SWITCHS_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(SWITCHS_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --SWITCHS_s1_allgrants all slave grants, which is an e_mux
  SWITCHS_s1_allgrants <= SWITCHS_s1_grant_vector;
  --SWITCHS_s1_end_xfer assignment, which is an e_assign
  SWITCHS_s1_end_xfer <= NOT ((SWITCHS_s1_waits_for_read OR SWITCHS_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_SWITCHS_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_SWITCHS_s1 <= SWITCHS_s1_end_xfer AND (((NOT SWITCHS_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --SWITCHS_s1_arb_share_counter arbitration counter enable, which is an e_assign
  SWITCHS_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_SWITCHS_s1 AND SWITCHS_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_SWITCHS_s1 AND NOT SWITCHS_s1_non_bursting_master_requests));
  --SWITCHS_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      SWITCHS_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(SWITCHS_s1_arb_counter_enable) = '1' then 
        SWITCHS_s1_arb_share_counter <= SWITCHS_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --SWITCHS_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      SWITCHS_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((SWITCHS_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_SWITCHS_s1)) OR ((end_xfer_arb_share_counter_term_SWITCHS_s1 AND NOT SWITCHS_s1_non_bursting_master_requests)))) = '1' then 
        SWITCHS_s1_slavearbiterlockenable <= SWITCHS_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master SWITCHS/s1 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= SWITCHS_s1_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --SWITCHS_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  SWITCHS_s1_slavearbiterlockenable2 <= SWITCHS_s1_arb_share_counter_next_value;
  --cpu/data_master SWITCHS/s1 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= SWITCHS_s1_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --SWITCHS_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  SWITCHS_s1_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_SWITCHS_s1 <= internal_cpu_data_master_requests_SWITCHS_s1;
  --master is always granted when requested
  internal_cpu_data_master_granted_SWITCHS_s1 <= internal_cpu_data_master_qualified_request_SWITCHS_s1;
  --cpu/data_master saved-grant SWITCHS/s1, which is an e_assign
  cpu_data_master_saved_grant_SWITCHS_s1 <= internal_cpu_data_master_requests_SWITCHS_s1;
  --allow new arb cycle for SWITCHS/s1, which is an e_assign
  SWITCHS_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  SWITCHS_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  SWITCHS_s1_master_qreq_vector <= std_logic'('1');
  --SWITCHS_s1_reset_n assignment, which is an e_assign
  SWITCHS_s1_reset_n <= reset_n;
  --SWITCHS_s1_firsttransfer first transaction, which is an e_assign
  SWITCHS_s1_firsttransfer <= A_WE_StdLogic((std_logic'(SWITCHS_s1_begins_xfer) = '1'), SWITCHS_s1_unreg_firsttransfer, SWITCHS_s1_reg_firsttransfer);
  --SWITCHS_s1_unreg_firsttransfer first transaction, which is an e_assign
  SWITCHS_s1_unreg_firsttransfer <= NOT ((SWITCHS_s1_slavearbiterlockenable AND SWITCHS_s1_any_continuerequest));
  --SWITCHS_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      SWITCHS_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(SWITCHS_s1_begins_xfer) = '1' then 
        SWITCHS_s1_reg_firsttransfer <= SWITCHS_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --SWITCHS_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  SWITCHS_s1_beginbursttransfer_internal <= SWITCHS_s1_begins_xfer;
  shifted_address_to_SWITCHS_s1_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --SWITCHS_s1_address mux, which is an e_mux
  SWITCHS_s1_address <= A_EXT (A_SRL(shifted_address_to_SWITCHS_s1_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_SWITCHS_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_SWITCHS_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_SWITCHS_s1_end_xfer <= SWITCHS_s1_end_xfer;
      end if;
    end if;

  end process;

  --SWITCHS_s1_waits_for_read in a cycle, which is an e_mux
  SWITCHS_s1_waits_for_read <= SWITCHS_s1_in_a_read_cycle AND SWITCHS_s1_begins_xfer;
  --SWITCHS_s1_in_a_read_cycle assignment, which is an e_assign
  SWITCHS_s1_in_a_read_cycle <= internal_cpu_data_master_granted_SWITCHS_s1 AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= SWITCHS_s1_in_a_read_cycle;
  --SWITCHS_s1_waits_for_write in a cycle, which is an e_mux
  SWITCHS_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(SWITCHS_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --SWITCHS_s1_in_a_write_cycle assignment, which is an e_assign
  SWITCHS_s1_in_a_write_cycle <= internal_cpu_data_master_granted_SWITCHS_s1 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= SWITCHS_s1_in_a_write_cycle;
  wait_for_SWITCHS_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_SWITCHS_s1 <= internal_cpu_data_master_granted_SWITCHS_s1;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_SWITCHS_s1 <= internal_cpu_data_master_qualified_request_SWITCHS_s1;
  --vhdl renameroo for output signals
  cpu_data_master_requests_SWITCHS_s1 <= internal_cpu_data_master_requests_SWITCHS_s1;
--synthesis translate_off
    --SWITCHS/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity cpu_jtag_debug_module_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_data_master_debugaccess : IN STD_LOGIC;
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_instruction_master_latency_counter : IN STD_LOGIC;
                 signal cpu_instruction_master_read : IN STD_LOGIC;
                 signal cpu_jtag_debug_module_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_jtag_debug_module_resetrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_data_master_requests_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_instruction_master_granted_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_instruction_master_requests_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_address : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                 signal cpu_jtag_debug_module_begintransfer : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_jtag_debug_module_chipselect : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_debugaccess : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_jtag_debug_module_reset : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_reset_n : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_resetrequest_from_sa : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_write : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_cpu_jtag_debug_module_end_xfer : OUT STD_LOGIC
              );
end entity cpu_jtag_debug_module_arbitrator;


architecture europa of cpu_jtag_debug_module_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_instruction_master_continuerequest :  STD_LOGIC;
                signal cpu_instruction_master_saved_grant_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_jtag_debug_module_allgrants :  STD_LOGIC;
                signal cpu_jtag_debug_module_allow_new_arb_cycle :  STD_LOGIC;
                signal cpu_jtag_debug_module_any_bursting_master_saved_grant :  STD_LOGIC;
                signal cpu_jtag_debug_module_any_continuerequest :  STD_LOGIC;
                signal cpu_jtag_debug_module_arb_addend :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_arb_counter_enable :  STD_LOGIC;
                signal cpu_jtag_debug_module_arb_share_counter :  STD_LOGIC;
                signal cpu_jtag_debug_module_arb_share_counter_next_value :  STD_LOGIC;
                signal cpu_jtag_debug_module_arb_share_set_values :  STD_LOGIC;
                signal cpu_jtag_debug_module_arb_winner :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_arbitration_holdoff_internal :  STD_LOGIC;
                signal cpu_jtag_debug_module_beginbursttransfer_internal :  STD_LOGIC;
                signal cpu_jtag_debug_module_begins_xfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_chosen_master_double_vector :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_jtag_debug_module_chosen_master_rot_left :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_end_xfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_firsttransfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_grant_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_in_a_read_cycle :  STD_LOGIC;
                signal cpu_jtag_debug_module_in_a_write_cycle :  STD_LOGIC;
                signal cpu_jtag_debug_module_master_qreq_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_non_bursting_master_requests :  STD_LOGIC;
                signal cpu_jtag_debug_module_reg_firsttransfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_saved_chosen_master_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_slavearbiterlockenable :  STD_LOGIC;
                signal cpu_jtag_debug_module_slavearbiterlockenable2 :  STD_LOGIC;
                signal cpu_jtag_debug_module_unreg_firsttransfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_waits_for_read :  STD_LOGIC;
                signal cpu_jtag_debug_module_waits_for_write :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_cpu_jtag_debug_module :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_data_master_requests_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_instruction_master_granted_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_instruction_master_requests_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_jtag_debug_module_reset_n :  STD_LOGIC;
                signal last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module :  STD_LOGIC;
                signal last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module :  STD_LOGIC;
                signal shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal wait_for_cpu_jtag_debug_module_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT cpu_jtag_debug_module_end_xfer;
      end if;
    end if;

  end process;

  cpu_jtag_debug_module_begins_xfer <= NOT d1_reasons_to_wait AND ((internal_cpu_data_master_qualified_request_cpu_jtag_debug_module OR internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module));
  --assign cpu_jtag_debug_module_readdata_from_sa = cpu_jtag_debug_module_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  cpu_jtag_debug_module_readdata_from_sa <= cpu_jtag_debug_module_readdata;
  internal_cpu_data_master_requests_cpu_jtag_debug_module <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(18 DOWNTO 11) & std_logic_vector'("00000000000")) = std_logic_vector'("1000000100000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --cpu_jtag_debug_module_arb_share_counter set values, which is an e_mux
  cpu_jtag_debug_module_arb_share_set_values <= std_logic'('1');
  --cpu_jtag_debug_module_non_bursting_master_requests mux, which is an e_mux
  cpu_jtag_debug_module_non_bursting_master_requests <= ((internal_cpu_data_master_requests_cpu_jtag_debug_module OR internal_cpu_instruction_master_requests_cpu_jtag_debug_module) OR internal_cpu_data_master_requests_cpu_jtag_debug_module) OR internal_cpu_instruction_master_requests_cpu_jtag_debug_module;
  --cpu_jtag_debug_module_any_bursting_master_saved_grant mux, which is an e_mux
  cpu_jtag_debug_module_any_bursting_master_saved_grant <= std_logic'('0');
  --cpu_jtag_debug_module_arb_share_counter_next_value assignment, which is an e_assign
  cpu_jtag_debug_module_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_jtag_debug_module_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_jtag_debug_module_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(cpu_jtag_debug_module_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_jtag_debug_module_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --cpu_jtag_debug_module_allgrants all slave grants, which is an e_mux
  cpu_jtag_debug_module_allgrants <= ((or_reduce(cpu_jtag_debug_module_grant_vector) OR or_reduce(cpu_jtag_debug_module_grant_vector)) OR or_reduce(cpu_jtag_debug_module_grant_vector)) OR or_reduce(cpu_jtag_debug_module_grant_vector);
  --cpu_jtag_debug_module_end_xfer assignment, which is an e_assign
  cpu_jtag_debug_module_end_xfer <= NOT ((cpu_jtag_debug_module_waits_for_read OR cpu_jtag_debug_module_waits_for_write));
  --end_xfer_arb_share_counter_term_cpu_jtag_debug_module arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_cpu_jtag_debug_module <= cpu_jtag_debug_module_end_xfer AND (((NOT cpu_jtag_debug_module_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --cpu_jtag_debug_module_arb_share_counter arbitration counter enable, which is an e_assign
  cpu_jtag_debug_module_arb_counter_enable <= ((end_xfer_arb_share_counter_term_cpu_jtag_debug_module AND cpu_jtag_debug_module_allgrants)) OR ((end_xfer_arb_share_counter_term_cpu_jtag_debug_module AND NOT cpu_jtag_debug_module_non_bursting_master_requests));
  --cpu_jtag_debug_module_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_jtag_debug_module_arb_counter_enable) = '1' then 
        cpu_jtag_debug_module_arb_share_counter <= cpu_jtag_debug_module_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu_jtag_debug_module_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((or_reduce(cpu_jtag_debug_module_master_qreq_vector) AND end_xfer_arb_share_counter_term_cpu_jtag_debug_module)) OR ((end_xfer_arb_share_counter_term_cpu_jtag_debug_module AND NOT cpu_jtag_debug_module_non_bursting_master_requests)))) = '1' then 
        cpu_jtag_debug_module_slavearbiterlockenable <= cpu_jtag_debug_module_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master cpu/jtag_debug_module arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= cpu_jtag_debug_module_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --cpu_jtag_debug_module_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  cpu_jtag_debug_module_slavearbiterlockenable2 <= cpu_jtag_debug_module_arb_share_counter_next_value;
  --cpu/data_master cpu/jtag_debug_module arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= cpu_jtag_debug_module_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --cpu/instruction_master cpu/jtag_debug_module arbiterlock, which is an e_assign
  cpu_instruction_master_arbiterlock <= cpu_jtag_debug_module_slavearbiterlockenable AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master cpu/jtag_debug_module arbiterlock2, which is an e_assign
  cpu_instruction_master_arbiterlock2 <= cpu_jtag_debug_module_slavearbiterlockenable2 AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master granted cpu/jtag_debug_module last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_instruction_master_saved_grant_cpu_jtag_debug_module) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((cpu_jtag_debug_module_arbitration_holdoff_internal OR NOT internal_cpu_instruction_master_requests_cpu_jtag_debug_module))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module))))));
      end if;
    end if;

  end process;

  --cpu_instruction_master_continuerequest continued request, which is an e_mux
  cpu_instruction_master_continuerequest <= last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module AND internal_cpu_instruction_master_requests_cpu_jtag_debug_module;
  --cpu_jtag_debug_module_any_continuerequest at least one master continues requesting, which is an e_mux
  cpu_jtag_debug_module_any_continuerequest <= cpu_instruction_master_continuerequest OR cpu_data_master_continuerequest;
  internal_cpu_data_master_qualified_request_cpu_jtag_debug_module <= internal_cpu_data_master_requests_cpu_jtag_debug_module AND NOT (((((NOT cpu_data_master_waitrequest) AND cpu_data_master_write)) OR cpu_instruction_master_arbiterlock));
  --cpu_jtag_debug_module_writedata mux, which is an e_mux
  cpu_jtag_debug_module_writedata <= cpu_data_master_writedata;
  internal_cpu_instruction_master_requests_cpu_jtag_debug_module <= ((to_std_logic(((Std_Logic_Vector'(cpu_instruction_master_address_to_slave(18 DOWNTO 11) & std_logic_vector'("00000000000")) = std_logic_vector'("1000000100000000000")))) AND (cpu_instruction_master_read))) AND cpu_instruction_master_read;
  --cpu/data_master granted cpu/jtag_debug_module last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_data_master_saved_grant_cpu_jtag_debug_module) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((cpu_jtag_debug_module_arbitration_holdoff_internal OR NOT internal_cpu_data_master_requests_cpu_jtag_debug_module))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module))))));
      end if;
    end if;

  end process;

  --cpu_data_master_continuerequest continued request, which is an e_mux
  cpu_data_master_continuerequest <= last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module AND internal_cpu_data_master_requests_cpu_jtag_debug_module;
  internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module <= internal_cpu_instruction_master_requests_cpu_jtag_debug_module AND NOT ((((cpu_instruction_master_read AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_latency_counter))) /= std_logic_vector'("00000000000000000000000000000000")))))) OR cpu_data_master_arbiterlock));
  --local readdatavalid cpu_instruction_master_read_data_valid_cpu_jtag_debug_module, which is an e_mux
  cpu_instruction_master_read_data_valid_cpu_jtag_debug_module <= (internal_cpu_instruction_master_granted_cpu_jtag_debug_module AND cpu_instruction_master_read) AND NOT cpu_jtag_debug_module_waits_for_read;
  --allow new arb cycle for cpu/jtag_debug_module, which is an e_assign
  cpu_jtag_debug_module_allow_new_arb_cycle <= NOT cpu_data_master_arbiterlock AND NOT cpu_instruction_master_arbiterlock;
  --cpu/instruction_master assignment into master qualified-requests vector for cpu/jtag_debug_module, which is an e_assign
  cpu_jtag_debug_module_master_qreq_vector(0) <= internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module;
  --cpu/instruction_master grant cpu/jtag_debug_module, which is an e_assign
  internal_cpu_instruction_master_granted_cpu_jtag_debug_module <= cpu_jtag_debug_module_grant_vector(0);
  --cpu/instruction_master saved-grant cpu/jtag_debug_module, which is an e_assign
  cpu_instruction_master_saved_grant_cpu_jtag_debug_module <= cpu_jtag_debug_module_arb_winner(0) AND internal_cpu_instruction_master_requests_cpu_jtag_debug_module;
  --cpu/data_master assignment into master qualified-requests vector for cpu/jtag_debug_module, which is an e_assign
  cpu_jtag_debug_module_master_qreq_vector(1) <= internal_cpu_data_master_qualified_request_cpu_jtag_debug_module;
  --cpu/data_master grant cpu/jtag_debug_module, which is an e_assign
  internal_cpu_data_master_granted_cpu_jtag_debug_module <= cpu_jtag_debug_module_grant_vector(1);
  --cpu/data_master saved-grant cpu/jtag_debug_module, which is an e_assign
  cpu_data_master_saved_grant_cpu_jtag_debug_module <= cpu_jtag_debug_module_arb_winner(1) AND internal_cpu_data_master_requests_cpu_jtag_debug_module;
  --cpu/jtag_debug_module chosen-master double-vector, which is an e_assign
  cpu_jtag_debug_module_chosen_master_double_vector <= A_EXT (((std_logic_vector'("0") & ((cpu_jtag_debug_module_master_qreq_vector & cpu_jtag_debug_module_master_qreq_vector))) AND (((std_logic_vector'("0") & (Std_Logic_Vector'(NOT cpu_jtag_debug_module_master_qreq_vector & NOT cpu_jtag_debug_module_master_qreq_vector))) + (std_logic_vector'("000") & (cpu_jtag_debug_module_arb_addend))))), 4);
  --stable onehot encoding of arb winner
  cpu_jtag_debug_module_arb_winner <= A_WE_StdLogicVector((std_logic'(((cpu_jtag_debug_module_allow_new_arb_cycle AND or_reduce(cpu_jtag_debug_module_grant_vector)))) = '1'), cpu_jtag_debug_module_grant_vector, cpu_jtag_debug_module_saved_chosen_master_vector);
  --saved cpu_jtag_debug_module_grant_vector, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_saved_chosen_master_vector <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_jtag_debug_module_allow_new_arb_cycle) = '1' then 
        cpu_jtag_debug_module_saved_chosen_master_vector <= A_WE_StdLogicVector((std_logic'(or_reduce(cpu_jtag_debug_module_grant_vector)) = '1'), cpu_jtag_debug_module_grant_vector, cpu_jtag_debug_module_saved_chosen_master_vector);
      end if;
    end if;

  end process;

  --onehot encoding of chosen master
  cpu_jtag_debug_module_grant_vector <= Std_Logic_Vector'(A_ToStdLogicVector(((cpu_jtag_debug_module_chosen_master_double_vector(1) OR cpu_jtag_debug_module_chosen_master_double_vector(3)))) & A_ToStdLogicVector(((cpu_jtag_debug_module_chosen_master_double_vector(0) OR cpu_jtag_debug_module_chosen_master_double_vector(2)))));
  --cpu/jtag_debug_module chosen master rotated left, which is an e_assign
  cpu_jtag_debug_module_chosen_master_rot_left <= A_EXT (A_WE_StdLogicVector((((A_SLL(cpu_jtag_debug_module_arb_winner,std_logic_vector'("00000000000000000000000000000001")))) /= std_logic_vector'("00")), (std_logic_vector'("000000000000000000000000000000") & ((A_SLL(cpu_jtag_debug_module_arb_winner,std_logic_vector'("00000000000000000000000000000001"))))), std_logic_vector'("00000000000000000000000000000001")), 2);
  --cpu/jtag_debug_module's addend for next-master-grant
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_arb_addend <= std_logic_vector'("01");
    elsif clk'event and clk = '1' then
      if std_logic'(or_reduce(cpu_jtag_debug_module_grant_vector)) = '1' then 
        cpu_jtag_debug_module_arb_addend <= A_WE_StdLogicVector((std_logic'(cpu_jtag_debug_module_end_xfer) = '1'), cpu_jtag_debug_module_chosen_master_rot_left, cpu_jtag_debug_module_grant_vector);
      end if;
    end if;

  end process;

  cpu_jtag_debug_module_begintransfer <= cpu_jtag_debug_module_begins_xfer;
  --assign lhs ~cpu_jtag_debug_module_reset of type reset_n to cpu_jtag_debug_module_reset_n, which is an e_assign
  cpu_jtag_debug_module_reset <= NOT internal_cpu_jtag_debug_module_reset_n;
  --cpu_jtag_debug_module_reset_n assignment, which is an e_assign
  internal_cpu_jtag_debug_module_reset_n <= reset_n;
  --assign cpu_jtag_debug_module_resetrequest_from_sa = cpu_jtag_debug_module_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  cpu_jtag_debug_module_resetrequest_from_sa <= cpu_jtag_debug_module_resetrequest;
  cpu_jtag_debug_module_chipselect <= internal_cpu_data_master_granted_cpu_jtag_debug_module OR internal_cpu_instruction_master_granted_cpu_jtag_debug_module;
  --cpu_jtag_debug_module_firsttransfer first transaction, which is an e_assign
  cpu_jtag_debug_module_firsttransfer <= A_WE_StdLogic((std_logic'(cpu_jtag_debug_module_begins_xfer) = '1'), cpu_jtag_debug_module_unreg_firsttransfer, cpu_jtag_debug_module_reg_firsttransfer);
  --cpu_jtag_debug_module_unreg_firsttransfer first transaction, which is an e_assign
  cpu_jtag_debug_module_unreg_firsttransfer <= NOT ((cpu_jtag_debug_module_slavearbiterlockenable AND cpu_jtag_debug_module_any_continuerequest));
  --cpu_jtag_debug_module_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_jtag_debug_module_begins_xfer) = '1' then 
        cpu_jtag_debug_module_reg_firsttransfer <= cpu_jtag_debug_module_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --cpu_jtag_debug_module_beginbursttransfer_internal begin burst transfer, which is an e_assign
  cpu_jtag_debug_module_beginbursttransfer_internal <= cpu_jtag_debug_module_begins_xfer;
  --cpu_jtag_debug_module_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  cpu_jtag_debug_module_arbitration_holdoff_internal <= cpu_jtag_debug_module_begins_xfer AND cpu_jtag_debug_module_firsttransfer;
  --cpu_jtag_debug_module_write assignment, which is an e_mux
  cpu_jtag_debug_module_write <= internal_cpu_data_master_granted_cpu_jtag_debug_module AND cpu_data_master_write;
  shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --cpu_jtag_debug_module_address mux, which is an e_mux
  cpu_jtag_debug_module_address <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_cpu_jtag_debug_module)) = '1'), (A_SRL(shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010"))), (A_SRL(shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master,std_logic_vector'("00000000000000000000000000000010")))), 9);
  shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master <= cpu_instruction_master_address_to_slave;
  --d1_cpu_jtag_debug_module_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_cpu_jtag_debug_module_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_cpu_jtag_debug_module_end_xfer <= cpu_jtag_debug_module_end_xfer;
      end if;
    end if;

  end process;

  --cpu_jtag_debug_module_waits_for_read in a cycle, which is an e_mux
  cpu_jtag_debug_module_waits_for_read <= cpu_jtag_debug_module_in_a_read_cycle AND cpu_jtag_debug_module_begins_xfer;
  --cpu_jtag_debug_module_in_a_read_cycle assignment, which is an e_assign
  cpu_jtag_debug_module_in_a_read_cycle <= ((internal_cpu_data_master_granted_cpu_jtag_debug_module AND cpu_data_master_read)) OR ((internal_cpu_instruction_master_granted_cpu_jtag_debug_module AND cpu_instruction_master_read));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= cpu_jtag_debug_module_in_a_read_cycle;
  --cpu_jtag_debug_module_waits_for_write in a cycle, which is an e_mux
  cpu_jtag_debug_module_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_jtag_debug_module_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --cpu_jtag_debug_module_in_a_write_cycle assignment, which is an e_assign
  cpu_jtag_debug_module_in_a_write_cycle <= internal_cpu_data_master_granted_cpu_jtag_debug_module AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= cpu_jtag_debug_module_in_a_write_cycle;
  wait_for_cpu_jtag_debug_module_counter <= std_logic'('0');
  --cpu_jtag_debug_module_byteenable byte enable port mux, which is an e_mux
  cpu_jtag_debug_module_byteenable <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_cpu_jtag_debug_module)) = '1'), (std_logic_vector'("0000000000000000000000000000") & (cpu_data_master_byteenable)), -SIGNED(std_logic_vector'("00000000000000000000000000000001"))), 4);
  --debugaccess mux, which is an e_mux
  cpu_jtag_debug_module_debugaccess <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_cpu_jtag_debug_module)) = '1'), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_debugaccess))), std_logic_vector'("00000000000000000000000000000000")));
  --vhdl renameroo for output signals
  cpu_data_master_granted_cpu_jtag_debug_module <= internal_cpu_data_master_granted_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_cpu_jtag_debug_module <= internal_cpu_data_master_qualified_request_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_data_master_requests_cpu_jtag_debug_module <= internal_cpu_data_master_requests_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_instruction_master_granted_cpu_jtag_debug_module <= internal_cpu_instruction_master_granted_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_instruction_master_qualified_request_cpu_jtag_debug_module <= internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_instruction_master_requests_cpu_jtag_debug_module <= internal_cpu_instruction_master_requests_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_jtag_debug_module_reset_n <= internal_cpu_jtag_debug_module_reset_n;
--synthesis translate_off
    --cpu/jtag_debug_module enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

    --grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line2 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_data_master_granted_cpu_jtag_debug_module))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_instruction_master_granted_cpu_jtag_debug_module))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line2, now);
          write(write_line2, string'(": "));
          write(write_line2, string'("> 1 of grant signals are active simultaneously"));
          write(output, write_line2.all);
          deallocate (write_line2);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --saved_grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line3 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_data_master_saved_grant_cpu_jtag_debug_module))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_saved_grant_cpu_jtag_debug_module))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line3, now);
          write(write_line3, string'(": "));
          write(write_line3, string'("> 1 of saved_grant signals are active simultaneously"));
          write(output, write_line3.all);
          deallocate (write_line3);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cpu_data_master_arbitrator is 
        port (
              -- inputs:
                 signal CPU_MEM_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal KEYS_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal SWITCHS_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (17 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_granted_CPU_MEM_s1 : IN STD_LOGIC;
                 signal cpu_data_master_granted_HEX0_s1 : IN STD_LOGIC;
                 signal cpu_data_master_granted_HEX1_s1 : IN STD_LOGIC;
                 signal cpu_data_master_granted_HEX2_s1 : IN STD_LOGIC;
                 signal cpu_data_master_granted_HEX3_s1 : IN STD_LOGIC;
                 signal cpu_data_master_granted_HEX4_to_HEX7_s1 : IN STD_LOGIC;
                 signal cpu_data_master_granted_KEYS_s1 : IN STD_LOGIC;
                 signal cpu_data_master_granted_SWITCHS_s1 : IN STD_LOGIC;
                 signal cpu_data_master_granted_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_data_master_granted_high_res_timer_s1 : IN STD_LOGIC;
                 signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_lcd_control_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_pwm_green_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_granted_pwm_red1_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_granted_pwm_red2_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_granted_sys_clk_timer_s1 : IN STD_LOGIC;
                 signal cpu_data_master_granted_uart_s1 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_CPU_MEM_s1 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_HEX0_s1 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_HEX1_s1 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_HEX2_s1 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_HEX3_s1 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_HEX4_to_HEX7_s1 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_KEYS_s1 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_SWITCHS_s1 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_high_res_timer_s1 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_lcd_control_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_pwm_green_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_pwm_red1_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_pwm_red2_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_sys_clk_timer_s1 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_uart_s1 : IN STD_LOGIC;
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_CPU_MEM_s1 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_HEX0_s1 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_HEX1_s1 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_HEX2_s1 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_HEX3_s1 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_HEX4_to_HEX7_s1 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_KEYS_s1 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_SWITCHS_s1 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_high_res_timer_s1 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_lcd_control_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_pwm_green_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_pwm_red1_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_pwm_red2_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_sys_clk_timer_s1 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_uart_s1 : IN STD_LOGIC;
                 signal cpu_data_master_requests_CPU_MEM_s1 : IN STD_LOGIC;
                 signal cpu_data_master_requests_HEX0_s1 : IN STD_LOGIC;
                 signal cpu_data_master_requests_HEX1_s1 : IN STD_LOGIC;
                 signal cpu_data_master_requests_HEX2_s1 : IN STD_LOGIC;
                 signal cpu_data_master_requests_HEX3_s1 : IN STD_LOGIC;
                 signal cpu_data_master_requests_HEX4_to_HEX7_s1 : IN STD_LOGIC;
                 signal cpu_data_master_requests_KEYS_s1 : IN STD_LOGIC;
                 signal cpu_data_master_requests_SWITCHS_s1 : IN STD_LOGIC;
                 signal cpu_data_master_requests_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_data_master_requests_high_res_timer_s1 : IN STD_LOGIC;
                 signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_lcd_control_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_pwm_green_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_requests_pwm_red1_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_requests_pwm_red2_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_requests_sys_clk_timer_s1 : IN STD_LOGIC;
                 signal cpu_data_master_requests_uart_s1 : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_CPU_MEM_s1_end_xfer : IN STD_LOGIC;
                 signal d1_HEX0_s1_end_xfer : IN STD_LOGIC;
                 signal d1_HEX1_s1_end_xfer : IN STD_LOGIC;
                 signal d1_HEX2_s1_end_xfer : IN STD_LOGIC;
                 signal d1_HEX3_s1_end_xfer : IN STD_LOGIC;
                 signal d1_HEX4_to_HEX7_s1_end_xfer : IN STD_LOGIC;
                 signal d1_KEYS_s1_end_xfer : IN STD_LOGIC;
                 signal d1_SWITCHS_s1_end_xfer : IN STD_LOGIC;
                 signal d1_cpu_jtag_debug_module_end_xfer : IN STD_LOGIC;
                 signal d1_high_res_timer_s1_end_xfer : IN STD_LOGIC;
                 signal d1_jtag_uart_avalon_jtag_slave_end_xfer : IN STD_LOGIC;
                 signal d1_lcd_control_slave_end_xfer : IN STD_LOGIC;
                 signal d1_pwm_green_avalon_slave_0_end_xfer : IN STD_LOGIC;
                 signal d1_pwm_red1_avalon_slave_0_end_xfer : IN STD_LOGIC;
                 signal d1_pwm_red2_avalon_slave_0_end_xfer : IN STD_LOGIC;
                 signal d1_sys_clk_timer_s1_end_xfer : IN STD_LOGIC;
                 signal d1_uart_s1_end_xfer : IN STD_LOGIC;
                 signal high_res_timer_s1_irq_from_sa : IN STD_LOGIC;
                 signal high_res_timer_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_irq_from_sa : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal lcd_control_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal lcd_control_slave_wait_counter_eq_0 : IN STD_LOGIC;
                 signal lcd_control_slave_wait_counter_eq_1 : IN STD_LOGIC;
                 signal pwm_green_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pwm_red1_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pwm_red2_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal registered_cpu_data_master_read_data_valid_CPU_MEM_s1 : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sys_clk_timer_s1_irq_from_sa : IN STD_LOGIC;
                 signal sys_clk_timer_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal uart_s1_irq_from_sa : IN STD_LOGIC;
                 signal uart_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal cpu_data_master_address_to_slave : OUT STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_irq : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_data_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_data_master_waitrequest : OUT STD_LOGIC
              );
end entity cpu_data_master_arbitrator;


architecture europa of cpu_data_master_arbitrator is
                signal cpu_data_master_run :  STD_LOGIC;
                signal internal_cpu_data_master_address_to_slave :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal internal_cpu_data_master_waitrequest :  STD_LOGIC;
                signal p1_registered_cpu_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal r_0 :  STD_LOGIC;
                signal r_1 :  STD_LOGIC;
                signal r_2 :  STD_LOGIC;
                signal r_3 :  STD_LOGIC;
                signal registered_cpu_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

  --r_0 master_run cascaded wait assignment, which is an e_assign
  r_0 <= Vector_To_Std_Logic((((((((((((((((((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_CPU_MEM_s1 OR registered_cpu_data_master_read_data_valid_CPU_MEM_s1) OR NOT cpu_data_master_requests_CPU_MEM_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_granted_CPU_MEM_s1 OR NOT cpu_data_master_qualified_request_CPU_MEM_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_CPU_MEM_s1 OR NOT cpu_data_master_read) OR ((registered_cpu_data_master_read_data_valid_CPU_MEM_s1 AND cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_CPU_MEM_s1 OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_HEX0_s1 OR NOT cpu_data_master_requests_HEX0_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_HEX0_s1 OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_HEX0_s1 OR NOT cpu_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_HEX1_s1 OR NOT cpu_data_master_requests_HEX1_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_HEX1_s1 OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_HEX1_s1 OR NOT cpu_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_HEX2_s1 OR NOT cpu_data_master_requests_HEX2_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_HEX2_s1 OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_HEX2_s1 OR NOT cpu_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_HEX3_s1 OR NOT cpu_data_master_requests_HEX3_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_HEX3_s1 OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))));
  --cascaded wait assignment, which is an e_assign
  cpu_data_master_run <= ((r_0 AND r_1) AND r_2) AND r_3;
  --r_1 master_run cascaded wait assignment, which is an e_assign
  r_1 <= Vector_To_Std_Logic(((((((((((((((((((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_HEX3_s1 OR NOT cpu_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_HEX4_to_HEX7_s1 OR NOT cpu_data_master_requests_HEX4_to_HEX7_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_HEX4_to_HEX7_s1 OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_HEX4_to_HEX7_s1 OR NOT cpu_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_KEYS_s1 OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_KEYS_s1 OR NOT cpu_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_SWITCHS_s1 OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_SWITCHS_s1 OR NOT cpu_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_data_master_requests_cpu_jtag_debug_module)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_granted_cpu_jtag_debug_module OR NOT cpu_data_master_qualified_request_cpu_jtag_debug_module)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_high_res_timer_s1 OR NOT cpu_data_master_requests_high_res_timer_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_high_res_timer_s1 OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_high_res_timer_s1 OR NOT cpu_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))));
  --r_2 master_run cascaded wait assignment, which is an e_assign
  r_2 <= Vector_To_Std_Logic((((((((((((((((((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave OR NOT cpu_data_master_requests_jtag_uart_avalon_jtag_slave)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT jtag_uart_avalon_jtag_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT jtag_uart_avalon_jtag_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_lcd_control_slave OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(lcd_control_slave_wait_counter_eq_1)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_lcd_control_slave OR NOT cpu_data_master_write)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(lcd_control_slave_wait_counter_eq_1)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_pwm_green_avalon_slave_0 OR NOT cpu_data_master_requests_pwm_green_avalon_slave_0)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_pwm_green_avalon_slave_0 OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_pwm_green_avalon_slave_0 OR NOT cpu_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_pwm_red1_avalon_slave_0 OR NOT cpu_data_master_requests_pwm_red1_avalon_slave_0)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_pwm_red1_avalon_slave_0 OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_pwm_red1_avalon_slave_0 OR NOT cpu_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_pwm_red2_avalon_slave_0 OR NOT cpu_data_master_requests_pwm_red2_avalon_slave_0)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_pwm_red2_avalon_slave_0 OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_pwm_red2_avalon_slave_0 OR NOT cpu_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")));
  --r_3 master_run cascaded wait assignment, which is an e_assign
  r_3 <= Vector_To_Std_Logic(((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_sys_clk_timer_s1 OR NOT cpu_data_master_requests_sys_clk_timer_s1))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_sys_clk_timer_s1 OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_sys_clk_timer_s1 OR NOT cpu_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_uart_s1 OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_uart_s1 OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))));
  --optimize select-logic by passing only those address bits which matter.
  internal_cpu_data_master_address_to_slave <= cpu_data_master_address(18 DOWNTO 0);
  --cpu/data_master readdata mux, which is an e_mux
  cpu_data_master_readdata <= ((((((((((((A_REP(NOT cpu_data_master_requests_CPU_MEM_s1, 32) OR CPU_MEM_s1_readdata_from_sa)) AND ((A_REP(NOT cpu_data_master_requests_KEYS_s1, 32) OR (std_logic_vector'("00000000000000000000000000000") & (KEYS_s1_readdata_from_sa))))) AND ((A_REP(NOT cpu_data_master_requests_SWITCHS_s1, 32) OR (std_logic_vector'("00000000000000") & (SWITCHS_s1_readdata_from_sa))))) AND ((A_REP(NOT cpu_data_master_requests_cpu_jtag_debug_module, 32) OR cpu_jtag_debug_module_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_high_res_timer_s1, 32) OR (std_logic_vector'("0000000000000000") & (high_res_timer_s1_readdata_from_sa))))) AND ((A_REP(NOT cpu_data_master_requests_jtag_uart_avalon_jtag_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_lcd_control_slave, 32) OR (std_logic_vector'("000000000000000000000000") & (lcd_control_slave_readdata_from_sa))))) AND ((A_REP(NOT cpu_data_master_requests_pwm_green_avalon_slave_0, 32) OR pwm_green_avalon_slave_0_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_pwm_red1_avalon_slave_0, 32) OR pwm_red1_avalon_slave_0_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_pwm_red2_avalon_slave_0, 32) OR pwm_red2_avalon_slave_0_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_sys_clk_timer_s1, 32) OR (std_logic_vector'("0000000000000000") & (sys_clk_timer_s1_readdata_from_sa))))) AND ((A_REP(NOT cpu_data_master_requests_uart_s1, 32) OR (std_logic_vector'("0000000000000000") & (uart_s1_readdata_from_sa))));
  --actual waitrequest port, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_data_master_waitrequest <= Vector_To_Std_Logic(NOT std_logic_vector'("00000000000000000000000000000000"));
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        internal_cpu_data_master_waitrequest <= Vector_To_Std_Logic(NOT (A_WE_StdLogicVector((std_logic'((NOT ((cpu_data_master_read OR cpu_data_master_write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_run AND internal_cpu_data_master_waitrequest))))))));
      end if;
    end if;

  end process;

  --irq assign, which is an e_assign
  cpu_data_master_irq <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(uart_s1_irq_from_sa) & A_ToStdLogicVector(high_res_timer_s1_irq_from_sa) & A_ToStdLogicVector(sys_clk_timer_s1_irq_from_sa) & A_ToStdLogicVector(jtag_uart_avalon_jtag_slave_irq_from_sa));
  --unpredictable registered wait state incoming data, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      registered_cpu_data_master_readdata <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        registered_cpu_data_master_readdata <= p1_registered_cpu_data_master_readdata;
      end if;
    end if;

  end process;

  --registered readdata mux, which is an e_mux
  p1_registered_cpu_data_master_readdata <= A_REP(NOT cpu_data_master_requests_jtag_uart_avalon_jtag_slave, 32) OR jtag_uart_avalon_jtag_slave_readdata_from_sa;
  --vhdl renameroo for output signals
  cpu_data_master_address_to_slave <= internal_cpu_data_master_address_to_slave;
  --vhdl renameroo for output signals
  cpu_data_master_waitrequest <= internal_cpu_data_master_waitrequest;

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity cpu_instruction_master_arbitrator is 
        port (
              -- inputs:
                 signal CPU_MEM_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal cpu_instruction_master_address : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_instruction_master_granted_CPU_MEM_s1 : IN STD_LOGIC;
                 signal cpu_instruction_master_granted_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_CPU_MEM_s1 : IN STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_instruction_master_read : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_CPU_MEM_s1 : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_instruction_master_requests_CPU_MEM_s1 : IN STD_LOGIC;
                 signal cpu_instruction_master_requests_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_CPU_MEM_s1_end_xfer : IN STD_LOGIC;
                 signal d1_cpu_jtag_debug_module_end_xfer : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_instruction_master_address_to_slave : OUT STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_instruction_master_latency_counter : OUT STD_LOGIC;
                 signal cpu_instruction_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_instruction_master_readdatavalid : OUT STD_LOGIC;
                 signal cpu_instruction_master_waitrequest : OUT STD_LOGIC
              );
end entity cpu_instruction_master_arbitrator;


architecture europa of cpu_instruction_master_arbitrator is
                signal active_and_waiting_last_time :  STD_LOGIC;
                signal cpu_instruction_master_address_last_time :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal cpu_instruction_master_is_granted_some_slave :  STD_LOGIC;
                signal cpu_instruction_master_read_but_no_slave_selected :  STD_LOGIC;
                signal cpu_instruction_master_read_last_time :  STD_LOGIC;
                signal cpu_instruction_master_run :  STD_LOGIC;
                signal internal_cpu_instruction_master_address_to_slave :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal internal_cpu_instruction_master_latency_counter :  STD_LOGIC;
                signal internal_cpu_instruction_master_waitrequest :  STD_LOGIC;
                signal latency_load_value :  STD_LOGIC;
                signal p1_cpu_instruction_master_latency_counter :  STD_LOGIC;
                signal pre_flush_cpu_instruction_master_readdatavalid :  STD_LOGIC;
                signal r_0 :  STD_LOGIC;
                signal r_1 :  STD_LOGIC;

begin

  --r_0 master_run cascaded wait assignment, which is an e_assign
  r_0 <= Vector_To_Std_Logic((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_qualified_request_CPU_MEM_s1 OR NOT cpu_instruction_master_requests_CPU_MEM_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_granted_CPU_MEM_s1 OR NOT cpu_instruction_master_qualified_request_CPU_MEM_s1)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_instruction_master_qualified_request_CPU_MEM_s1 OR NOT cpu_instruction_master_read)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_read)))))))));
  --cascaded wait assignment, which is an e_assign
  cpu_instruction_master_run <= r_0 AND r_1;
  --r_1 master_run cascaded wait assignment, which is an e_assign
  r_1 <= Vector_To_Std_Logic((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_instruction_master_requests_cpu_jtag_debug_module)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_granted_cpu_jtag_debug_module OR NOT cpu_instruction_master_qualified_request_cpu_jtag_debug_module)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_instruction_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_instruction_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_cpu_jtag_debug_module_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_read)))))))));
  --optimize select-logic by passing only those address bits which matter.
  internal_cpu_instruction_master_address_to_slave <= cpu_instruction_master_address(18 DOWNTO 0);
  --cpu_instruction_master_read_but_no_slave_selected assignment, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_instruction_master_read_but_no_slave_selected <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        cpu_instruction_master_read_but_no_slave_selected <= (cpu_instruction_master_read AND cpu_instruction_master_run) AND NOT cpu_instruction_master_is_granted_some_slave;
      end if;
    end if;

  end process;

  --some slave is getting selected, which is an e_mux
  cpu_instruction_master_is_granted_some_slave <= cpu_instruction_master_granted_CPU_MEM_s1 OR cpu_instruction_master_granted_cpu_jtag_debug_module;
  --latent slave read data valids which may be flushed, which is an e_mux
  pre_flush_cpu_instruction_master_readdatavalid <= cpu_instruction_master_read_data_valid_CPU_MEM_s1;
  --latent slave read data valid which is not flushed, which is an e_mux
  cpu_instruction_master_readdatavalid <= (((cpu_instruction_master_read_but_no_slave_selected OR pre_flush_cpu_instruction_master_readdatavalid) OR cpu_instruction_master_read_but_no_slave_selected) OR pre_flush_cpu_instruction_master_readdatavalid) OR cpu_instruction_master_read_data_valid_cpu_jtag_debug_module;
  --cpu/instruction_master readdata mux, which is an e_mux
  cpu_instruction_master_readdata <= ((A_REP(NOT cpu_instruction_master_read_data_valid_CPU_MEM_s1, 32) OR CPU_MEM_s1_readdata_from_sa)) AND ((A_REP(NOT ((cpu_instruction_master_qualified_request_cpu_jtag_debug_module AND cpu_instruction_master_read)) , 32) OR cpu_jtag_debug_module_readdata_from_sa));
  --actual waitrequest port, which is an e_assign
  internal_cpu_instruction_master_waitrequest <= NOT cpu_instruction_master_run;
  --latent max counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_instruction_master_latency_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        internal_cpu_instruction_master_latency_counter <= p1_cpu_instruction_master_latency_counter;
      end if;
    end if;

  end process;

  --latency counter load mux, which is an e_mux
  p1_cpu_instruction_master_latency_counter <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(((cpu_instruction_master_run AND cpu_instruction_master_read))) = '1'), (std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(latency_load_value))), A_WE_StdLogicVector((std_logic'((internal_cpu_instruction_master_latency_counter)) = '1'), ((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(internal_cpu_instruction_master_latency_counter))) - std_logic_vector'("000000000000000000000000000000001")), std_logic_vector'("000000000000000000000000000000000"))));
  --read latency load values, which is an e_mux
  latency_load_value <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_requests_CPU_MEM_s1))) AND std_logic_vector'("00000000000000000000000000000001")));
  --vhdl renameroo for output signals
  cpu_instruction_master_address_to_slave <= internal_cpu_instruction_master_address_to_slave;
  --vhdl renameroo for output signals
  cpu_instruction_master_latency_counter <= internal_cpu_instruction_master_latency_counter;
  --vhdl renameroo for output signals
  cpu_instruction_master_waitrequest <= internal_cpu_instruction_master_waitrequest;
--synthesis translate_off
    --cpu_instruction_master_address check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_instruction_master_address_last_time <= std_logic_vector'("0000000000000000000");
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          cpu_instruction_master_address_last_time <= cpu_instruction_master_address;
        end if;
      end if;

    end process;

    --cpu/instruction_master waited last time, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        active_and_waiting_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          active_and_waiting_last_time <= internal_cpu_instruction_master_waitrequest AND (cpu_instruction_master_read);
        end if;
      end if;

    end process;

    --cpu_instruction_master_address matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line4 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((cpu_instruction_master_address /= cpu_instruction_master_address_last_time))))) = '1' then 
          write(write_line4, now);
          write(write_line4, string'(": "));
          write(write_line4, string'("cpu_instruction_master_address did not heed wait!!!"));
          write(output, write_line4.all);
          deallocate (write_line4);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --cpu_instruction_master_read check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_instruction_master_read_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          cpu_instruction_master_read_last_time <= cpu_instruction_master_read;
        end if;
      end if;

    end process;

    --cpu_instruction_master_read matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line5 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((std_logic'(cpu_instruction_master_read) /= std_logic'(cpu_instruction_master_read_last_time)))))) = '1' then 
          write(write_line5, now);
          write(write_line5, string'(": "));
          write(write_line5, string'("cpu_instruction_master_read did not heed wait!!!"));
          write(output, write_line5.all);
          deallocate (write_line5);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity high_res_timer_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal high_res_timer_s1_irq : IN STD_LOGIC;
                 signal high_res_timer_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_high_res_timer_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_high_res_timer_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_high_res_timer_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_high_res_timer_s1 : OUT STD_LOGIC;
                 signal d1_high_res_timer_s1_end_xfer : OUT STD_LOGIC;
                 signal high_res_timer_s1_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal high_res_timer_s1_chipselect : OUT STD_LOGIC;
                 signal high_res_timer_s1_irq_from_sa : OUT STD_LOGIC;
                 signal high_res_timer_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal high_res_timer_s1_reset_n : OUT STD_LOGIC;
                 signal high_res_timer_s1_write_n : OUT STD_LOGIC;
                 signal high_res_timer_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
              );
end entity high_res_timer_s1_arbitrator;


architecture europa of high_res_timer_s1_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_high_res_timer_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_high_res_timer_s1 :  STD_LOGIC;
                signal high_res_timer_s1_allgrants :  STD_LOGIC;
                signal high_res_timer_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal high_res_timer_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal high_res_timer_s1_any_continuerequest :  STD_LOGIC;
                signal high_res_timer_s1_arb_counter_enable :  STD_LOGIC;
                signal high_res_timer_s1_arb_share_counter :  STD_LOGIC;
                signal high_res_timer_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal high_res_timer_s1_arb_share_set_values :  STD_LOGIC;
                signal high_res_timer_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal high_res_timer_s1_begins_xfer :  STD_LOGIC;
                signal high_res_timer_s1_end_xfer :  STD_LOGIC;
                signal high_res_timer_s1_firsttransfer :  STD_LOGIC;
                signal high_res_timer_s1_grant_vector :  STD_LOGIC;
                signal high_res_timer_s1_in_a_read_cycle :  STD_LOGIC;
                signal high_res_timer_s1_in_a_write_cycle :  STD_LOGIC;
                signal high_res_timer_s1_master_qreq_vector :  STD_LOGIC;
                signal high_res_timer_s1_non_bursting_master_requests :  STD_LOGIC;
                signal high_res_timer_s1_reg_firsttransfer :  STD_LOGIC;
                signal high_res_timer_s1_slavearbiterlockenable :  STD_LOGIC;
                signal high_res_timer_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal high_res_timer_s1_unreg_firsttransfer :  STD_LOGIC;
                signal high_res_timer_s1_waits_for_read :  STD_LOGIC;
                signal high_res_timer_s1_waits_for_write :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_high_res_timer_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_high_res_timer_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_high_res_timer_s1 :  STD_LOGIC;
                signal shifted_address_to_high_res_timer_s1_from_cpu_data_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal wait_for_high_res_timer_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT high_res_timer_s1_end_xfer;
      end if;
    end if;

  end process;

  high_res_timer_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_high_res_timer_s1);
  --assign high_res_timer_s1_readdata_from_sa = high_res_timer_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  high_res_timer_s1_readdata_from_sa <= high_res_timer_s1_readdata;
  internal_cpu_data_master_requests_high_res_timer_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(18 DOWNTO 5) & std_logic_vector'("00000")) = std_logic_vector'("1000001000000100000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --high_res_timer_s1_arb_share_counter set values, which is an e_mux
  high_res_timer_s1_arb_share_set_values <= std_logic'('1');
  --high_res_timer_s1_non_bursting_master_requests mux, which is an e_mux
  high_res_timer_s1_non_bursting_master_requests <= internal_cpu_data_master_requests_high_res_timer_s1;
  --high_res_timer_s1_any_bursting_master_saved_grant mux, which is an e_mux
  high_res_timer_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --high_res_timer_s1_arb_share_counter_next_value assignment, which is an e_assign
  high_res_timer_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(high_res_timer_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(high_res_timer_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(high_res_timer_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(high_res_timer_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --high_res_timer_s1_allgrants all slave grants, which is an e_mux
  high_res_timer_s1_allgrants <= high_res_timer_s1_grant_vector;
  --high_res_timer_s1_end_xfer assignment, which is an e_assign
  high_res_timer_s1_end_xfer <= NOT ((high_res_timer_s1_waits_for_read OR high_res_timer_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_high_res_timer_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_high_res_timer_s1 <= high_res_timer_s1_end_xfer AND (((NOT high_res_timer_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --high_res_timer_s1_arb_share_counter arbitration counter enable, which is an e_assign
  high_res_timer_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_high_res_timer_s1 AND high_res_timer_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_high_res_timer_s1 AND NOT high_res_timer_s1_non_bursting_master_requests));
  --high_res_timer_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      high_res_timer_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(high_res_timer_s1_arb_counter_enable) = '1' then 
        high_res_timer_s1_arb_share_counter <= high_res_timer_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --high_res_timer_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      high_res_timer_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((high_res_timer_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_high_res_timer_s1)) OR ((end_xfer_arb_share_counter_term_high_res_timer_s1 AND NOT high_res_timer_s1_non_bursting_master_requests)))) = '1' then 
        high_res_timer_s1_slavearbiterlockenable <= high_res_timer_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master high_res_timer/s1 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= high_res_timer_s1_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --high_res_timer_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  high_res_timer_s1_slavearbiterlockenable2 <= high_res_timer_s1_arb_share_counter_next_value;
  --cpu/data_master high_res_timer/s1 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= high_res_timer_s1_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --high_res_timer_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  high_res_timer_s1_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_high_res_timer_s1 <= internal_cpu_data_master_requests_high_res_timer_s1 AND NOT (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write));
  --high_res_timer_s1_writedata mux, which is an e_mux
  high_res_timer_s1_writedata <= cpu_data_master_writedata (15 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_data_master_granted_high_res_timer_s1 <= internal_cpu_data_master_qualified_request_high_res_timer_s1;
  --cpu/data_master saved-grant high_res_timer/s1, which is an e_assign
  cpu_data_master_saved_grant_high_res_timer_s1 <= internal_cpu_data_master_requests_high_res_timer_s1;
  --allow new arb cycle for high_res_timer/s1, which is an e_assign
  high_res_timer_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  high_res_timer_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  high_res_timer_s1_master_qreq_vector <= std_logic'('1');
  --high_res_timer_s1_reset_n assignment, which is an e_assign
  high_res_timer_s1_reset_n <= reset_n;
  high_res_timer_s1_chipselect <= internal_cpu_data_master_granted_high_res_timer_s1;
  --high_res_timer_s1_firsttransfer first transaction, which is an e_assign
  high_res_timer_s1_firsttransfer <= A_WE_StdLogic((std_logic'(high_res_timer_s1_begins_xfer) = '1'), high_res_timer_s1_unreg_firsttransfer, high_res_timer_s1_reg_firsttransfer);
  --high_res_timer_s1_unreg_firsttransfer first transaction, which is an e_assign
  high_res_timer_s1_unreg_firsttransfer <= NOT ((high_res_timer_s1_slavearbiterlockenable AND high_res_timer_s1_any_continuerequest));
  --high_res_timer_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      high_res_timer_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(high_res_timer_s1_begins_xfer) = '1' then 
        high_res_timer_s1_reg_firsttransfer <= high_res_timer_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --high_res_timer_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  high_res_timer_s1_beginbursttransfer_internal <= high_res_timer_s1_begins_xfer;
  --~high_res_timer_s1_write_n assignment, which is an e_mux
  high_res_timer_s1_write_n <= NOT ((internal_cpu_data_master_granted_high_res_timer_s1 AND cpu_data_master_write));
  shifted_address_to_high_res_timer_s1_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --high_res_timer_s1_address mux, which is an e_mux
  high_res_timer_s1_address <= A_EXT (A_SRL(shifted_address_to_high_res_timer_s1_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 3);
  --d1_high_res_timer_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_high_res_timer_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_high_res_timer_s1_end_xfer <= high_res_timer_s1_end_xfer;
      end if;
    end if;

  end process;

  --high_res_timer_s1_waits_for_read in a cycle, which is an e_mux
  high_res_timer_s1_waits_for_read <= high_res_timer_s1_in_a_read_cycle AND high_res_timer_s1_begins_xfer;
  --high_res_timer_s1_in_a_read_cycle assignment, which is an e_assign
  high_res_timer_s1_in_a_read_cycle <= internal_cpu_data_master_granted_high_res_timer_s1 AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= high_res_timer_s1_in_a_read_cycle;
  --high_res_timer_s1_waits_for_write in a cycle, which is an e_mux
  high_res_timer_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(high_res_timer_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --high_res_timer_s1_in_a_write_cycle assignment, which is an e_assign
  high_res_timer_s1_in_a_write_cycle <= internal_cpu_data_master_granted_high_res_timer_s1 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= high_res_timer_s1_in_a_write_cycle;
  wait_for_high_res_timer_s1_counter <= std_logic'('0');
  --assign high_res_timer_s1_irq_from_sa = high_res_timer_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  high_res_timer_s1_irq_from_sa <= high_res_timer_s1_irq;
  --vhdl renameroo for output signals
  cpu_data_master_granted_high_res_timer_s1 <= internal_cpu_data_master_granted_high_res_timer_s1;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_high_res_timer_s1 <= internal_cpu_data_master_qualified_request_high_res_timer_s1;
  --vhdl renameroo for output signals
  cpu_data_master_requests_high_res_timer_s1 <= internal_cpu_data_master_requests_high_res_timer_s1;
--synthesis translate_off
    --high_res_timer/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity jtag_uart_avalon_jtag_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_dataavailable : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_irq : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_readyfordata : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                 signal d1_jtag_uart_avalon_jtag_slave_end_xfer : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_address : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_chipselect : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_dataavailable_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_irq_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_read_n : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_readyfordata_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_reset_n : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_write_n : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity jtag_uart_avalon_jtag_slave_arbitrator;


architecture europa of jtag_uart_avalon_jtag_slave_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_allgrants :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_any_continuerequest :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_arb_counter_enable :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_arb_share_counter :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_arb_share_set_values :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_begins_xfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_end_xfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_firsttransfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_grant_vector :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_in_a_read_cycle :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_in_a_write_cycle :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_master_qreq_vector :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_non_bursting_master_requests :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_reg_firsttransfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_slavearbiterlockenable :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_unreg_firsttransfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_waits_for_read :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal wait_for_jtag_uart_avalon_jtag_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT jtag_uart_avalon_jtag_slave_end_xfer;
      end if;
    end if;

  end process;

  jtag_uart_avalon_jtag_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave);
  --assign jtag_uart_avalon_jtag_slave_readdata_from_sa = jtag_uart_avalon_jtag_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_avalon_jtag_slave_readdata_from_sa <= jtag_uart_avalon_jtag_slave_readdata;
  internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(18 DOWNTO 3) & std_logic_vector'("000")) = std_logic_vector'("1000001000011100000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign jtag_uart_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_avalon_jtag_slave_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_avalon_jtag_slave_dataavailable_from_sa <= jtag_uart_avalon_jtag_slave_dataavailable;
  --assign jtag_uart_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_avalon_jtag_slave_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_avalon_jtag_slave_readyfordata_from_sa <= jtag_uart_avalon_jtag_slave_readyfordata;
  --assign jtag_uart_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_avalon_jtag_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa <= jtag_uart_avalon_jtag_slave_waitrequest;
  --jtag_uart_avalon_jtag_slave_arb_share_counter set values, which is an e_mux
  jtag_uart_avalon_jtag_slave_arb_share_set_values <= std_logic'('1');
  --jtag_uart_avalon_jtag_slave_non_bursting_master_requests mux, which is an e_mux
  jtag_uart_avalon_jtag_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave;
  --jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant mux, which is an e_mux
  jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --jtag_uart_avalon_jtag_slave_arb_share_counter_next_value assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(jtag_uart_avalon_jtag_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(jtag_uart_avalon_jtag_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(jtag_uart_avalon_jtag_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(jtag_uart_avalon_jtag_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --jtag_uart_avalon_jtag_slave_allgrants all slave grants, which is an e_mux
  jtag_uart_avalon_jtag_slave_allgrants <= jtag_uart_avalon_jtag_slave_grant_vector;
  --jtag_uart_avalon_jtag_slave_end_xfer assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_end_xfer <= NOT ((jtag_uart_avalon_jtag_slave_waits_for_read OR jtag_uart_avalon_jtag_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave <= jtag_uart_avalon_jtag_slave_end_xfer AND (((NOT jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --jtag_uart_avalon_jtag_slave_arb_share_counter arbitration counter enable, which is an e_assign
  jtag_uart_avalon_jtag_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave AND jtag_uart_avalon_jtag_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave AND NOT jtag_uart_avalon_jtag_slave_non_bursting_master_requests));
  --jtag_uart_avalon_jtag_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_avalon_jtag_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(jtag_uart_avalon_jtag_slave_arb_counter_enable) = '1' then 
        jtag_uart_avalon_jtag_slave_arb_share_counter <= jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --jtag_uart_avalon_jtag_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((jtag_uart_avalon_jtag_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave)) OR ((end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave AND NOT jtag_uart_avalon_jtag_slave_non_bursting_master_requests)))) = '1' then 
        jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master jtag_uart/avalon_jtag_slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= jtag_uart_avalon_jtag_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 <= jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
  --cpu/data_master jtag_uart/avalon_jtag_slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --jtag_uart_avalon_jtag_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  jtag_uart_avalon_jtag_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave AND NOT ((((cpu_data_master_read AND (NOT cpu_data_master_waitrequest))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --jtag_uart_avalon_jtag_slave_writedata mux, which is an e_mux
  jtag_uart_avalon_jtag_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  --cpu/data_master saved-grant jtag_uart/avalon_jtag_slave, which is an e_assign
  cpu_data_master_saved_grant_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave;
  --allow new arb cycle for jtag_uart/avalon_jtag_slave, which is an e_assign
  jtag_uart_avalon_jtag_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  jtag_uart_avalon_jtag_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  jtag_uart_avalon_jtag_slave_master_qreq_vector <= std_logic'('1');
  --jtag_uart_avalon_jtag_slave_reset_n assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_reset_n <= reset_n;
  jtag_uart_avalon_jtag_slave_chipselect <= internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave;
  --jtag_uart_avalon_jtag_slave_firsttransfer first transaction, which is an e_assign
  jtag_uart_avalon_jtag_slave_firsttransfer <= A_WE_StdLogic((std_logic'(jtag_uart_avalon_jtag_slave_begins_xfer) = '1'), jtag_uart_avalon_jtag_slave_unreg_firsttransfer, jtag_uart_avalon_jtag_slave_reg_firsttransfer);
  --jtag_uart_avalon_jtag_slave_unreg_firsttransfer first transaction, which is an e_assign
  jtag_uart_avalon_jtag_slave_unreg_firsttransfer <= NOT ((jtag_uart_avalon_jtag_slave_slavearbiterlockenable AND jtag_uart_avalon_jtag_slave_any_continuerequest));
  --jtag_uart_avalon_jtag_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_avalon_jtag_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(jtag_uart_avalon_jtag_slave_begins_xfer) = '1' then 
        jtag_uart_avalon_jtag_slave_reg_firsttransfer <= jtag_uart_avalon_jtag_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --jtag_uart_avalon_jtag_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  jtag_uart_avalon_jtag_slave_beginbursttransfer_internal <= jtag_uart_avalon_jtag_slave_begins_xfer;
  --~jtag_uart_avalon_jtag_slave_read_n assignment, which is an e_mux
  jtag_uart_avalon_jtag_slave_read_n <= NOT ((internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave AND cpu_data_master_read));
  --~jtag_uart_avalon_jtag_slave_write_n assignment, which is an e_mux
  jtag_uart_avalon_jtag_slave_write_n <= NOT ((internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave AND cpu_data_master_write));
  shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --jtag_uart_avalon_jtag_slave_address mux, which is an e_mux
  jtag_uart_avalon_jtag_slave_address <= Vector_To_Std_Logic(A_SRL(shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")));
  --d1_jtag_uart_avalon_jtag_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_jtag_uart_avalon_jtag_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_jtag_uart_avalon_jtag_slave_end_xfer <= jtag_uart_avalon_jtag_slave_end_xfer;
      end if;
    end if;

  end process;

  --jtag_uart_avalon_jtag_slave_waits_for_read in a cycle, which is an e_mux
  jtag_uart_avalon_jtag_slave_waits_for_read <= jtag_uart_avalon_jtag_slave_in_a_read_cycle AND internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  --jtag_uart_avalon_jtag_slave_in_a_read_cycle assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_in_a_read_cycle <= internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= jtag_uart_avalon_jtag_slave_in_a_read_cycle;
  --jtag_uart_avalon_jtag_slave_waits_for_write in a cycle, which is an e_mux
  jtag_uart_avalon_jtag_slave_waits_for_write <= jtag_uart_avalon_jtag_slave_in_a_write_cycle AND internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  --jtag_uart_avalon_jtag_slave_in_a_write_cycle assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_in_a_write_cycle <= internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= jtag_uart_avalon_jtag_slave_in_a_write_cycle;
  wait_for_jtag_uart_avalon_jtag_slave_counter <= std_logic'('0');
  --assign jtag_uart_avalon_jtag_slave_irq_from_sa = jtag_uart_avalon_jtag_slave_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_avalon_jtag_slave_irq_from_sa <= jtag_uart_avalon_jtag_slave_irq;
  --vhdl renameroo for output signals
  cpu_data_master_granted_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  --vhdl renameroo for output signals
  cpu_data_master_requests_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave;
  --vhdl renameroo for output signals
  jtag_uart_avalon_jtag_slave_waitrequest_from_sa <= internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
--synthesis translate_off
    --jtag_uart/avalon_jtag_slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity lcd_control_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal lcd_control_slave_readdata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_lcd_control_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_lcd_control_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_lcd_control_slave : OUT STD_LOGIC;
                 signal cpu_data_master_requests_lcd_control_slave : OUT STD_LOGIC;
                 signal d1_lcd_control_slave_end_xfer : OUT STD_LOGIC;
                 signal lcd_control_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal lcd_control_slave_begintransfer : OUT STD_LOGIC;
                 signal lcd_control_slave_read : OUT STD_LOGIC;
                 signal lcd_control_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal lcd_control_slave_wait_counter_eq_0 : OUT STD_LOGIC;
                 signal lcd_control_slave_wait_counter_eq_1 : OUT STD_LOGIC;
                 signal lcd_control_slave_write : OUT STD_LOGIC;
                 signal lcd_control_slave_writedata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
              );
end entity lcd_control_slave_arbitrator;


architecture europa of lcd_control_slave_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_lcd_control_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_lcd_control_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_lcd_control_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_lcd_control_slave :  STD_LOGIC;
                signal internal_cpu_data_master_requests_lcd_control_slave :  STD_LOGIC;
                signal internal_lcd_control_slave_wait_counter_eq_0 :  STD_LOGIC;
                signal lcd_control_slave_allgrants :  STD_LOGIC;
                signal lcd_control_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal lcd_control_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal lcd_control_slave_any_continuerequest :  STD_LOGIC;
                signal lcd_control_slave_arb_counter_enable :  STD_LOGIC;
                signal lcd_control_slave_arb_share_counter :  STD_LOGIC;
                signal lcd_control_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal lcd_control_slave_arb_share_set_values :  STD_LOGIC;
                signal lcd_control_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal lcd_control_slave_begins_xfer :  STD_LOGIC;
                signal lcd_control_slave_counter_load_value :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal lcd_control_slave_end_xfer :  STD_LOGIC;
                signal lcd_control_slave_firsttransfer :  STD_LOGIC;
                signal lcd_control_slave_grant_vector :  STD_LOGIC;
                signal lcd_control_slave_in_a_read_cycle :  STD_LOGIC;
                signal lcd_control_slave_in_a_write_cycle :  STD_LOGIC;
                signal lcd_control_slave_master_qreq_vector :  STD_LOGIC;
                signal lcd_control_slave_non_bursting_master_requests :  STD_LOGIC;
                signal lcd_control_slave_pretend_byte_enable :  STD_LOGIC;
                signal lcd_control_slave_reg_firsttransfer :  STD_LOGIC;
                signal lcd_control_slave_slavearbiterlockenable :  STD_LOGIC;
                signal lcd_control_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal lcd_control_slave_unreg_firsttransfer :  STD_LOGIC;
                signal lcd_control_slave_wait_counter :  STD_LOGIC_VECTOR (5 DOWNTO 0);
                signal lcd_control_slave_waits_for_read :  STD_LOGIC;
                signal lcd_control_slave_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_lcd_control_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal wait_for_lcd_control_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT lcd_control_slave_end_xfer;
      end if;
    end if;

  end process;

  lcd_control_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_lcd_control_slave);
  --assign lcd_control_slave_readdata_from_sa = lcd_control_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  lcd_control_slave_readdata_from_sa <= lcd_control_slave_readdata;
  internal_cpu_data_master_requests_lcd_control_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(18 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("1000001000011010000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --lcd_control_slave_arb_share_counter set values, which is an e_mux
  lcd_control_slave_arb_share_set_values <= std_logic'('1');
  --lcd_control_slave_non_bursting_master_requests mux, which is an e_mux
  lcd_control_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_lcd_control_slave;
  --lcd_control_slave_any_bursting_master_saved_grant mux, which is an e_mux
  lcd_control_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --lcd_control_slave_arb_share_counter_next_value assignment, which is an e_assign
  lcd_control_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(lcd_control_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(lcd_control_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(lcd_control_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(lcd_control_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --lcd_control_slave_allgrants all slave grants, which is an e_mux
  lcd_control_slave_allgrants <= lcd_control_slave_grant_vector;
  --lcd_control_slave_end_xfer assignment, which is an e_assign
  lcd_control_slave_end_xfer <= NOT ((lcd_control_slave_waits_for_read OR lcd_control_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_lcd_control_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_lcd_control_slave <= lcd_control_slave_end_xfer AND (((NOT lcd_control_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --lcd_control_slave_arb_share_counter arbitration counter enable, which is an e_assign
  lcd_control_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_lcd_control_slave AND lcd_control_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_lcd_control_slave AND NOT lcd_control_slave_non_bursting_master_requests));
  --lcd_control_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      lcd_control_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(lcd_control_slave_arb_counter_enable) = '1' then 
        lcd_control_slave_arb_share_counter <= lcd_control_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --lcd_control_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      lcd_control_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((lcd_control_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_lcd_control_slave)) OR ((end_xfer_arb_share_counter_term_lcd_control_slave AND NOT lcd_control_slave_non_bursting_master_requests)))) = '1' then 
        lcd_control_slave_slavearbiterlockenable <= lcd_control_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master lcd/control_slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= lcd_control_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --lcd_control_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  lcd_control_slave_slavearbiterlockenable2 <= lcd_control_slave_arb_share_counter_next_value;
  --cpu/data_master lcd/control_slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= lcd_control_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --lcd_control_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  lcd_control_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_lcd_control_slave <= internal_cpu_data_master_requests_lcd_control_slave;
  --lcd_control_slave_writedata mux, which is an e_mux
  lcd_control_slave_writedata <= cpu_data_master_writedata (7 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_data_master_granted_lcd_control_slave <= internal_cpu_data_master_qualified_request_lcd_control_slave;
  --cpu/data_master saved-grant lcd/control_slave, which is an e_assign
  cpu_data_master_saved_grant_lcd_control_slave <= internal_cpu_data_master_requests_lcd_control_slave;
  --allow new arb cycle for lcd/control_slave, which is an e_assign
  lcd_control_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  lcd_control_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  lcd_control_slave_master_qreq_vector <= std_logic'('1');
  lcd_control_slave_begintransfer <= lcd_control_slave_begins_xfer;
  --lcd_control_slave_firsttransfer first transaction, which is an e_assign
  lcd_control_slave_firsttransfer <= A_WE_StdLogic((std_logic'(lcd_control_slave_begins_xfer) = '1'), lcd_control_slave_unreg_firsttransfer, lcd_control_slave_reg_firsttransfer);
  --lcd_control_slave_unreg_firsttransfer first transaction, which is an e_assign
  lcd_control_slave_unreg_firsttransfer <= NOT ((lcd_control_slave_slavearbiterlockenable AND lcd_control_slave_any_continuerequest));
  --lcd_control_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      lcd_control_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(lcd_control_slave_begins_xfer) = '1' then 
        lcd_control_slave_reg_firsttransfer <= lcd_control_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --lcd_control_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  lcd_control_slave_beginbursttransfer_internal <= lcd_control_slave_begins_xfer;
  --lcd_control_slave_read assignment, which is an e_mux
  lcd_control_slave_read <= (((internal_cpu_data_master_granted_lcd_control_slave AND cpu_data_master_read)) AND NOT lcd_control_slave_begins_xfer) AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (lcd_control_slave_wait_counter))<std_logic_vector'("00000000000000000000000000001101"))));
  --lcd_control_slave_write assignment, which is an e_mux
  lcd_control_slave_write <= (((((internal_cpu_data_master_granted_lcd_control_slave AND cpu_data_master_write)) AND NOT lcd_control_slave_begins_xfer) AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (lcd_control_slave_wait_counter))>=std_logic_vector'("00000000000000000000000000001101"))))) AND to_std_logic((((std_logic_vector'("00000000000000000000000000") & (lcd_control_slave_wait_counter))<std_logic_vector'("00000000000000000000000000011010"))))) AND lcd_control_slave_pretend_byte_enable;
  shifted_address_to_lcd_control_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --lcd_control_slave_address mux, which is an e_mux
  lcd_control_slave_address <= A_EXT (A_SRL(shifted_address_to_lcd_control_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_lcd_control_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_lcd_control_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_lcd_control_slave_end_xfer <= lcd_control_slave_end_xfer;
      end if;
    end if;

  end process;

  --lcd_control_slave_wait_counter_eq_1 assignment, which is an e_assign
  lcd_control_slave_wait_counter_eq_1 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (lcd_control_slave_wait_counter)) = std_logic_vector'("00000000000000000000000000000001")));
  --lcd_control_slave_waits_for_read in a cycle, which is an e_mux
  lcd_control_slave_waits_for_read <= lcd_control_slave_in_a_read_cycle AND wait_for_lcd_control_slave_counter;
  --lcd_control_slave_in_a_read_cycle assignment, which is an e_assign
  lcd_control_slave_in_a_read_cycle <= internal_cpu_data_master_granted_lcd_control_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= lcd_control_slave_in_a_read_cycle;
  --lcd_control_slave_waits_for_write in a cycle, which is an e_mux
  lcd_control_slave_waits_for_write <= lcd_control_slave_in_a_write_cycle AND wait_for_lcd_control_slave_counter;
  --lcd_control_slave_in_a_write_cycle assignment, which is an e_assign
  lcd_control_slave_in_a_write_cycle <= internal_cpu_data_master_granted_lcd_control_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= lcd_control_slave_in_a_write_cycle;
  internal_lcd_control_slave_wait_counter_eq_0 <= to_std_logic(((std_logic_vector'("00000000000000000000000000") & (lcd_control_slave_wait_counter)) = std_logic_vector'("00000000000000000000000000000000")));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      lcd_control_slave_wait_counter <= std_logic_vector'("000000");
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        lcd_control_slave_wait_counter <= lcd_control_slave_counter_load_value;
      end if;
    end if;

  end process;

  lcd_control_slave_counter_load_value <= A_EXT (A_WE_StdLogicVector((std_logic'(((lcd_control_slave_in_a_read_cycle AND lcd_control_slave_begins_xfer))) = '1'), std_logic_vector'("000000000000000000000000000011000"), A_WE_StdLogicVector((std_logic'(((lcd_control_slave_in_a_write_cycle AND lcd_control_slave_begins_xfer))) = '1'), std_logic_vector'("000000000000000000000000000100101"), A_WE_StdLogicVector((std_logic'((NOT internal_lcd_control_slave_wait_counter_eq_0)) = '1'), ((std_logic_vector'("000000000000000000000000000") & (lcd_control_slave_wait_counter)) - std_logic_vector'("000000000000000000000000000000001")), std_logic_vector'("000000000000000000000000000000000")))), 6);
  wait_for_lcd_control_slave_counter <= lcd_control_slave_begins_xfer OR NOT internal_lcd_control_slave_wait_counter_eq_0;
  --lcd_control_slave_pretend_byte_enable byte enable port mux, which is an e_mux
  lcd_control_slave_pretend_byte_enable <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_lcd_control_slave)) = '1'), (std_logic_vector'("0000000000000000000000000000") & (cpu_data_master_byteenable)), -SIGNED(std_logic_vector'("00000000000000000000000000000001"))));
  --vhdl renameroo for output signals
  cpu_data_master_granted_lcd_control_slave <= internal_cpu_data_master_granted_lcd_control_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_lcd_control_slave <= internal_cpu_data_master_qualified_request_lcd_control_slave;
  --vhdl renameroo for output signals
  cpu_data_master_requests_lcd_control_slave <= internal_cpu_data_master_requests_lcd_control_slave;
  --vhdl renameroo for output signals
  lcd_control_slave_wait_counter_eq_0 <= internal_lcd_control_slave_wait_counter_eq_0;
--synthesis translate_off
    --lcd/control_slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pwm_green_avalon_slave_0_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pwm_green_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_pwm_green_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_pwm_green_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_pwm_green_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_pwm_green_avalon_slave_0 : OUT STD_LOGIC;
                 signal d1_pwm_green_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                 signal pwm_green_avalon_slave_0_address : OUT STD_LOGIC;
                 signal pwm_green_avalon_slave_0_chipselect : OUT STD_LOGIC;
                 signal pwm_green_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pwm_green_avalon_slave_0_reset_n : OUT STD_LOGIC;
                 signal pwm_green_avalon_slave_0_write_n : OUT STD_LOGIC;
                 signal pwm_green_avalon_slave_0_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity pwm_green_avalon_slave_0_arbitrator;


architecture europa of pwm_green_avalon_slave_0_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_pwm_green_avalon_slave_0 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_pwm_green_avalon_slave_0 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_pwm_green_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_pwm_green_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_pwm_green_avalon_slave_0 :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_allgrants :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_allow_new_arb_cycle :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_any_bursting_master_saved_grant :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_any_continuerequest :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_arb_counter_enable :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_arb_share_counter :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_arb_share_counter_next_value :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_arb_share_set_values :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_beginbursttransfer_internal :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_begins_xfer :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_firsttransfer :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_grant_vector :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_in_a_read_cycle :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_in_a_write_cycle :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_master_qreq_vector :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_non_bursting_master_requests :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_reg_firsttransfer :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_slavearbiterlockenable :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_slavearbiterlockenable2 :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_unreg_firsttransfer :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_waits_for_read :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_pwm_green_avalon_slave_0_from_cpu_data_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal wait_for_pwm_green_avalon_slave_0_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT pwm_green_avalon_slave_0_end_xfer;
      end if;
    end if;

  end process;

  pwm_green_avalon_slave_0_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_pwm_green_avalon_slave_0);
  --assign pwm_green_avalon_slave_0_readdata_from_sa = pwm_green_avalon_slave_0_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  pwm_green_avalon_slave_0_readdata_from_sa <= pwm_green_avalon_slave_0_readdata;
  internal_cpu_data_master_requests_pwm_green_avalon_slave_0 <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(18 DOWNTO 3) & std_logic_vector'("000")) = std_logic_vector'("1000001000011111000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --pwm_green_avalon_slave_0_arb_share_counter set values, which is an e_mux
  pwm_green_avalon_slave_0_arb_share_set_values <= std_logic'('1');
  --pwm_green_avalon_slave_0_non_bursting_master_requests mux, which is an e_mux
  pwm_green_avalon_slave_0_non_bursting_master_requests <= internal_cpu_data_master_requests_pwm_green_avalon_slave_0;
  --pwm_green_avalon_slave_0_any_bursting_master_saved_grant mux, which is an e_mux
  pwm_green_avalon_slave_0_any_bursting_master_saved_grant <= std_logic'('0');
  --pwm_green_avalon_slave_0_arb_share_counter_next_value assignment, which is an e_assign
  pwm_green_avalon_slave_0_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(pwm_green_avalon_slave_0_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pwm_green_avalon_slave_0_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(pwm_green_avalon_slave_0_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pwm_green_avalon_slave_0_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --pwm_green_avalon_slave_0_allgrants all slave grants, which is an e_mux
  pwm_green_avalon_slave_0_allgrants <= pwm_green_avalon_slave_0_grant_vector;
  --pwm_green_avalon_slave_0_end_xfer assignment, which is an e_assign
  pwm_green_avalon_slave_0_end_xfer <= NOT ((pwm_green_avalon_slave_0_waits_for_read OR pwm_green_avalon_slave_0_waits_for_write));
  --end_xfer_arb_share_counter_term_pwm_green_avalon_slave_0 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_pwm_green_avalon_slave_0 <= pwm_green_avalon_slave_0_end_xfer AND (((NOT pwm_green_avalon_slave_0_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --pwm_green_avalon_slave_0_arb_share_counter arbitration counter enable, which is an e_assign
  pwm_green_avalon_slave_0_arb_counter_enable <= ((end_xfer_arb_share_counter_term_pwm_green_avalon_slave_0 AND pwm_green_avalon_slave_0_allgrants)) OR ((end_xfer_arb_share_counter_term_pwm_green_avalon_slave_0 AND NOT pwm_green_avalon_slave_0_non_bursting_master_requests));
  --pwm_green_avalon_slave_0_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      pwm_green_avalon_slave_0_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(pwm_green_avalon_slave_0_arb_counter_enable) = '1' then 
        pwm_green_avalon_slave_0_arb_share_counter <= pwm_green_avalon_slave_0_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pwm_green_avalon_slave_0_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      pwm_green_avalon_slave_0_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((pwm_green_avalon_slave_0_master_qreq_vector AND end_xfer_arb_share_counter_term_pwm_green_avalon_slave_0)) OR ((end_xfer_arb_share_counter_term_pwm_green_avalon_slave_0 AND NOT pwm_green_avalon_slave_0_non_bursting_master_requests)))) = '1' then 
        pwm_green_avalon_slave_0_slavearbiterlockenable <= pwm_green_avalon_slave_0_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master pwm_green/avalon_slave_0 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= pwm_green_avalon_slave_0_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --pwm_green_avalon_slave_0_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  pwm_green_avalon_slave_0_slavearbiterlockenable2 <= pwm_green_avalon_slave_0_arb_share_counter_next_value;
  --cpu/data_master pwm_green/avalon_slave_0 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= pwm_green_avalon_slave_0_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --pwm_green_avalon_slave_0_any_continuerequest at least one master continues requesting, which is an e_assign
  pwm_green_avalon_slave_0_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_pwm_green_avalon_slave_0 <= internal_cpu_data_master_requests_pwm_green_avalon_slave_0 AND NOT (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write));
  --pwm_green_avalon_slave_0_writedata mux, which is an e_mux
  pwm_green_avalon_slave_0_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_pwm_green_avalon_slave_0 <= internal_cpu_data_master_qualified_request_pwm_green_avalon_slave_0;
  --cpu/data_master saved-grant pwm_green/avalon_slave_0, which is an e_assign
  cpu_data_master_saved_grant_pwm_green_avalon_slave_0 <= internal_cpu_data_master_requests_pwm_green_avalon_slave_0;
  --allow new arb cycle for pwm_green/avalon_slave_0, which is an e_assign
  pwm_green_avalon_slave_0_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  pwm_green_avalon_slave_0_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  pwm_green_avalon_slave_0_master_qreq_vector <= std_logic'('1');
  --pwm_green_avalon_slave_0_reset_n assignment, which is an e_assign
  pwm_green_avalon_slave_0_reset_n <= reset_n;
  pwm_green_avalon_slave_0_chipselect <= internal_cpu_data_master_granted_pwm_green_avalon_slave_0;
  --pwm_green_avalon_slave_0_firsttransfer first transaction, which is an e_assign
  pwm_green_avalon_slave_0_firsttransfer <= A_WE_StdLogic((std_logic'(pwm_green_avalon_slave_0_begins_xfer) = '1'), pwm_green_avalon_slave_0_unreg_firsttransfer, pwm_green_avalon_slave_0_reg_firsttransfer);
  --pwm_green_avalon_slave_0_unreg_firsttransfer first transaction, which is an e_assign
  pwm_green_avalon_slave_0_unreg_firsttransfer <= NOT ((pwm_green_avalon_slave_0_slavearbiterlockenable AND pwm_green_avalon_slave_0_any_continuerequest));
  --pwm_green_avalon_slave_0_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      pwm_green_avalon_slave_0_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(pwm_green_avalon_slave_0_begins_xfer) = '1' then 
        pwm_green_avalon_slave_0_reg_firsttransfer <= pwm_green_avalon_slave_0_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --pwm_green_avalon_slave_0_beginbursttransfer_internal begin burst transfer, which is an e_assign
  pwm_green_avalon_slave_0_beginbursttransfer_internal <= pwm_green_avalon_slave_0_begins_xfer;
  --~pwm_green_avalon_slave_0_write_n assignment, which is an e_mux
  pwm_green_avalon_slave_0_write_n <= NOT ((internal_cpu_data_master_granted_pwm_green_avalon_slave_0 AND cpu_data_master_write));
  shifted_address_to_pwm_green_avalon_slave_0_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --pwm_green_avalon_slave_0_address mux, which is an e_mux
  pwm_green_avalon_slave_0_address <= Vector_To_Std_Logic(A_SRL(shifted_address_to_pwm_green_avalon_slave_0_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")));
  --d1_pwm_green_avalon_slave_0_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_pwm_green_avalon_slave_0_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_pwm_green_avalon_slave_0_end_xfer <= pwm_green_avalon_slave_0_end_xfer;
      end if;
    end if;

  end process;

  --pwm_green_avalon_slave_0_waits_for_read in a cycle, which is an e_mux
  pwm_green_avalon_slave_0_waits_for_read <= pwm_green_avalon_slave_0_in_a_read_cycle AND pwm_green_avalon_slave_0_begins_xfer;
  --pwm_green_avalon_slave_0_in_a_read_cycle assignment, which is an e_assign
  pwm_green_avalon_slave_0_in_a_read_cycle <= internal_cpu_data_master_granted_pwm_green_avalon_slave_0 AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= pwm_green_avalon_slave_0_in_a_read_cycle;
  --pwm_green_avalon_slave_0_waits_for_write in a cycle, which is an e_mux
  pwm_green_avalon_slave_0_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pwm_green_avalon_slave_0_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --pwm_green_avalon_slave_0_in_a_write_cycle assignment, which is an e_assign
  pwm_green_avalon_slave_0_in_a_write_cycle <= internal_cpu_data_master_granted_pwm_green_avalon_slave_0 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= pwm_green_avalon_slave_0_in_a_write_cycle;
  wait_for_pwm_green_avalon_slave_0_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_pwm_green_avalon_slave_0 <= internal_cpu_data_master_granted_pwm_green_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_pwm_green_avalon_slave_0 <= internal_cpu_data_master_qualified_request_pwm_green_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_data_master_requests_pwm_green_avalon_slave_0 <= internal_cpu_data_master_requests_pwm_green_avalon_slave_0;
--synthesis translate_off
    --pwm_green/avalon_slave_0 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pwm_red1_avalon_slave_0_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pwm_red1_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_pwm_red1_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_pwm_red1_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_pwm_red1_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_pwm_red1_avalon_slave_0 : OUT STD_LOGIC;
                 signal d1_pwm_red1_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                 signal pwm_red1_avalon_slave_0_address : OUT STD_LOGIC;
                 signal pwm_red1_avalon_slave_0_chipselect : OUT STD_LOGIC;
                 signal pwm_red1_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pwm_red1_avalon_slave_0_reset_n : OUT STD_LOGIC;
                 signal pwm_red1_avalon_slave_0_write_n : OUT STD_LOGIC;
                 signal pwm_red1_avalon_slave_0_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity pwm_red1_avalon_slave_0_arbitrator;


architecture europa of pwm_red1_avalon_slave_0_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_pwm_red1_avalon_slave_0 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_pwm_red1_avalon_slave_0 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_pwm_red1_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_pwm_red1_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_pwm_red1_avalon_slave_0 :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_allgrants :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_allow_new_arb_cycle :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_any_bursting_master_saved_grant :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_any_continuerequest :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_arb_counter_enable :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_arb_share_counter :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_arb_share_counter_next_value :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_arb_share_set_values :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_beginbursttransfer_internal :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_begins_xfer :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_firsttransfer :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_grant_vector :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_in_a_read_cycle :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_in_a_write_cycle :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_master_qreq_vector :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_non_bursting_master_requests :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_reg_firsttransfer :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_slavearbiterlockenable :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_slavearbiterlockenable2 :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_unreg_firsttransfer :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_waits_for_read :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_pwm_red1_avalon_slave_0_from_cpu_data_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal wait_for_pwm_red1_avalon_slave_0_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT pwm_red1_avalon_slave_0_end_xfer;
      end if;
    end if;

  end process;

  pwm_red1_avalon_slave_0_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_pwm_red1_avalon_slave_0);
  --assign pwm_red1_avalon_slave_0_readdata_from_sa = pwm_red1_avalon_slave_0_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  pwm_red1_avalon_slave_0_readdata_from_sa <= pwm_red1_avalon_slave_0_readdata;
  internal_cpu_data_master_requests_pwm_red1_avalon_slave_0 <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(18 DOWNTO 3) & std_logic_vector'("000")) = std_logic_vector'("1000001000011101000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --pwm_red1_avalon_slave_0_arb_share_counter set values, which is an e_mux
  pwm_red1_avalon_slave_0_arb_share_set_values <= std_logic'('1');
  --pwm_red1_avalon_slave_0_non_bursting_master_requests mux, which is an e_mux
  pwm_red1_avalon_slave_0_non_bursting_master_requests <= internal_cpu_data_master_requests_pwm_red1_avalon_slave_0;
  --pwm_red1_avalon_slave_0_any_bursting_master_saved_grant mux, which is an e_mux
  pwm_red1_avalon_slave_0_any_bursting_master_saved_grant <= std_logic'('0');
  --pwm_red1_avalon_slave_0_arb_share_counter_next_value assignment, which is an e_assign
  pwm_red1_avalon_slave_0_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(pwm_red1_avalon_slave_0_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pwm_red1_avalon_slave_0_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(pwm_red1_avalon_slave_0_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pwm_red1_avalon_slave_0_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --pwm_red1_avalon_slave_0_allgrants all slave grants, which is an e_mux
  pwm_red1_avalon_slave_0_allgrants <= pwm_red1_avalon_slave_0_grant_vector;
  --pwm_red1_avalon_slave_0_end_xfer assignment, which is an e_assign
  pwm_red1_avalon_slave_0_end_xfer <= NOT ((pwm_red1_avalon_slave_0_waits_for_read OR pwm_red1_avalon_slave_0_waits_for_write));
  --end_xfer_arb_share_counter_term_pwm_red1_avalon_slave_0 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_pwm_red1_avalon_slave_0 <= pwm_red1_avalon_slave_0_end_xfer AND (((NOT pwm_red1_avalon_slave_0_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --pwm_red1_avalon_slave_0_arb_share_counter arbitration counter enable, which is an e_assign
  pwm_red1_avalon_slave_0_arb_counter_enable <= ((end_xfer_arb_share_counter_term_pwm_red1_avalon_slave_0 AND pwm_red1_avalon_slave_0_allgrants)) OR ((end_xfer_arb_share_counter_term_pwm_red1_avalon_slave_0 AND NOT pwm_red1_avalon_slave_0_non_bursting_master_requests));
  --pwm_red1_avalon_slave_0_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      pwm_red1_avalon_slave_0_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(pwm_red1_avalon_slave_0_arb_counter_enable) = '1' then 
        pwm_red1_avalon_slave_0_arb_share_counter <= pwm_red1_avalon_slave_0_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pwm_red1_avalon_slave_0_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      pwm_red1_avalon_slave_0_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((pwm_red1_avalon_slave_0_master_qreq_vector AND end_xfer_arb_share_counter_term_pwm_red1_avalon_slave_0)) OR ((end_xfer_arb_share_counter_term_pwm_red1_avalon_slave_0 AND NOT pwm_red1_avalon_slave_0_non_bursting_master_requests)))) = '1' then 
        pwm_red1_avalon_slave_0_slavearbiterlockenable <= pwm_red1_avalon_slave_0_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master pwm_red1/avalon_slave_0 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= pwm_red1_avalon_slave_0_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --pwm_red1_avalon_slave_0_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  pwm_red1_avalon_slave_0_slavearbiterlockenable2 <= pwm_red1_avalon_slave_0_arb_share_counter_next_value;
  --cpu/data_master pwm_red1/avalon_slave_0 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= pwm_red1_avalon_slave_0_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --pwm_red1_avalon_slave_0_any_continuerequest at least one master continues requesting, which is an e_assign
  pwm_red1_avalon_slave_0_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_pwm_red1_avalon_slave_0 <= internal_cpu_data_master_requests_pwm_red1_avalon_slave_0 AND NOT (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write));
  --pwm_red1_avalon_slave_0_writedata mux, which is an e_mux
  pwm_red1_avalon_slave_0_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_pwm_red1_avalon_slave_0 <= internal_cpu_data_master_qualified_request_pwm_red1_avalon_slave_0;
  --cpu/data_master saved-grant pwm_red1/avalon_slave_0, which is an e_assign
  cpu_data_master_saved_grant_pwm_red1_avalon_slave_0 <= internal_cpu_data_master_requests_pwm_red1_avalon_slave_0;
  --allow new arb cycle for pwm_red1/avalon_slave_0, which is an e_assign
  pwm_red1_avalon_slave_0_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  pwm_red1_avalon_slave_0_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  pwm_red1_avalon_slave_0_master_qreq_vector <= std_logic'('1');
  --pwm_red1_avalon_slave_0_reset_n assignment, which is an e_assign
  pwm_red1_avalon_slave_0_reset_n <= reset_n;
  pwm_red1_avalon_slave_0_chipselect <= internal_cpu_data_master_granted_pwm_red1_avalon_slave_0;
  --pwm_red1_avalon_slave_0_firsttransfer first transaction, which is an e_assign
  pwm_red1_avalon_slave_0_firsttransfer <= A_WE_StdLogic((std_logic'(pwm_red1_avalon_slave_0_begins_xfer) = '1'), pwm_red1_avalon_slave_0_unreg_firsttransfer, pwm_red1_avalon_slave_0_reg_firsttransfer);
  --pwm_red1_avalon_slave_0_unreg_firsttransfer first transaction, which is an e_assign
  pwm_red1_avalon_slave_0_unreg_firsttransfer <= NOT ((pwm_red1_avalon_slave_0_slavearbiterlockenable AND pwm_red1_avalon_slave_0_any_continuerequest));
  --pwm_red1_avalon_slave_0_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      pwm_red1_avalon_slave_0_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(pwm_red1_avalon_slave_0_begins_xfer) = '1' then 
        pwm_red1_avalon_slave_0_reg_firsttransfer <= pwm_red1_avalon_slave_0_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --pwm_red1_avalon_slave_0_beginbursttransfer_internal begin burst transfer, which is an e_assign
  pwm_red1_avalon_slave_0_beginbursttransfer_internal <= pwm_red1_avalon_slave_0_begins_xfer;
  --~pwm_red1_avalon_slave_0_write_n assignment, which is an e_mux
  pwm_red1_avalon_slave_0_write_n <= NOT ((internal_cpu_data_master_granted_pwm_red1_avalon_slave_0 AND cpu_data_master_write));
  shifted_address_to_pwm_red1_avalon_slave_0_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --pwm_red1_avalon_slave_0_address mux, which is an e_mux
  pwm_red1_avalon_slave_0_address <= Vector_To_Std_Logic(A_SRL(shifted_address_to_pwm_red1_avalon_slave_0_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")));
  --d1_pwm_red1_avalon_slave_0_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_pwm_red1_avalon_slave_0_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_pwm_red1_avalon_slave_0_end_xfer <= pwm_red1_avalon_slave_0_end_xfer;
      end if;
    end if;

  end process;

  --pwm_red1_avalon_slave_0_waits_for_read in a cycle, which is an e_mux
  pwm_red1_avalon_slave_0_waits_for_read <= pwm_red1_avalon_slave_0_in_a_read_cycle AND pwm_red1_avalon_slave_0_begins_xfer;
  --pwm_red1_avalon_slave_0_in_a_read_cycle assignment, which is an e_assign
  pwm_red1_avalon_slave_0_in_a_read_cycle <= internal_cpu_data_master_granted_pwm_red1_avalon_slave_0 AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= pwm_red1_avalon_slave_0_in_a_read_cycle;
  --pwm_red1_avalon_slave_0_waits_for_write in a cycle, which is an e_mux
  pwm_red1_avalon_slave_0_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pwm_red1_avalon_slave_0_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --pwm_red1_avalon_slave_0_in_a_write_cycle assignment, which is an e_assign
  pwm_red1_avalon_slave_0_in_a_write_cycle <= internal_cpu_data_master_granted_pwm_red1_avalon_slave_0 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= pwm_red1_avalon_slave_0_in_a_write_cycle;
  wait_for_pwm_red1_avalon_slave_0_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_pwm_red1_avalon_slave_0 <= internal_cpu_data_master_granted_pwm_red1_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_pwm_red1_avalon_slave_0 <= internal_cpu_data_master_qualified_request_pwm_red1_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_data_master_requests_pwm_red1_avalon_slave_0 <= internal_cpu_data_master_requests_pwm_red1_avalon_slave_0;
--synthesis translate_off
    --pwm_red1/avalon_slave_0 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pwm_red2_avalon_slave_0_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pwm_red2_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_pwm_red2_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_pwm_red2_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_pwm_red2_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_pwm_red2_avalon_slave_0 : OUT STD_LOGIC;
                 signal d1_pwm_red2_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                 signal pwm_red2_avalon_slave_0_address : OUT STD_LOGIC;
                 signal pwm_red2_avalon_slave_0_chipselect : OUT STD_LOGIC;
                 signal pwm_red2_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal pwm_red2_avalon_slave_0_reset_n : OUT STD_LOGIC;
                 signal pwm_red2_avalon_slave_0_write_n : OUT STD_LOGIC;
                 signal pwm_red2_avalon_slave_0_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity pwm_red2_avalon_slave_0_arbitrator;


architecture europa of pwm_red2_avalon_slave_0_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_pwm_red2_avalon_slave_0 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_pwm_red2_avalon_slave_0 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_pwm_red2_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_pwm_red2_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_pwm_red2_avalon_slave_0 :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_allgrants :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_allow_new_arb_cycle :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_any_bursting_master_saved_grant :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_any_continuerequest :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_arb_counter_enable :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_arb_share_counter :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_arb_share_counter_next_value :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_arb_share_set_values :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_beginbursttransfer_internal :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_begins_xfer :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_firsttransfer :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_grant_vector :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_in_a_read_cycle :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_in_a_write_cycle :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_master_qreq_vector :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_non_bursting_master_requests :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_reg_firsttransfer :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_slavearbiterlockenable :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_slavearbiterlockenable2 :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_unreg_firsttransfer :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_waits_for_read :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_pwm_red2_avalon_slave_0_from_cpu_data_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal wait_for_pwm_red2_avalon_slave_0_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT pwm_red2_avalon_slave_0_end_xfer;
      end if;
    end if;

  end process;

  pwm_red2_avalon_slave_0_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_pwm_red2_avalon_slave_0);
  --assign pwm_red2_avalon_slave_0_readdata_from_sa = pwm_red2_avalon_slave_0_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  pwm_red2_avalon_slave_0_readdata_from_sa <= pwm_red2_avalon_slave_0_readdata;
  internal_cpu_data_master_requests_pwm_red2_avalon_slave_0 <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(18 DOWNTO 3) & std_logic_vector'("000")) = std_logic_vector'("1000001000011110000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --pwm_red2_avalon_slave_0_arb_share_counter set values, which is an e_mux
  pwm_red2_avalon_slave_0_arb_share_set_values <= std_logic'('1');
  --pwm_red2_avalon_slave_0_non_bursting_master_requests mux, which is an e_mux
  pwm_red2_avalon_slave_0_non_bursting_master_requests <= internal_cpu_data_master_requests_pwm_red2_avalon_slave_0;
  --pwm_red2_avalon_slave_0_any_bursting_master_saved_grant mux, which is an e_mux
  pwm_red2_avalon_slave_0_any_bursting_master_saved_grant <= std_logic'('0');
  --pwm_red2_avalon_slave_0_arb_share_counter_next_value assignment, which is an e_assign
  pwm_red2_avalon_slave_0_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(pwm_red2_avalon_slave_0_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pwm_red2_avalon_slave_0_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(pwm_red2_avalon_slave_0_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pwm_red2_avalon_slave_0_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --pwm_red2_avalon_slave_0_allgrants all slave grants, which is an e_mux
  pwm_red2_avalon_slave_0_allgrants <= pwm_red2_avalon_slave_0_grant_vector;
  --pwm_red2_avalon_slave_0_end_xfer assignment, which is an e_assign
  pwm_red2_avalon_slave_0_end_xfer <= NOT ((pwm_red2_avalon_slave_0_waits_for_read OR pwm_red2_avalon_slave_0_waits_for_write));
  --end_xfer_arb_share_counter_term_pwm_red2_avalon_slave_0 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_pwm_red2_avalon_slave_0 <= pwm_red2_avalon_slave_0_end_xfer AND (((NOT pwm_red2_avalon_slave_0_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --pwm_red2_avalon_slave_0_arb_share_counter arbitration counter enable, which is an e_assign
  pwm_red2_avalon_slave_0_arb_counter_enable <= ((end_xfer_arb_share_counter_term_pwm_red2_avalon_slave_0 AND pwm_red2_avalon_slave_0_allgrants)) OR ((end_xfer_arb_share_counter_term_pwm_red2_avalon_slave_0 AND NOT pwm_red2_avalon_slave_0_non_bursting_master_requests));
  --pwm_red2_avalon_slave_0_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      pwm_red2_avalon_slave_0_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(pwm_red2_avalon_slave_0_arb_counter_enable) = '1' then 
        pwm_red2_avalon_slave_0_arb_share_counter <= pwm_red2_avalon_slave_0_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --pwm_red2_avalon_slave_0_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      pwm_red2_avalon_slave_0_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((pwm_red2_avalon_slave_0_master_qreq_vector AND end_xfer_arb_share_counter_term_pwm_red2_avalon_slave_0)) OR ((end_xfer_arb_share_counter_term_pwm_red2_avalon_slave_0 AND NOT pwm_red2_avalon_slave_0_non_bursting_master_requests)))) = '1' then 
        pwm_red2_avalon_slave_0_slavearbiterlockenable <= pwm_red2_avalon_slave_0_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master pwm_red2/avalon_slave_0 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= pwm_red2_avalon_slave_0_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --pwm_red2_avalon_slave_0_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  pwm_red2_avalon_slave_0_slavearbiterlockenable2 <= pwm_red2_avalon_slave_0_arb_share_counter_next_value;
  --cpu/data_master pwm_red2/avalon_slave_0 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= pwm_red2_avalon_slave_0_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --pwm_red2_avalon_slave_0_any_continuerequest at least one master continues requesting, which is an e_assign
  pwm_red2_avalon_slave_0_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_pwm_red2_avalon_slave_0 <= internal_cpu_data_master_requests_pwm_red2_avalon_slave_0 AND NOT (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write));
  --pwm_red2_avalon_slave_0_writedata mux, which is an e_mux
  pwm_red2_avalon_slave_0_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_pwm_red2_avalon_slave_0 <= internal_cpu_data_master_qualified_request_pwm_red2_avalon_slave_0;
  --cpu/data_master saved-grant pwm_red2/avalon_slave_0, which is an e_assign
  cpu_data_master_saved_grant_pwm_red2_avalon_slave_0 <= internal_cpu_data_master_requests_pwm_red2_avalon_slave_0;
  --allow new arb cycle for pwm_red2/avalon_slave_0, which is an e_assign
  pwm_red2_avalon_slave_0_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  pwm_red2_avalon_slave_0_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  pwm_red2_avalon_slave_0_master_qreq_vector <= std_logic'('1');
  --pwm_red2_avalon_slave_0_reset_n assignment, which is an e_assign
  pwm_red2_avalon_slave_0_reset_n <= reset_n;
  pwm_red2_avalon_slave_0_chipselect <= internal_cpu_data_master_granted_pwm_red2_avalon_slave_0;
  --pwm_red2_avalon_slave_0_firsttransfer first transaction, which is an e_assign
  pwm_red2_avalon_slave_0_firsttransfer <= A_WE_StdLogic((std_logic'(pwm_red2_avalon_slave_0_begins_xfer) = '1'), pwm_red2_avalon_slave_0_unreg_firsttransfer, pwm_red2_avalon_slave_0_reg_firsttransfer);
  --pwm_red2_avalon_slave_0_unreg_firsttransfer first transaction, which is an e_assign
  pwm_red2_avalon_slave_0_unreg_firsttransfer <= NOT ((pwm_red2_avalon_slave_0_slavearbiterlockenable AND pwm_red2_avalon_slave_0_any_continuerequest));
  --pwm_red2_avalon_slave_0_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      pwm_red2_avalon_slave_0_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(pwm_red2_avalon_slave_0_begins_xfer) = '1' then 
        pwm_red2_avalon_slave_0_reg_firsttransfer <= pwm_red2_avalon_slave_0_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --pwm_red2_avalon_slave_0_beginbursttransfer_internal begin burst transfer, which is an e_assign
  pwm_red2_avalon_slave_0_beginbursttransfer_internal <= pwm_red2_avalon_slave_0_begins_xfer;
  --~pwm_red2_avalon_slave_0_write_n assignment, which is an e_mux
  pwm_red2_avalon_slave_0_write_n <= NOT ((internal_cpu_data_master_granted_pwm_red2_avalon_slave_0 AND cpu_data_master_write));
  shifted_address_to_pwm_red2_avalon_slave_0_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --pwm_red2_avalon_slave_0_address mux, which is an e_mux
  pwm_red2_avalon_slave_0_address <= Vector_To_Std_Logic(A_SRL(shifted_address_to_pwm_red2_avalon_slave_0_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")));
  --d1_pwm_red2_avalon_slave_0_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_pwm_red2_avalon_slave_0_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_pwm_red2_avalon_slave_0_end_xfer <= pwm_red2_avalon_slave_0_end_xfer;
      end if;
    end if;

  end process;

  --pwm_red2_avalon_slave_0_waits_for_read in a cycle, which is an e_mux
  pwm_red2_avalon_slave_0_waits_for_read <= pwm_red2_avalon_slave_0_in_a_read_cycle AND pwm_red2_avalon_slave_0_begins_xfer;
  --pwm_red2_avalon_slave_0_in_a_read_cycle assignment, which is an e_assign
  pwm_red2_avalon_slave_0_in_a_read_cycle <= internal_cpu_data_master_granted_pwm_red2_avalon_slave_0 AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= pwm_red2_avalon_slave_0_in_a_read_cycle;
  --pwm_red2_avalon_slave_0_waits_for_write in a cycle, which is an e_mux
  pwm_red2_avalon_slave_0_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(pwm_red2_avalon_slave_0_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --pwm_red2_avalon_slave_0_in_a_write_cycle assignment, which is an e_assign
  pwm_red2_avalon_slave_0_in_a_write_cycle <= internal_cpu_data_master_granted_pwm_red2_avalon_slave_0 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= pwm_red2_avalon_slave_0_in_a_write_cycle;
  wait_for_pwm_red2_avalon_slave_0_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_pwm_red2_avalon_slave_0 <= internal_cpu_data_master_granted_pwm_red2_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_pwm_red2_avalon_slave_0 <= internal_cpu_data_master_qualified_request_pwm_red2_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_data_master_requests_pwm_red2_avalon_slave_0 <= internal_cpu_data_master_requests_pwm_red2_avalon_slave_0;
--synthesis translate_off
    --pwm_red2/avalon_slave_0 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity sys_clk_timer_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal sys_clk_timer_s1_irq : IN STD_LOGIC;
                 signal sys_clk_timer_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal cpu_data_master_granted_sys_clk_timer_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_sys_clk_timer_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_sys_clk_timer_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_sys_clk_timer_s1 : OUT STD_LOGIC;
                 signal d1_sys_clk_timer_s1_end_xfer : OUT STD_LOGIC;
                 signal sys_clk_timer_s1_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal sys_clk_timer_s1_chipselect : OUT STD_LOGIC;
                 signal sys_clk_timer_s1_irq_from_sa : OUT STD_LOGIC;
                 signal sys_clk_timer_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sys_clk_timer_s1_reset_n : OUT STD_LOGIC;
                 signal sys_clk_timer_s1_write_n : OUT STD_LOGIC;
                 signal sys_clk_timer_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
              );
end entity sys_clk_timer_s1_arbitrator;


architecture europa of sys_clk_timer_s1_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_sys_clk_timer_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_sys_clk_timer_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_sys_clk_timer_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_sys_clk_timer_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_sys_clk_timer_s1 :  STD_LOGIC;
                signal shifted_address_to_sys_clk_timer_s1_from_cpu_data_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal sys_clk_timer_s1_allgrants :  STD_LOGIC;
                signal sys_clk_timer_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal sys_clk_timer_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal sys_clk_timer_s1_any_continuerequest :  STD_LOGIC;
                signal sys_clk_timer_s1_arb_counter_enable :  STD_LOGIC;
                signal sys_clk_timer_s1_arb_share_counter :  STD_LOGIC;
                signal sys_clk_timer_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal sys_clk_timer_s1_arb_share_set_values :  STD_LOGIC;
                signal sys_clk_timer_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal sys_clk_timer_s1_begins_xfer :  STD_LOGIC;
                signal sys_clk_timer_s1_end_xfer :  STD_LOGIC;
                signal sys_clk_timer_s1_firsttransfer :  STD_LOGIC;
                signal sys_clk_timer_s1_grant_vector :  STD_LOGIC;
                signal sys_clk_timer_s1_in_a_read_cycle :  STD_LOGIC;
                signal sys_clk_timer_s1_in_a_write_cycle :  STD_LOGIC;
                signal sys_clk_timer_s1_master_qreq_vector :  STD_LOGIC;
                signal sys_clk_timer_s1_non_bursting_master_requests :  STD_LOGIC;
                signal sys_clk_timer_s1_reg_firsttransfer :  STD_LOGIC;
                signal sys_clk_timer_s1_slavearbiterlockenable :  STD_LOGIC;
                signal sys_clk_timer_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal sys_clk_timer_s1_unreg_firsttransfer :  STD_LOGIC;
                signal sys_clk_timer_s1_waits_for_read :  STD_LOGIC;
                signal sys_clk_timer_s1_waits_for_write :  STD_LOGIC;
                signal wait_for_sys_clk_timer_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT sys_clk_timer_s1_end_xfer;
      end if;
    end if;

  end process;

  sys_clk_timer_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_sys_clk_timer_s1);
  --assign sys_clk_timer_s1_readdata_from_sa = sys_clk_timer_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  sys_clk_timer_s1_readdata_from_sa <= sys_clk_timer_s1_readdata;
  internal_cpu_data_master_requests_sys_clk_timer_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(18 DOWNTO 5) & std_logic_vector'("00000")) = std_logic_vector'("1000001000000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --sys_clk_timer_s1_arb_share_counter set values, which is an e_mux
  sys_clk_timer_s1_arb_share_set_values <= std_logic'('1');
  --sys_clk_timer_s1_non_bursting_master_requests mux, which is an e_mux
  sys_clk_timer_s1_non_bursting_master_requests <= internal_cpu_data_master_requests_sys_clk_timer_s1;
  --sys_clk_timer_s1_any_bursting_master_saved_grant mux, which is an e_mux
  sys_clk_timer_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --sys_clk_timer_s1_arb_share_counter_next_value assignment, which is an e_assign
  sys_clk_timer_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(sys_clk_timer_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sys_clk_timer_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(sys_clk_timer_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sys_clk_timer_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --sys_clk_timer_s1_allgrants all slave grants, which is an e_mux
  sys_clk_timer_s1_allgrants <= sys_clk_timer_s1_grant_vector;
  --sys_clk_timer_s1_end_xfer assignment, which is an e_assign
  sys_clk_timer_s1_end_xfer <= NOT ((sys_clk_timer_s1_waits_for_read OR sys_clk_timer_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_sys_clk_timer_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_sys_clk_timer_s1 <= sys_clk_timer_s1_end_xfer AND (((NOT sys_clk_timer_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --sys_clk_timer_s1_arb_share_counter arbitration counter enable, which is an e_assign
  sys_clk_timer_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_sys_clk_timer_s1 AND sys_clk_timer_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_sys_clk_timer_s1 AND NOT sys_clk_timer_s1_non_bursting_master_requests));
  --sys_clk_timer_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sys_clk_timer_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(sys_clk_timer_s1_arb_counter_enable) = '1' then 
        sys_clk_timer_s1_arb_share_counter <= sys_clk_timer_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --sys_clk_timer_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sys_clk_timer_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((sys_clk_timer_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_sys_clk_timer_s1)) OR ((end_xfer_arb_share_counter_term_sys_clk_timer_s1 AND NOT sys_clk_timer_s1_non_bursting_master_requests)))) = '1' then 
        sys_clk_timer_s1_slavearbiterlockenable <= sys_clk_timer_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master sys_clk_timer/s1 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= sys_clk_timer_s1_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --sys_clk_timer_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  sys_clk_timer_s1_slavearbiterlockenable2 <= sys_clk_timer_s1_arb_share_counter_next_value;
  --cpu/data_master sys_clk_timer/s1 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= sys_clk_timer_s1_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --sys_clk_timer_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  sys_clk_timer_s1_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_sys_clk_timer_s1 <= internal_cpu_data_master_requests_sys_clk_timer_s1 AND NOT (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write));
  --sys_clk_timer_s1_writedata mux, which is an e_mux
  sys_clk_timer_s1_writedata <= cpu_data_master_writedata (15 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_data_master_granted_sys_clk_timer_s1 <= internal_cpu_data_master_qualified_request_sys_clk_timer_s1;
  --cpu/data_master saved-grant sys_clk_timer/s1, which is an e_assign
  cpu_data_master_saved_grant_sys_clk_timer_s1 <= internal_cpu_data_master_requests_sys_clk_timer_s1;
  --allow new arb cycle for sys_clk_timer/s1, which is an e_assign
  sys_clk_timer_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  sys_clk_timer_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  sys_clk_timer_s1_master_qreq_vector <= std_logic'('1');
  --sys_clk_timer_s1_reset_n assignment, which is an e_assign
  sys_clk_timer_s1_reset_n <= reset_n;
  sys_clk_timer_s1_chipselect <= internal_cpu_data_master_granted_sys_clk_timer_s1;
  --sys_clk_timer_s1_firsttransfer first transaction, which is an e_assign
  sys_clk_timer_s1_firsttransfer <= A_WE_StdLogic((std_logic'(sys_clk_timer_s1_begins_xfer) = '1'), sys_clk_timer_s1_unreg_firsttransfer, sys_clk_timer_s1_reg_firsttransfer);
  --sys_clk_timer_s1_unreg_firsttransfer first transaction, which is an e_assign
  sys_clk_timer_s1_unreg_firsttransfer <= NOT ((sys_clk_timer_s1_slavearbiterlockenable AND sys_clk_timer_s1_any_continuerequest));
  --sys_clk_timer_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sys_clk_timer_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(sys_clk_timer_s1_begins_xfer) = '1' then 
        sys_clk_timer_s1_reg_firsttransfer <= sys_clk_timer_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --sys_clk_timer_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  sys_clk_timer_s1_beginbursttransfer_internal <= sys_clk_timer_s1_begins_xfer;
  --~sys_clk_timer_s1_write_n assignment, which is an e_mux
  sys_clk_timer_s1_write_n <= NOT ((internal_cpu_data_master_granted_sys_clk_timer_s1 AND cpu_data_master_write));
  shifted_address_to_sys_clk_timer_s1_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --sys_clk_timer_s1_address mux, which is an e_mux
  sys_clk_timer_s1_address <= A_EXT (A_SRL(shifted_address_to_sys_clk_timer_s1_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 3);
  --d1_sys_clk_timer_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_sys_clk_timer_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_sys_clk_timer_s1_end_xfer <= sys_clk_timer_s1_end_xfer;
      end if;
    end if;

  end process;

  --sys_clk_timer_s1_waits_for_read in a cycle, which is an e_mux
  sys_clk_timer_s1_waits_for_read <= sys_clk_timer_s1_in_a_read_cycle AND sys_clk_timer_s1_begins_xfer;
  --sys_clk_timer_s1_in_a_read_cycle assignment, which is an e_assign
  sys_clk_timer_s1_in_a_read_cycle <= internal_cpu_data_master_granted_sys_clk_timer_s1 AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= sys_clk_timer_s1_in_a_read_cycle;
  --sys_clk_timer_s1_waits_for_write in a cycle, which is an e_mux
  sys_clk_timer_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sys_clk_timer_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --sys_clk_timer_s1_in_a_write_cycle assignment, which is an e_assign
  sys_clk_timer_s1_in_a_write_cycle <= internal_cpu_data_master_granted_sys_clk_timer_s1 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= sys_clk_timer_s1_in_a_write_cycle;
  wait_for_sys_clk_timer_s1_counter <= std_logic'('0');
  --assign sys_clk_timer_s1_irq_from_sa = sys_clk_timer_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  sys_clk_timer_s1_irq_from_sa <= sys_clk_timer_s1_irq;
  --vhdl renameroo for output signals
  cpu_data_master_granted_sys_clk_timer_s1 <= internal_cpu_data_master_granted_sys_clk_timer_s1;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_sys_clk_timer_s1 <= internal_cpu_data_master_qualified_request_sys_clk_timer_s1;
  --vhdl renameroo for output signals
  cpu_data_master_requests_sys_clk_timer_s1 <= internal_cpu_data_master_requests_sys_clk_timer_s1;
--synthesis translate_off
    --sys_clk_timer/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity uart_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal uart_s1_dataavailable : IN STD_LOGIC;
                 signal uart_s1_irq : IN STD_LOGIC;
                 signal uart_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal uart_s1_readyfordata : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_uart_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_uart_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_uart_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_uart_s1 : OUT STD_LOGIC;
                 signal d1_uart_s1_end_xfer : OUT STD_LOGIC;
                 signal uart_s1_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal uart_s1_begintransfer : OUT STD_LOGIC;
                 signal uart_s1_chipselect : OUT STD_LOGIC;
                 signal uart_s1_dataavailable_from_sa : OUT STD_LOGIC;
                 signal uart_s1_irq_from_sa : OUT STD_LOGIC;
                 signal uart_s1_read_n : OUT STD_LOGIC;
                 signal uart_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal uart_s1_readyfordata_from_sa : OUT STD_LOGIC;
                 signal uart_s1_reset_n : OUT STD_LOGIC;
                 signal uart_s1_write_n : OUT STD_LOGIC;
                 signal uart_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
              );
end entity uart_s1_arbitrator;


architecture europa of uart_s1_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_uart_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_uart_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_uart_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_uart_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_uart_s1 :  STD_LOGIC;
                signal shifted_address_to_uart_s1_from_cpu_data_master :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal uart_s1_allgrants :  STD_LOGIC;
                signal uart_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal uart_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal uart_s1_any_continuerequest :  STD_LOGIC;
                signal uart_s1_arb_counter_enable :  STD_LOGIC;
                signal uart_s1_arb_share_counter :  STD_LOGIC;
                signal uart_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal uart_s1_arb_share_set_values :  STD_LOGIC;
                signal uart_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal uart_s1_begins_xfer :  STD_LOGIC;
                signal uart_s1_end_xfer :  STD_LOGIC;
                signal uart_s1_firsttransfer :  STD_LOGIC;
                signal uart_s1_grant_vector :  STD_LOGIC;
                signal uart_s1_in_a_read_cycle :  STD_LOGIC;
                signal uart_s1_in_a_write_cycle :  STD_LOGIC;
                signal uart_s1_master_qreq_vector :  STD_LOGIC;
                signal uart_s1_non_bursting_master_requests :  STD_LOGIC;
                signal uart_s1_reg_firsttransfer :  STD_LOGIC;
                signal uart_s1_slavearbiterlockenable :  STD_LOGIC;
                signal uart_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal uart_s1_unreg_firsttransfer :  STD_LOGIC;
                signal uart_s1_waits_for_read :  STD_LOGIC;
                signal uart_s1_waits_for_write :  STD_LOGIC;
                signal wait_for_uart_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT uart_s1_end_xfer;
      end if;
    end if;

  end process;

  uart_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_uart_s1);
  --assign uart_s1_readdata_from_sa = uart_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  uart_s1_readdata_from_sa <= uart_s1_readdata;
  internal_cpu_data_master_requests_uart_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(18 DOWNTO 5) & std_logic_vector'("00000")) = std_logic_vector'("1000001000001000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign uart_s1_dataavailable_from_sa = uart_s1_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  uart_s1_dataavailable_from_sa <= uart_s1_dataavailable;
  --assign uart_s1_readyfordata_from_sa = uart_s1_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  uart_s1_readyfordata_from_sa <= uart_s1_readyfordata;
  --uart_s1_arb_share_counter set values, which is an e_mux
  uart_s1_arb_share_set_values <= std_logic'('1');
  --uart_s1_non_bursting_master_requests mux, which is an e_mux
  uart_s1_non_bursting_master_requests <= internal_cpu_data_master_requests_uart_s1;
  --uart_s1_any_bursting_master_saved_grant mux, which is an e_mux
  uart_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --uart_s1_arb_share_counter_next_value assignment, which is an e_assign
  uart_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(uart_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(uart_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(uart_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(uart_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --uart_s1_allgrants all slave grants, which is an e_mux
  uart_s1_allgrants <= uart_s1_grant_vector;
  --uart_s1_end_xfer assignment, which is an e_assign
  uart_s1_end_xfer <= NOT ((uart_s1_waits_for_read OR uart_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_uart_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_uart_s1 <= uart_s1_end_xfer AND (((NOT uart_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --uart_s1_arb_share_counter arbitration counter enable, which is an e_assign
  uart_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_uart_s1 AND uart_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_uart_s1 AND NOT uart_s1_non_bursting_master_requests));
  --uart_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      uart_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(uart_s1_arb_counter_enable) = '1' then 
        uart_s1_arb_share_counter <= uart_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --uart_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      uart_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((uart_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_uart_s1)) OR ((end_xfer_arb_share_counter_term_uart_s1 AND NOT uart_s1_non_bursting_master_requests)))) = '1' then 
        uart_s1_slavearbiterlockenable <= uart_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master uart/s1 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= uart_s1_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --uart_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  uart_s1_slavearbiterlockenable2 <= uart_s1_arb_share_counter_next_value;
  --cpu/data_master uart/s1 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= uart_s1_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --uart_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  uart_s1_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_uart_s1 <= internal_cpu_data_master_requests_uart_s1;
  --uart_s1_writedata mux, which is an e_mux
  uart_s1_writedata <= cpu_data_master_writedata (15 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_data_master_granted_uart_s1 <= internal_cpu_data_master_qualified_request_uart_s1;
  --cpu/data_master saved-grant uart/s1, which is an e_assign
  cpu_data_master_saved_grant_uart_s1 <= internal_cpu_data_master_requests_uart_s1;
  --allow new arb cycle for uart/s1, which is an e_assign
  uart_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  uart_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  uart_s1_master_qreq_vector <= std_logic'('1');
  uart_s1_begintransfer <= uart_s1_begins_xfer;
  --uart_s1_reset_n assignment, which is an e_assign
  uart_s1_reset_n <= reset_n;
  uart_s1_chipselect <= internal_cpu_data_master_granted_uart_s1;
  --uart_s1_firsttransfer first transaction, which is an e_assign
  uart_s1_firsttransfer <= A_WE_StdLogic((std_logic'(uart_s1_begins_xfer) = '1'), uart_s1_unreg_firsttransfer, uart_s1_reg_firsttransfer);
  --uart_s1_unreg_firsttransfer first transaction, which is an e_assign
  uart_s1_unreg_firsttransfer <= NOT ((uart_s1_slavearbiterlockenable AND uart_s1_any_continuerequest));
  --uart_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      uart_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(uart_s1_begins_xfer) = '1' then 
        uart_s1_reg_firsttransfer <= uart_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --uart_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  uart_s1_beginbursttransfer_internal <= uart_s1_begins_xfer;
  --~uart_s1_read_n assignment, which is an e_mux
  uart_s1_read_n <= NOT ((internal_cpu_data_master_granted_uart_s1 AND cpu_data_master_read));
  --~uart_s1_write_n assignment, which is an e_mux
  uart_s1_write_n <= NOT ((internal_cpu_data_master_granted_uart_s1 AND cpu_data_master_write));
  shifted_address_to_uart_s1_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --uart_s1_address mux, which is an e_mux
  uart_s1_address <= A_EXT (A_SRL(shifted_address_to_uart_s1_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 3);
  --d1_uart_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_uart_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_uart_s1_end_xfer <= uart_s1_end_xfer;
      end if;
    end if;

  end process;

  --uart_s1_waits_for_read in a cycle, which is an e_mux
  uart_s1_waits_for_read <= uart_s1_in_a_read_cycle AND uart_s1_begins_xfer;
  --uart_s1_in_a_read_cycle assignment, which is an e_assign
  uart_s1_in_a_read_cycle <= internal_cpu_data_master_granted_uart_s1 AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= uart_s1_in_a_read_cycle;
  --uart_s1_waits_for_write in a cycle, which is an e_mux
  uart_s1_waits_for_write <= uart_s1_in_a_write_cycle AND uart_s1_begins_xfer;
  --uart_s1_in_a_write_cycle assignment, which is an e_assign
  uart_s1_in_a_write_cycle <= internal_cpu_data_master_granted_uart_s1 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= uart_s1_in_a_write_cycle;
  wait_for_uart_s1_counter <= std_logic'('0');
  --assign uart_s1_irq_from_sa = uart_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  uart_s1_irq_from_sa <= uart_s1_irq;
  --vhdl renameroo for output signals
  cpu_data_master_granted_uart_s1 <= internal_cpu_data_master_granted_uart_s1;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_uart_s1 <= internal_cpu_data_master_qualified_request_uart_s1;
  --vhdl renameroo for output signals
  cpu_data_master_requests_uart_s1 <= internal_cpu_data_master_requests_uart_s1;
--synthesis translate_off
    --uart/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity NIOS_System_1_reset_clk_domain_synch_module is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC
              );
end entity NIOS_System_1_reset_clk_domain_synch_module;


architecture europa of NIOS_System_1_reset_clk_domain_synch_module is
                signal data_in_d1 :  STD_LOGIC;
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of data_in_d1 : signal is "{-from ""*""} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of data_out : signal is "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101";

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      data_in_d1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        data_in_d1 <= data_in;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      data_out <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        data_out <= data_in_d1;
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity NIOS_System_1 is 
        port (
              -- 1) global signals:
                 signal clk : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- the_HEX0
                 signal out_port_from_the_HEX0 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);

              -- the_HEX1
                 signal out_port_from_the_HEX1 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);

              -- the_HEX2
                 signal out_port_from_the_HEX2 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);

              -- the_HEX3
                 signal out_port_from_the_HEX3 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);

              -- the_HEX4_to_HEX7
                 signal out_port_from_the_HEX4_to_HEX7 : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);

              -- the_KEYS
                 signal in_port_to_the_KEYS : IN STD_LOGIC_VECTOR (2 DOWNTO 0);

              -- the_SWITCHS
                 signal in_port_to_the_SWITCHS : IN STD_LOGIC_VECTOR (17 DOWNTO 0);

              -- the_lcd
                 signal LCD_E_from_the_lcd : OUT STD_LOGIC;
                 signal LCD_RS_from_the_lcd : OUT STD_LOGIC;
                 signal LCD_RW_from_the_lcd : OUT STD_LOGIC;
                 signal LCD_data_to_and_from_the_lcd : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);

              -- the_pwm_green
                 signal out_port_from_the_pwm_green : OUT STD_LOGIC;

              -- the_pwm_red1
                 signal out_port_from_the_pwm_red1 : OUT STD_LOGIC;

              -- the_pwm_red2
                 signal out_port_from_the_pwm_red2 : OUT STD_LOGIC;

              -- the_uart
                 signal rxd_to_the_uart : IN STD_LOGIC;
                 signal txd_from_the_uart : OUT STD_LOGIC
              );
end entity NIOS_System_1;


architecture europa of NIOS_System_1 is
component CPU_MEM_s1_arbitrator is 
           port (
                 -- inputs:
                    signal CPU_MEM_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_instruction_master_latency_counter : IN STD_LOGIC;
                    signal cpu_instruction_master_read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal CPU_MEM_s1_address : OUT STD_LOGIC_VECTOR (14 DOWNTO 0);
                    signal CPU_MEM_s1_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal CPU_MEM_s1_chipselect : OUT STD_LOGIC;
                    signal CPU_MEM_s1_clken : OUT STD_LOGIC;
                    signal CPU_MEM_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal CPU_MEM_s1_write : OUT STD_LOGIC;
                    signal CPU_MEM_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_data_master_granted_CPU_MEM_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_CPU_MEM_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_CPU_MEM_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_CPU_MEM_s1 : OUT STD_LOGIC;
                    signal cpu_instruction_master_granted_CPU_MEM_s1 : OUT STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_CPU_MEM_s1 : OUT STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_CPU_MEM_s1 : OUT STD_LOGIC;
                    signal cpu_instruction_master_requests_CPU_MEM_s1 : OUT STD_LOGIC;
                    signal d1_CPU_MEM_s1_end_xfer : OUT STD_LOGIC;
                    signal registered_cpu_data_master_read_data_valid_CPU_MEM_s1 : OUT STD_LOGIC
                 );
end component CPU_MEM_s1_arbitrator;

component CPU_MEM is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (14 DOWNTO 0);
                    signal byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal clken : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component CPU_MEM;

component HEX0_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal HEX0_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal HEX0_s1_chipselect : OUT STD_LOGIC;
                    signal HEX0_s1_reset_n : OUT STD_LOGIC;
                    signal HEX0_s1_write_n : OUT STD_LOGIC;
                    signal HEX0_s1_writedata : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
                    signal cpu_data_master_granted_HEX0_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_HEX0_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_HEX0_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_HEX0_s1 : OUT STD_LOGIC;
                    signal d1_HEX0_s1_end_xfer : OUT STD_LOGIC
                 );
end component HEX0_s1_arbitrator;

component HEX0 is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (6 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
                 );
end component HEX0;

component HEX1_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal HEX1_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal HEX1_s1_chipselect : OUT STD_LOGIC;
                    signal HEX1_s1_reset_n : OUT STD_LOGIC;
                    signal HEX1_s1_write_n : OUT STD_LOGIC;
                    signal HEX1_s1_writedata : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
                    signal cpu_data_master_granted_HEX1_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_HEX1_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_HEX1_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_HEX1_s1 : OUT STD_LOGIC;
                    signal d1_HEX1_s1_end_xfer : OUT STD_LOGIC
                 );
end component HEX1_s1_arbitrator;

component HEX1 is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (6 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
                 );
end component HEX1;

component HEX2_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal HEX2_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal HEX2_s1_chipselect : OUT STD_LOGIC;
                    signal HEX2_s1_reset_n : OUT STD_LOGIC;
                    signal HEX2_s1_write_n : OUT STD_LOGIC;
                    signal HEX2_s1_writedata : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
                    signal cpu_data_master_granted_HEX2_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_HEX2_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_HEX2_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_HEX2_s1 : OUT STD_LOGIC;
                    signal d1_HEX2_s1_end_xfer : OUT STD_LOGIC
                 );
end component HEX2_s1_arbitrator;

component HEX2 is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (6 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
                 );
end component HEX2;

component HEX3_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal HEX3_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal HEX3_s1_chipselect : OUT STD_LOGIC;
                    signal HEX3_s1_reset_n : OUT STD_LOGIC;
                    signal HEX3_s1_write_n : OUT STD_LOGIC;
                    signal HEX3_s1_writedata : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
                    signal cpu_data_master_granted_HEX3_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_HEX3_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_HEX3_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_HEX3_s1 : OUT STD_LOGIC;
                    signal d1_HEX3_s1_end_xfer : OUT STD_LOGIC
                 );
end component HEX3_s1_arbitrator;

component HEX3 is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (6 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
                 );
end component HEX3;

component HEX4_to_HEX7_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal HEX4_to_HEX7_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal HEX4_to_HEX7_s1_chipselect : OUT STD_LOGIC;
                    signal HEX4_to_HEX7_s1_reset_n : OUT STD_LOGIC;
                    signal HEX4_to_HEX7_s1_write_n : OUT STD_LOGIC;
                    signal HEX4_to_HEX7_s1_writedata : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
                    signal cpu_data_master_granted_HEX4_to_HEX7_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_HEX4_to_HEX7_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_HEX4_to_HEX7_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_HEX4_to_HEX7_s1 : OUT STD_LOGIC;
                    signal d1_HEX4_to_HEX7_s1_end_xfer : OUT STD_LOGIC
                 );
end component HEX4_to_HEX7_s1_arbitrator;

component HEX4_to_HEX7 is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (27 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC_VECTOR (27 DOWNTO 0)
                 );
end component HEX4_to_HEX7;

component KEYS_s1_arbitrator is 
           port (
                 -- inputs:
                    signal KEYS_s1_readdata : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal KEYS_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal KEYS_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal KEYS_s1_reset_n : OUT STD_LOGIC;
                    signal cpu_data_master_granted_KEYS_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_KEYS_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_KEYS_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_KEYS_s1 : OUT STD_LOGIC;
                    signal d1_KEYS_s1_end_xfer : OUT STD_LOGIC
                 );
end component KEYS_s1_arbitrator;

component KEYS is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal in_port : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal readdata : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
                 );
end component KEYS;

component SWITCHS_s1_arbitrator is 
           port (
                 -- inputs:
                    signal SWITCHS_s1_readdata : IN STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal SWITCHS_s1_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal SWITCHS_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal SWITCHS_s1_reset_n : OUT STD_LOGIC;
                    signal cpu_data_master_granted_SWITCHS_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_SWITCHS_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_SWITCHS_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_SWITCHS_s1 : OUT STD_LOGIC;
                    signal d1_SWITCHS_s1_end_xfer : OUT STD_LOGIC
                 );
end component SWITCHS_s1_arbitrator;

component SWITCHS is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal in_port : IN STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal readdata : OUT STD_LOGIC_VECTOR (17 DOWNTO 0)
                 );
end component SWITCHS;

component cpu_jtag_debug_module_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_data_master_debugaccess : IN STD_LOGIC;
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_instruction_master_latency_counter : IN STD_LOGIC;
                    signal cpu_instruction_master_read : IN STD_LOGIC;
                    signal cpu_jtag_debug_module_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_jtag_debug_module_resetrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_data_master_requests_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_instruction_master_granted_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_instruction_master_requests_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_address : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal cpu_jtag_debug_module_begintransfer : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_jtag_debug_module_chipselect : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_debugaccess : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_jtag_debug_module_reset : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_reset_n : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_resetrequest_from_sa : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_write : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_cpu_jtag_debug_module_end_xfer : OUT STD_LOGIC
                 );
end component cpu_jtag_debug_module_arbitrator;

component cpu_data_master_arbitrator is 
           port (
                 -- inputs:
                    signal CPU_MEM_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal KEYS_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal SWITCHS_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_granted_CPU_MEM_s1 : IN STD_LOGIC;
                    signal cpu_data_master_granted_HEX0_s1 : IN STD_LOGIC;
                    signal cpu_data_master_granted_HEX1_s1 : IN STD_LOGIC;
                    signal cpu_data_master_granted_HEX2_s1 : IN STD_LOGIC;
                    signal cpu_data_master_granted_HEX3_s1 : IN STD_LOGIC;
                    signal cpu_data_master_granted_HEX4_to_HEX7_s1 : IN STD_LOGIC;
                    signal cpu_data_master_granted_KEYS_s1 : IN STD_LOGIC;
                    signal cpu_data_master_granted_SWITCHS_s1 : IN STD_LOGIC;
                    signal cpu_data_master_granted_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_data_master_granted_high_res_timer_s1 : IN STD_LOGIC;
                    signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_lcd_control_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_pwm_green_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_granted_pwm_red1_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_granted_pwm_red2_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_granted_sys_clk_timer_s1 : IN STD_LOGIC;
                    signal cpu_data_master_granted_uart_s1 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_CPU_MEM_s1 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_HEX0_s1 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_HEX1_s1 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_HEX2_s1 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_HEX3_s1 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_HEX4_to_HEX7_s1 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_KEYS_s1 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_SWITCHS_s1 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_high_res_timer_s1 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_lcd_control_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_pwm_green_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_pwm_red1_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_pwm_red2_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_sys_clk_timer_s1 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_uart_s1 : IN STD_LOGIC;
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_CPU_MEM_s1 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_HEX0_s1 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_HEX1_s1 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_HEX2_s1 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_HEX3_s1 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_HEX4_to_HEX7_s1 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_KEYS_s1 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_SWITCHS_s1 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_high_res_timer_s1 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_lcd_control_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_pwm_green_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_pwm_red1_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_pwm_red2_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_sys_clk_timer_s1 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_uart_s1 : IN STD_LOGIC;
                    signal cpu_data_master_requests_CPU_MEM_s1 : IN STD_LOGIC;
                    signal cpu_data_master_requests_HEX0_s1 : IN STD_LOGIC;
                    signal cpu_data_master_requests_HEX1_s1 : IN STD_LOGIC;
                    signal cpu_data_master_requests_HEX2_s1 : IN STD_LOGIC;
                    signal cpu_data_master_requests_HEX3_s1 : IN STD_LOGIC;
                    signal cpu_data_master_requests_HEX4_to_HEX7_s1 : IN STD_LOGIC;
                    signal cpu_data_master_requests_KEYS_s1 : IN STD_LOGIC;
                    signal cpu_data_master_requests_SWITCHS_s1 : IN STD_LOGIC;
                    signal cpu_data_master_requests_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_data_master_requests_high_res_timer_s1 : IN STD_LOGIC;
                    signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_lcd_control_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_pwm_green_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_requests_pwm_red1_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_requests_pwm_red2_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_requests_sys_clk_timer_s1 : IN STD_LOGIC;
                    signal cpu_data_master_requests_uart_s1 : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_CPU_MEM_s1_end_xfer : IN STD_LOGIC;
                    signal d1_HEX0_s1_end_xfer : IN STD_LOGIC;
                    signal d1_HEX1_s1_end_xfer : IN STD_LOGIC;
                    signal d1_HEX2_s1_end_xfer : IN STD_LOGIC;
                    signal d1_HEX3_s1_end_xfer : IN STD_LOGIC;
                    signal d1_HEX4_to_HEX7_s1_end_xfer : IN STD_LOGIC;
                    signal d1_KEYS_s1_end_xfer : IN STD_LOGIC;
                    signal d1_SWITCHS_s1_end_xfer : IN STD_LOGIC;
                    signal d1_cpu_jtag_debug_module_end_xfer : IN STD_LOGIC;
                    signal d1_high_res_timer_s1_end_xfer : IN STD_LOGIC;
                    signal d1_jtag_uart_avalon_jtag_slave_end_xfer : IN STD_LOGIC;
                    signal d1_lcd_control_slave_end_xfer : IN STD_LOGIC;
                    signal d1_pwm_green_avalon_slave_0_end_xfer : IN STD_LOGIC;
                    signal d1_pwm_red1_avalon_slave_0_end_xfer : IN STD_LOGIC;
                    signal d1_pwm_red2_avalon_slave_0_end_xfer : IN STD_LOGIC;
                    signal d1_sys_clk_timer_s1_end_xfer : IN STD_LOGIC;
                    signal d1_uart_s1_end_xfer : IN STD_LOGIC;
                    signal high_res_timer_s1_irq_from_sa : IN STD_LOGIC;
                    signal high_res_timer_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_irq_from_sa : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal lcd_control_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal lcd_control_slave_wait_counter_eq_0 : IN STD_LOGIC;
                    signal lcd_control_slave_wait_counter_eq_1 : IN STD_LOGIC;
                    signal pwm_green_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pwm_red1_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pwm_red2_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal registered_cpu_data_master_read_data_valid_CPU_MEM_s1 : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sys_clk_timer_s1_irq_from_sa : IN STD_LOGIC;
                    signal sys_clk_timer_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal uart_s1_irq_from_sa : IN STD_LOGIC;
                    signal uart_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal cpu_data_master_address_to_slave : OUT STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_irq : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_data_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_data_master_waitrequest : OUT STD_LOGIC
                 );
end component cpu_data_master_arbitrator;

component cpu_instruction_master_arbitrator is 
           port (
                 -- inputs:
                    signal CPU_MEM_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal cpu_instruction_master_address : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_instruction_master_granted_CPU_MEM_s1 : IN STD_LOGIC;
                    signal cpu_instruction_master_granted_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_CPU_MEM_s1 : IN STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_instruction_master_read : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_CPU_MEM_s1 : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_instruction_master_requests_CPU_MEM_s1 : IN STD_LOGIC;
                    signal cpu_instruction_master_requests_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_CPU_MEM_s1_end_xfer : IN STD_LOGIC;
                    signal d1_cpu_jtag_debug_module_end_xfer : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_instruction_master_address_to_slave : OUT STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_instruction_master_latency_counter : OUT STD_LOGIC;
                    signal cpu_instruction_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_instruction_master_readdatavalid : OUT STD_LOGIC;
                    signal cpu_instruction_master_waitrequest : OUT STD_LOGIC
                 );
end component cpu_instruction_master_arbitrator;

component cpu is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal d_irq : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d_waitrequest : IN STD_LOGIC;
                    signal i_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal i_readdatavalid : IN STD_LOGIC;
                    signal i_waitrequest : IN STD_LOGIC;
                    signal jtag_debug_module_address : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal jtag_debug_module_begintransfer : IN STD_LOGIC;
                    signal jtag_debug_module_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal jtag_debug_module_clk : IN STD_LOGIC;
                    signal jtag_debug_module_debugaccess : IN STD_LOGIC;
                    signal jtag_debug_module_reset : IN STD_LOGIC;
                    signal jtag_debug_module_select : IN STD_LOGIC;
                    signal jtag_debug_module_write : IN STD_LOGIC;
                    signal jtag_debug_module_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal d_address : OUT STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal d_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal d_read : OUT STD_LOGIC;
                    signal d_write : OUT STD_LOGIC;
                    signal d_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal i_address : OUT STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal i_read : OUT STD_LOGIC;
                    signal jtag_debug_module_debugaccess_to_roms : OUT STD_LOGIC;
                    signal jtag_debug_module_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_debug_module_resetrequest : OUT STD_LOGIC
                 );
end component cpu;

component high_res_timer_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal high_res_timer_s1_irq : IN STD_LOGIC;
                    signal high_res_timer_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_high_res_timer_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_high_res_timer_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_high_res_timer_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_high_res_timer_s1 : OUT STD_LOGIC;
                    signal d1_high_res_timer_s1_end_xfer : OUT STD_LOGIC;
                    signal high_res_timer_s1_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal high_res_timer_s1_chipselect : OUT STD_LOGIC;
                    signal high_res_timer_s1_irq_from_sa : OUT STD_LOGIC;
                    signal high_res_timer_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal high_res_timer_s1_reset_n : OUT STD_LOGIC;
                    signal high_res_timer_s1_write_n : OUT STD_LOGIC;
                    signal high_res_timer_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component high_res_timer_s1_arbitrator;

component high_res_timer is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal irq : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component high_res_timer;

component jtag_uart_avalon_jtag_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_dataavailable : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_irq : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_readyfordata : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                    signal d1_jtag_uart_avalon_jtag_slave_end_xfer : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_address : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_chipselect : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_dataavailable_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_irq_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_read_n : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_readyfordata_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_reset_n : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_write_n : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component jtag_uart_avalon_jtag_slave_arbitrator;

component jtag_uart is 
           port (
                 -- inputs:
                    signal av_address : IN STD_LOGIC;
                    signal av_chipselect : IN STD_LOGIC;
                    signal av_read_n : IN STD_LOGIC;
                    signal av_write_n : IN STD_LOGIC;
                    signal av_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal rst_n : IN STD_LOGIC;

                 -- outputs:
                    signal av_irq : OUT STD_LOGIC;
                    signal av_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal av_waitrequest : OUT STD_LOGIC;
                    signal dataavailable : OUT STD_LOGIC;
                    signal readyfordata : OUT STD_LOGIC
                 );
end component jtag_uart;

component lcd_control_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal lcd_control_slave_readdata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_lcd_control_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_lcd_control_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_lcd_control_slave : OUT STD_LOGIC;
                    signal cpu_data_master_requests_lcd_control_slave : OUT STD_LOGIC;
                    signal d1_lcd_control_slave_end_xfer : OUT STD_LOGIC;
                    signal lcd_control_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal lcd_control_slave_begintransfer : OUT STD_LOGIC;
                    signal lcd_control_slave_read : OUT STD_LOGIC;
                    signal lcd_control_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal lcd_control_slave_wait_counter_eq_0 : OUT STD_LOGIC;
                    signal lcd_control_slave_wait_counter_eq_1 : OUT STD_LOGIC;
                    signal lcd_control_slave_write : OUT STD_LOGIC;
                    signal lcd_control_slave_writedata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
                 );
end component lcd_control_slave_arbitrator;

component lcd is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal begintransfer : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);

                 -- outputs:
                    signal LCD_E : OUT STD_LOGIC;
                    signal LCD_RS : OUT STD_LOGIC;
                    signal LCD_RW : OUT STD_LOGIC;
                    signal LCD_data : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal readdata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
                 );
end component lcd;

component pwm_green_avalon_slave_0_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pwm_green_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_pwm_green_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_pwm_green_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_pwm_green_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_pwm_green_avalon_slave_0 : OUT STD_LOGIC;
                    signal d1_pwm_green_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                    signal pwm_green_avalon_slave_0_address : OUT STD_LOGIC;
                    signal pwm_green_avalon_slave_0_chipselect : OUT STD_LOGIC;
                    signal pwm_green_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pwm_green_avalon_slave_0_reset_n : OUT STD_LOGIC;
                    signal pwm_green_avalon_slave_0_write_n : OUT STD_LOGIC;
                    signal pwm_green_avalon_slave_0_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component pwm_green_avalon_slave_0_arbitrator;

component pwm_green is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC;
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component pwm_green;

component pwm_red1_avalon_slave_0_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pwm_red1_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_pwm_red1_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_pwm_red1_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_pwm_red1_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_pwm_red1_avalon_slave_0 : OUT STD_LOGIC;
                    signal d1_pwm_red1_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                    signal pwm_red1_avalon_slave_0_address : OUT STD_LOGIC;
                    signal pwm_red1_avalon_slave_0_chipselect : OUT STD_LOGIC;
                    signal pwm_red1_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pwm_red1_avalon_slave_0_reset_n : OUT STD_LOGIC;
                    signal pwm_red1_avalon_slave_0_write_n : OUT STD_LOGIC;
                    signal pwm_red1_avalon_slave_0_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component pwm_red1_avalon_slave_0_arbitrator;

component pwm_red1 is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC;
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component pwm_red1;

component pwm_red2_avalon_slave_0_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pwm_red2_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_pwm_red2_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_pwm_red2_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_pwm_red2_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_pwm_red2_avalon_slave_0 : OUT STD_LOGIC;
                    signal d1_pwm_red2_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                    signal pwm_red2_avalon_slave_0_address : OUT STD_LOGIC;
                    signal pwm_red2_avalon_slave_0_chipselect : OUT STD_LOGIC;
                    signal pwm_red2_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal pwm_red2_avalon_slave_0_reset_n : OUT STD_LOGIC;
                    signal pwm_red2_avalon_slave_0_write_n : OUT STD_LOGIC;
                    signal pwm_red2_avalon_slave_0_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component pwm_red2_avalon_slave_0_arbitrator;

component pwm_red2 is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC;
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal out_port : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component pwm_red2;

component sys_clk_timer_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal sys_clk_timer_s1_irq : IN STD_LOGIC;
                    signal sys_clk_timer_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal cpu_data_master_granted_sys_clk_timer_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_sys_clk_timer_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_sys_clk_timer_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_sys_clk_timer_s1 : OUT STD_LOGIC;
                    signal d1_sys_clk_timer_s1_end_xfer : OUT STD_LOGIC;
                    signal sys_clk_timer_s1_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal sys_clk_timer_s1_chipselect : OUT STD_LOGIC;
                    signal sys_clk_timer_s1_irq_from_sa : OUT STD_LOGIC;
                    signal sys_clk_timer_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sys_clk_timer_s1_reset_n : OUT STD_LOGIC;
                    signal sys_clk_timer_s1_write_n : OUT STD_LOGIC;
                    signal sys_clk_timer_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component sys_clk_timer_s1_arbitrator;

component sys_clk_timer is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal irq : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component sys_clk_timer;

component uart_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal uart_s1_dataavailable : IN STD_LOGIC;
                    signal uart_s1_irq : IN STD_LOGIC;
                    signal uart_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal uart_s1_readyfordata : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_uart_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_uart_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_uart_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_uart_s1 : OUT STD_LOGIC;
                    signal d1_uart_s1_end_xfer : OUT STD_LOGIC;
                    signal uart_s1_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal uart_s1_begintransfer : OUT STD_LOGIC;
                    signal uart_s1_chipselect : OUT STD_LOGIC;
                    signal uart_s1_dataavailable_from_sa : OUT STD_LOGIC;
                    signal uart_s1_irq_from_sa : OUT STD_LOGIC;
                    signal uart_s1_read_n : OUT STD_LOGIC;
                    signal uart_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal uart_s1_readyfordata_from_sa : OUT STD_LOGIC;
                    signal uart_s1_reset_n : OUT STD_LOGIC;
                    signal uart_s1_write_n : OUT STD_LOGIC;
                    signal uart_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component uart_s1_arbitrator;

component uart is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal begintransfer : IN STD_LOGIC;
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal read_n : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal rxd : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal dataavailable : OUT STD_LOGIC;
                    signal irq : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal readyfordata : OUT STD_LOGIC;
                    signal txd : OUT STD_LOGIC
                 );
end component uart;

component NIOS_System_1_reset_clk_domain_synch_module is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC
                 );
end component NIOS_System_1_reset_clk_domain_synch_module;

                signal CPU_MEM_s1_address :  STD_LOGIC_VECTOR (14 DOWNTO 0);
                signal CPU_MEM_s1_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal CPU_MEM_s1_chipselect :  STD_LOGIC;
                signal CPU_MEM_s1_clken :  STD_LOGIC;
                signal CPU_MEM_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal CPU_MEM_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal CPU_MEM_s1_write :  STD_LOGIC;
                signal CPU_MEM_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal HEX0_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal HEX0_s1_chipselect :  STD_LOGIC;
                signal HEX0_s1_reset_n :  STD_LOGIC;
                signal HEX0_s1_write_n :  STD_LOGIC;
                signal HEX0_s1_writedata :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal HEX1_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal HEX1_s1_chipselect :  STD_LOGIC;
                signal HEX1_s1_reset_n :  STD_LOGIC;
                signal HEX1_s1_write_n :  STD_LOGIC;
                signal HEX1_s1_writedata :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal HEX2_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal HEX2_s1_chipselect :  STD_LOGIC;
                signal HEX2_s1_reset_n :  STD_LOGIC;
                signal HEX2_s1_write_n :  STD_LOGIC;
                signal HEX2_s1_writedata :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal HEX3_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal HEX3_s1_chipselect :  STD_LOGIC;
                signal HEX3_s1_reset_n :  STD_LOGIC;
                signal HEX3_s1_write_n :  STD_LOGIC;
                signal HEX3_s1_writedata :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal HEX4_to_HEX7_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal HEX4_to_HEX7_s1_chipselect :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_reset_n :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_write_n :  STD_LOGIC;
                signal HEX4_to_HEX7_s1_writedata :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal KEYS_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal KEYS_s1_readdata :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal KEYS_s1_readdata_from_sa :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal KEYS_s1_reset_n :  STD_LOGIC;
                signal SWITCHS_s1_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal SWITCHS_s1_readdata :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal SWITCHS_s1_readdata_from_sa :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal SWITCHS_s1_reset_n :  STD_LOGIC;
                signal clk_reset_n :  STD_LOGIC;
                signal cpu_data_master_address :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal cpu_data_master_address_to_slave :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal cpu_data_master_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_data_master_debugaccess :  STD_LOGIC;
                signal cpu_data_master_granted_CPU_MEM_s1 :  STD_LOGIC;
                signal cpu_data_master_granted_HEX0_s1 :  STD_LOGIC;
                signal cpu_data_master_granted_HEX1_s1 :  STD_LOGIC;
                signal cpu_data_master_granted_HEX2_s1 :  STD_LOGIC;
                signal cpu_data_master_granted_HEX3_s1 :  STD_LOGIC;
                signal cpu_data_master_granted_HEX4_to_HEX7_s1 :  STD_LOGIC;
                signal cpu_data_master_granted_KEYS_s1 :  STD_LOGIC;
                signal cpu_data_master_granted_SWITCHS_s1 :  STD_LOGIC;
                signal cpu_data_master_granted_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_data_master_granted_high_res_timer_s1 :  STD_LOGIC;
                signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_data_master_granted_lcd_control_slave :  STD_LOGIC;
                signal cpu_data_master_granted_pwm_green_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_granted_pwm_red1_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_granted_pwm_red2_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_granted_sys_clk_timer_s1 :  STD_LOGIC;
                signal cpu_data_master_granted_uart_s1 :  STD_LOGIC;
                signal cpu_data_master_irq :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_data_master_qualified_request_CPU_MEM_s1 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_HEX0_s1 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_HEX1_s1 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_HEX2_s1 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_HEX3_s1 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_HEX4_to_HEX7_s1 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_KEYS_s1 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_SWITCHS_s1 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_data_master_qualified_request_high_res_timer_s1 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_lcd_control_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_pwm_green_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_pwm_red1_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_pwm_red2_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_sys_clk_timer_s1 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_uart_s1 :  STD_LOGIC;
                signal cpu_data_master_read :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_CPU_MEM_s1 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_HEX0_s1 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_HEX1_s1 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_HEX2_s1 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_HEX3_s1 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_HEX4_to_HEX7_s1 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_KEYS_s1 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_SWITCHS_s1 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_high_res_timer_s1 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_lcd_control_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_pwm_green_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_pwm_red1_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_pwm_red2_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_sys_clk_timer_s1 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_uart_s1 :  STD_LOGIC;
                signal cpu_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_data_master_requests_CPU_MEM_s1 :  STD_LOGIC;
                signal cpu_data_master_requests_HEX0_s1 :  STD_LOGIC;
                signal cpu_data_master_requests_HEX1_s1 :  STD_LOGIC;
                signal cpu_data_master_requests_HEX2_s1 :  STD_LOGIC;
                signal cpu_data_master_requests_HEX3_s1 :  STD_LOGIC;
                signal cpu_data_master_requests_HEX4_to_HEX7_s1 :  STD_LOGIC;
                signal cpu_data_master_requests_KEYS_s1 :  STD_LOGIC;
                signal cpu_data_master_requests_SWITCHS_s1 :  STD_LOGIC;
                signal cpu_data_master_requests_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_data_master_requests_high_res_timer_s1 :  STD_LOGIC;
                signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_data_master_requests_lcd_control_slave :  STD_LOGIC;
                signal cpu_data_master_requests_pwm_green_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_requests_pwm_red1_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_requests_pwm_red2_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_requests_sys_clk_timer_s1 :  STD_LOGIC;
                signal cpu_data_master_requests_uart_s1 :  STD_LOGIC;
                signal cpu_data_master_waitrequest :  STD_LOGIC;
                signal cpu_data_master_write :  STD_LOGIC;
                signal cpu_data_master_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_instruction_master_address :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal cpu_instruction_master_address_to_slave :  STD_LOGIC_VECTOR (18 DOWNTO 0);
                signal cpu_instruction_master_granted_CPU_MEM_s1 :  STD_LOGIC;
                signal cpu_instruction_master_granted_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_latency_counter :  STD_LOGIC;
                signal cpu_instruction_master_qualified_request_CPU_MEM_s1 :  STD_LOGIC;
                signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_read :  STD_LOGIC;
                signal cpu_instruction_master_read_data_valid_CPU_MEM_s1 :  STD_LOGIC;
                signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_instruction_master_readdatavalid :  STD_LOGIC;
                signal cpu_instruction_master_requests_CPU_MEM_s1 :  STD_LOGIC;
                signal cpu_instruction_master_requests_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_waitrequest :  STD_LOGIC;
                signal cpu_jtag_debug_module_address :  STD_LOGIC_VECTOR (8 DOWNTO 0);
                signal cpu_jtag_debug_module_begintransfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_jtag_debug_module_chipselect :  STD_LOGIC;
                signal cpu_jtag_debug_module_debugaccess :  STD_LOGIC;
                signal cpu_jtag_debug_module_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_jtag_debug_module_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_jtag_debug_module_reset :  STD_LOGIC;
                signal cpu_jtag_debug_module_reset_n :  STD_LOGIC;
                signal cpu_jtag_debug_module_resetrequest :  STD_LOGIC;
                signal cpu_jtag_debug_module_resetrequest_from_sa :  STD_LOGIC;
                signal cpu_jtag_debug_module_write :  STD_LOGIC;
                signal cpu_jtag_debug_module_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal d1_CPU_MEM_s1_end_xfer :  STD_LOGIC;
                signal d1_HEX0_s1_end_xfer :  STD_LOGIC;
                signal d1_HEX1_s1_end_xfer :  STD_LOGIC;
                signal d1_HEX2_s1_end_xfer :  STD_LOGIC;
                signal d1_HEX3_s1_end_xfer :  STD_LOGIC;
                signal d1_HEX4_to_HEX7_s1_end_xfer :  STD_LOGIC;
                signal d1_KEYS_s1_end_xfer :  STD_LOGIC;
                signal d1_SWITCHS_s1_end_xfer :  STD_LOGIC;
                signal d1_cpu_jtag_debug_module_end_xfer :  STD_LOGIC;
                signal d1_high_res_timer_s1_end_xfer :  STD_LOGIC;
                signal d1_jtag_uart_avalon_jtag_slave_end_xfer :  STD_LOGIC;
                signal d1_lcd_control_slave_end_xfer :  STD_LOGIC;
                signal d1_pwm_green_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal d1_pwm_red1_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal d1_pwm_red2_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal d1_sys_clk_timer_s1_end_xfer :  STD_LOGIC;
                signal d1_uart_s1_end_xfer :  STD_LOGIC;
                signal high_res_timer_s1_address :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal high_res_timer_s1_chipselect :  STD_LOGIC;
                signal high_res_timer_s1_irq :  STD_LOGIC;
                signal high_res_timer_s1_irq_from_sa :  STD_LOGIC;
                signal high_res_timer_s1_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal high_res_timer_s1_readdata_from_sa :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal high_res_timer_s1_reset_n :  STD_LOGIC;
                signal high_res_timer_s1_write_n :  STD_LOGIC;
                signal high_res_timer_s1_writedata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal internal_LCD_E_from_the_lcd :  STD_LOGIC;
                signal internal_LCD_RS_from_the_lcd :  STD_LOGIC;
                signal internal_LCD_RW_from_the_lcd :  STD_LOGIC;
                signal internal_out_port_from_the_HEX0 :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal internal_out_port_from_the_HEX1 :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal internal_out_port_from_the_HEX2 :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal internal_out_port_from_the_HEX3 :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal internal_out_port_from_the_HEX4_to_HEX7 :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal internal_out_port_from_the_pwm_green :  STD_LOGIC;
                signal internal_out_port_from_the_pwm_red1 :  STD_LOGIC;
                signal internal_out_port_from_the_pwm_red2 :  STD_LOGIC;
                signal internal_txd_from_the_uart :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_address :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_chipselect :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_dataavailable :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_dataavailable_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_irq :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_irq_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_read_n :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal jtag_uart_avalon_jtag_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal jtag_uart_avalon_jtag_slave_readyfordata :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_readyfordata_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_reset_n :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_waitrequest :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_write_n :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal lcd_control_slave_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal lcd_control_slave_begintransfer :  STD_LOGIC;
                signal lcd_control_slave_read :  STD_LOGIC;
                signal lcd_control_slave_readdata :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal lcd_control_slave_readdata_from_sa :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal lcd_control_slave_wait_counter_eq_0 :  STD_LOGIC;
                signal lcd_control_slave_wait_counter_eq_1 :  STD_LOGIC;
                signal lcd_control_slave_write :  STD_LOGIC;
                signal lcd_control_slave_writedata :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal module_input :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_address :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_chipselect :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pwm_green_avalon_slave_0_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pwm_green_avalon_slave_0_reset_n :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_write_n :  STD_LOGIC;
                signal pwm_green_avalon_slave_0_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pwm_red1_avalon_slave_0_address :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_chipselect :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pwm_red1_avalon_slave_0_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pwm_red1_avalon_slave_0_reset_n :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_write_n :  STD_LOGIC;
                signal pwm_red1_avalon_slave_0_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pwm_red2_avalon_slave_0_address :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_chipselect :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pwm_red2_avalon_slave_0_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pwm_red2_avalon_slave_0_reset_n :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_write_n :  STD_LOGIC;
                signal pwm_red2_avalon_slave_0_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal registered_cpu_data_master_read_data_valid_CPU_MEM_s1 :  STD_LOGIC;
                signal reset_n_sources :  STD_LOGIC;
                signal sys_clk_timer_s1_address :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal sys_clk_timer_s1_chipselect :  STD_LOGIC;
                signal sys_clk_timer_s1_irq :  STD_LOGIC;
                signal sys_clk_timer_s1_irq_from_sa :  STD_LOGIC;
                signal sys_clk_timer_s1_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sys_clk_timer_s1_readdata_from_sa :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sys_clk_timer_s1_reset_n :  STD_LOGIC;
                signal sys_clk_timer_s1_write_n :  STD_LOGIC;
                signal sys_clk_timer_s1_writedata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal uart_s1_address :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal uart_s1_begintransfer :  STD_LOGIC;
                signal uart_s1_chipselect :  STD_LOGIC;
                signal uart_s1_dataavailable :  STD_LOGIC;
                signal uart_s1_dataavailable_from_sa :  STD_LOGIC;
                signal uart_s1_irq :  STD_LOGIC;
                signal uart_s1_irq_from_sa :  STD_LOGIC;
                signal uart_s1_read_n :  STD_LOGIC;
                signal uart_s1_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal uart_s1_readdata_from_sa :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal uart_s1_readyfordata :  STD_LOGIC;
                signal uart_s1_readyfordata_from_sa :  STD_LOGIC;
                signal uart_s1_reset_n :  STD_LOGIC;
                signal uart_s1_write_n :  STD_LOGIC;
                signal uart_s1_writedata :  STD_LOGIC_VECTOR (15 DOWNTO 0);

begin

  --the_CPU_MEM_s1, which is an e_instance
  the_CPU_MEM_s1 : CPU_MEM_s1_arbitrator
    port map(
      CPU_MEM_s1_address => CPU_MEM_s1_address,
      CPU_MEM_s1_byteenable => CPU_MEM_s1_byteenable,
      CPU_MEM_s1_chipselect => CPU_MEM_s1_chipselect,
      CPU_MEM_s1_clken => CPU_MEM_s1_clken,
      CPU_MEM_s1_readdata_from_sa => CPU_MEM_s1_readdata_from_sa,
      CPU_MEM_s1_write => CPU_MEM_s1_write,
      CPU_MEM_s1_writedata => CPU_MEM_s1_writedata,
      cpu_data_master_granted_CPU_MEM_s1 => cpu_data_master_granted_CPU_MEM_s1,
      cpu_data_master_qualified_request_CPU_MEM_s1 => cpu_data_master_qualified_request_CPU_MEM_s1,
      cpu_data_master_read_data_valid_CPU_MEM_s1 => cpu_data_master_read_data_valid_CPU_MEM_s1,
      cpu_data_master_requests_CPU_MEM_s1 => cpu_data_master_requests_CPU_MEM_s1,
      cpu_instruction_master_granted_CPU_MEM_s1 => cpu_instruction_master_granted_CPU_MEM_s1,
      cpu_instruction_master_qualified_request_CPU_MEM_s1 => cpu_instruction_master_qualified_request_CPU_MEM_s1,
      cpu_instruction_master_read_data_valid_CPU_MEM_s1 => cpu_instruction_master_read_data_valid_CPU_MEM_s1,
      cpu_instruction_master_requests_CPU_MEM_s1 => cpu_instruction_master_requests_CPU_MEM_s1,
      d1_CPU_MEM_s1_end_xfer => d1_CPU_MEM_s1_end_xfer,
      registered_cpu_data_master_read_data_valid_CPU_MEM_s1 => registered_cpu_data_master_read_data_valid_CPU_MEM_s1,
      CPU_MEM_s1_readdata => CPU_MEM_s1_readdata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_byteenable => cpu_data_master_byteenable,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      cpu_instruction_master_address_to_slave => cpu_instruction_master_address_to_slave,
      cpu_instruction_master_latency_counter => cpu_instruction_master_latency_counter,
      cpu_instruction_master_read => cpu_instruction_master_read,
      reset_n => clk_reset_n
    );


  --the_CPU_MEM, which is an e_ptf_instance
  the_CPU_MEM : CPU_MEM
    port map(
      readdata => CPU_MEM_s1_readdata,
      address => CPU_MEM_s1_address,
      byteenable => CPU_MEM_s1_byteenable,
      chipselect => CPU_MEM_s1_chipselect,
      clk => clk,
      clken => CPU_MEM_s1_clken,
      write => CPU_MEM_s1_write,
      writedata => CPU_MEM_s1_writedata
    );


  --the_HEX0_s1, which is an e_instance
  the_HEX0_s1 : HEX0_s1_arbitrator
    port map(
      HEX0_s1_address => HEX0_s1_address,
      HEX0_s1_chipselect => HEX0_s1_chipselect,
      HEX0_s1_reset_n => HEX0_s1_reset_n,
      HEX0_s1_write_n => HEX0_s1_write_n,
      HEX0_s1_writedata => HEX0_s1_writedata,
      cpu_data_master_granted_HEX0_s1 => cpu_data_master_granted_HEX0_s1,
      cpu_data_master_qualified_request_HEX0_s1 => cpu_data_master_qualified_request_HEX0_s1,
      cpu_data_master_read_data_valid_HEX0_s1 => cpu_data_master_read_data_valid_HEX0_s1,
      cpu_data_master_requests_HEX0_s1 => cpu_data_master_requests_HEX0_s1,
      d1_HEX0_s1_end_xfer => d1_HEX0_s1_end_xfer,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      reset_n => clk_reset_n
    );


  --the_HEX0, which is an e_ptf_instance
  the_HEX0 : HEX0
    port map(
      out_port => internal_out_port_from_the_HEX0,
      address => HEX0_s1_address,
      chipselect => HEX0_s1_chipselect,
      clk => clk,
      reset_n => HEX0_s1_reset_n,
      write_n => HEX0_s1_write_n,
      writedata => HEX0_s1_writedata
    );


  --the_HEX1_s1, which is an e_instance
  the_HEX1_s1 : HEX1_s1_arbitrator
    port map(
      HEX1_s1_address => HEX1_s1_address,
      HEX1_s1_chipselect => HEX1_s1_chipselect,
      HEX1_s1_reset_n => HEX1_s1_reset_n,
      HEX1_s1_write_n => HEX1_s1_write_n,
      HEX1_s1_writedata => HEX1_s1_writedata,
      cpu_data_master_granted_HEX1_s1 => cpu_data_master_granted_HEX1_s1,
      cpu_data_master_qualified_request_HEX1_s1 => cpu_data_master_qualified_request_HEX1_s1,
      cpu_data_master_read_data_valid_HEX1_s1 => cpu_data_master_read_data_valid_HEX1_s1,
      cpu_data_master_requests_HEX1_s1 => cpu_data_master_requests_HEX1_s1,
      d1_HEX1_s1_end_xfer => d1_HEX1_s1_end_xfer,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      reset_n => clk_reset_n
    );


  --the_HEX1, which is an e_ptf_instance
  the_HEX1 : HEX1
    port map(
      out_port => internal_out_port_from_the_HEX1,
      address => HEX1_s1_address,
      chipselect => HEX1_s1_chipselect,
      clk => clk,
      reset_n => HEX1_s1_reset_n,
      write_n => HEX1_s1_write_n,
      writedata => HEX1_s1_writedata
    );


  --the_HEX2_s1, which is an e_instance
  the_HEX2_s1 : HEX2_s1_arbitrator
    port map(
      HEX2_s1_address => HEX2_s1_address,
      HEX2_s1_chipselect => HEX2_s1_chipselect,
      HEX2_s1_reset_n => HEX2_s1_reset_n,
      HEX2_s1_write_n => HEX2_s1_write_n,
      HEX2_s1_writedata => HEX2_s1_writedata,
      cpu_data_master_granted_HEX2_s1 => cpu_data_master_granted_HEX2_s1,
      cpu_data_master_qualified_request_HEX2_s1 => cpu_data_master_qualified_request_HEX2_s1,
      cpu_data_master_read_data_valid_HEX2_s1 => cpu_data_master_read_data_valid_HEX2_s1,
      cpu_data_master_requests_HEX2_s1 => cpu_data_master_requests_HEX2_s1,
      d1_HEX2_s1_end_xfer => d1_HEX2_s1_end_xfer,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      reset_n => clk_reset_n
    );


  --the_HEX2, which is an e_ptf_instance
  the_HEX2 : HEX2
    port map(
      out_port => internal_out_port_from_the_HEX2,
      address => HEX2_s1_address,
      chipselect => HEX2_s1_chipselect,
      clk => clk,
      reset_n => HEX2_s1_reset_n,
      write_n => HEX2_s1_write_n,
      writedata => HEX2_s1_writedata
    );


  --the_HEX3_s1, which is an e_instance
  the_HEX3_s1 : HEX3_s1_arbitrator
    port map(
      HEX3_s1_address => HEX3_s1_address,
      HEX3_s1_chipselect => HEX3_s1_chipselect,
      HEX3_s1_reset_n => HEX3_s1_reset_n,
      HEX3_s1_write_n => HEX3_s1_write_n,
      HEX3_s1_writedata => HEX3_s1_writedata,
      cpu_data_master_granted_HEX3_s1 => cpu_data_master_granted_HEX3_s1,
      cpu_data_master_qualified_request_HEX3_s1 => cpu_data_master_qualified_request_HEX3_s1,
      cpu_data_master_read_data_valid_HEX3_s1 => cpu_data_master_read_data_valid_HEX3_s1,
      cpu_data_master_requests_HEX3_s1 => cpu_data_master_requests_HEX3_s1,
      d1_HEX3_s1_end_xfer => d1_HEX3_s1_end_xfer,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      reset_n => clk_reset_n
    );


  --the_HEX3, which is an e_ptf_instance
  the_HEX3 : HEX3
    port map(
      out_port => internal_out_port_from_the_HEX3,
      address => HEX3_s1_address,
      chipselect => HEX3_s1_chipselect,
      clk => clk,
      reset_n => HEX3_s1_reset_n,
      write_n => HEX3_s1_write_n,
      writedata => HEX3_s1_writedata
    );


  --the_HEX4_to_HEX7_s1, which is an e_instance
  the_HEX4_to_HEX7_s1 : HEX4_to_HEX7_s1_arbitrator
    port map(
      HEX4_to_HEX7_s1_address => HEX4_to_HEX7_s1_address,
      HEX4_to_HEX7_s1_chipselect => HEX4_to_HEX7_s1_chipselect,
      HEX4_to_HEX7_s1_reset_n => HEX4_to_HEX7_s1_reset_n,
      HEX4_to_HEX7_s1_write_n => HEX4_to_HEX7_s1_write_n,
      HEX4_to_HEX7_s1_writedata => HEX4_to_HEX7_s1_writedata,
      cpu_data_master_granted_HEX4_to_HEX7_s1 => cpu_data_master_granted_HEX4_to_HEX7_s1,
      cpu_data_master_qualified_request_HEX4_to_HEX7_s1 => cpu_data_master_qualified_request_HEX4_to_HEX7_s1,
      cpu_data_master_read_data_valid_HEX4_to_HEX7_s1 => cpu_data_master_read_data_valid_HEX4_to_HEX7_s1,
      cpu_data_master_requests_HEX4_to_HEX7_s1 => cpu_data_master_requests_HEX4_to_HEX7_s1,
      d1_HEX4_to_HEX7_s1_end_xfer => d1_HEX4_to_HEX7_s1_end_xfer,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      reset_n => clk_reset_n
    );


  --the_HEX4_to_HEX7, which is an e_ptf_instance
  the_HEX4_to_HEX7 : HEX4_to_HEX7
    port map(
      out_port => internal_out_port_from_the_HEX4_to_HEX7,
      address => HEX4_to_HEX7_s1_address,
      chipselect => HEX4_to_HEX7_s1_chipselect,
      clk => clk,
      reset_n => HEX4_to_HEX7_s1_reset_n,
      write_n => HEX4_to_HEX7_s1_write_n,
      writedata => HEX4_to_HEX7_s1_writedata
    );


  --the_KEYS_s1, which is an e_instance
  the_KEYS_s1 : KEYS_s1_arbitrator
    port map(
      KEYS_s1_address => KEYS_s1_address,
      KEYS_s1_readdata_from_sa => KEYS_s1_readdata_from_sa,
      KEYS_s1_reset_n => KEYS_s1_reset_n,
      cpu_data_master_granted_KEYS_s1 => cpu_data_master_granted_KEYS_s1,
      cpu_data_master_qualified_request_KEYS_s1 => cpu_data_master_qualified_request_KEYS_s1,
      cpu_data_master_read_data_valid_KEYS_s1 => cpu_data_master_read_data_valid_KEYS_s1,
      cpu_data_master_requests_KEYS_s1 => cpu_data_master_requests_KEYS_s1,
      d1_KEYS_s1_end_xfer => d1_KEYS_s1_end_xfer,
      KEYS_s1_readdata => KEYS_s1_readdata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_write => cpu_data_master_write,
      reset_n => clk_reset_n
    );


  --the_KEYS, which is an e_ptf_instance
  the_KEYS : KEYS
    port map(
      readdata => KEYS_s1_readdata,
      address => KEYS_s1_address,
      clk => clk,
      in_port => in_port_to_the_KEYS,
      reset_n => KEYS_s1_reset_n
    );


  --the_SWITCHS_s1, which is an e_instance
  the_SWITCHS_s1 : SWITCHS_s1_arbitrator
    port map(
      SWITCHS_s1_address => SWITCHS_s1_address,
      SWITCHS_s1_readdata_from_sa => SWITCHS_s1_readdata_from_sa,
      SWITCHS_s1_reset_n => SWITCHS_s1_reset_n,
      cpu_data_master_granted_SWITCHS_s1 => cpu_data_master_granted_SWITCHS_s1,
      cpu_data_master_qualified_request_SWITCHS_s1 => cpu_data_master_qualified_request_SWITCHS_s1,
      cpu_data_master_read_data_valid_SWITCHS_s1 => cpu_data_master_read_data_valid_SWITCHS_s1,
      cpu_data_master_requests_SWITCHS_s1 => cpu_data_master_requests_SWITCHS_s1,
      d1_SWITCHS_s1_end_xfer => d1_SWITCHS_s1_end_xfer,
      SWITCHS_s1_readdata => SWITCHS_s1_readdata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_write => cpu_data_master_write,
      reset_n => clk_reset_n
    );


  --the_SWITCHS, which is an e_ptf_instance
  the_SWITCHS : SWITCHS
    port map(
      readdata => SWITCHS_s1_readdata,
      address => SWITCHS_s1_address,
      clk => clk,
      in_port => in_port_to_the_SWITCHS,
      reset_n => SWITCHS_s1_reset_n
    );


  --the_cpu_jtag_debug_module, which is an e_instance
  the_cpu_jtag_debug_module : cpu_jtag_debug_module_arbitrator
    port map(
      cpu_data_master_granted_cpu_jtag_debug_module => cpu_data_master_granted_cpu_jtag_debug_module,
      cpu_data_master_qualified_request_cpu_jtag_debug_module => cpu_data_master_qualified_request_cpu_jtag_debug_module,
      cpu_data_master_read_data_valid_cpu_jtag_debug_module => cpu_data_master_read_data_valid_cpu_jtag_debug_module,
      cpu_data_master_requests_cpu_jtag_debug_module => cpu_data_master_requests_cpu_jtag_debug_module,
      cpu_instruction_master_granted_cpu_jtag_debug_module => cpu_instruction_master_granted_cpu_jtag_debug_module,
      cpu_instruction_master_qualified_request_cpu_jtag_debug_module => cpu_instruction_master_qualified_request_cpu_jtag_debug_module,
      cpu_instruction_master_read_data_valid_cpu_jtag_debug_module => cpu_instruction_master_read_data_valid_cpu_jtag_debug_module,
      cpu_instruction_master_requests_cpu_jtag_debug_module => cpu_instruction_master_requests_cpu_jtag_debug_module,
      cpu_jtag_debug_module_address => cpu_jtag_debug_module_address,
      cpu_jtag_debug_module_begintransfer => cpu_jtag_debug_module_begintransfer,
      cpu_jtag_debug_module_byteenable => cpu_jtag_debug_module_byteenable,
      cpu_jtag_debug_module_chipselect => cpu_jtag_debug_module_chipselect,
      cpu_jtag_debug_module_debugaccess => cpu_jtag_debug_module_debugaccess,
      cpu_jtag_debug_module_readdata_from_sa => cpu_jtag_debug_module_readdata_from_sa,
      cpu_jtag_debug_module_reset => cpu_jtag_debug_module_reset,
      cpu_jtag_debug_module_reset_n => cpu_jtag_debug_module_reset_n,
      cpu_jtag_debug_module_resetrequest_from_sa => cpu_jtag_debug_module_resetrequest_from_sa,
      cpu_jtag_debug_module_write => cpu_jtag_debug_module_write,
      cpu_jtag_debug_module_writedata => cpu_jtag_debug_module_writedata,
      d1_cpu_jtag_debug_module_end_xfer => d1_cpu_jtag_debug_module_end_xfer,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_byteenable => cpu_data_master_byteenable,
      cpu_data_master_debugaccess => cpu_data_master_debugaccess,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      cpu_instruction_master_address_to_slave => cpu_instruction_master_address_to_slave,
      cpu_instruction_master_latency_counter => cpu_instruction_master_latency_counter,
      cpu_instruction_master_read => cpu_instruction_master_read,
      cpu_jtag_debug_module_readdata => cpu_jtag_debug_module_readdata,
      cpu_jtag_debug_module_resetrequest => cpu_jtag_debug_module_resetrequest,
      reset_n => clk_reset_n
    );


  --the_cpu_data_master, which is an e_instance
  the_cpu_data_master : cpu_data_master_arbitrator
    port map(
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_irq => cpu_data_master_irq,
      cpu_data_master_readdata => cpu_data_master_readdata,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      CPU_MEM_s1_readdata_from_sa => CPU_MEM_s1_readdata_from_sa,
      KEYS_s1_readdata_from_sa => KEYS_s1_readdata_from_sa,
      SWITCHS_s1_readdata_from_sa => SWITCHS_s1_readdata_from_sa,
      clk => clk,
      cpu_data_master_address => cpu_data_master_address,
      cpu_data_master_granted_CPU_MEM_s1 => cpu_data_master_granted_CPU_MEM_s1,
      cpu_data_master_granted_HEX0_s1 => cpu_data_master_granted_HEX0_s1,
      cpu_data_master_granted_HEX1_s1 => cpu_data_master_granted_HEX1_s1,
      cpu_data_master_granted_HEX2_s1 => cpu_data_master_granted_HEX2_s1,
      cpu_data_master_granted_HEX3_s1 => cpu_data_master_granted_HEX3_s1,
      cpu_data_master_granted_HEX4_to_HEX7_s1 => cpu_data_master_granted_HEX4_to_HEX7_s1,
      cpu_data_master_granted_KEYS_s1 => cpu_data_master_granted_KEYS_s1,
      cpu_data_master_granted_SWITCHS_s1 => cpu_data_master_granted_SWITCHS_s1,
      cpu_data_master_granted_cpu_jtag_debug_module => cpu_data_master_granted_cpu_jtag_debug_module,
      cpu_data_master_granted_high_res_timer_s1 => cpu_data_master_granted_high_res_timer_s1,
      cpu_data_master_granted_jtag_uart_avalon_jtag_slave => cpu_data_master_granted_jtag_uart_avalon_jtag_slave,
      cpu_data_master_granted_lcd_control_slave => cpu_data_master_granted_lcd_control_slave,
      cpu_data_master_granted_pwm_green_avalon_slave_0 => cpu_data_master_granted_pwm_green_avalon_slave_0,
      cpu_data_master_granted_pwm_red1_avalon_slave_0 => cpu_data_master_granted_pwm_red1_avalon_slave_0,
      cpu_data_master_granted_pwm_red2_avalon_slave_0 => cpu_data_master_granted_pwm_red2_avalon_slave_0,
      cpu_data_master_granted_sys_clk_timer_s1 => cpu_data_master_granted_sys_clk_timer_s1,
      cpu_data_master_granted_uart_s1 => cpu_data_master_granted_uart_s1,
      cpu_data_master_qualified_request_CPU_MEM_s1 => cpu_data_master_qualified_request_CPU_MEM_s1,
      cpu_data_master_qualified_request_HEX0_s1 => cpu_data_master_qualified_request_HEX0_s1,
      cpu_data_master_qualified_request_HEX1_s1 => cpu_data_master_qualified_request_HEX1_s1,
      cpu_data_master_qualified_request_HEX2_s1 => cpu_data_master_qualified_request_HEX2_s1,
      cpu_data_master_qualified_request_HEX3_s1 => cpu_data_master_qualified_request_HEX3_s1,
      cpu_data_master_qualified_request_HEX4_to_HEX7_s1 => cpu_data_master_qualified_request_HEX4_to_HEX7_s1,
      cpu_data_master_qualified_request_KEYS_s1 => cpu_data_master_qualified_request_KEYS_s1,
      cpu_data_master_qualified_request_SWITCHS_s1 => cpu_data_master_qualified_request_SWITCHS_s1,
      cpu_data_master_qualified_request_cpu_jtag_debug_module => cpu_data_master_qualified_request_cpu_jtag_debug_module,
      cpu_data_master_qualified_request_high_res_timer_s1 => cpu_data_master_qualified_request_high_res_timer_s1,
      cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave => cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave,
      cpu_data_master_qualified_request_lcd_control_slave => cpu_data_master_qualified_request_lcd_control_slave,
      cpu_data_master_qualified_request_pwm_green_avalon_slave_0 => cpu_data_master_qualified_request_pwm_green_avalon_slave_0,
      cpu_data_master_qualified_request_pwm_red1_avalon_slave_0 => cpu_data_master_qualified_request_pwm_red1_avalon_slave_0,
      cpu_data_master_qualified_request_pwm_red2_avalon_slave_0 => cpu_data_master_qualified_request_pwm_red2_avalon_slave_0,
      cpu_data_master_qualified_request_sys_clk_timer_s1 => cpu_data_master_qualified_request_sys_clk_timer_s1,
      cpu_data_master_qualified_request_uart_s1 => cpu_data_master_qualified_request_uart_s1,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_read_data_valid_CPU_MEM_s1 => cpu_data_master_read_data_valid_CPU_MEM_s1,
      cpu_data_master_read_data_valid_HEX0_s1 => cpu_data_master_read_data_valid_HEX0_s1,
      cpu_data_master_read_data_valid_HEX1_s1 => cpu_data_master_read_data_valid_HEX1_s1,
      cpu_data_master_read_data_valid_HEX2_s1 => cpu_data_master_read_data_valid_HEX2_s1,
      cpu_data_master_read_data_valid_HEX3_s1 => cpu_data_master_read_data_valid_HEX3_s1,
      cpu_data_master_read_data_valid_HEX4_to_HEX7_s1 => cpu_data_master_read_data_valid_HEX4_to_HEX7_s1,
      cpu_data_master_read_data_valid_KEYS_s1 => cpu_data_master_read_data_valid_KEYS_s1,
      cpu_data_master_read_data_valid_SWITCHS_s1 => cpu_data_master_read_data_valid_SWITCHS_s1,
      cpu_data_master_read_data_valid_cpu_jtag_debug_module => cpu_data_master_read_data_valid_cpu_jtag_debug_module,
      cpu_data_master_read_data_valid_high_res_timer_s1 => cpu_data_master_read_data_valid_high_res_timer_s1,
      cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave => cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave,
      cpu_data_master_read_data_valid_lcd_control_slave => cpu_data_master_read_data_valid_lcd_control_slave,
      cpu_data_master_read_data_valid_pwm_green_avalon_slave_0 => cpu_data_master_read_data_valid_pwm_green_avalon_slave_0,
      cpu_data_master_read_data_valid_pwm_red1_avalon_slave_0 => cpu_data_master_read_data_valid_pwm_red1_avalon_slave_0,
      cpu_data_master_read_data_valid_pwm_red2_avalon_slave_0 => cpu_data_master_read_data_valid_pwm_red2_avalon_slave_0,
      cpu_data_master_read_data_valid_sys_clk_timer_s1 => cpu_data_master_read_data_valid_sys_clk_timer_s1,
      cpu_data_master_read_data_valid_uart_s1 => cpu_data_master_read_data_valid_uart_s1,
      cpu_data_master_requests_CPU_MEM_s1 => cpu_data_master_requests_CPU_MEM_s1,
      cpu_data_master_requests_HEX0_s1 => cpu_data_master_requests_HEX0_s1,
      cpu_data_master_requests_HEX1_s1 => cpu_data_master_requests_HEX1_s1,
      cpu_data_master_requests_HEX2_s1 => cpu_data_master_requests_HEX2_s1,
      cpu_data_master_requests_HEX3_s1 => cpu_data_master_requests_HEX3_s1,
      cpu_data_master_requests_HEX4_to_HEX7_s1 => cpu_data_master_requests_HEX4_to_HEX7_s1,
      cpu_data_master_requests_KEYS_s1 => cpu_data_master_requests_KEYS_s1,
      cpu_data_master_requests_SWITCHS_s1 => cpu_data_master_requests_SWITCHS_s1,
      cpu_data_master_requests_cpu_jtag_debug_module => cpu_data_master_requests_cpu_jtag_debug_module,
      cpu_data_master_requests_high_res_timer_s1 => cpu_data_master_requests_high_res_timer_s1,
      cpu_data_master_requests_jtag_uart_avalon_jtag_slave => cpu_data_master_requests_jtag_uart_avalon_jtag_slave,
      cpu_data_master_requests_lcd_control_slave => cpu_data_master_requests_lcd_control_slave,
      cpu_data_master_requests_pwm_green_avalon_slave_0 => cpu_data_master_requests_pwm_green_avalon_slave_0,
      cpu_data_master_requests_pwm_red1_avalon_slave_0 => cpu_data_master_requests_pwm_red1_avalon_slave_0,
      cpu_data_master_requests_pwm_red2_avalon_slave_0 => cpu_data_master_requests_pwm_red2_avalon_slave_0,
      cpu_data_master_requests_sys_clk_timer_s1 => cpu_data_master_requests_sys_clk_timer_s1,
      cpu_data_master_requests_uart_s1 => cpu_data_master_requests_uart_s1,
      cpu_data_master_write => cpu_data_master_write,
      cpu_jtag_debug_module_readdata_from_sa => cpu_jtag_debug_module_readdata_from_sa,
      d1_CPU_MEM_s1_end_xfer => d1_CPU_MEM_s1_end_xfer,
      d1_HEX0_s1_end_xfer => d1_HEX0_s1_end_xfer,
      d1_HEX1_s1_end_xfer => d1_HEX1_s1_end_xfer,
      d1_HEX2_s1_end_xfer => d1_HEX2_s1_end_xfer,
      d1_HEX3_s1_end_xfer => d1_HEX3_s1_end_xfer,
      d1_HEX4_to_HEX7_s1_end_xfer => d1_HEX4_to_HEX7_s1_end_xfer,
      d1_KEYS_s1_end_xfer => d1_KEYS_s1_end_xfer,
      d1_SWITCHS_s1_end_xfer => d1_SWITCHS_s1_end_xfer,
      d1_cpu_jtag_debug_module_end_xfer => d1_cpu_jtag_debug_module_end_xfer,
      d1_high_res_timer_s1_end_xfer => d1_high_res_timer_s1_end_xfer,
      d1_jtag_uart_avalon_jtag_slave_end_xfer => d1_jtag_uart_avalon_jtag_slave_end_xfer,
      d1_lcd_control_slave_end_xfer => d1_lcd_control_slave_end_xfer,
      d1_pwm_green_avalon_slave_0_end_xfer => d1_pwm_green_avalon_slave_0_end_xfer,
      d1_pwm_red1_avalon_slave_0_end_xfer => d1_pwm_red1_avalon_slave_0_end_xfer,
      d1_pwm_red2_avalon_slave_0_end_xfer => d1_pwm_red2_avalon_slave_0_end_xfer,
      d1_sys_clk_timer_s1_end_xfer => d1_sys_clk_timer_s1_end_xfer,
      d1_uart_s1_end_xfer => d1_uart_s1_end_xfer,
      high_res_timer_s1_irq_from_sa => high_res_timer_s1_irq_from_sa,
      high_res_timer_s1_readdata_from_sa => high_res_timer_s1_readdata_from_sa,
      jtag_uart_avalon_jtag_slave_irq_from_sa => jtag_uart_avalon_jtag_slave_irq_from_sa,
      jtag_uart_avalon_jtag_slave_readdata_from_sa => jtag_uart_avalon_jtag_slave_readdata_from_sa,
      jtag_uart_avalon_jtag_slave_waitrequest_from_sa => jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
      lcd_control_slave_readdata_from_sa => lcd_control_slave_readdata_from_sa,
      lcd_control_slave_wait_counter_eq_0 => lcd_control_slave_wait_counter_eq_0,
      lcd_control_slave_wait_counter_eq_1 => lcd_control_slave_wait_counter_eq_1,
      pwm_green_avalon_slave_0_readdata_from_sa => pwm_green_avalon_slave_0_readdata_from_sa,
      pwm_red1_avalon_slave_0_readdata_from_sa => pwm_red1_avalon_slave_0_readdata_from_sa,
      pwm_red2_avalon_slave_0_readdata_from_sa => pwm_red2_avalon_slave_0_readdata_from_sa,
      registered_cpu_data_master_read_data_valid_CPU_MEM_s1 => registered_cpu_data_master_read_data_valid_CPU_MEM_s1,
      reset_n => clk_reset_n,
      sys_clk_timer_s1_irq_from_sa => sys_clk_timer_s1_irq_from_sa,
      sys_clk_timer_s1_readdata_from_sa => sys_clk_timer_s1_readdata_from_sa,
      uart_s1_irq_from_sa => uart_s1_irq_from_sa,
      uart_s1_readdata_from_sa => uart_s1_readdata_from_sa
    );


  --the_cpu_instruction_master, which is an e_instance
  the_cpu_instruction_master : cpu_instruction_master_arbitrator
    port map(
      cpu_instruction_master_address_to_slave => cpu_instruction_master_address_to_slave,
      cpu_instruction_master_latency_counter => cpu_instruction_master_latency_counter,
      cpu_instruction_master_readdata => cpu_instruction_master_readdata,
      cpu_instruction_master_readdatavalid => cpu_instruction_master_readdatavalid,
      cpu_instruction_master_waitrequest => cpu_instruction_master_waitrequest,
      CPU_MEM_s1_readdata_from_sa => CPU_MEM_s1_readdata_from_sa,
      clk => clk,
      cpu_instruction_master_address => cpu_instruction_master_address,
      cpu_instruction_master_granted_CPU_MEM_s1 => cpu_instruction_master_granted_CPU_MEM_s1,
      cpu_instruction_master_granted_cpu_jtag_debug_module => cpu_instruction_master_granted_cpu_jtag_debug_module,
      cpu_instruction_master_qualified_request_CPU_MEM_s1 => cpu_instruction_master_qualified_request_CPU_MEM_s1,
      cpu_instruction_master_qualified_request_cpu_jtag_debug_module => cpu_instruction_master_qualified_request_cpu_jtag_debug_module,
      cpu_instruction_master_read => cpu_instruction_master_read,
      cpu_instruction_master_read_data_valid_CPU_MEM_s1 => cpu_instruction_master_read_data_valid_CPU_MEM_s1,
      cpu_instruction_master_read_data_valid_cpu_jtag_debug_module => cpu_instruction_master_read_data_valid_cpu_jtag_debug_module,
      cpu_instruction_master_requests_CPU_MEM_s1 => cpu_instruction_master_requests_CPU_MEM_s1,
      cpu_instruction_master_requests_cpu_jtag_debug_module => cpu_instruction_master_requests_cpu_jtag_debug_module,
      cpu_jtag_debug_module_readdata_from_sa => cpu_jtag_debug_module_readdata_from_sa,
      d1_CPU_MEM_s1_end_xfer => d1_CPU_MEM_s1_end_xfer,
      d1_cpu_jtag_debug_module_end_xfer => d1_cpu_jtag_debug_module_end_xfer,
      reset_n => clk_reset_n
    );


  --the_cpu, which is an e_ptf_instance
  the_cpu : cpu
    port map(
      d_address => cpu_data_master_address,
      d_byteenable => cpu_data_master_byteenable,
      d_read => cpu_data_master_read,
      d_write => cpu_data_master_write,
      d_writedata => cpu_data_master_writedata,
      i_address => cpu_instruction_master_address,
      i_read => cpu_instruction_master_read,
      jtag_debug_module_debugaccess_to_roms => cpu_data_master_debugaccess,
      jtag_debug_module_readdata => cpu_jtag_debug_module_readdata,
      jtag_debug_module_resetrequest => cpu_jtag_debug_module_resetrequest,
      clk => clk,
      d_irq => cpu_data_master_irq,
      d_readdata => cpu_data_master_readdata,
      d_waitrequest => cpu_data_master_waitrequest,
      i_readdata => cpu_instruction_master_readdata,
      i_readdatavalid => cpu_instruction_master_readdatavalid,
      i_waitrequest => cpu_instruction_master_waitrequest,
      jtag_debug_module_address => cpu_jtag_debug_module_address,
      jtag_debug_module_begintransfer => cpu_jtag_debug_module_begintransfer,
      jtag_debug_module_byteenable => cpu_jtag_debug_module_byteenable,
      jtag_debug_module_clk => clk,
      jtag_debug_module_debugaccess => cpu_jtag_debug_module_debugaccess,
      jtag_debug_module_reset => cpu_jtag_debug_module_reset,
      jtag_debug_module_select => cpu_jtag_debug_module_chipselect,
      jtag_debug_module_write => cpu_jtag_debug_module_write,
      jtag_debug_module_writedata => cpu_jtag_debug_module_writedata,
      reset_n => cpu_jtag_debug_module_reset_n
    );


  --the_high_res_timer_s1, which is an e_instance
  the_high_res_timer_s1 : high_res_timer_s1_arbitrator
    port map(
      cpu_data_master_granted_high_res_timer_s1 => cpu_data_master_granted_high_res_timer_s1,
      cpu_data_master_qualified_request_high_res_timer_s1 => cpu_data_master_qualified_request_high_res_timer_s1,
      cpu_data_master_read_data_valid_high_res_timer_s1 => cpu_data_master_read_data_valid_high_res_timer_s1,
      cpu_data_master_requests_high_res_timer_s1 => cpu_data_master_requests_high_res_timer_s1,
      d1_high_res_timer_s1_end_xfer => d1_high_res_timer_s1_end_xfer,
      high_res_timer_s1_address => high_res_timer_s1_address,
      high_res_timer_s1_chipselect => high_res_timer_s1_chipselect,
      high_res_timer_s1_irq_from_sa => high_res_timer_s1_irq_from_sa,
      high_res_timer_s1_readdata_from_sa => high_res_timer_s1_readdata_from_sa,
      high_res_timer_s1_reset_n => high_res_timer_s1_reset_n,
      high_res_timer_s1_write_n => high_res_timer_s1_write_n,
      high_res_timer_s1_writedata => high_res_timer_s1_writedata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      high_res_timer_s1_irq => high_res_timer_s1_irq,
      high_res_timer_s1_readdata => high_res_timer_s1_readdata,
      reset_n => clk_reset_n
    );


  --the_high_res_timer, which is an e_ptf_instance
  the_high_res_timer : high_res_timer
    port map(
      irq => high_res_timer_s1_irq,
      readdata => high_res_timer_s1_readdata,
      address => high_res_timer_s1_address,
      chipselect => high_res_timer_s1_chipselect,
      clk => clk,
      reset_n => high_res_timer_s1_reset_n,
      write_n => high_res_timer_s1_write_n,
      writedata => high_res_timer_s1_writedata
    );


  --the_jtag_uart_avalon_jtag_slave, which is an e_instance
  the_jtag_uart_avalon_jtag_slave : jtag_uart_avalon_jtag_slave_arbitrator
    port map(
      cpu_data_master_granted_jtag_uart_avalon_jtag_slave => cpu_data_master_granted_jtag_uart_avalon_jtag_slave,
      cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave => cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave,
      cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave => cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave,
      cpu_data_master_requests_jtag_uart_avalon_jtag_slave => cpu_data_master_requests_jtag_uart_avalon_jtag_slave,
      d1_jtag_uart_avalon_jtag_slave_end_xfer => d1_jtag_uart_avalon_jtag_slave_end_xfer,
      jtag_uart_avalon_jtag_slave_address => jtag_uart_avalon_jtag_slave_address,
      jtag_uart_avalon_jtag_slave_chipselect => jtag_uart_avalon_jtag_slave_chipselect,
      jtag_uart_avalon_jtag_slave_dataavailable_from_sa => jtag_uart_avalon_jtag_slave_dataavailable_from_sa,
      jtag_uart_avalon_jtag_slave_irq_from_sa => jtag_uart_avalon_jtag_slave_irq_from_sa,
      jtag_uart_avalon_jtag_slave_read_n => jtag_uart_avalon_jtag_slave_read_n,
      jtag_uart_avalon_jtag_slave_readdata_from_sa => jtag_uart_avalon_jtag_slave_readdata_from_sa,
      jtag_uart_avalon_jtag_slave_readyfordata_from_sa => jtag_uart_avalon_jtag_slave_readyfordata_from_sa,
      jtag_uart_avalon_jtag_slave_reset_n => jtag_uart_avalon_jtag_slave_reset_n,
      jtag_uart_avalon_jtag_slave_waitrequest_from_sa => jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
      jtag_uart_avalon_jtag_slave_write_n => jtag_uart_avalon_jtag_slave_write_n,
      jtag_uart_avalon_jtag_slave_writedata => jtag_uart_avalon_jtag_slave_writedata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      jtag_uart_avalon_jtag_slave_dataavailable => jtag_uart_avalon_jtag_slave_dataavailable,
      jtag_uart_avalon_jtag_slave_irq => jtag_uart_avalon_jtag_slave_irq,
      jtag_uart_avalon_jtag_slave_readdata => jtag_uart_avalon_jtag_slave_readdata,
      jtag_uart_avalon_jtag_slave_readyfordata => jtag_uart_avalon_jtag_slave_readyfordata,
      jtag_uart_avalon_jtag_slave_waitrequest => jtag_uart_avalon_jtag_slave_waitrequest,
      reset_n => clk_reset_n
    );


  --the_jtag_uart, which is an e_ptf_instance
  the_jtag_uart : jtag_uart
    port map(
      av_irq => jtag_uart_avalon_jtag_slave_irq,
      av_readdata => jtag_uart_avalon_jtag_slave_readdata,
      av_waitrequest => jtag_uart_avalon_jtag_slave_waitrequest,
      dataavailable => jtag_uart_avalon_jtag_slave_dataavailable,
      readyfordata => jtag_uart_avalon_jtag_slave_readyfordata,
      av_address => jtag_uart_avalon_jtag_slave_address,
      av_chipselect => jtag_uart_avalon_jtag_slave_chipselect,
      av_read_n => jtag_uart_avalon_jtag_slave_read_n,
      av_write_n => jtag_uart_avalon_jtag_slave_write_n,
      av_writedata => jtag_uart_avalon_jtag_slave_writedata,
      clk => clk,
      rst_n => jtag_uart_avalon_jtag_slave_reset_n
    );


  --the_lcd_control_slave, which is an e_instance
  the_lcd_control_slave : lcd_control_slave_arbitrator
    port map(
      cpu_data_master_granted_lcd_control_slave => cpu_data_master_granted_lcd_control_slave,
      cpu_data_master_qualified_request_lcd_control_slave => cpu_data_master_qualified_request_lcd_control_slave,
      cpu_data_master_read_data_valid_lcd_control_slave => cpu_data_master_read_data_valid_lcd_control_slave,
      cpu_data_master_requests_lcd_control_slave => cpu_data_master_requests_lcd_control_slave,
      d1_lcd_control_slave_end_xfer => d1_lcd_control_slave_end_xfer,
      lcd_control_slave_address => lcd_control_slave_address,
      lcd_control_slave_begintransfer => lcd_control_slave_begintransfer,
      lcd_control_slave_read => lcd_control_slave_read,
      lcd_control_slave_readdata_from_sa => lcd_control_slave_readdata_from_sa,
      lcd_control_slave_wait_counter_eq_0 => lcd_control_slave_wait_counter_eq_0,
      lcd_control_slave_wait_counter_eq_1 => lcd_control_slave_wait_counter_eq_1,
      lcd_control_slave_write => lcd_control_slave_write,
      lcd_control_slave_writedata => lcd_control_slave_writedata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_byteenable => cpu_data_master_byteenable,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      lcd_control_slave_readdata => lcd_control_slave_readdata,
      reset_n => clk_reset_n
    );


  --the_lcd, which is an e_ptf_instance
  the_lcd : lcd
    port map(
      LCD_E => internal_LCD_E_from_the_lcd,
      LCD_RS => internal_LCD_RS_from_the_lcd,
      LCD_RW => internal_LCD_RW_from_the_lcd,
      LCD_data => LCD_data_to_and_from_the_lcd,
      readdata => lcd_control_slave_readdata,
      address => lcd_control_slave_address,
      begintransfer => lcd_control_slave_begintransfer,
      read => lcd_control_slave_read,
      write => lcd_control_slave_write,
      writedata => lcd_control_slave_writedata
    );


  --the_pwm_green_avalon_slave_0, which is an e_instance
  the_pwm_green_avalon_slave_0 : pwm_green_avalon_slave_0_arbitrator
    port map(
      cpu_data_master_granted_pwm_green_avalon_slave_0 => cpu_data_master_granted_pwm_green_avalon_slave_0,
      cpu_data_master_qualified_request_pwm_green_avalon_slave_0 => cpu_data_master_qualified_request_pwm_green_avalon_slave_0,
      cpu_data_master_read_data_valid_pwm_green_avalon_slave_0 => cpu_data_master_read_data_valid_pwm_green_avalon_slave_0,
      cpu_data_master_requests_pwm_green_avalon_slave_0 => cpu_data_master_requests_pwm_green_avalon_slave_0,
      d1_pwm_green_avalon_slave_0_end_xfer => d1_pwm_green_avalon_slave_0_end_xfer,
      pwm_green_avalon_slave_0_address => pwm_green_avalon_slave_0_address,
      pwm_green_avalon_slave_0_chipselect => pwm_green_avalon_slave_0_chipselect,
      pwm_green_avalon_slave_0_readdata_from_sa => pwm_green_avalon_slave_0_readdata_from_sa,
      pwm_green_avalon_slave_0_reset_n => pwm_green_avalon_slave_0_reset_n,
      pwm_green_avalon_slave_0_write_n => pwm_green_avalon_slave_0_write_n,
      pwm_green_avalon_slave_0_writedata => pwm_green_avalon_slave_0_writedata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      pwm_green_avalon_slave_0_readdata => pwm_green_avalon_slave_0_readdata,
      reset_n => clk_reset_n
    );


  --the_pwm_green, which is an e_ptf_instance
  the_pwm_green : pwm_green
    port map(
      out_port => internal_out_port_from_the_pwm_green (-2 DOWNTO 0),
      readdata => pwm_green_avalon_slave_0_readdata,
      address => pwm_green_avalon_slave_0_address,
      chipselect => pwm_green_avalon_slave_0_chipselect,
      clk => clk,
      reset_n => pwm_green_avalon_slave_0_reset_n,
      write_n => pwm_green_avalon_slave_0_write_n,
      writedata => pwm_green_avalon_slave_0_writedata
    );


  --the_pwm_red1_avalon_slave_0, which is an e_instance
  the_pwm_red1_avalon_slave_0 : pwm_red1_avalon_slave_0_arbitrator
    port map(
      cpu_data_master_granted_pwm_red1_avalon_slave_0 => cpu_data_master_granted_pwm_red1_avalon_slave_0,
      cpu_data_master_qualified_request_pwm_red1_avalon_slave_0 => cpu_data_master_qualified_request_pwm_red1_avalon_slave_0,
      cpu_data_master_read_data_valid_pwm_red1_avalon_slave_0 => cpu_data_master_read_data_valid_pwm_red1_avalon_slave_0,
      cpu_data_master_requests_pwm_red1_avalon_slave_0 => cpu_data_master_requests_pwm_red1_avalon_slave_0,
      d1_pwm_red1_avalon_slave_0_end_xfer => d1_pwm_red1_avalon_slave_0_end_xfer,
      pwm_red1_avalon_slave_0_address => pwm_red1_avalon_slave_0_address,
      pwm_red1_avalon_slave_0_chipselect => pwm_red1_avalon_slave_0_chipselect,
      pwm_red1_avalon_slave_0_readdata_from_sa => pwm_red1_avalon_slave_0_readdata_from_sa,
      pwm_red1_avalon_slave_0_reset_n => pwm_red1_avalon_slave_0_reset_n,
      pwm_red1_avalon_slave_0_write_n => pwm_red1_avalon_slave_0_write_n,
      pwm_red1_avalon_slave_0_writedata => pwm_red1_avalon_slave_0_writedata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      pwm_red1_avalon_slave_0_readdata => pwm_red1_avalon_slave_0_readdata,
      reset_n => clk_reset_n
    );


  --the_pwm_red1, which is an e_ptf_instance
  the_pwm_red1 : pwm_red1
    port map(
      out_port => internal_out_port_from_the_pwm_red1 (-2 DOWNTO 0),
      readdata => pwm_red1_avalon_slave_0_readdata,
      address => pwm_red1_avalon_slave_0_address,
      chipselect => pwm_red1_avalon_slave_0_chipselect,
      clk => clk,
      reset_n => pwm_red1_avalon_slave_0_reset_n,
      write_n => pwm_red1_avalon_slave_0_write_n,
      writedata => pwm_red1_avalon_slave_0_writedata
    );


  --the_pwm_red2_avalon_slave_0, which is an e_instance
  the_pwm_red2_avalon_slave_0 : pwm_red2_avalon_slave_0_arbitrator
    port map(
      cpu_data_master_granted_pwm_red2_avalon_slave_0 => cpu_data_master_granted_pwm_red2_avalon_slave_0,
      cpu_data_master_qualified_request_pwm_red2_avalon_slave_0 => cpu_data_master_qualified_request_pwm_red2_avalon_slave_0,
      cpu_data_master_read_data_valid_pwm_red2_avalon_slave_0 => cpu_data_master_read_data_valid_pwm_red2_avalon_slave_0,
      cpu_data_master_requests_pwm_red2_avalon_slave_0 => cpu_data_master_requests_pwm_red2_avalon_slave_0,
      d1_pwm_red2_avalon_slave_0_end_xfer => d1_pwm_red2_avalon_slave_0_end_xfer,
      pwm_red2_avalon_slave_0_address => pwm_red2_avalon_slave_0_address,
      pwm_red2_avalon_slave_0_chipselect => pwm_red2_avalon_slave_0_chipselect,
      pwm_red2_avalon_slave_0_readdata_from_sa => pwm_red2_avalon_slave_0_readdata_from_sa,
      pwm_red2_avalon_slave_0_reset_n => pwm_red2_avalon_slave_0_reset_n,
      pwm_red2_avalon_slave_0_write_n => pwm_red2_avalon_slave_0_write_n,
      pwm_red2_avalon_slave_0_writedata => pwm_red2_avalon_slave_0_writedata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      pwm_red2_avalon_slave_0_readdata => pwm_red2_avalon_slave_0_readdata,
      reset_n => clk_reset_n
    );


  --the_pwm_red2, which is an e_ptf_instance
  the_pwm_red2 : pwm_red2
    port map(
      out_port => internal_out_port_from_the_pwm_red2 (-2 DOWNTO 0),
      readdata => pwm_red2_avalon_slave_0_readdata,
      address => pwm_red2_avalon_slave_0_address,
      chipselect => pwm_red2_avalon_slave_0_chipselect,
      clk => clk,
      reset_n => pwm_red2_avalon_slave_0_reset_n,
      write_n => pwm_red2_avalon_slave_0_write_n,
      writedata => pwm_red2_avalon_slave_0_writedata
    );


  --the_sys_clk_timer_s1, which is an e_instance
  the_sys_clk_timer_s1 : sys_clk_timer_s1_arbitrator
    port map(
      cpu_data_master_granted_sys_clk_timer_s1 => cpu_data_master_granted_sys_clk_timer_s1,
      cpu_data_master_qualified_request_sys_clk_timer_s1 => cpu_data_master_qualified_request_sys_clk_timer_s1,
      cpu_data_master_read_data_valid_sys_clk_timer_s1 => cpu_data_master_read_data_valid_sys_clk_timer_s1,
      cpu_data_master_requests_sys_clk_timer_s1 => cpu_data_master_requests_sys_clk_timer_s1,
      d1_sys_clk_timer_s1_end_xfer => d1_sys_clk_timer_s1_end_xfer,
      sys_clk_timer_s1_address => sys_clk_timer_s1_address,
      sys_clk_timer_s1_chipselect => sys_clk_timer_s1_chipselect,
      sys_clk_timer_s1_irq_from_sa => sys_clk_timer_s1_irq_from_sa,
      sys_clk_timer_s1_readdata_from_sa => sys_clk_timer_s1_readdata_from_sa,
      sys_clk_timer_s1_reset_n => sys_clk_timer_s1_reset_n,
      sys_clk_timer_s1_write_n => sys_clk_timer_s1_write_n,
      sys_clk_timer_s1_writedata => sys_clk_timer_s1_writedata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      reset_n => clk_reset_n,
      sys_clk_timer_s1_irq => sys_clk_timer_s1_irq,
      sys_clk_timer_s1_readdata => sys_clk_timer_s1_readdata
    );


  --the_sys_clk_timer, which is an e_ptf_instance
  the_sys_clk_timer : sys_clk_timer
    port map(
      irq => sys_clk_timer_s1_irq,
      readdata => sys_clk_timer_s1_readdata,
      address => sys_clk_timer_s1_address,
      chipselect => sys_clk_timer_s1_chipselect,
      clk => clk,
      reset_n => sys_clk_timer_s1_reset_n,
      write_n => sys_clk_timer_s1_write_n,
      writedata => sys_clk_timer_s1_writedata
    );


  --the_uart_s1, which is an e_instance
  the_uart_s1 : uart_s1_arbitrator
    port map(
      cpu_data_master_granted_uart_s1 => cpu_data_master_granted_uart_s1,
      cpu_data_master_qualified_request_uart_s1 => cpu_data_master_qualified_request_uart_s1,
      cpu_data_master_read_data_valid_uart_s1 => cpu_data_master_read_data_valid_uart_s1,
      cpu_data_master_requests_uart_s1 => cpu_data_master_requests_uart_s1,
      d1_uart_s1_end_xfer => d1_uart_s1_end_xfer,
      uart_s1_address => uart_s1_address,
      uart_s1_begintransfer => uart_s1_begintransfer,
      uart_s1_chipselect => uart_s1_chipselect,
      uart_s1_dataavailable_from_sa => uart_s1_dataavailable_from_sa,
      uart_s1_irq_from_sa => uart_s1_irq_from_sa,
      uart_s1_read_n => uart_s1_read_n,
      uart_s1_readdata_from_sa => uart_s1_readdata_from_sa,
      uart_s1_readyfordata_from_sa => uart_s1_readyfordata_from_sa,
      uart_s1_reset_n => uart_s1_reset_n,
      uart_s1_write_n => uart_s1_write_n,
      uart_s1_writedata => uart_s1_writedata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      reset_n => clk_reset_n,
      uart_s1_dataavailable => uart_s1_dataavailable,
      uart_s1_irq => uart_s1_irq,
      uart_s1_readdata => uart_s1_readdata,
      uart_s1_readyfordata => uart_s1_readyfordata
    );


  --the_uart, which is an e_ptf_instance
  the_uart : uart
    port map(
      dataavailable => uart_s1_dataavailable,
      irq => uart_s1_irq,
      readdata => uart_s1_readdata,
      readyfordata => uart_s1_readyfordata,
      txd => internal_txd_from_the_uart,
      address => uart_s1_address,
      begintransfer => uart_s1_begintransfer,
      chipselect => uart_s1_chipselect,
      clk => clk,
      read_n => uart_s1_read_n,
      reset_n => uart_s1_reset_n,
      rxd => rxd_to_the_uart,
      write_n => uart_s1_write_n,
      writedata => uart_s1_writedata
    );


  --reset is asserted asynchronously and deasserted synchronously
  NIOS_System_1_reset_clk_domain_synch : NIOS_System_1_reset_clk_domain_synch_module
    port map(
      data_out => clk_reset_n,
      clk => clk,
      data_in => module_input,
      reset_n => reset_n_sources
    );

  module_input <= std_logic'('1');

  --reset sources mux, which is an e_mux
  reset_n_sources <= Vector_To_Std_Logic(NOT (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT reset_n))) OR std_logic_vector'("00000000000000000000000000000000")) OR (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_jtag_debug_module_resetrequest_from_sa)))) OR (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_jtag_debug_module_resetrequest_from_sa))))));
  --vhdl renameroo for output signals
  LCD_E_from_the_lcd <= internal_LCD_E_from_the_lcd;
  --vhdl renameroo for output signals
  LCD_RS_from_the_lcd <= internal_LCD_RS_from_the_lcd;
  --vhdl renameroo for output signals
  LCD_RW_from_the_lcd <= internal_LCD_RW_from_the_lcd;
  --vhdl renameroo for output signals
  out_port_from_the_HEX0 <= internal_out_port_from_the_HEX0;
  --vhdl renameroo for output signals
  out_port_from_the_HEX1 <= internal_out_port_from_the_HEX1;
  --vhdl renameroo for output signals
  out_port_from_the_HEX2 <= internal_out_port_from_the_HEX2;
  --vhdl renameroo for output signals
  out_port_from_the_HEX3 <= internal_out_port_from_the_HEX3;
  --vhdl renameroo for output signals
  out_port_from_the_HEX4_to_HEX7 <= internal_out_port_from_the_HEX4_to_HEX7;
  --vhdl renameroo for output signals
  out_port_from_the_pwm_green <= internal_out_port_from_the_pwm_green;
  --vhdl renameroo for output signals
  out_port_from_the_pwm_red1 <= internal_out_port_from_the_pwm_red1;
  --vhdl renameroo for output signals
  out_port_from_the_pwm_red2 <= internal_out_port_from_the_pwm_red2;
  --vhdl renameroo for output signals
  txd_from_the_uart <= internal_txd_from_the_uart;

end europa;


--synthesis translate_off

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add your libraries here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>

entity test_bench is 
end entity test_bench;


architecture europa of test_bench is
component NIOS_System_1 is 
           port (
                 -- 1) global signals:
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- the_HEX0
                    signal out_port_from_the_HEX0 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);

                 -- the_HEX1
                    signal out_port_from_the_HEX1 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);

                 -- the_HEX2
                    signal out_port_from_the_HEX2 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);

                 -- the_HEX3
                    signal out_port_from_the_HEX3 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);

                 -- the_HEX4_to_HEX7
                    signal out_port_from_the_HEX4_to_HEX7 : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);

                 -- the_KEYS
                    signal in_port_to_the_KEYS : IN STD_LOGIC_VECTOR (2 DOWNTO 0);

                 -- the_SWITCHS
                    signal in_port_to_the_SWITCHS : IN STD_LOGIC_VECTOR (17 DOWNTO 0);

                 -- the_lcd
                    signal LCD_E_from_the_lcd : OUT STD_LOGIC;
                    signal LCD_RS_from_the_lcd : OUT STD_LOGIC;
                    signal LCD_RW_from_the_lcd : OUT STD_LOGIC;
                    signal LCD_data_to_and_from_the_lcd : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);

                 -- the_pwm_green
                    signal out_port_from_the_pwm_green : OUT STD_LOGIC;

                 -- the_pwm_red1
                    signal out_port_from_the_pwm_red1 : OUT STD_LOGIC;

                 -- the_pwm_red2
                    signal out_port_from_the_pwm_red2 : OUT STD_LOGIC;

                 -- the_uart
                    signal rxd_to_the_uart : IN STD_LOGIC;
                    signal txd_from_the_uart : OUT STD_LOGIC
                 );
end component NIOS_System_1;

                signal LCD_E_from_the_lcd :  STD_LOGIC;
                signal LCD_RS_from_the_lcd :  STD_LOGIC;
                signal LCD_RW_from_the_lcd :  STD_LOGIC;
                signal LCD_data_to_and_from_the_lcd :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal clk :  STD_LOGIC;
                signal in_port_to_the_KEYS :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal in_port_to_the_SWITCHS :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal jtag_uart_avalon_jtag_slave_dataavailable_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_readyfordata_from_sa :  STD_LOGIC;
                signal out_port_from_the_HEX0 :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal out_port_from_the_HEX1 :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal out_port_from_the_HEX2 :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal out_port_from_the_HEX3 :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal out_port_from_the_HEX4_to_HEX7 :  STD_LOGIC_VECTOR (27 DOWNTO 0);
                signal out_port_from_the_pwm_green :  STD_LOGIC;
                signal out_port_from_the_pwm_red1 :  STD_LOGIC;
                signal out_port_from_the_pwm_red2 :  STD_LOGIC;
                signal reset_n :  STD_LOGIC;
                signal rxd_to_the_uart :  STD_LOGIC;
                signal txd_from_the_uart :  STD_LOGIC;
                signal uart_s1_dataavailable_from_sa :  STD_LOGIC;
                signal uart_s1_readyfordata_from_sa :  STD_LOGIC;


-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add your component and signal declaration here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>


begin

  --Set us up the Dut
  DUT : NIOS_System_1
    port map(
      LCD_E_from_the_lcd => LCD_E_from_the_lcd,
      LCD_RS_from_the_lcd => LCD_RS_from_the_lcd,
      LCD_RW_from_the_lcd => LCD_RW_from_the_lcd,
      LCD_data_to_and_from_the_lcd => LCD_data_to_and_from_the_lcd,
      out_port_from_the_HEX0 => out_port_from_the_HEX0,
      out_port_from_the_HEX1 => out_port_from_the_HEX1,
      out_port_from_the_HEX2 => out_port_from_the_HEX2,
      out_port_from_the_HEX3 => out_port_from_the_HEX3,
      out_port_from_the_HEX4_to_HEX7 => out_port_from_the_HEX4_to_HEX7,
      out_port_from_the_pwm_green => out_port_from_the_pwm_green,
      out_port_from_the_pwm_red1 => out_port_from_the_pwm_red1,
      out_port_from_the_pwm_red2 => out_port_from_the_pwm_red2,
      txd_from_the_uart => txd_from_the_uart,
      clk => clk,
      in_port_to_the_KEYS => in_port_to_the_KEYS,
      in_port_to_the_SWITCHS => in_port_to_the_SWITCHS,
      reset_n => reset_n,
      rxd_to_the_uart => rxd_to_the_uart
    );


  process
  begin
    clk <= '0';
    loop
       wait for 10 ns;
       clk <= not clk;
    end loop;
  end process;
  PROCESS
    BEGIN
       reset_n <= '0';
       wait for 200 ns;
       reset_n <= '1'; 
    WAIT;
  END PROCESS;


-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add additional architecture here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>


end europa;



--synthesis translate_on
