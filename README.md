# PropPrelib
A library to assist with MATLAB functions for Propulsion Prelim

# How to use
Download this repository as a zip folder.

Copy the +PropPrelim folder into the same directory as your scripts.

In your script write the following at the beginning:

```python
import PropPrelim.*
```

Take a look in the examples folder for specific use cases.

# Features
### Currently implemented and planned
* Unit Systems
  - [x] BE
  - [x] SI
* Atmosphric Models AED 2nd. ed.
  - [x] Standard
  - [x] Hot
  - [x] Cold
  - [x] Tropic
* Engine Models AED 2nd. ed.
  - [ ] Simple High Bypass Turbofan
  - [x] Simple Low Bypass Turbofan
  - [ ] Simple Advanced Turbojet
  - [ ] Simple Advanced Turboprop
  - [ ] Simple User Input Model **(WIP)**
  - [ ] Full Cycle Mixed Turbofan with Afterburner **(WIP)**
* Drag Models AED 2nd. ed.
  - [x] Future Fighter
  - [x] Current Fighter
  - [ ] AIAA 2019 Supersonic Passenger Airliner Competition Drag Model
* Design Process
  - Constraint Analysis
    - [x] Thrust Loading/Wing Loading Conditions<sup>1</sup>
  - Climb Scheduler
    - [x] Minimum Time<sup>2</sup>
    - [ ] Minimum Fuel
    - [ ] Climb Schedule to Mission Leg Conversion
  - Mission Analysis
    - [x] Manuever Fuel Consumption and Mass Fraction<sup>1</sup>
    - [ ] Mission Leg to Constraint Conversion
    - [ ] Mission Descriptions and Automated Runthrough
  - Parametric Cycle Analysis (Design Point)
    - Mixed Turbofan with Afterburner
      - [x] Constant Specific Heat<sup>2,3</sup>
      - [ ] Modified Specific Heat
      - [x] Variable Specific Heat<sup>2,3</sup>
  - [x] Sensitivity Analysis
  - Performance Cycle Analysis (Off Design)
    - Mixed Turbofan with Afterburner
      - [ ] Constant Specific Heat
      - [ ] Modified Specific Heat
      - [ ] Variable Specific Heat **(WIP)**
   - Engine Tuning
      - [ ] Installation Losses
      - [ ] Engine Scale
      - [ ] Engine Control
   - Optimization and Iterations
     - [ ] Variable Constraints
     - [ ] RFP Application Functions
     - [ ] RFP/Mission/Engine Optimization using Gradient Descent
   - Aerodynamics Utilities
     - [x] Dynamic Pressure
     - [x] g0 as a Function of currently selected unitsystem
     - [x] Mass Flow Parameter
   - General Purpose
     - [x] Flexible Argument Parser
     - [x] Variable name Formatter
     - [x] Struct Pretty Printer
     - [x] Table Comparision Printer
   - Mattingly Subroutines
     - [x] FAIR<sup>3</sup>
     - [x] MASSFP<sup>2,3</sup>
     - [x] RGCOMPR<sup>2,3</sup>
     - [x] TURB<sup>3,4</sup>
     - [x] TURBC<sup>3,4</sup>
     - [ ] FAIR<sub>M</sub>
     
<sup>1: Not fully implemented for every input case.</sup><br>
<sup>2: Current Implementation may be innacurate depending in inputs.</sup><br>
<sup>3: Current Implementation does not correctly handle SI units.</sup><br>
<sup>4: Current Implementation has not been tested thoroughly either due to insufficent integration or due to insufficent example data.</sup>
  
### Potential Future Considerations
  * Integration with AEDsys
    - [ ] ONX/REF file loading and saving
    - [ ] AEDsys Mission/Constraint Loading and Saving
  * Analysis
    - [ ] Carpet Plots
    - [ ] Improved options for Mach/Altitude Plots
    - [ ] Simulink?????
  * General
    - [ ] Better documentation
    - [ ] Unit testing
    - [ ] Implementation of better programming languages (C++, Python , etc...)
