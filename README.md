# HybridBCI

> A framework for EEG-NIRS HCI comunication.

> HCI - BCI - EEG - NIRS


# Table of Contents

- [Documentation](#Documentation)
- [SystemDesign](#SystemDesign)
- [Prerequisites](#Prerequisites)
- [Installation](#Installation)
- [FAQ](#faq)
- [License](#license)
- [Refrence](#Refrence)



---

## Documentation
Detailed documentation on the software design, implementation and usage of the code are published at *Journal Name* and can be found <a href="#" >Paper</a> .

---

## SystemDesign
<img src="https://i.ibb.co/3rPJgYs/Block.png" title="FVCproductions" alt="FVCproductions">

---

## Prerequisites
The main GUI interface of the HybridBCI is designed in <a href="https://www.mathworks.com/products/matlab/app-designer.html" >App Designer</a>, which is still under development in Matlab, so try to use latest version of the Matlab for maximum compatibility. Minimum requirment would be `Matlab R2018a`.

Depending on which part of the code you are using different libraries are required. 

> Main functionality

  - Matlab R2018a
  - <a href="#" >Psychtoolbox</a>

> EEG
  - <a href="https://www.mathworks.com/help/dsp/index.html?s_tid=CRUX_lftnav" >DSP System Toolbox</a> 

> Speller
 - <a href="https://www.mathworks.com/products/text-analytics.html" >TextAnalytics Toolbox</a> 

---

## Installation
  HybridBCI needs administrative privileges to creat folders for saving log files and storing recorded data and created models. Run Matlab as administrator and navigate to the root folder of the HybridBCI and:

  ```shell
    HybridBCI
  ```
  For testing, you can use the sampleSubject data and set feedback as Simulation.

---

## FAQ
  
  **Q:** How do I add a new EEG feature?

  **A:** Read the <a href="#" >Paper</a> at 'EEG Features' section.  
  ___

  **Q:** How do I add a new NIRS feature?

  **A:** Read the <a href="#" >Paper</a> at 'NIRS Features' section. 
  ___

  **Q:** How do I implement a new recording device?

  **A:** Read the <a href="#" >Paper</a> at 'Data Acquisition' section.  
  ___

  **Q:** How do I cite the paper?

  **A:** As in [Refrence](#Refrence). 

---

## License
  [![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)
  - **[MIT license](http://opensource.org/licenses/mit-license.php)**
  - Copyright 2020 © CLISLAB.  

---

## Refrence
The paper is under review yet. Wait for it.
