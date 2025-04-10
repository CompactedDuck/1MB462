#!/bin/bash -l

#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 30:00
#SBATCH -J 04_quast_eval
#SBATCH --mail-type=ALL
#SBATCH --mail-user=matthew.redmayne.0786@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules and set paths
module load bioinfo-tools quast/5.0.2
export A1="$HOME/1MB462/analysis/02_Assembly/PacBio/e_faecium.contigs.fasta"
export A2="$HOME/1MB462/analysis/02_Assembly/Illumina_ONT/contigs.fasta"
export REFR="$HOME/1MB462/data/reference/ncbi_dataset/data/GCF_900447735.1/GCF_900447735.1_43941_G01_genomic.fna"
export OUTDIR="$HOME/1MB462/analysis/03_Evaluation/QUAST"

# Run QUAST
quast.py $A1 \
    $A2 \
    -r $REFR \
    -o $OUTDIR
