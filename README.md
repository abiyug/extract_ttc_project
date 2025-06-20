# extract_ttc

An R function to extract TrueType fonts (TTF) from TrueType Collection (TTC) files using the `stripttc` tool.

## Overview
The `extract_ttc` function extracts TTF files from a TTC file (e.g., `Baskerville.ttc`) and saves them to a `fonts` directory. Tested on macOS with `stripttc` installed via Homebrew and compiled.

## Installation
1. **Install Homebrew** (if not installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

* **Install and Compile** `stripttc`:
            * Install `getfonts` (includes `stripttc` source):
            bash

            `HOMEBREW_NO_AUTO_UPDATE=1 brew install getfonts`

            * Navigate to the source directory (e.g., `/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/getfonts.rb` or wherever Homebrew stores it) and compile:
            
             bash

            `cd` /path/to/getfonts/source

            `make`

            Copy `stripttc` to the project working directory for testing:

            bash

            `cp` stripttc /path/to/extract_ttc_project

            * Set STRIP_TTC_PATH in .Renviron to point to stripttc:

            `STRIP_TTC_PATH=/path/to/extract_ttc_project/stripttc`

            Alternatively, place stripttc in /usr/local/bin for system-wide access:
            
            bash

            `cp` stripttc /usr/local/bin/

## Usage
    R

    `source("extract_ttc.R")`
    `extract_ttc(ttc_path = "/System/Library/Fonts/Baskerville.ttc", verbose = TRUE)`

## Notes
    * Outputs TTF files with stripttc-generated names (e.g., font1.ttf).
    * Tested on macOS; may require adjustments for other OS.
    * Future work: Add font face-based renaming with unique suffixes to avoid conflicts.

