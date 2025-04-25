#!/bin/bash -l

#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J 07_circlator
#SBATCH --mail-type=ALL
#SBATCH --mail-user=matthew.redmayne.0786@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules and set paths
module load bioinfo-tools 
module load bwa/0.7.18 samtools/1.3 prodigal/2.6.3 MUMmer/3.23 spades/4.0.0 circlator/1.5.5
export ASSM="$HOME/1MB462/analysis/02_Assembly/PacBio/e_faecium.contigs.fasta"
export READ="$HOME/1MB462/analysis/02_Assembly/PacBio/e_faecium.correctedReads.fasta.gz"
export OUTDIR="$HOME/1MB462/analysis/02_Assembly/Circ"

# Run Circlator on PacBio assembly
circlator all $ASSM $READ $OUTDIR
