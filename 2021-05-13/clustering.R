################################################################################
# Install required packages
################################################################################
if (!requireNamespace("reticulate", quietly = TRUE)) {
  install.packages("reticulate", repos = "https://cloud.r-project.org/")
}
py_DAJIN <- reticulate::conda_list()$python
py_DAJIN <- grep("DAJIN/bin/python", py_DAJIN, value = TRUE)
Sys.setenv(RETICULATE_PYTHON = py_DAJIN)
reticulate::use_condaenv("DAJIN")

joblib <- reticulate::import("joblib")
h <- reticulate::import("hdbscan")

################################################################################
# Input
################################################################################

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) {
  df_score <- read.csv(args[1], header = FALSE, stringsAsFactors = FALSE)
  threads <- as.integer(args[2])
} else {
  df_score <- read.csv(".DAJIN_temp/clustering/tmp_midsfreq.csv", header = FALSE, stringsAsFactors = FALSE)
  threads <- as.integer(parallel::detectCores() - 1)
}
df_score <- as.matrix(df_score)

################################################################################
# PCA as a preprocessing step
################################################################################

pca <- prcomp(df_score, scale = FALSE)

pc_num <- 1:5
pc_score <- as.data.frame(pca$x[, pc_num])
prop_var <- pca$sdev[pc_num]^2 / sum(pca$sdev[pc_num]^2)
pc_score <- sweep(pc_score, 2, prop_var, FUN = "*")

################################################################################
# Clustering
################################################################################

hdb_cl_num <- function(.x) {
  cl <- h$HDBSCAN(
    min_samples = 1L,
    min_cluster_size = as.integer(.x),
    core_dist_n_jobs = threads,
    memory = joblib$Memory(cachedir = ".DAJIN_temp/clustering", verbose = 0)
  )
  length(unique(cl$fit_predict(pc_score)))
}

hdb_predict <- function(data, cl_size) {
  cl <- h$HDBSCAN(
    min_samples = 1L,
    min_cluster_size = as.integer(cl_size),
    core_dist_n_jobs = threads,
    memory = joblib$Memory(cachedir = ".DAJIN_temp/clustering", verbose = 0)
  )
  cl$fit_predict(data) + 1
}

cl_seq <-
  as.integer(seq(nrow(pc_score) * 0.1, nrow(pc_score) * 0.4, length.out = 20)) + 2

hdb <- lapply(cl_seq, hdb_cl_num)
hdb <- unlist(setNames(hdb, cl_seq))
hdb <- hdb[hdb != 1]

if (length(hdb) > 0) {
  cl_mode <- names(which.max(table(hdb)))
  cl_size <- as.integer(max(names(hdb[hdb == cl_mode])))
} else {
  cl_size <- max(cl_seq)
}

cl_hdb <- hdb_predict(pc_score, cl_size)

# ===========================================================
# Repeat clustering
# ===========================================================

for (.cl in unique(cl_hdb)) {
  if (sum(cl_hdb == .cl) <= 5) next
  .df_score <- df_score[cl_hdb == .cl, ]
  .pca <- prcomp(.df_score, scale = FALSE)
  .pc_score <- as.data.frame(.pca$x[, pc_num])
  .prop_var <- .pca$sdev[pc_num]^2 / sum(.pca$sdev[pc_num]^2)
  .pc_score <- sweep(.pc_score, 2, .prop_var, FUN = "*")
  .minPts <- as.integer(nrow(.pc_score) * 0.45) + 2L
  .cl_hdb <- hdb_predict(.pc_score, .minPts)
  cl_hdb[cl_hdb == .cl] <- .cl_hdb + (.cl * 100)
}
cl_hdb <- as.integer(as.factor(cl_hdb))

################################################################################
# Output
################################################################################

write(cl_hdb, stdout(), ncolumns = 1)