# ============================================================
# DESIGN CBR CALCULATION
# IRC:37-2018
# ============================================================

# ------------------------------------------------------------
# 1. File locations
# ------------------------------------------------------------

input_file <- "E:/Pavement_Reliability_Project/_Clean_Data/CBR_clean.csv"

output_folder <- "E:/Pavement_Reliability_Project/_CBR_Analysis"

if (!dir.exists(output_folder)) {
  dir.create(
    output_folder,
    recursive = TRUE
  )
}

output_file <- file.path(
  output_folder,
  "CBR_Analysis_Results.csv"
)

# ------------------------------------------------------------
# 2. Read cleaned CBR data
# ------------------------------------------------------------

cbr_clean <- read.csv(
  input_file,
  stringsAsFactors = FALSE
)

# ------------------------------------------------------------
# 3. Basic CBR statistics
# ------------------------------------------------------------

CBR_mean <- mean(
  cbr_clean$CBR_percent
)

CBR_median <- median(
  cbr_clean$CBR_percent
)

CBR_sd <- sd(
  cbr_clean$CBR_percent
)

CBR_min <- min(
  cbr_clean$CBR_percent
)

CBR_max <- max(
  cbr_clean$CBR_percent
)

# ------------------------------------------------------------
# 4. Calculate CBR percentiles
# ------------------------------------------------------------

CBR_percentiles <- quantile(
  cbr_clean$CBR_percent,
  probs = c(
    0.10,
    0.25,
    0.50,
    0.75,
    0.90
  ),
  names = TRUE
)

# ------------------------------------------------------------
# 5. Design CBR
#
# For the high-volume-road case used in this project,
# IRC:37-2018 specifies the 90th-percentile CBR.
# ------------------------------------------------------------

Design_CBR <- as.numeric(
  quantile(
    cbr_clean$CBR_percent,
    probs = 0.90
  )
)

# ------------------------------------------------------------
# 6. Print results
# ------------------------------------------------------------

cat("\n========================================\n")
cat("CBR ANALYSIS RESULTS\n")
cat("========================================\n")

cat(
  "Number of observations:",
  nrow(cbr_clean),
  "\n"
)

cat(
  "Mean CBR:",
  round(CBR_mean, 2),
  "%\n"
)

cat(
  "Median CBR:",
  round(CBR_median, 2),
  "%\n"
)

cat(
  "Standard deviation:",
  round(CBR_sd, 2),
  "%\n"
)

cat(
  "Minimum CBR:",
  round(CBR_min, 2),
  "%\n"
)

cat(
  "Maximum CBR:",
  round(CBR_max, 2),
  "%\n"
)

cat(
  "90th percentile CBR:",
  round(Design_CBR, 2),
  "%\n"
)

cat(
  "Design CBR adopted:",
  round(Design_CBR, 2),
  "%\n"
)

# ------------------------------------------------------------
# 7. Create results table
# ------------------------------------------------------------

CBR_results <- data.frame(
  
  Number_of_Observations = nrow(cbr_clean),
  
  Mean_CBR_percent = round(
    CBR_mean,
    2
  ),
  
  Median_CBR_percent = round(
    CBR_median,
    2
  ),
  
  SD_CBR_percent = round(
    CBR_sd,
    2
  ),
  
  Minimum_CBR_percent = round(
    CBR_min,
    2
  ),
  
  Maximum_CBR_percent = round(
    CBR_max,
    2
  ),
  
  CBR_90th_Percentile = round(
    Design_CBR,
    2
  ),
  
  Design_CBR_percent = round(
    Design_CBR,
    2
  ),
  
  Design_CBR_Method = "90th percentile - IRC:37-2018"
)

# ------------------------------------------------------------
# 8. Save results
# ------------------------------------------------------------

write.csv(
  CBR_results,
  output_file,
  row.names = FALSE
)

cat("\nResults saved at:\n")
cat(output_file)

cat("\n========================================\n")