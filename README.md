## Overview

The `extract_ttc` function extracts individual **TrueType fonts (TTF)** from **TrueType Collection (TTC)** files, such as `Baskerville.ttc` or `Optima.ttc`, and saves them to a `fonts` directory in the project. It uses the `stripttc` tool to perform the extraction, generating TTF files with default names (e.g., `font1.ttf`, `font2.ttf`). Designed for **macOS**, this function ensures that TTF files from multiple TTCs are appended without overwrites, making it suitable for font processing workflows (e.g., font analysis or visualization with `ggplot2`).

Currently, it retains `stripttc`-generated names, with plans to implement **font face-based renaming** using `systemfonts` metadata in future updates. In the interim, an accompanying R script, `View_font_face_with_ggplot2.R`, provides proper font name appending and rendering with `ggplot2`. This script can be **sourced** or **run directly** in R, assuming `pacman`, `dplyr`, `purrr`, `ggplot2`, `stringr`, `systemfonts`, and `showtext` are installed or available.

## Installation
1. **Install Homebrew** (if not installed):

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. **Install and Compile `stripttc`**:
- Install `getfonts` (includes `stripttc` source):
 ```
  `HOMEBREW_NO_AUTO_UPDATE=1 brew install getfonts`
```
- Locate the `getfonts` source directory (e.g., `/usr/local/Cellar/getfonts/<version>`):
  ```
  brew --prefix getfonts
  ```
- Compile `stripttc`:
  ```
  cd /path/to/getfonts/source
  make
  ```
- Copy `stripttc` to the project working directory for testing:
  ```
  cp stripttc /path/to/extract_ttc_project/stripttc
  ```
- Set `STRIP_TTC_PATH` in the project `.Renviron`:
  ```
  STRIP_TTC_PATH=/path/to/extract_ttc_project/stripttc
  ```
  Alternatively, copy to `/usr/local/bin` for system-wide access:
  ```
  cp stripttc /usr/local/bin/
  ```

## Usage
```R
source("extract_ttc.R")
extract_ttc(ttc_path = "/System/Library/Fonts/Baskerville.ttc", verbose = TRUE)
```

## Verification
- Clone the repository:
```
cd /tmp
git clone https://github.com/abiyug/extract_ttc_project.git test_clone
cd test_clone
```
- Copy the binary `stripttc` to the project directory:

```
cp /path/to/stripttc /tmp/test_clone/stripttc
```

- Create .Renviron with: (or you can add it in a bin and/or make the location searchapth path)

```
STRIP_TTC_PATH=/tmp/test_clone/stripttc
```
- Start R and run the following
```{r, eval = FALSE}
source("extract_ttc.R")
extract_ttc("/System/Library/Fonts/Optima.ttc", verbose = TRUE)
```

- Verify the `fonts` directory is created and and *.ttf files are stored
```{r, eval - FALSE
dir("fonts")
```

## Notes
-  Outputs TTF files with `stripttc-generated` names (e.g., `font1.ttf`).
-  Tested on macOS; may require adjustments for other OS.
-  Future work: Add font face-based renaming with unique suffixes to avoid conflicts.

