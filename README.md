# Flori M365Report
Welcome to Flori M365Report

<img align="right" src="https://github.com/schmm2/Flori-M365Report/raw/main/Branding/icon.png" width="200px" alt="Flori">

The main idea behind Flori is to create a nice looking report about your Microsoft 365 Tenant. 

The idea is not to collect al different policies, users, devices and list them, thats what the [M365Documentation Project](https://github.com/ThomasKur/M365Documentation.) is doing. We want to ask specific questions about the environment like 

- "Which users are inactive" and could be deleted and even save me some money on licensing. 
- How many priviliged Admins are there and do they have a Phishing resistant Authentication Method added?
- And so on...

With the help of Collector Scripts (Idea copied from the M365Documentation Project), many types of information can be collected and be written the wished output format (Word, CSV, HTML).

The project will be setup so everybody can use the module in their specific environment. It will be adaptable with templates and parameters so you can get the exact report you as an indiviual or MSP are needing.

The project will hopefully be community centric. The main idea is that everybody can create a "Collector" script to query different types of data to complete their vision of a perfect report. These Collectors will be stored inside the project so everbody else can profit from them.

# Usage

TODO

# License
The license of the project is GPL v3.

## Source
The foundation/boilerplate of this project, along with several PowerShell functions, were copied from the exceptional M365 Documentation project, curated and maintained by the Thomas Kurt and the supportive community. You can explore their fantastic work at https://github.com/ThomasKur/M365Documentation.

Creating a PowerShell module of this complexity was a new to me, and the existing PowerShell functions from the M365 Documentation project were very important in accelerating my progress. To maintain transparency, I document all modifications directly in the respective .ps1 files. Below, you'll find a list of the files I've borrowed, providing a clear overview of what has been adapted from the original source and what I've changed to fit my needs. If I'm in violation with any GPL v3. Rules please let me know and I will change the project accordingly.

### Copied Files

| Original Filename  | New Name  | Source |
|---|---|---|
| M365Documentation.psd1   | M365Report.psd1   | https://github.com/ThomasKur/M365Documentation/blob/main/PSModule/M365Documentation/M365Documentation.psd1  |
|   |   |   |
|   |   |   |

List not completed yet... 

# Issues / Feedback
For any issues or feedback related to this project, please sign up for GitHub, and create an issue.

# Thanks

@ThomasKur for open sourcing the M365 Documentation project.

@guidooliveira / @PrzemyslawKlys for the PSWriteWord Module, which enables the creation of the Word file. https://github.com/EvotecIT/PSWriteWord
