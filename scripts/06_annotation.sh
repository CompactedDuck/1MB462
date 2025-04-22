#!/bin/bash -l

#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J 06_annotation
#SBATCH --mail-type=ALL
#SBATCH --mail-user=matthew.redmayne.0786@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools prokka/1.45-5b58020

# Set paths
export IN="$HOME/1MB462/analysis/02_Assembly/PacBio/e_faecium.contigs.fasta"
export OUT="$HOME/1MB462/analysis/05_Annotation"

cd $OUT

# Run Prokka
prokka --outdir "$OUT" --force  --prefix e_faecium "$IN"
