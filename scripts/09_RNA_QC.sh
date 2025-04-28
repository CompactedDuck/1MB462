#!/bin/bash -l

#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J 09_RNA_QC
#SBATCH --mail-type=ALL
#SBATCH --mail-user=matthew.redmayne.0786@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules and set paths
module load bioinfo-tools FastQC/0.11.9 

# Set input and output paths
export INDIR="$HOME/1MB462/data/raw_data/1_Zhang_2017/transcriptomics_data"
export OUTDIR="$HOME/1MB462/analysis/07_RNA/01_QC"

# Run FastQC on BH reads
cd "$INDIR/RNA-Seq_BH"

fastqc -o "$OUTDIR/BH" trim_paired*.fastq.gz

# Run FastQC on Serum reads
cd "$INDIR/RNA-Seq_Serum"

fastqc -o "$OUTDIR/Serum" trim_paired*.fastq.gz
