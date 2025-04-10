#!/bin/bash -l

#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J 05_mummer
#SBATCH --mail-type=ALL
#SBATCH --mail-user=matthew.redmayne.0786@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules and set paths
module load bioinfo-tools MUMmer/4.0.0rc1

# Set input and output paths
export A1="$HOME/1MB462/analysis/02_Assembly/PacBio/e_faecium.contigs.fasta"
export A2="$HOME/1MB462/analysis/02_Assembly/Illumina_ONT/contigs.fasta"
export REFR="$HOME/1MB462/data/reference/ncbi_dataset/data/GCF_900447735.1/GCF_900447735.1_43941_G01_genomic.fna"
export OUTDIR="$HOME/1MB462/analysis/03_Evaluation/MUMmer"

cd "$OUTDIR"

# Run Nucmer for both assemblies
echo "Running nucmer for Illumina+ONT"
nucmer --prefix=out_Illumina "$REFR" "$A2"

echo "Running nucmer for PacBio"
nucmer --prefix=out_PacBio "$REFR" "$A1"

wait

# Filter the delta files
delta-filter -q out_Illumina.delta > out_Illumina.filtered.delta
delta-filter -q out_PacBio.delta > out_PacBio.filtered.delta

# Generate plots for both assemblies
mummerplot --prefix=plot_Illumina --png -R "$REFR" -Q "$A2" out_Illumina.filtered.delta
mummerplot --prefix=plot_PacBio --png -R "$REFR" -Q "$A1" out_PacBio.filtered.delta
