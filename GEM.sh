#Script that makes scripts for each phenotype to run indiv by chromosome.

phenotypes=("eid", "w3FA_NMR", "w3FA_NMR_TFAP", "w6FA_NMR", "w6FA_NMR_TFAP", "w6_w3_ratio_NMR", "DHA_NMR", "DHA_NMR_TFAP", "LA_NMR", "LA_NMR_TFAP", "PUFA_NMR", "PUFA_NMR_TFAP", "MUFA_NMR", "MUFA_NMR_TFAP", "PUFA_MUFA_ratio_NMR")

genoindir=("/scratch/as58810/ProjectFall2022/geno")
outdir=("/scratch/as58810/ProjectFall2022/results")
pheno=("/scratch/as58810/ProjectFall2022/vegFinal.tsv")

for j in ${phenotypes[@]} 
    do

mkdir -p /work/kylab/aryaman/VegxPUFA/GEMScripts/$j


echo "#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=GEM-VegxPUFA-"$j"
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --time=144:00:00
#SBATCH --mem=30000
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --constraint=EDR
#SBATCH --mail-user=as58810@uga.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-22

i=\$SLURM_ARRAY_TASK_ID

cd /work/kylab/aryaman/VegxPUFA/GEMScripts/$j
ml GEM/1.4.3-intel-2020b


mkdir -p $outdir/$j

GEM \
--bgen $genoindir/chr\$i.bgen \
--sample $genoindir/chr\$i.sample \
--pheno-file $pheno \
--sampleid-name IID \
--pheno-name $j \
--covar-names age age2 PCA1 PCA2 PCA3 PCA4 PCA5 \
PCA6 PCA7 PCA8 PCA9 PCA10 \
townsend sex genoBatch \
alcoholFreq \
--robust 1 \
--exposure-names SSRV \
--threads 8 \
--output-style meta \
--out $outdir/$j/chr\$i

" > /work/kylab/aryaman/VegxPUFA/GEMScripts/$j/GEM5-$j.sh

#Uncomment to run all those scripts
#sbatch /work/kylab/mike/BioxVeg/GEM5/byPheno/$j/GEM5-$j.sh


done #end pheno loop
