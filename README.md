# ACO-LP: Supervised Link Prediction via Ant-Colony Pheromone Features

[![Made with MATLAB](https://img.shields.io/badge/Made%20with-MATLAB-orange.svg)](https://www.mathworks.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

MATLAB implementation of a supervised missing-link prediction pipeline that
uses an Ant-Colony-Optimization-derived **pheromone (PH) feature**, combined
with the classical **Common Neighbor (CN)** and **Node-Link Clustering (NLC)**
features, on eight real-world complex networks.

This is the companion code for the manuscript
*A Supervised Link Prediction Method Relied Upon Ant-Colony Optimization Algorithm*
by **Soheila Ansari** and **Mohammad Reza Keyvanpour**
(Department of Computer Engineering, Alzahra University). The manuscript
draft lives in [`paper/`](paper/).

---

## What is in this repository

```
acolp-link-prediction/
├── README.md                     ← you are here
├── CITATION.cff                  ← machine-readable citation
├── LICENSE                       ← MIT (code)
├── .gitignore
├── paper/                        ← manuscript + thesis PDF
├── data/                         ← 8 benchmark networks (see data/README.md)
├── Supervised/                   ← supervised pipeline (28 files)
│   └── Main.m                    ←   ⭐ entry point
└── Unsupervised/                 ← unsupervised baselines (12 files)
    ├── Unsupervised_CN_V1.m      ←   ⭐ CN baseline
    └── Unsupervised_NLC_V0.m     ←   ⭐ NLC baseline
```

The two implementation folders are kept self-contained on purpose: a few
filenames are shared between them (`adj_gen.m`, `CN.m`, `NLC.m`,
`sort_column1.m`, …) but the supervised and unsupervised versions are
**not** identical — for example, `sort_column1.m` sorts ascending for
triangle search in the supervised code and descending for top-L ranking
in the unsupervised code. Keep them separate when you run experiments.

See [`Supervised/README.md`](Supervised/README.md) and
[`Unsupervised/README.md`](Unsupervised/README.md) for run instructions.

---

## Method in one paragraph

For each candidate node pair, we compute three structural features:
**CN** (number of common neighbours), **NLC** (node-link clustering
coefficient, Wu et al. 2016), and **PH** (a pheromone score derived from
an Ant-Colony triangle search; see §3.3 of the paper). Class imbalance is
handled with **ADASYN** oversampling, the candidate pool is restricted to
node pairs at graph distance ≤ 2, and a linear-kernel **SVM** is trained
on a 10-fold cross-validation split. Performance is reported in terms of
**Recall, F1-measure, and AUP** (area under the precision-recall curve).

The PH feature is the main contribution. Its design is inspired by the
unsupervised ACO link prediction of Sherkat et al. (2015), but here the
pheromone values are not used to score links directly — they are used as
a **feature** that a downstream classifier can combine with other
indices. The combined feature vector `SVM(NLC, CN, PH)` gives the best
result on the largest benchmark (PolBlogs, AUP ≈ 0.90).

---

## Quick start

You will need MATLAB R2018b or newer with the **Statistics and Machine
Learning Toolbox** (for `fitcsvm`, `perfcurve`, `crossvalind`) and the
graph functions (`graph`, `adjacency`, `degree`).

```matlab
% From the repo root, add the code and data to the path
addpath(genpath('Supervised'));
addpath(genpath('Unsupervised'));
addpath('data');

% Run the supervised pipeline (default dataset is 'polblogs')
cd Supervised
Main
```

To switch datasets, edit the `dataset` variable near the top of
`Main.m`. Supported values:

```
'Karate', 'Dolphins', 'Football', 'NS',       % small-scale
'Jazz',   'celegans', 'USAir',    'polblogs'  % large-scale
```

To turn features on/off, edit the three flags in `Main.m`:

```matlab
NLC_feat = 1;   CN_feat = 0;   ACO_feat = 1;
```

---

## Datasets

Eight publicly available real-world networks are bundled in `data/`.
Full attribution, edge counts, and reference papers are listed in
[`data/README.md`](data/README.md). Source: SNAP, Newman's network data
collection, KONECT, and the network repository.

---

## How to cite

If you use this code or the PH feature in your own work, please cite
the manuscript:

```bibtex
@unpublished{ansari2021acolp,
  author = {Ansari, Soheila and Keyvanpour, Mohammad Reza},
  title  = {A Supervised Link Prediction Method Relied Upon
            Ant-Colony Optimization Algorithm},
  note   = {Manuscript, Department of Computer Engineering,
            Alzahra University, Tehran, Iran},
  year   = {2021}
}

@misc{ansari2021acolp_code,
  author       = {Ansari, Soheila and Keyvanpour, Mohammad Reza},
  title        = {{ACO-LP}: Supervised Link Prediction via
                  Ant-Colony Pheromone Features (MATLAB)},
  year         = {2021},
  howpublished = {\url{https://github.com/<your-username>/acolp-link-prediction}}
}
```

A `CITATION.cff` file is provided at the repo root so GitHub will show a
**"Cite this repository"** button automatically.

> If/when the manuscript is published, please update the `@unpublished`
> entry above (and `CITATION.cff`) with the venue, volume, and DOI.

---

## Acknowledgments

This work builds on two prior ideas that should be cited alongside
the code:

* **Sherkat, E., Rahgozar, M., Asadpour, M.** (2015).
  *Structural link prediction based on ant colony approach in social
  networks.* Physica A 419, 80–94. — origin of the (a)/(b) triangle
  sub-graph idea that the PH feature builds on.
* **Wu, Z., Lin, Y., Wan, H., Jamil, W.** (2016).
  *Predicting top-L missing links with node and link clustering
  information in large-scale networks.* J. Stat. Mech. 083202. —
  origin of the NLC feature.

The ADASYN oversampling implementation in `Supervised/ADASYN.m`
follows He, Bai, Garcia & Li (2008).

Soheila thanks her thesis supervisor Dr. Mohammad Reza Keyvanpour for
his patient and generous guidance throughout this project.

---

## License

The **code** in this repository is released under the **MIT License**
(see [`LICENSE`](LICENSE)). The **manuscript PDF** in `paper/` is the
intellectual property of the authors and is included here for reference;
please do not redistribute it as your own work.

The **datasets** in `data/` retain the licenses of their original
sources — see `data/README.md` for per-dataset attribution.

---

<div dir="rtl" lang="fa">

## درباره این مخزن (فارسی)

این مخزن، پیاده‌سازی MATLAB یک روش پیش‌بینی پیوند مبتنی بر یادگیری
نظارت‌شده است که در آن یک ویژگی جدید مبتنی بر فرومون الگوریتم
کلونی مورچگان (PH) در کنار ویژگی‌های کلاسیک Common Neighbor و
Node-Link Clustering ترکیب می‌شود. کد بر روی هشت شبکهٔ واقعی
(کوچک و بزرگ) ارزیابی شده است.

پوشهٔ `Supervised/` شامل ۲۸ فایل پیاده‌سازی روش پیشنهادی است،
و پوشهٔ `Unsupervised/` شامل ۱۲ فایل برای پیاده‌سازی روش‌های پایه
(CN و NLC بدون ناظر) است. این دو پوشه به‌صورت مستقل نگه‌داری شده‌اند
چون چند فایل هم‌نام در آن‌ها رفتار متفاوتی دارند (به‌ویژه
`sort_column1.m`).

برای راهنمای استفاده، فایل‌های `README.md` در هر پوشه را ببینید.

</div>
