# Unsupervised baselines (12 files)

This folder contains the **unsupervised baselines** that the supervised
method is compared against, Common Neighbor (CN) and Node-Link
Clustering (NLC) ranked top-L missing-link prediction.

## Run

From the repository root:

```matlab
addpath(genpath('Unsupervised'));
addpath('data');
cd Unsupervised

Unsupervised_CN_V1     % CN baseline
% or
Unsupervised_NLC_V0    % NLC baseline (Wu et al. 2016)
```

Both scripts:

1. Build the adjacency matrix for the selected dataset.
2. Randomly hide 10 % of the existing edges as test edges.
3. Score every non-existing edge in the training graph using the chosen
   similarity index.
4. Take the top-L scored pairs as predicted links.
5. Report Accuracy, Sensitivity, Specificity, Precision, Recall,
   F-measure, G-mean **and AUC** (averaged over 10 independent runs).

The top-L cut-off and the dataset are configured at the top of each
script:

```matlab
L_top      = 100;
num_of_run = 10;
dataset    = 'Jazz';
```

## File map

| File | Role |
|---|---|
| **Unsupervised_CN_V1.m** | CN-based top-L link prediction |
| **Unsupervised_NLC_V0.m** | NLC-based top-L link prediction (Wu et al. 2016) |
| `adj_gen.m` | dataset loader (looks in `../data/`) |
| `CN.m` | Common Neighbor scoring |
| `NLC.m` | Node-Link Clustering scoring (Wu et al. 2016) |
| `ACO_Feature_Extract.m` | also present here so the folder can run a quick PH-based unsupervised score as an extra baseline; **differs slightly from the Supervised/ version** |
| `main_feature_extraction.m` | older, exploratory single-run driver |
| `Conv2EdgeList.m` | converts an N×N feature matrix to a per-edge list |
| `Evaluate.m` | confusion-matrix metrics (Accuracy / Sensitivity / Specificity / Precision / Recall / F-measure / G-mean) |
| `roc_curve.m` | ROC curve and AUROC |
| `sort_column1.m` | **descending** sort by column 1 (NB: in `Supervised/` the same-named file sorts **ascending** — do not mix folders on the MATLAB path) |

## Why are several filenames shared with `Supervised/`?

`adj_gen.m`, `CN.m`, `NLC.m`, `Conv2EdgeList.m`, `Evaluate.m`,
`roc_curve.m`, `sort_column1.m`, `ACO_Feature_Extract.m`, and
`main_feature_extraction.m` all appear in both folders. Most are
identical, but a few differ in non-trivial ways, most importantly
`sort_column1.m`, whose sort direction is flipped between the two
folders to suit each pipeline. Keep the two folders separate on the
MATLAB path; do not `addpath` both at the same time unless you know
which version will be shadowed.
