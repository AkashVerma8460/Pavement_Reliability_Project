# ============================================================
# SYNTHETIC CBR DATASET
# Based on IRC:37-2018 design conditions
# ============================================================

set.seed(123)

# ------------------------------------------------------------
# 1. saving the dataset
# ------------------------------------------------------------

save_folder <- "E:/Pavement_Reliability_Project/_Raw_Data"

# Create the folder if it does not already exist
if (!dir.exists(save_folder)) {
  dir.create(
    save_folder,
    recursive = TRUE
  )
}

# Complete output file path
output_file <- file.path(
  save_folder,
  "CBR_raw_synthetic.csv"
)

# ------------------------------------------------------------
# 2. Number of CBR observations
# ------------------------------------------------------------

n_cbr <- 180

# ------------------------------------------------------------
# 3. Function for truncated normal distribution
# Keeps generated CBR values within specified limits
# ------------------------------------------------------------

rtruncnorm_base <- function(n, mean, sd, lower, upper) {
  
  result <- numeric(0)
  
  while (length(result) < n) {
    
    x <- rnorm(
      n * 2,
      mean = mean,
      sd = sd
    )
    
    x <- x[
      x >= lower &
        x <= upper
    ]
    
    result <- c(result, x)
  }
  
  result[1:n]
}

# ------------------------------------------------------------
# 4. Generate CBR values
#
# 4-day soaked CBR
# Synthetic range: 6% to 15%
# ------------------------------------------------------------

CBR_percent <- rtruncnorm_base(
  n = n_cbr,
  mean = 8.5,
  sd = 1.8,
  lower = 6,
  upper = 15
)

# ------------------------------------------------------------
# 5. Generate station locations
#
# Representative 90 km road section
# ------------------------------------------------------------

Station_km <- seq(
  from = 0,
  to = 90,
  length.out = n_cbr
)

# ------------------------------------------------------------
# 6. Generate compaction
#
# Minimum = 97%
# Maximum = 100%
# ------------------------------------------------------------

Compaction_percent <- runif(
  n_cbr,
  min = 97,
  max = 100
)

# ------------------------------------------------------------
# 7. Create CBR dataset
# ------------------------------------------------------------

cbr_data <- data.frame(
  
  Sample_ID = sprintf(
    "CBR%03d",
    1:n_cbr
  ),
  
  Station_km = round(
    Station_km,
    2
  ),
  
  CBR_percent = round(
    CBR_percent,
    2
  ),
  
  Compaction_percent = round(
    Compaction_percent,
    2
  ),
  
  Test_Condition = "4-day soaked"
)

# ------------------------------------------------------------
# 8. Check generated data
# ------------------------------------------------------------

cat("\n===== CBR DATA SUMMARY =====\n")

print(
  summary(cbr_data)
)

cat("\n===== FIRST 10 OBSERVATIONS =====\n")

print(
  head(cbr_data, 10)
)

# CBR range
cat("\n===== CBR RANGE =====\n")

print(
  range(cbr_data$CBR_percent)
)

# Minimum compaction
cat("\n===== MINIMUM COMPACTION =====\n")

print(
  min(cbr_data$Compaction_percent)
)

# Check for missing values
cat("\n===== MISSING VALUES =====\n")

print(
  colSums(is.na(cbr_data))
)

# ------------------------------------------------------------
# 9. Save the dataset
# ------------------------------------------------------------

write.csv(
  cbr_data,
  output_file,
  row.names = FALSE
)

# ------------------------------------------------------------
# 10. Confirm where the file was saved
# ------------------------------------------------------------

cat("\n========================================\n")
cat("CBR dataset successfully saved!\n")
cat("Location:\n")
cat(output_file)
cat("\n========================================\n")
