# Datasets

Eight real-world complex networks are used in the experiments, four
small-scale (≤ 1000 edges) and four large-scale. Every file in this
folder is a published, freely available benchmark. Original sources
and required citations are listed below.

## File format

Each `.txt` file is a plain edge list. Each row is one undirected edge;
columns 1 and 2 are the IDs of the two endpoint nodes. Node IDs are
1-based integers. Two datasets ship as MATLAB `.mat` files:

| File | Variable inside | Format |
|---|---|---|
| `karate.mat` | `karate_edges` | edge list (N × 2) |
| `FootballMatrix.mat` | `FootballMatrix` | adjacency matrix |

## Topological summary

Reproduced from the manuscript (Tables 1 and 2):

### Small-scale networks (< 1000 edges)

| Dataset | N | M | ⟨K⟩ | ⟨d⟩ | ⟨c⟩ | ⟨ECC⟩ |
|---|---:|---:|---:|---:|---:|---:|
| Karate | 34 | 78 | 4.59 | 2.41 | 0.57 | 0.27 |
| Dolphins | 62 | 159 | 5.13 | 3.36 | 0.26 | 0.12 |
| Football | 115 | 613 | 10.66 | 2.51 | 0.41 | 0.17 |
| NetSci (NS) | 379 | 914 | 4.82 | 6.04 | 0.74 | 0.69 |

### Large-scale networks (≥ 1000 edges)

| Dataset | N | M | ⟨K⟩ | ⟨d⟩ | ⟨c⟩ | ⟨ECC⟩ |
|---|---:|---:|---:|---:|---:|---:|
| Jazz | 198 | 2742 | 27.70 | 2.24 | 0.62 | 0.36 |
| Celegans | 297 | 2148 | 14.47 | 2.46 | 0.29 | 0.08 |
| USAir | 332 | 2126 | 12.81 | 2.74 | 0.63 | 0.37 |
| PolBlogs | 1222 | 16714 | 27.36 | 2.74 | 0.32 | 0.10 |

(N = nodes, M = edges, ⟨K⟩ = mean degree, ⟨d⟩ = mean shortest path,
⟨c⟩ = mean node-clustering coefficient, ⟨ECC⟩ = mean edge clustering.)

---

## Per-dataset attribution

Please retain the corresponding citation when you use a dataset in
downstream work.

### Karate club — `karate.mat`, `karate.txt`
Social network of friendships between 34 members of a US university
karate club in the 1970s.
> W. W. Zachary, *An information flow model for conflict and fission in
> small groups*, Journal of Anthropological Research **33** (1977),
> 452–473.

### Dolphins — `dolphins.txt`
Undirected social network of frequent associations between 62
bottlenose dolphins living off Doubtful Sound, New Zealand. With
thanks to David Lusseau for permission to redistribute.
> D. Lusseau, K. Schneider, O. J. Boisseau, P. Haase, E. Slooten,
> S. M. Dawson, *The bottlenose dolphin community of Doubtful Sound
> features a large proportion of long-lasting associations*,
> Behavioral Ecology and Sociobiology **54** (2003), 396–405.

### American college football — `FootballMatrix.mat`
Games between Division IA US college football teams during the
regular season of fall 2000.
> M. Girvan, M. E. J. Newman, *Community structure in social and
> biological networks*, Proc. Natl. Acad. Sci. USA **99** (2002),
> 7821–7826.

### Network science co-authorship (NetSci) — `NS.txt`
Co-authorship network of scientists working on network theory and
experiment, compiled by Newman in May 2006 (largest connected
component).
> M. E. J. Newman, *Finding community structure in networks using
> the eigenvectors of matrices*, Phys. Rev. E **74** (2006), 036104.

### Jazz musicians — `jazz.txt`
Collaboration network between jazz musicians (an edge means two
musicians have performed together in the same band).
> P. Gleiser, L. Danon, *Community structure in jazz*, Advances in
> Complex Systems **6** (2003), 565.

### C. elegans metabolic network — `celegans.txt`
Metabolic network of *Caenorhabditis elegans*; nodes are substrates,
edges are metabolic reactions.
> J. Duch, A. Arenas, *Community identification using Extremal
> Optimization*, Phys. Rev. E **72** (2005), 027104.

### US Air 1997 — `USAir.txt`
Network of flights between US airports. Mirror copy of the Pajek
data set at <http://vlado.fmf.uni-lj.si/pub/networks/data/mix/USAir97.net>.

### Political blogs (PolBlogs) — `polblogs.txt`
Hyperlinks between US political weblogs collected during the 2004 US
election cycle. With thanks to Lada Adamic for permission to
redistribute.
> L. A. Adamic, N. Glance, *The political blogosphere and the 2004
> US Election: divided they blog*, in Proceedings of the 3rd
> International Workshop on Link Discovery (LinkKDD '05), 2005,
> pp. 36–43.

---

## Where to find more network datasets

The following repositories were consulted when assembling this benchmark:

- SNAP — <https://snap.stanford.edu/data/>
- Newman's collection — <http://www-personal.umich.edu/~mejn/netdata/>
- KONECT — <http://konect.cc/networks/>
- Network Repository — <https://networkrepository.com/>
