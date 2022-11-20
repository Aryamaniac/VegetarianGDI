#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=GEM
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=144:00:00
#SBATCH --mem=30000
#SBATCH --output=GEM.%j.out
#SBATCH --error=GEM.%j.err
#SBATCH --mail-user=as58810@uga.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-22

i=$SLURM_ARRAY_TASK_ID

cd /scratch/as58810/ProjectFall2022

ml GEM/1.4.3-intel-2020b

genodir=("/scratch/as58810/ProjectFall2022/geno")
phenodir=("/scratch/as58810/ProjectFall2022/")
outdir=("/scratch/as58810/ProjectFall2022/results")
mkdir -p $outdir

phenotypes=("w3FA_NMR") #CHANGE

exposures=("CSRV" "SSRV")


for j in ${phenotypes[@]} 
        do

for e in ${exposures[@]} 
        do

mkdir -p $outdir/$j

echo running "$j" and "$e"

GEM \
--bgen $genodir/chr"$i".bgen \
--sample $genodir/chr"$i".sample \
--pheno-file $phenodir/filteredFinalVeg.csv \
--sampleid-name IID \
--pheno-name $j \
--covar-names sex age townsend \
PCA1 PCA2 PCA3 PCA4 PCA5 PCA6 PCA7 PCA8 PCA9 PCA10 \
--robust 1 \
--exposure-names "$e" \
--thread 16 \
--out $outdir/$j/"$j"x"$e"-chr"$i".txt

done
done
