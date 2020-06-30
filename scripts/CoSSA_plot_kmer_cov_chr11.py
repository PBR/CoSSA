#!/usr/bin/python

import sys
import gzip
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
with gzip.open(file, "rb") as f:
	df = pd.read_table(file)

### add column names
df.columns=['chr','position','end_position','coverage']
print(df.head(20))
grouped = pd.pivot_table(df.reset_index(), index='position', columns='chr', values='coverage')
# get rid of the automatically created subplot titles
s=['']
grouped.plot(subplots=True, kind='bar', title=s, sharex=True, sharey=True ) 
plt.suptitle('Mean K-mer coverage per 100kb per chromosome ')
plt.subplots_adjust(left=0.05, right=0.95, bottom=0.05, top=0.95, hspace=0)
plt.ylim(0,1)
ax = plt.gca()
ax.axes.yaxis.set_ticks([])
plt.ylabel='mean coverage per bin(0-1)'
#plt.show()
plt.savefig(file + '.png')


