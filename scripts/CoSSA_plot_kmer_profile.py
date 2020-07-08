#!/usr/bin/python3

import sys
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

##############################################################
### script plots the kmer coverage over the chromosomes
### input file is obtained from mosdepth coverage calculations
##############################################################

### set path to the input data (.gz)
file = sys.argv[1]

### load the data (from mosdepth)
with open(file, "rb") as f:
        df = pd.read_table(file)

### add column names
df.columns=['depth','count']
max= df['count'].argmax()
print('max coverage:',max)
x_min = max * 0.5
x_max = max * 4
df.plot(x ='depth', y='count', kind = 'line', lw=3, legend=False)
plt.suptitle('K-mer profile')
plt.xlim(x_min,x_max)
plt.ylabel('k-mer frequency')
plt.xlabel('k-mer coverage')
plt.savefig(file + '.png')

