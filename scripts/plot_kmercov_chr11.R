#!/usr/bin/env Rscript
library(ggplot2)
library(scales)

#chrs = c("ST4.03ch00","ST4.03ch01","ST4.03ch02","ST4.03ch03","ST4.03ch04","ST4.03ch05","ST4.03ch06","ST4.03ch07","ST4.03ch08","ST4.03ch09","ST4.03ch10","ST4.03ch11","ST4.03ch12")
chrs = c("chr11")

args = commandArgs(trailingOnly=TRUE)
x = read.table(args[1], header=T)
x = x[x$chr %in% chrs,]
x$chr = factor(x$chr, levels=chrs)

# Iterate samples
for (i in 5:ncol(x)) {
    sample = colnames(x)[i]
    print(sample)
    df = data.frame(chr=x$chr, start=x$start + (x$end - x$start) / 2, rd=(x[,i]))
    p1 = ggplot(data=df, aes(x=start, y=rd))
    p1 = p1 + geom_point(pch=21, size=0.5)
    p1 = p1 + xlab("Chromosome")
    p1 = p1 + ylab("kmer depth per 10kb bins")
    p1 = p1 + scale_x_continuous(labels=comma)
    p1 = p1 + facet_grid(. ~ chr, scales="free_x", space="free_x")
    p1 = p1 + theme(axis.text.x = element_text(angle=45, hjust=1))
    ggsave(paste0(sample, ".wholegenome.pdf"), width=24, height=6)
    print(warnings())
}
