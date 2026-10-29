# Third-party components

This repository contains files copied from, or derived from, the open-source
projects listed below. These files are **not** covered by the University of
Cagliari copyright notice in `LICENSE`: they keep their original copyright
holders and licences, whose notices (where present in the upstream project)
have been left intact in the file headers. Some files have been locally
modified to fit SYNtzulA; the modifications are released under the same
licence as the original file.

| Component | URL | Licence | Files in this repository |
|---|---|---|---|
| SERV — bit-serial RISC-V core (Olof Kindgren) | https://github.com/olofk/serv | ISC | `rtl/serv/*.v` (except `serv_compdec.v`, see below) |
| Servant — reference SoC for SERV (Olof Kindgren) | https://github.com/olofk/serv (directory `servant/`) | ISC | `rtl/servant/servant_arbiter.v`, `rtl/servant/servant_mux.v`, `rtl/servant/servant_ram.v`, `rtl/servant/servant_gpio.v`, `rtl/servant/servant_timer.v`, `rtl/servant/servant_clock_gen.v` (derived); `sim/tb/servant_sim.v`, `sim/tb/servant_tb.v` (derived) |
| `serv_compdec` — RISC-V compressed-instruction decoder (lowRISC contributors; ETH Zurich and University of Bologna; adapted to SERV by @Abdulwadoodd) | https://github.com/olofk/serv/blob/main/rtl/serv_compdec.v | Apache-2.0 | `rtl/serv/serv_compdec.v` |
| `vlog_tb_utils` — Verilog testbench utilities (Olof Kindgren) | https://github.com/fusesoc/vlog_tb_utils | ISC | `sim/tb/vlog_tb_utils.v` |
| PicoSoC / PicoRV32 — SPI flash simulation model (Claire Xenia Wolf) | https://github.com/YosysHQ/picorv32 (directory `picosoc/`) | ISC | `sim/tb/flash_spi_sim.sv` |
| Yosys iCE40 cell simulation models (Claire Xenia Wolf / YosysHQ) | https://github.com/YosysHQ/yosys (directory `techlibs/ice40/`) | ISC | `sim/tb/cells_sim.v`, `sim/tb/SB_PLL40_PAD.v`, `sim/tb/SB_PLL40_2F_PAD.v`, `rtl/syntzulu_dual_core/SB_SPRAM256KA.v` |
| BasicUART — basic UART transmitter/receiver (Stanislav Jurny) | https://github.com/STjurny/BasicUART | MIT | `rtl/servant/SerialTransmitter.v`, `rtl/servant/SerialReceiver.v` |
| IHP SG13G2 open PDK — standard-cell, I/O and SRAM behavioural models (IHP PDK Authors) | https://github.com/IHP-GmbH/IHP-Open-PDK | Apache-2.0 | `std_cells/sg13g2_stdcell.v`, `std_cells/sg13g2_io.v`, `rtl/behavioural_ihp/*.v` |
| SiFive Freedom E SDK — RISC-V linker script (SiFive Inc.) | https://github.com/sifive/freedom-e-sdk | Apache-2.0 | `firmware/src/linker.lds`, `firmware/src/linkerscript.lds` (derived) |
| five-embeddev RISC-V bare-metal startup, CSR access and timer driver | https://github.com/five-embeddev/riscv-scratchpad | Unlicense | `firmware/src/startup.c`, `firmware/src/riscv-csr.h`, `firmware/src/riscv-interrupts.h`, `firmware/src/timer.c`, `firmware/src/timer.h` |

All other files in this repository are original work developed at DIEE,
University of Cagliari, and are covered by `LICENSE`.
