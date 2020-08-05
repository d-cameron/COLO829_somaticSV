#! /bin/sh

SAMBAMBA=/hpc/local/CentOS7/cog_bioinf/sambamba_v0.6.5/sambamba
BEDTOOLS=/hpc/local/CentOS7/cog_bioinf/bedtools-2.25.0/bin/bedtools
#1,000,000 random positions
BED=human_hg19.bed




for TECH in illumina nanopore pacbio tenx
do
        for TYPE in tumor normal
                BAM=${TECH}.${TYPE}.bam
                $SAMBAMBA depth base -t 4 --min-coverage=0 -L $BED ${BAM} > ${BAM}.depth
        done
done

#Convert bionano xmaps to BED and calculate depth with bedtools coverage
cut -f 3,6,7 bionano.tumor.xmap | grep ^[0-9] | sed s/\\.[0-9]//g | sed 's/^23/X/g' | sed 's/^24/Y/g' > bionano.tumor.bed
$BEDTOOLS coverage -a $BED -b bionano.tumor.bed > bionano.tumor.depth
cut -f 3,6,7 bionano.normal.xmap | grep ^[0-9] | sed s/\\.[0-9]//g | sed 's/^23/X/g' | sed 's/^24/Y/g' > bionano.normal.bed
$BEDTOOLS coverage -a $BED -b bionano.normal.bed > bionano.normal.depth


Rscript depth_plot.R