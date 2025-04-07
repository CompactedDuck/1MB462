#!/bin/bash -l

#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J 02_illumina_trim
#SBATCH --mail-type=ALL
#SBATCH --mail-user=matthew.redmayne.0786@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules and set paths
module load bioinfo-tools trimmomatic/0.39
export ODIR="$HOME/1MB462/data/trimmed_data"
export INDIR="$HOME/1MB462/data/raw_data/1_Zhang_2017/genomics_data/Illumina"

# Create output directory
mkdir -p "$ODIR"

# Run Trimmomatic
cd "$INDIR" || { echo "Failed to enter $INDIR"; exit 1; }

trimmomatic PE -phred64 -threads 2 \
  E745-1.L500_SZAXPI015146-56_1_clean.fq.gz E745-1.L500_SZAXPI015146-56_2_clean.fq.gz \
  "$ODIR"/E745-1_R1_paired.fq.gz "$ODIR"/E745-1_R1_unpaired.fq.gz \
  "$ODIR"/E745-1_R2_paired.fq.gz "$ODIR"/E745-1_R2_unpaired.fq.gz \
  ILLUMINACLIP:"$TRIMMOMATIC_HOME"/adapters/TruSeq3-PE.fa:2:30:10 \
  LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
