# Spartan-6-FPGA-DSP48A1
Prepared By: Mohamed Mostafa Mohamed Ali
Submitted To: Eng. Kareem Waseem

📌 Overview
This project focuses on the implementation and verification of a digital design using the DSP48A1 block available on the Spartan-6 FPGA platform. The design includes RTL modeling, verification through testbenches, synthesis, implementation, and analysis using linting tools.

📁 Project Structure

1. 🧠 RTL Code
Developed Verilog modules to implement the core functionality.

Includes a reg_Mux module as the main component.

2. 🧪 Testbench Code
Multiple testbench paths were designed to verify the behavior of the RTL code:

Path 1

Path 2

Path 3

Path 4

3. 📜 Do File
Used for automated simulation and waveform analysis.

4. ⛓ Constraint File
Defines pin assignments and timing constraints specific to the Spartan-6 board.

⚙️ Development Workflow
🔍 Elaboration
Prepared the design for simulation by elaborating the hierarchy and functional components.

🛠 Synthesis
Converted the RTL design into gate-level netlists using synthesis tools targeting Spartan-6.

🧩 Implementation
Mapping, placement, and routing of the synthesized netlist onto the FPGA.

✅ Linting
Verified code quality, syntax, and potential issues using linting tools.

📌 Tools & Technologies
Xilinx ISE Design Suite (for Spartan-6)

Verilog HDL

ModelSim or equivalent for simulation
