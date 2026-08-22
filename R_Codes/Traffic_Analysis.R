# ============================================================
# TRAFFIC ANALYSIS - DESIGN MSA
# IRC:37-2018
# ============================================================

# ------------------------------------------------------------
# 1. FILE LOCATIONS
# ------------------------------------------------------------

input_file <-
  "E:/Pavement_Reliability_Project/_Clean_Data/Traffic_clean.csv"

output_folder <-
  "E:/Pavement_Reliability_Project/_Traffic_Analysis"

if (!dir.exists(output_folder)) {
  dir.create(
    output_folder,
    recursive = TRUE
  )
}

output_file <- file.path(
  output_folder,
  "Traffic_Analysis_Results.csv"
)


# ------------------------------------------------------------
# 2. READ CLEANED TRAFFIC DATA
# ------------------------------------------------------------

traffic <- read.csv(
  input_file,
  stringsAsFactors = FALSE
)


# ------------------------------------------------------------
# 3. CHECK REQUIRED COLUMNS
# ------------------------------------------------------------

required_columns <- c(
  "Year",
  "CVPD",
  "Growth_Rate_percent",
  "VDF",
  "LDF",
  "Design_Period_Years"
)

missing_columns <- setdiff(
  required_columns,
  names(traffic)
)

if (length(missing_columns) > 0) {
  
  stop(
    paste(
      "Missing required columns:",
      paste(
        missing_columns,
        collapse = ", "
      )
    )
  )
}


# ------------------------------------------------------------
# 4. CONVERT REQUIRED COLUMNS TO NUMERIC
# ------------------------------------------------------------

traffic$Year <-
  as.numeric(traffic$Year)

traffic$CVPD <-
  as.numeric(traffic$CVPD)

traffic$Growth_Rate_percent <-
  as.numeric(
    traffic$Growth_Rate_percent
  )

traffic$VDF <-
  as.numeric(traffic$VDF)

traffic$LDF <-
  as.numeric(traffic$LDF)

traffic$Design_Period_Years <-
  as.numeric(
    traffic$Design_Period_Years
  )


# ------------------------------------------------------------
# 5. SELECT DESIGN-YEAR DATA
#
# The latest year in the cleaned dataset is used
# as the present/base traffic year.
# ------------------------------------------------------------

design_year <-
  max(
    traffic$Year,
    na.rm = TRUE
  )

design_row <-
  traffic[
    traffic$Year == design_year,
  ]


# Make sure exactly one row is selected

if (nrow(design_row) != 1) {
  
  stop(
    "Design year must contain exactly one observation."
  )
}


# ------------------------------------------------------------
# 6. EXTRACT DESIGN INPUTS
# ------------------------------------------------------------

A <-
  design_row$CVPD

D <-
  design_row$LDF

F <-
  design_row$VDF

r <-
  design_row$Growth_Rate_percent / 100

n <-
  design_row$Design_Period_Years


# ------------------------------------------------------------
# 7. CHECK INPUTS
# ------------------------------------------------------------

if (A <= 0) {
  stop("CVPD must be greater than zero.")
}

if (D <= 0 || D > 1) {
  stop("LDF must be between 0 and 1.")
}

if (F <= 0) {
  stop("VDF must be greater than zero.")
}

if (r <= 0) {
  stop("Growth rate must be greater than zero.")
}

if (n <= 0) {
  stop("Design period must be greater than zero.")
}


# ------------------------------------------------------------
# 8. CALCULATE DESIGN-DIRECTION CVPD
# ------------------------------------------------------------

Design_Direction_CVPD <-
  A * D


# ------------------------------------------------------------
# 9. CALCULATE CUMULATIVE STANDARD AXLES
#
# IRC:37-2018:
#
# N = 365 × A × D × F ×
#     [((1+r)^n - 1) / r]
#
# ------------------------------------------------------------

N <-
  365 *
  A *
  D *
  F *
  (
    ((1 + r)^n - 1) /
      r
  )


# ------------------------------------------------------------
# 10. CONVERT TO MSA
# ------------------------------------------------------------

Design_MSA <-
  N / 1e6


# ------------------------------------------------------------
# 11. DISPLAY RESULTS
# ------------------------------------------------------------

cat("\n========================================\n")
cat("TRAFFIC DESIGN CALCULATION\n")
cat("========================================\n")

cat(
  "Design year:",
  design_year,
  "\n"
)

cat(
  "Design CVPD (A):",
  round(A, 0),
  "\n"
)

cat(
  "LDF (D):",
  D,
  "\n"
)

cat(
  "VDF (F):",
  F,
  "\n"
)

cat(
  "Growth rate (r):",
  round(
    r * 100,
    2
  ),
  "%\n"
)

cat(
  "Design period (n):",
  n,
  "years\n"
)

cat(
  "Design-direction CVPD:",
  round(
    Design_Direction_CVPD,
    0
  ),
  "\n"
)

cat(
  "Cumulative standard axles:",
  format(
    round(N, 0),
    big.mark = ","
  ),
  "\n"
)

cat(
  "DESIGN TRAFFIC:",
  round(
    Design_MSA,
    2
  ),
  "MSA\n"
)

cat("========================================\n")


# ------------------------------------------------------------
# 12. CREATE RESULTS TABLE
# ------------------------------------------------------------

traffic_results <- data.frame(
  
  Design_Year =
    design_year,
  
  Design_CVPD =
    round(
      A,
      0
    ),
  
  LDF =
    D,
  
  VDF =
    F,
  
  Growth_Rate_percent =
    round(
      r * 100,
      2
    ),
  
  Design_Period_Years =
    n,
  
  Design_Direction_CVPD =
    round(
      Design_Direction_CVPD,
      0
    ),
  
  Cumulative_Standard_Axles =
    N,
  
  Design_MSA =
    round(
      Design_MSA,
      2
    )
)


# ------------------------------------------------------------
# 13. SAVE RESULTS
# ------------------------------------------------------------

write.csv(
  traffic_results,
  output_file,
  row.names = FALSE
)


# ------------------------------------------------------------
# 14. CONFIRM OUTPUT
# ------------------------------------------------------------

cat("\nTraffic analysis completed.\n")
cat("Results saved at:\n")
cat(output_file)
cat("\n")