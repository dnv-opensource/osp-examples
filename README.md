# OSP examples

This directory is a small collection of FMI and Open Simulation Platform (OSP)
examples. It contains C++ FMU sources, a PythonFMU model, and an OSP system
description that connects generated FMUs.

## Directory map

```text
osp-examples/
|-- .git/                    Git metadata for this examples checkout
|-- cpp-fmus/                C++ FMU project based on CPPFMU
|-- PythonFMU/               PythonFMU resistor model and build files
`-- system/                  OSP system structure and FMU files
```

### `cpp-fmus/`

The C++ FMU project contains:

- `CMakeLists.txt` and `cmake/` for configuring and packaging FMUs.
- `src/` with the example FMU implementations.
- `cppfmu/` with the CPPFMU framework submodule.
- `fmi/` with FMI headers and support files.
- `tools/` with utilities such as `MergeFMUs.cmake`.
- `build.ps1` for the Windows build workflow.
- `fail/`, `mock/`, `null/`, and `vector/` with example FMU sources.

Build it from this directory with CMake:

```powershell
Set-Location cpp-fmus
git submodule update --init --recursive
cmake -S . -B build
cmake --build build
```

The generated FMUs are placed in the `build/` directory. The project README
also documents optional FMI compliance checks and merging platform-specific
FMUs.

### `PythonFMU/`

This directory contains a PythonFMU resistor example:

- `demoslave.py` defines the `Resistor` FMI 2.0 co-simulation slave.
- `requirements.txt` lists the model dependencies.
- `build.ps1` contains the `pythonfmu build` command.

Build the example from this directory after installing PythonFMU:

```powershell
Set-Location PythonFMU
pythonfmu build -f demoslave.py requirements.txt
```

#### PythonFMU host runtime

> [!IMPORTANT]
> When loading a PythonFMU in a non-Python host on Linux, set `LD_PRELOAD` to
> the full path of the shared library for the Python runtime that will execute
> the FMU **before starting the host process**. The library must match the
> Python version and architecture available on the target system; PythonFMU
> does not bundle Python.
>
> For example, launch the host with:
>
> ```bash
> LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libpython3.11.so cosim run path/to/system
> ```
>
> Replace the example path and version with the `libpython` library installed
> on your system. Setting `LD_PRELOAD` after the host has already started is
> too late. This Linux-specific step is needed for non-Python hosts; it is not
> required when the host process is Python itself.
>
> On Windows, `LD_PRELOAD` does not exist. Instead, make the directory
> containing the matching Python DLL (`python3.dll` or a versioned DLL such as
> `python311.dll`) available on `PATH` before starting the non-Python host:
>
> ```powershell
> $env:PATH = "C:\Path\To\Python311;$env:PATH"
> .\cosim.exe run path\to\system
> ```
>
> Use a Python DLL with the same version and architecture as the environment
> that will execute the FMU. If the DLL is already discoverable by the host,
> no additional environment change is required.

### `system/`

This is a runnable OSP system example:

- `OspSystemStructure.xml` selects fixed-step execution with a base step of
  `0.01` seconds.
- `Resistor.fmu` is the PythonFMU resistor model.
- `vector.fmu` supplies the voltage inputs and receives the resistor currents.

The connections in the system structure are:

```text
vector.output[0]        -> resistor.positive_pin_v
vector.output[1]        -> resistor.negative_pin_v
resistor.positive_pin_i -> vector.input[0]
resistor.negative_pin_i -> vector.input[1]
```

Pass `system/` to an OSP-compatible co-simulation runner to execute it and
write simulation results.

## Open simulation tools

| Tool | Purpose | Link |
| --- | --- | --- |
| **libcosim** | C++ co-simulation library and OSP execution engine. | [GitHub repository](https://github.com/open-simulation-platform/libcosim) |
| **libcosim-cli / `cosim`** | Command-line tool for running OSP/SSP simulations and inspecting FMUs. The upstream repository is named `cosim-cli`. | [GitHub repository](https://github.com/open-simulation-platform/cosim-cli) |
| **libcosimpy** | Python wrapper for libcosim through the C API. | [GitHub repository](https://github.com/open-simulation-platform/libcosimpy) |
| **libcosimc** | C API wrapping a subset of libcosim. | [GitHub repository](https://github.com/open-simulation-platform/libcosimc) |
| **cosim-demo-app** | Server-client demo application demonstrating libcosim features. | [GitHub repository](https://github.com/open-simulation-platform/cosim-demo-app) |
| **demo-cases** | OSP co-simulation cases with `OspSystemStructure.xml` and SSP `SystemStructure.ssd` configurations. | [GitHub repository](https://github.com/open-simulation-platform/demo-cases) |
| **PythonFMU** | Builds Python model code into FMI 2.0 co-simulation FMUs. | [GitHub repository](https://github.com/NTNU-IHB/PythonFMU) / [PyPI package](https://pypi.org/project/pythonfmu/) |
