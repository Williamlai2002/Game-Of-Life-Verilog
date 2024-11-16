This repository contains a hardware implementation of Conway's Game of Life, a popular cellular automaton, developed for the DE-10 FPGA platform using Verilog. The project leverages FPGA hardware and Python-based visualization to simulate and display the evolving grid in real time.

Overview
Conway's Game of Life is a grid-based simulation where each cell has two possible states: alive (1) or dead (0). The state of each cell in the next iteration depends on its current state and the number of live neighbors, according to these rules:

A cell with fewer than 2 or more than 3 live neighbors dies (underpopulation/overpopulation).
A cell with exactly 3 live neighbors becomes alive.
A cell with 2 live neighbors retains its current state (stability).
In this project, an 8x8 grid is implemented on an FPGA with real-time visualization via Python.

Features
Grid Representation

The grid consists of 64 cells represented by a 64-bit register. Each bit corresponds to the state of one cell (1 for alive, 0 for dead).
The grid supports wrap-around edges, ensuring that every cell has 8 neighbors, even on edges and corners.
Configurable Initial State

The grid can be reset to any user-defined initial state by providing a 64-bit integer value via a load signal.
A default initial state is included in the project, featuring a "glider" configuration, a pattern that perpetually moves across the grid.
Clock Management

The simulation uses two clocks derived from the DE-10's 50 MHz clock:
A game clock (~2.98 Hz) to control the evolution of the grid.
A write clock, 8 times faster than the game clock, to transfer data to the JTAG UART for visualization.
Visualization via Python

Grid states are transmitted sequentially through the JTAG UART and displayed using a Python script.
Each cell is visualized as either a black (dead) or white (alive) square on an 8x8 grid.
Interactivity and Debugging

The KEY[0] signal resets the grid to its initial state, allowing users to observe patterns evolving from specific starting conditions.
Debugging support includes connecting the JTAG data to on-board LEDs (LEDR[7:0]) for quick verification of output states.
Implementation Steps
Clocks

Use counters to derive the game clock and write clock from the 50 MHz FPGA clock.
Game Logic

Implement the neighbor computation logic for each cell, considering wrap-around edges.
Update the grid states based on the Game of Life rules during each clock cycle.
Integration with JTAG UART

Connect the grid's state output to the JTAG module for data transfer.
Ensure data transmission is synchronized with the write clock.
Python Visualization

Use the provided Python script to read bytes from the JTAG UART and display the grid's state in real time.
Adjust the vertical position of the display using the spacebar.
Deployment

Program the FPGA with the Verilog file, run the Python script, and visualize the grid's evolution.
How to Use
Clone this repository and upload the Verilog file to the DE-10 FPGA board.
Run the provided Python visualization script.
Observe the simulation and experiment with different initial states. Use KEY[0] to reset the board at any time.
Learning Objectives
This project is a practical exploration of:

Cellular automata and Conway's Game of Life.
Hardware description languages (Verilog).
FPGA-based simulation and real-time visualization.
Clock generation and synchronization.
Interaction between hardware and software for data visualization.
