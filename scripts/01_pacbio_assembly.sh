#!/bin/bash -l

#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 08:00:00
#SBATCH -J 01_pacbio_assembly
#SBATCH --mail-type=ALL
#SBATCH --mail-user=matthew.redmayne.0786@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules and set paths
module load bioinfo-tools canu/2.2
export WDIR="$HOME/1MB462/1MB462/analysis/02_Assembly/PacBio"
export PBIO="$HOME/1MB462/data/raw_data/1_Zhang_2017/genomics_data/PacBio"

# Run Canu (from PacBio directory)
cd "$PBIO"

canu \
  -p e_faecium \
  -d "$WDIR" \
  genomeSize=2.58m \
  -pacbio *.fastq.gz \
  maxThreads=2 \
  maxMemory=16g \
  corThreads=2 \
  corMemory=12g \
  useGrid=false
