# Satellite Simulation Parallelization Exercise

This repository contains a parallelization exercise centered around a simple satellite simulation application. The goal is to parallelize the computation—first using **OpenMP** for shared-memory CPU parallelism, then migrating to **OpenCL** for heterogeneous (CPU/GPU) acceleration. The project serves as a hands-on exploration of parallel programming models, performance trade-offs, and portability considerations across different hardware backends.

## Dependencies & Setup

To build and run the project, you'll need:
- **CMake** (≥3.10)
- **SDL2** (for visualization and windowing)
- **OpenCL** headers, runtime, and platform tools (e.g., `opencl-headers`, `ocl-icd` on Linux; vendor SDKs on Windows/macOS)

Win64 binaries for SDL2 and OpenCL ICD/loader are optionally included.

**Note on Git History**:  
> Development began before this repository was initialized. The early implementation milestones were added retroactively.

Exercise template by: Matias Koskela matias.koskela@tut.fi
                      Heikki Kultala heikki.kultala@tut.fi
                      Topi Leppanen  topi.leppanen@tuni.fi

Implementation/solution by me
