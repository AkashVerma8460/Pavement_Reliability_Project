# ============================================================
# FINAL MONTE CARLO INPUT PARAMETERS
# Reliability-Based Flexible Pavement Design
# ============================================================
#
# BASELINE VALUES:
#   CBR              = 10.71 %
#   Traffic growth   = 5.00 %
#   Bituminous MR    = 3000 MPa
#   Granular MR      = 98.6 MPa
#
# DISTRIBUTIONS:
#   CBR              = Log-normal
#   Traffic growth   = Normal
#   Bituminous MR    = Log-normal
#   Granular MR      = Log-normal
#
# DATA INPUT:
#   CBR       -> CLEANED CBR DATA
#   Traffic   -> CLEANED TRAFFIC DATA
#
# ============================================================


# ------------------------------------------------------------
# 1. FILE LOCATIONS
# ------------------------------------------------------------

# CLEANED CBR DATA
cbr_file <-
  "E:/Pavement_Reliability_Project/_Clean_Data/CBR_clean.csv"


# CLEANED TRAFFIC DATA
traffic_file <-
  "E:/Pavement_Reliability_Project/_Clean_Data/Traffic_clean.csv"


# ------------------------------------------------------------
# 2. OUTPUT FOLDER
# ------------------------------------------------------------

output_folder <-
  "E:/Pavement_Reliability_Project/_R_Results"

if (!dir.exists(output_folder)) {
  
  dir.create(
    output_folder,
    recursive = TRUE
  )
}


output_file <-
  file.path(
    output_folder,
    "Monte_Carlo_Final_Input_Parameters.csv"
  )


# ============================================================
# PARAMETER 1
# CBR
# ============================================================


# ------------------------------------------------------------
# 3. READ CLEANED CBR DATA
# ------------------------------------------------------------

cbr_data <-
  read.csv(
    cbr_file,
    stringsAsFactors = FALSE
  )


# ------------------------------------------------------------
# 4. CHECK CBR COLUMN
# ------------------------------------------------------------

if (!"CBR_percent" %in% names(cbr_data)) {
  
  stop(
    "CBR_percent column not found in CBR_clean.csv"
  )
}


# Convert to numeric

cbr_data$CBR_percent <-
  as.numeric(
    cbr_data$CBR_percent
  )


# Remove missing values

CBR_values <-
  cbr_data$CBR_percent[
    !is.na(
      cbr_data$CBR_percent
    )
  ]


# ------------------------------------------------------------
# 5. CBR BASELINE
#
# YOUR CALCULATED DESIGN CBR
# ------------------------------------------------------------

CBR_baseline <-
  10.71


# ------------------------------------------------------------
# 6. CBR MEAN AND SD FROM CLEANED DATA
# ------------------------------------------------------------

CBR_data_mean <-
  mean(
    CBR_values
  )

CBR_data_SD <-
  sd(
    CBR_values
  )


# COV from your actual CBR dataset

CBR_COV <-
  CBR_data_SD /
  CBR_data_mean


# ------------------------------------------------------------
# 7. LOGNORMAL PARAMETERS FOR CBR
#
# R's rlnorm() requires:
#
# meanlog
# sdlog
#
# Convert arithmetic mean and SD to log-scale.
# ------------------------------------------------------------

CBR_meanlog <-
  log(
    CBR_baseline^2 /
      sqrt(
        CBR_baseline^2 +
          CBR_data_SD^2
      )
  )


CBR_sdlog <-
  sqrt(
    log(
      1 +
        (CBR_data_SD^2 /
           CBR_baseline^2)
    )
  )


# ============================================================
# PARAMETER 2
# TRAFFIC GROWTH RATE
# ============================================================


# ------------------------------------------------------------
# 8. READ CLEANED TRAFFIC DATA
# ------------------------------------------------------------

traffic_data <-
  read.csv(
    traffic_file,
    stringsAsFactors = FALSE
  )


# ------------------------------------------------------------
# 9. CHECK TRAFFIC GROWTH COLUMN
# ------------------------------------------------------------

if (
  !"Growth_Rate_percent" %in%
  names(traffic_data)
) {
  
  stop(
    "Growth_Rate_percent column not found in Traffic_clean.csv"
  )
}


# Convert to numeric

traffic_data$Growth_Rate_percent <-
  as.numeric(
    traffic_data$Growth_Rate_percent
  )


# Remove missing values

Growth_values <-
  traffic_data$Growth_Rate_percent[
    !is.na(
      traffic_data$Growth_Rate_percent
    )
  ]


# ------------------------------------------------------------
# 10. TRAFFIC GROWTH BASELINE
#
# YOUR SELECTED BASELINE
# ------------------------------------------------------------

Growth_baseline_percent <-
  5.0


# ------------------------------------------------------------
# 11. TRAFFIC GROWTH SD
#
# Calculated from your cleaned traffic data.
# ------------------------------------------------------------

Growth_data_mean <-
  mean(
    Growth_values
  )

Growth_SD_percent <-
  sd(
    Growth_values
  )


# Convert to decimal for simulation

Growth_baseline <-
  Growth_baseline_percent / 100

Growth_SD <-
  Growth_SD_percent / 100


# ============================================================
# PARAMETER 3
# BITUMINOUS RESILIENT MODULUS
# ============================================================


