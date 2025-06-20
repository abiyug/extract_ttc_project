# View_font_face_with_ggplot2.R
# Purpose: Append font names to TTFs and render with ggplot2
# Dependencies: pacman, dplyr, purrr, ggplot2, stringr, systemfonts, showtext
# Usage: Source or run directly
# source("View_font_face_with_ggplot2.R") or start R and run from command line

pacman::p_load(dplyr, purrr, ggplot2, stringr, sysfonts,showtext)

source("extract_ttc.R")

# use whatever ttc family font is available to you
paz_to_fnt <- "/System/Library/Fonts/Supplemental/Baskerville.ttc"

# get font family name
font_family_name <- str_extract(paz_to_fnt, "[^/]+(?=\\.ttc$)")

#run the function to extract ttf from ttc
extracted_fonts <- extract_ttc(paz_to_fnt, verbose = TRUE) #3 4 n 5 & 6


# Preping visualization with R
#Verify font is not loaded yet in R space for use
showtext::showtext_auto() # load the fonts
sysfonts::font_families() # verify via console that the

# patter used to build the tibble for ggplot 2
pattern <- paste0("^", (str_replace_all(font_family_name, " ", "")), ".*ttf", "$")

# Check the extracted files
lbl_txt <- "The quick brown fox jumps over the lazy dog."

#Viz
font_data <-
list.files("fonts",
                pattern = pattern, 
                full.names = T) %>%
     as_tibble() %>% 
     rename(path = value) %>% 
     mutate(index = readr::parse_number(path), .before = "path") %>%
     inner_join(
       systemfonts::system_fonts() %>%  
         #filter(str_detect(family, font_family_name)) %>%  # reg ex NOTxButX
         filter(family == font_family_name) %>%  # reg ex NOTxButX
         distinct() %>%
         select(index, path, name, family, style) %>%
         arrange(index) %>%
         select(index, family, font_face = name, style) %>%
         arrange(index),
       by = join_by(index)
     ) %>%
     select(index, family, font_face, style, path) %>%
     mutate(x = 1,
            y = seq_along(index),
            .before = "index") %>%
     mutate(lbl = lbl_txt,
            name = basename(path), .before = "path")


#load all font_faces fonts for use to R
walk2(font_data$font_face, font_data$path, font_add)

#To verify the fonts have been loaded and are ready for use 
showtext_auto() # load the fonts
font_families() # verify via console that the


#Viz

textz <- 8 # 20
fnt_nm <- paste0(font_family_name, ".ttc")


ggplot(font_data, aes(x, y)) +
  geom_text(aes(x = x, y = y, 
                label = font_face, family = font_face),
            hjust = 0,
            color = "gray44",
            size = textz) +
  geom_text(aes(x = 1.5, y = y, label = lbl_txt, family = font_face),
            hjust = 0,
            color = "#2f496e",
            size = textz) +
  #geom_blank(aes(x = 1.6, y = y)) +
  scale_x_continuous(expand = expansion(c(0, 2))) +
  scale_y_reverse() +
  labs(title = paste0(fnt_nm, " Unbundled"),
       x = "", y = "") +
  theme(plot.title = element_text(size = 62, color = "#5f0f4e", hjust = 0.5))
