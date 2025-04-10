#!/bin/bash -l

#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 06:00:00
#SBATCH -J 03_spades_assembly
#SBATCH --mail-type=ALL
#SBATCH --mail-user=matthew.redmayne.0786@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules and set paths
module load bioinfo-tools spades/4.0.0
export ONT="$HOME/1MB462/data/raw_data/1_Zhang_2017/genomics_data/Nanopore/E745_all.fasta.gz"
export R1="$HOME/1MB462/data/trimmed_data/E745-1_R1_paired.fq.gz"
export R2="$HOME/1MB462/data/trimmed_data/E745-1_R2_paired.fq.gz"
export OUTDIR="$HOME/1MB462/analysis/02_Assembly/Illumina_ONT"

#Run SPAdes
spades.py \
    -1 "$R1" \
    -2 "$R2" \
    --nanopore "$ONT" \
    -o "$OUTDIR" \
    -k 55 \
    -t 2
