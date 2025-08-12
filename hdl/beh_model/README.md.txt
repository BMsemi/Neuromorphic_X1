# NEUROMORPHIC_X1 ReRAM Simulation

This project simulates a behavioral ReRAM memory integrated into a Wishbone-compatible interface and connected to a top-level wrapper called `NEUROMORPHIC_X1`.  
It is intended strictly for simulation (**non-synthesizable**) and demonstrates a functional neuromorphic compute-in-memory macro.

---

## 📁 File Overview

| File Name                       | Description |
|---------------------------------|-------------|
| `NEUROMORPHIC_X1_macro.v`       | Behavioral macro-level definition of the neuromorphic ReRAM macro. Includes all digital, analog, and scan pins. |
| `NEUROMORPHIC_X1.v`             | Top-level wrapper that instantiates `NEUROMORPHIC_X1_macro` and hardwires all ports to the test interface. |
| `ReRAM_Wishbone_Interface.v`    | Integration layer connecting ReRAM functional logic to the Wishbone interface. Handles address decoding and read/write control. |
| `wishbone_slave_interface.v`    | Implements Wishbone slave protocol and handshaking logic. Detects valid transactions and routes them to the ReRAM block. |
| `tb_ReRAM_Wishbone_Interface.v` | Testbench that simulates write and read transactions via the Wishbone interface, verifying timing and correctness. |
| `run.do`                        | QuestaSim/ModelSim simulation script to compile all files and run the testbench with waveform display. |

---

## ⚙️ Functionality Overview

### 🧠 ReRAM Behavior (Inside `NEUROMORPHIC_X1_macro`)
- **Write Operation**:
  - Takes `DI` (data in), `AD` (address), and `SEL` (byte select) from Wishbone interface
  - Stores data after `EN` goes LOW, with a **10-cycle latency**
- **Read Operation**:
  - Fixed latency of **44 clock cycles**
  - Output data on `DO[31:0]` is held for **1 cycle**
- **Usage Note**:
  - The user must not initiate new transactions until all pending writes are committed to the Crossbar Array

### 🔗 Wishbone Interface
- Expects target address: `0x3000_000C`
- Valid only when `SEL = 4'b0010`
- `R_WB` determines transaction type (1 = Read, 0 = Write)
- Asserts `func_ack` when transaction completes

---

## 🧪 Simulation Instructions

### Requirements:
- QuestaSim / ModelSim with SystemVerilog support

### Steps to Simulate:
1. Launch QuestaSim/ModelSim
2. Navigate to the project directory:
   ```
   cd {project_path}
   ```
3. Run:
   ```
   do run.do
   ```
4. The script will:
   - Compile all `.v` source files
   - Load the `tb_ReRAM_Wishbone_Interface` testbench
   - Add all relevant signals to the waveform
   - Run the simulation for a predefined duration

---

## 🧪 Testbench Features

The testbench (`tb_ReRAM_Wishbone_Interface.v`) executes:

1. **Write 32 entries** → read back 20 entries  
2. **Write 10 more entries** → read back 20 (overlapping previous data)  
3. **Write 30 entries** → read back 32 entries  
4. Apply **reset mid-operation** → verify correct behavior after reset  
5. **Write 10 entries** → read back 7 entries 

Testbench logs and assertions confirm:
- Correct data transfer  
- Proper latency handling  
- Wishbone protocol compliance  

---

## 📈 Output

- **Console logs**: Show timestamps for each write/read transaction
- **Waveform window**: Displays
  - Top-level Wishbone signals (`CLKin`, `RSTin`, `EN`, `R_WB`, `AD`, `DI`, `DO`, `func_ack`)
  - Internal ReRAM timing delays
  - Analog/scan pins (stubbed for simulation)

---

## ⚠️ Notes

- This design is **behavioral only** and not synthesizable
- All timing values (10-cycle write, 44-cycle read) are simulation constants
- Useful for verifying:
  - Protocol timing
  - Data integrity  
  - System-level integration in a neuromorphic memory macro context
