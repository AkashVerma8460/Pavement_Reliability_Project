# ============================================================
# CBR RAW DATA CLEANING
# ============================================================

# ------------------------------------------------------------
# 1. Set input and output locations
# ------------------------------------------------------------

input_file <- "E:/Pavement_Reliability_Project/_Raw_Data/CBR_raw_synthetic.csv"

output_folder <- "E:/Pavement_Reliability_Project/_Clean_Data"

# Create output folder if it does not exist
if (!dir.exists(output_folder)) {
  dir.create(
    output_folder,
    recursive = TRUE
  )
}

output_file <- file.path(
  output_folder,
  "CBR_clean.csv"
)

# ------------------------------------------------------------
# 2. Import raw CBR data
# ------------------------------------------------------------

cbr_raw <- read.csv(
  input_file,
  stringsAsFactors = FALSE
)

# ------------------------------------------------------------
# 3. Inspect raw data
# ------------------------------------------------------------

cat("\n===== DATA STRUCTURE =====\n")
str(cbr_raw)

cat("\n===== FIRST 10 ROWS =====\n")
print(head(cbr_raw, 10))

cat("\n===== NUMBER OF ROWS AND COLUMNS =====\n")
print(dim(cbr_raw))

# ------------------------------------------------------------
# 4. Check column names
# ------------------------------------------------------------

cat("\n===== COLUMN NAMES =====\n")
print(names(cbr_raw))

# ------------------------------------------------------------
# 5. Check missing values
# ------------------------------------------------------------

cat("\n===== MISSING VALUES =====\n")

missing_values <- colSums(
  is.na(cbr_raw)
)

print(missing_values)

# ------------------------------------------------------------
# 6. Check duplicate rows
# ------------------------------------------------------------

cat("\n===== DUPLICATE ROWS =====\n")

duplicate_rows <- duplicated(cbr_raw)

cat(
  "Number of duplicate rows:",
  sum(duplicate_rows),
  "\n"
)

# Remove exact duplicate rows
cbr_clean <- cbr_raw[
  !duplicate_rows,
]

# ------------------------------------------------------------
# 7. Convert important columns to numeric
# ------------------------------------------------------------

cbr_clean$Station_km <- as.numeric(
  cbr_clean$Station_km
)

cbr_clean$CBR_percent <- as.numeric(
  cbr_clean$CBR_percent
)

cbr_clean$Compaction_percent <- as.numeric(
  cbr_clean$Compaction_percent
)

# ------------------------------------------------------------
# 8. Check invalid CBR values
# ------------------------------------------------------------

cat("\n===== CBR RANGE CHECK =====\n")

cat(
  "Minimum CBR:",
  min(cbr_clean$CBR_percent, na.rm = TRUE),
  "\n"
)

cat(
  "Maximum CBR:",
  max(cbr_clean$CBR_percent, na.rm = TRUE),
  "\n"
)

# Identify missing or non-positive CBR
invalid_cbr <- is.na(cbr_clean$CBR_percent) |
  cbr_clean$CBR_percent <= 0

cat(
  "Invalid CBR observations:",
  sum(invalid_cbr),
  "\n"
)

# Remove invalid CBR observations
cbr_clean <- cbr_clean[
  !invalid_cbr,
]

# ------------------------------------------------------------
# 9. Check compaction condition
# ------------------------------------------------------------

cat("\n===== COMPACTION CHECK =====\n")

cat(
  "Minimum compaction:",
  min(cbr_clean$Compaction_percent, na.rm = TRUE),
  "%\n"
)

# Identify observations below 97%
low_compaction <- cbr_clean$Compaction_percent < 97

cat(
  "Observations below 97%:",
  sum(low_compaction),
  "\n"
)

# Remove observations below the selected 97% condition
cbr_clean <- cbr_clean[
  !low_compaction,
]

# ------------------------------------------------------------
# 10. Check CBR test condition
# ------------------------------------------------------------

cat("\n===== TEST CONDITION CHECK =====\n")

print(
  table(cbr_clean$Test_Condition)
)

# Keep only the 4-day soaked condition
cbr_clean <- cbr_clean[
  cbr_clean$Test_Condition == "4-day soaked",
]

# ------------------------------------------------------------
# 11. Check station locations
# ------------------------------------------------------------

cat("\n===== STATION CHECK =====\n")

cat(
  "Minimum station:",
  min(cbr_clean$Station_km, na.rm = TRUE),
  "km\n"
)

cat(
  "Maximum station:",
  max(cbr_clean$Station_km, na.rm = TRUE),
  "km\n"
)

# ------------------------------------------------------------
# 12. Final missing-value check
# ------------------------------------------------------------

cat("\n===== FINAL MISSING VALUE CHECK =====\n")

print(
  colSums(is.na(cbr_clean))
)

# ------------------------------------------------------------
# 13. Final dataset summary
# ------------------------------------------------------------

cat("\n===== CLEAN CBR SUMMARY =====\n")

print(
  summary(cbr_clean)
)

cat("\nNumber of observations after cleaning:",
    nrow(cbr_clean),
    "\n")

# ------------------------------------------------------------
# 14. Save cleaned dataset
# ------------------------------------------------------------

write.csv(
  cbr_clean,
  output_file,
  row.names = FALSE
)

# ------------------------------------------------------------
# 15. Confirm saved location
# ------------------------------------------------------------

cat("\n========================================\n")
cat("CBR CLEANING COMPLETED\n")
cat("Cleaned file saved at:\n")
cat(output_file)
cat("\n========================================\n")