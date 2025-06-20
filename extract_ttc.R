extract_ttc <- function(ttc_path, 
                        output_dir = normalizePath(file.path(getwd(), "fonts"), mustWork = FALSE), 
                        stripttc_path = Sys.getenv("STRIP_TTC_PATH"), 
                        verbose = FALSE) {
  # Ensure the output directory exists
  if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)
  
  # Validate inputs
  if (!file.exists(ttc_path)) stop("TTC file not found: ", ttc_path)
  if (stripttc_path == "" || !file.exists(stripttc_path)) {
    stop("stripttc binary not found. Set STRIP_TTC_PATH in the project .Renviron or specify stripttc_path.")
  }
  
  # Change to output directory to ensure TTFs are extracted there
  orig_wd <- getwd()
  on.exit(setwd(orig_wd))  # Restore original working directory
  if (verbose) cat("Changing to output directory:", output_dir, "\n")
  setwd(output_dir)
  
  # Construct and execute command
  cmd <- sprintf("'%s' '%s'", stripttc_path, normalizePath(ttc_path))
  if (verbose) cat("Executing command:", cmd, "\n")
  
  # Run stripttc and capture output
  result <- tryCatch({
    system(cmd, intern = TRUE, ignore.stderr = FALSE)
  }, warning = function(w) {
    warning("stripttc warning: ", w$message, "\nOutput: ", paste(result, collapse = "\n"))
    return(NULL)
  }, error = function(e) {
    stop("stripttc failed: ", e$message, "\nCommand: ", cmd, "\nOutput: ", paste(result, collapse = "\n"))
  })
  
  # Get list of extracted TTF files
  ttf_files <- list.files(output_dir, pattern = "\\.ttf$", full.names = TRUE)
  if (length(ttf_files) == 0) {
    warning("No TTF files extracted. Check the TTC file or stripttc output:\n", paste(result, collapse = "\n"))
    return(invisible(NULL))
  }
  
  # Print success message with font names
  cat("Successfully extracted", length(ttf_files), "TTF files to", output_dir, "\n")
  cat("These are the fonts:\n", paste(basename(ttf_files), collapse = "\n"), "\n")
  
  # Return list of extracted font files
  invisible(ttf_files)
}