# ------------------------------------------------------------
# 12. BITUMINOUS BASELINE
#
# YOUR IRC-BASED VALUE
# ------------------------------------------------------------

Bituminous_MR_baseline <-
  3000


# ------------------------------------------------------------
# 13. BITUMINOUS DISTRIBUTION
#
# LOG-NORMAL
#
# Paper literature:
# COV range = 10% to 40%
#
# Selected midpoint:
# COV = 25%
# ------------------------------------------------------------

Bituminous_MR_distribution <-
  "Log-normal"

Bituminous_MR_COV <-
  0.25


# ------------------------------------------------------------
# 14. BITUMINOUS SD
# ------------------------------------------------------------

Bituminous_MR_SD <-
  Bituminous_MR_baseline *
  Bituminous_MR_COV


# ------------------------------------------------------------
# 15. CONVERT TO LOGNORMAL PARAMETERS
# ------------------------------------------------------------

Bituminous_MR_meanlog <-
  log(
    Bituminous_MR_baseline^2 /
      sqrt(
        Bituminous_MR_baseline^2 +
          Bituminous_MR_SD^2
      )
  )


Bituminous_MR_sdlog <-
  sqrt(
    log(
      1 +
        (Bituminous_MR_SD^2 /
           Bituminous_MR_baseline^2)
    )
  )


# ============================================================
# PARAMETER 4
# GRANULAR RESILIENT MODULUS
# ============================================================


# ------------------------------------------------------------
# 16. GRANULAR BASELINE
#
# YOUR IRC-BASED VALUE
# ------------------------------------------------------------

Granular_MR_baseline <-
  98.6


# ------------------------------------------------------------
# 17. GRANULAR DISTRIBUTION
#
# LOG-NORMAL
#
# Paper literature:
# COV range = 5% to 60%
#
# Selected midpoint:
# COV = 32.5%
# ------------------------------------------------------------

Granular_MR_distribution <-
  "Log-normal"

Granular_MR_COV <-
  0.325


# ------------------------------------------------------------
# 18. GRANULAR SD
# ------------------------------------------------------------

Granular_MR_SD <-
  Granular_MR_baseline *
  Granular_MR_COV


# ------------------------------------------------------------
# 19. CONVERT TO LOGNORMAL PARAMETERS
# ------------------------------------------------------------

Granular_MR_meanlog <-
  log(
    Granular_MR_baseline^2 /
      sqrt(
        Granular_MR_baseline^2 +
          Granular_MR_SD^2
      )
  )


Granular_MR_sdlog <-
  sqrt(
    log(
      1 +
        (Granular_MR_SD^2 /
           Granular_MR_baseline^2)
    )
  )


# ============================================================
# 20. CREATE FINAL PARAMETER TABLE
# ============================================================

Monte_Carlo_Parameters <-
  data.frame(
    
    Parameter = c(
      "CBR",
      "Traffic_Growth_Rate",
      "Bituminous_MR",
      "Granular_MR"
    ),
    
    Distribution = c(
      "Log-normal",
      "Normal",
      "Log-normal",
      "Log-normal"
    ),
    
    Baseline = c(
      CBR_baseline,
      Growth_baseline_percent,
      Bituminous_MR_baseline,
      Granular_MR_baseline
    ),
    
    SD = c(
      CBR_data_SD,
      Growth_SD_percent,
      Bituminous_MR_SD,
      Granular_MR_SD
    ),
    
    COV = c(
      CBR_COV,
      Growth_SD_percent /
        Growth_baseline_percent,
      Bituminous_MR_COV,
      Granular_MR_COV
    ),
    
    Unit = c(
      "%",
      "%",
      "MPa",
      "MPa"
    )
  )


# ============================================================
# 21. DISPLAY FINAL PARAMETERS
# ============================================================

cat("\n")
cat("====================================================\n")
cat("FINAL MONTE CARLO INPUT PARAMETERS\n")
cat("====================================================\n")

print(
  Monte_Carlo_Parameters
)


# ============================================================
# 22. DISPLAY LOGNORMAL PARAMETERS
# ============================================================

cat("\n")
cat("====================================================\n")
cat("LOGNORMAL PARAMETERS\n")
cat("====================================================\n")


cat("\nCBR:\n")

cat(
  "meanlog = ",
  round(CBR_meanlog, 6),
  "\n"
)

cat(
  "sdlog   = ",
  round(CBR_sdlog, 6),
  "\n"
)


cat("\nBituminous MR:\n")

cat(
  "meanlog = ",
  round(Bituminous_MR_meanlog, 6),
  "\n"
)

cat(
  "sdlog   = ",
  round(Bituminous_MR_sdlog, 6),
  "\n"
)


cat("\nGranular MR:\n")

cat(
  "meanlog = ",
  round(Granular_MR_meanlog, 6),
  "\n"
)

cat(
  "sdlog   = ",
  round(Granular_MR_sdlog, 6),
  "\n"
)


# ============================================================
# 23. SAVE FINAL PARAMETERS
# ============================================================

write.csv(
  Monte_Carlo_Parameters,
  output_file,
  row.names = FALSE
)


# ============================================================
# 24. CONFIRM OUTPUT
# ============================================================

cat("\n")
cat("====================================================\n")
cat("PARAMETER FILE SAVED SUCCESSFULLY\n")
cat("====================================================\n")

cat(
  "Location:\n",
  output_file,
  "\n"
)

cat("====================================================\n")