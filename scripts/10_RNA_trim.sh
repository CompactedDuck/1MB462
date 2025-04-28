#!/bin/bash -l

#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 06:00:00
#SBATCH -J 10_RNA_trim
#SBATCH --mail-type=ALL
#SBATCH --mail-user=matthew.redmayne.0786@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules and set paths
module load bioinfo-tools trimmomatic/0.39
export ODIR1="$HOME/1MB462/data/trimmed_data/RNA_seq/BH"
export ODIR2="$HOME/1MB462/data/trimmed_data/RNA_seq/Serum"
export INDIR="$HOME/1MB462/data/raw_data/1_Zhang_2017/transcriptomics_data"


# Create output directory
mkdir -p "$ODIR1"
mkdir -p "$ODIR2"

# Run Trimmomatic for BH reads
cd "$INDIR/RNA-Seq_BH"

for f in trim_paired_*_pass_1.fastq.gz
do
    base=${f%%_pass_1.fastq.gz}  
    sample_name=${base#trim_paired_}  

    # Run Trimmomatic with cleaned sample names
    trimmomatic PE -phred64 -threads 2 \
        "$f" "trim_paired_${sample_name}_pass_2.fastq.gz" \
        "$ODIR1/${sample_name}_pass_1_trimmed.fastq.gz" "$ODIR1/${sample_name}_pass_1_unpaired.fastq.gz" \
        "$ODIR1/${sample_name}_pass_2_trimmed.fastq.gz" "$ODIR1/${sample_name}_pass_2_unpaired.fastq.gz" \
        ILLUMINACLIP:"$TRIMMOMATIC_HOME"/adapters/TruSeq3-PE.fa:2:30:10 \
        LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done

wait

# Run Trimmomatic for Serum reads
cd "$INDIR/RNA-Seq_Serum"

for f in trim_paired_*_pass_1.fastq.gz
do
    base=${f%%_pass_1.fastq.gz}  
    sample_name=${base#trim_paired_}  

    # Run Trimmomatic with cleaned sample names
    trimmomatic PE -phred64 -threads 2 \
        "$f" "trim_paired_${sample_name}_pass_2.fastq.gz" \
        "$ODIR2/${sample_name}_pass_1_trimmed.fastq.gz" "$ODIR2/${sample_name}_pass_1_unpaired.fastq.gz" \
        "$ODIR2/${sample_name}_pass_2_trimmed.fastq.gz" "$ODIR2/${sample_name}_pass_2_unpaired.fastq.gz" \
        ILLUMINACLIP:"$TRIMMOMATIC_HOME"/adapters/TruSeq3-PE.fa:2:30:10 \
        LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done
