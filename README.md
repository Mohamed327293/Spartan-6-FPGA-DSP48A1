# Spartan-6-FPGA-DSP48A1
Prepared By: Mohamed Mostafa Mohamed Ali
Submitted To: Eng. Kareem Waseem

📌 Overview
This project focuses on the implementation and verification of a digital design using the DSP48A1 block available on the Spartan-6 FPGA platform. The design includes RTL modeling, verification through testbenches, synthesis, implementation, and analysis using linting tools.

📁 Project Structure
│
├── rtl/
│ └── reg_Mux.v # Main RTL module for DSP logic
│
├── testbench/
│ ├── tb_path1.v # Testbench for scenario 1
│ ├── tb_path2.v # Testbench for scenario 2
│ ├── tb_path3.v # Testbench for scenario 3
│ └── tb_path4.v # Testbench for scenario 4
│
├── constraints/
│ └── constraints.ucf # User constraints file for Spartan-6
│
├── scripts/
│ └── run.do # Simulation Do file (ModelSim or equivalent)
│
├── report/
│ ├── synthesis.rpt # Synthesis report (timing, area, etc.)
│ ├── implementation.rpt # Place and route report
│ └── lint_report.txt # Linting output and analysis
│
├── Mohamed_Mostafa_Project1.pdf # Final project documentation
│
└── README.md # Project description and instructions

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
