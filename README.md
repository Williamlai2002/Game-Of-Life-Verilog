This repository contains a hardware implementation of Conway's Game of Life, a popular cellular automaton, developed for the DE-10 FPGA platform using Verilog. The project leverages FPGA hardware and Python-based visualization to simulate and display the evolving grid in real time.

## Overview
Conway's Game of Life is a grid-based simulation where each cell has two possible states: alive (1) or dead (0). The state of each cell in the next iteration depends on its current state and the number of live neighbors, according to these rules:

A cell with fewer than 2 or more than 3 live neighbors dies (underpopulation/overpopulation).
A cell with exactly 3 live neighbors becomes alive.
A cell with 2 live neighbors retains its current state (stability).
In this project, an 8x8 grid is implemented on an FPGA with real-time visualization via Python.

## Features
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
## Implementation Steps
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

## Brief description of each file
JTAG_UART_MODULE.v

This file defines the Verilog implementation of the JTAG UART interface. It handles communication between the FPGA and an external Python visualization script, facilitating the transfer of grid data for real-time display.

jtag_uart.qip

A Quartus IP (Intellectual Property) file, which integrates the JTAG UART module into the FPGA design. It contains metadata and configuration information for properly including and connecting the JTAG UART interface in the project.
lab4_task2.v

The top-level Verilog file for Lab 4, Task 2. It contains the Game of Life implementation, instantiates the JTAG UART module, and defines the clocking and control logic for the simulation. This module serves as the main entry point for synthesizing the design and running the Game of Life on the FPGA.
