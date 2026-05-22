# Supervised pipeline (28 files)

This folder contains the supervised link-prediction implementation
described in §3 of the manuscript. The entry point is **`Main.m`**.

## Run

From the repository root:

```matlab
addpath(genpath('Supervised'));
addpath('data');           % so adj_gen.m can find the .txt / .mat files
cd Supervised
Main
```

`Main.m` will:

1. Build an adjacency matrix for the selected dataset (`adj_gen`).
2. Split edges into 10 folds (`randDivide`) and, for each fold, derive
   a feature subgraph, a train subgraph, and a test subgraph
   (the *G_feature ⊆ G_train ⊆ G_test* construction of §3.2).
3. Restrict candidate node pairs to those at hop distance ≤ 2
   (`CN > 0` filter, lines 78–81).
4. Compute the feature vector — any combination of **CN, NLC, PH** —
   on the train and test sets.
5. Apply **ADASYN** oversampling to balance positive/negative classes
   in the training data.
6. Fit a linear-kernel **SVM** (`fitcsvm`) and predict.
7. Report Accuracy, Precision, Recall, F1-measure, AUROC and AUPR,
   averaged over 10 folds.

## Configure

The top of `Main.m` exposes two configuration blocks:

```matlab
%% Dataset selection
dataset = 'polblogs';   % 'Karate' 'Dolphins' 'Football' 'NS'
                        % 'Jazz' 'celegans' 'USAir' 'polblogs'

%% Which feature to calculate?
NLC_feat = 1;
CN_feat  = 0;
ACO_feat = 1;           % the PH feature
```

The seven feature-vector configurations reported in Tables 3 and 4
of the paper correspond to different combinations of these flags.

## File map

| File | Role |
|---|---|
| **Main.m** | top-level driver (10-fold CV, dataset loop) |
| `main_feature_extraction.m` | older, single-fold driver kept for reference |
| `adj_gen.m` | loads a dataset from `../data/` and returns adjacency matrix |
| `randDivide.m` | partitions the edge list into *K* folds |
| `CN.m` | Common Neighbor feature |
| `NLC.m` | Node-Link Clustering feature (Wu et al. 2016) |
| `Clust_Coef.m` | classical clustering coefficient (used by `main_feature_extraction.m`) |
| **`ACO_Feature_Extract.m`** | extracts the **PH feature** via ACO triangle search |
| **`ACO_Feature_Extract1.m`** | duplicate of `ACO_Feature_Extract.m` (slight variant — kept for provenance, safe to delete in a future cleanup) |
| `Is_Rep_Triangle.m` | tests whether a triangle has already been recorded |
| `Tau_update_by_Subgr.m`, `Tau_update_by_Subgr1.m` | pheromone update for the (a) / (b) sub-graphs |
| `LP.m` | predicts one link for one triangle (used by the unsupervised ACO ancestor) |
| `conv_ACO_list.m`, `Conv2EdgeList.m` | convert pheromone/NLC matrices to per-edge feature vectors |
| `label.m` | assigns 0/1 ground-truth labels to candidate edges |
| `sort_column1.m`, `sort_column3.m`, `sort_row_column1.m` | row/column sort helpers |
| `addscore.m`, `FindEdge.m`, `FindRow.m` | edge-list bookkeeping helpers |
| `ADASYN.m` | adaptive synthetic over-sampling (He et al. 2008) |
| `C4_5.m` | C4.5 decision-tree classifier (alternative to SVM — not used in the reported results) |
| `myACC.m` | accuracy / precision / recall / F1 at a chosen threshold |
| `Evaluate.m` | accuracy / sensitivity / specificity / F-measure / G-mean at top-L |
| `pr_curve.m` | precision-recall curve + AUPR |
| `roc_curve.m` | ROC curve + AUROC |
| `scoreAUC.m` | helper that returns AUC only |
| `svm_test.m` | sanity-check script using Fisher's iris data |

## Known limitations (and small fixes worth making)

These are not blockers but they are worth knowing about before you
re-run experiments for a paper revision:

* **No fixed RNG seed.** `Main.m` uses `randperm` and `randDivide`
  without `rng(42)`. Every run gives different numbers.
  Add `rng(42)` (or whatever seed) at the top of `Main.m` for
  reproducible folds.
* **`Main.m` is a script, not a function.** Switching dataset or
  features requires editing the file. Wrapping it as
  `function out = Main(dataset, opts)` would be a small but useful
  refactor.
* **`ACO_Feature_Extract.m` and `ACO_Feature_Extract1.m`** differ by
  three lines and are functionally equivalent. One of them can be
  deleted once you've decided which is canonical.
* **`label.m` and `Conv2EdgeList.m`** print a character-by-character
  progress bar with `fprintf('\b', …)`; this is slow and noisy on
  PolBlogs. Replacing them with sparse-matrix indexing would speed
  things up considerably.
* **ADASYN is invoked in `Main.m` (line 196) but is not described in
  §3 of the manuscript.** If you keep the oversampling step, please
  add a paragraph to the methods section in the revision.
