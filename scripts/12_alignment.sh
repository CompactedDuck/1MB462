#!/bin/bash -l

#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 12:00:00
#SBATCH -J 12_alignment
#SBATCH --mail-type=ALL
#SBATCH --mail-user=matthew.redmayne.0786@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules and set paths
module load bioinfo-tools bwa/0.7.18 samtools/1.20

# Set input and output paths
export REFPATH="$HOME/1MB462/analysis/02_Assembly/PacBio/e_faecium.contigs.fasta"
export REF="e_faecium.contigs.fasta"
export INDIR="$HOME/1MB462/data/trimmed_data/RNA_seq"
export OUTDIR="$HOME/1MB462/analysis/08_Alignment/"
export WDIR="$SNIC_TMP/proj"

mkdir -p $WDIR
cd $WDIR
cp $REFPATH .
cp $INDIR/BH/* .
cp $INDIR/Serum/* .

#create index file
bwa index $REF

#align BH reads
bwa mem -t 8 $REF ERR1797972_pass_1_trimmed.fastq.gz ERR1797972_pass_2_trimmed.fastq.gz > aln-BH1.sam
bwa mem -t 8 $REF ERR1797973_pass_1_trimmed.fastq.gz ERR1797973_pass_2_trimmed.fastq.gz > aln-BH2.sam
bwa mem -t 8 $REF ERR1797974_pass_1_trimmed.fastq.gz ERR1797974_pass_2_trimmed.fastq.gz > aln-BH3.sam

#align Serum reads
bwa mem -t 8 $REF ERR1797969_pass_1_trimmed.fastq.gz ERR1797969_pass_2_trimmed.fastq.gz > aln-Serum1.sam
bwa mem -t 8 $REF ERR1797970_pass_1_trimmed.fastq.gz ERR1797970_pass_2_trimmed.fastq.gz > aln-Serum2.sam
bwa mem -t 8 $REF ERR1797971_pass_1_trimmed.fastq.gz ERR1797971_pass_2_trimmed.fastq.gz > aln-Serum3.sam

#convert files to .bam and index
for file in *.sam
do
    base=${file%.sam}
    samtools view -@ 4 -bS $file | samtools sort -@ 4 -m 2G -o ${base}_sorted.bam
    samtools index ${base}_sorted.bam
    rm $file
done

#copy files to the output directory
cp *.bam *.bai $OUTDIR
