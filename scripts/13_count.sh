#!/bin/bash -l

#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 6:00:00
#SBATCH -J 13_count
#SBATCH --mail-type=ALL
#SBATCH --mail-user=matthew.redmayne.0786@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules and set paths
module load bioinfo-tools htseq/2.0.2

export REF="$HOME/1MB462/analysis/05_Annotation/e_faecium_no_fasta.gff"
export INDIR="$HOME/1MB462/analysis/08_Alignment/"
export OUTDIR="$HOME/1MB462/analysis/09_Counts"

mkdir -p $OUTDIR
cd $INDIR

#Run HTSeq counts for all alignemnts
htseq-count -f bam -r pos -s yes -t CDS -i ID aln-BH1_sorted.bam $REF  > $OUTDIR/BH1_count.txt
htseq-count -f bam -r pos -s yes -t CDS -i ID aln-BH2_sorted.bam $REF  > $OUTDIR/BH2_count.txt
htseq-count -f bam -r pos -s yes -t CDS -i ID aln-BH3_sorted.bam $REF  > $OUTDIR/BH3_count.txt
htseq-count -f bam -r pos -s yes -t CDS -i ID aln-Serum1_sorted.bam $REF  > $OUTDIR/Serum1_count.txt
htseq-count -f bam -r pos -s yes -t CDS -i ID aln-Serum2_sorted.bam $REF  > $OUTDIR/Serum2_count.txt
htseq-count -f bam -r pos -s yes -t CDS -i ID aln-Serum3_sorted.bam $REF  > $OUTDIR/Serum3_count.txt
