---
title: "Simulation of Datasets"
author: "Reinhard Simon"
date: "7/21/2020"
output:
  word_document: default
  html_document: default
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Objective

Simulate datasets to serve as minimal working examples for the CoSSA 
pipeline - not to model inheritance, a breeding program, or a 
gene.

The focus is on the CoSSA pipeline, and for this, the datasets need only to contain
distinct frequencies of k-mers - the underlying mechanism is of secondary interest. 
Next, it should be possible to map the final list
of k-mers on a real genome. Third, the scripts should run fast for a course and
have small datasets.

## Implementation

The implementing simulation scripts have two phases: 

- the creation of biological variability (manually or in R script)
- the creation of sequencing reads with error rate (Julia scripts)

In the first phase, the simulations use a real gene locus from the potato genome
(so results of the CoSSA pipeline can be mapped), and introduce arbitrary variations based on SNPs. 
There are two datasets of increasing
complexity. Both use the sen3 locus from the potato reference genome as a 
starting point.


```{r eval=FALSE}

library(BSgenome.Stuberosum.PGSC.DM3404)

dm <- BSgenome.Stuberosum.PGSC.DM3404::BSgenome.Stuberosum.PGSC.DM3404

ch11 <- dm$chr11

sen3 <- ch11[1259552:1772869]

```

### Phase 1: Creation of biological variability

#### Dataset 1

This dataset illustrates a simple set operation. It consists of the
reference sen3 locus for one genotype, and of one arbitrary SNP manually 
introduced in the second sequence for another genotype. 
The read simulation produces paired-end read files with a length of 150 and an error
rate of 0.01.

The resulting files are in the sub-directories:

- CoSSA_toy1
- CoSSA_toy2

This dataset facilitates subtracting toy2 from toy1 and creating a list of 
corresponding k-mers mappable on chromosome 11.

#### Dataset 2

The second dataset allows the application of a more typical set operations
scenario in a Bulked Segregant Analysis. 
It consists of the files in the subdirectories: R_bulk, S_bulk, R_parent, and S_parent.

In brief, the main ideas in the simulation script are to:

a) add a bit more variability for the sequence background
b) again use a distinct locus for the R parent and bulk
c) use a mixture of R and S sequences in the S bulk
d) use only R derived sequences in the R bulk

In more detail:

First, the script identifies a subsequence with no missing bases (N). Then it
sets the R region and the SNP.

```{r r_def, eval=FALSE}
sen3 <- sen3[2700:31800] # N-free subsequence

r_range <- range(2501, 3500)
r_locus <- sen3[r_range[1]:r_range[2]]
r_locus[500] <- "T" # instead of G
```

SNPs are assumed to occur with a frequency of 0.04. However, this would lead 
further in the script to a long running-time. So, this fragment arbitrarily 
defines a set of 100 SNP locations.

```{r eval=FALSE}
snp_frq <- 0.04 
n <- length(sen3)
snploci <- sample(1:n, n * snp_frq )

m <- 100 # subset of haplotypes
haplo <- sample(snploci, m)

```

In the next steps, all the sequences are ‘mutated’ at the ‘haplo’ locations. 
In the case of R sequences, the presence of the R locus is assured by merely 
re-inserting the original ‘r_locus’ (see r_def script) sequence. Lastly, the script 
writes the result as a fasta file as the starting point for the second phase.

The creation of the S parent is similar: it omits the steps to assure
the presence of the R locus. 

For the bulks, the script repeats the creation of a mutated sequence several times:
the S-bulk consists of ten mutated sequences plus five with assured R presence,
the R-bulk consists of five mutated sequences with assured R locus presence.


### Phase 2: Creation of Paired-end Read Files

This phase is for both datasets largely the same. The script uses the Julia library
Pseudoseq for the main work. 
The coverage (cov) and the 'initial number of genome copies' (ng) parameters were 
tuned to achieve 
a similar small file size. 

The read length parameter is 150bp, with an error rate of 0.001.
The other parameters follow the Pseudoseq tutorial.
