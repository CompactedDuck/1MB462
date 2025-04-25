#!/bin/bash -l

#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J 08_synteny
#SBATCH --mail-type=ALL
#SBATCH --mail-user=matthew.redmayne.0786@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules and set paths
module load bioinfo-tools MUMmer/4.0.0rc1

# Set input and output paths
export PBIO="$HOME/1MB462/analysis/02_Assembly/PacBio/e_faecium.contigs.fasta"
export REF="$HOME/1MB462/data/e_faecalis/ncbi_dataset/data/GCF_000393015.1/GCF_000393015.1_Ente_faec_T5_V1_genomic.fna"
export OUTDIR="$HOME/1MB462/analysis/06_Synteny"

cd "$OUTDIR"

# Run Nucmer 
nucmer --prefix=out_synteny "$REF" "$PBIO"

wait

# Filter the delta files
delta-filter -q out_synteny.delta > out_synteny.filtered.delta

# Generate plots for both assemblies
mummerplot --prefix=plot_synteny --png -R "$REF" -Q "$PBIO" out_synteny.filtered.delta
