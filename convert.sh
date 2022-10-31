#!/bin/bash
#SBATCH --job-name=convertpgen         # Job name
#SBATCH --partition=highmem_p             # Partition (queue) name
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --mem=400gb                     # Job memory request
#SBATCH --time=144:00:00               # Time limit hrs:min:sec
#SBATCH --output=convertpgen.%j.out    # Standard output log
#SBATCH --error=convertpgen.%j.err     # Standard error log
#SBATCH --mail-user=as58810@uga.edu
#SBATCH --mail-type=ALL

#Load PLINK
ml PLINK/2.00-alpha2.3-x86_64-20200914-dev

chr=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)

#Set genotype directory
genodir=("/scratch/as58810/bgen_v1.2_UKBsource")

#Set output directory
outdir=("/scratch/as58810/pgen")
mkdir -p $outdir

for i in ${chr[@]}
do

#RUN PLINK2
plink2 \
--bgen $genodir/ukb_imp_chr"$i"_v3.bgen ref-first \
--sample $genodir/ukb_imp_v3.sample \
--make-pgen \
--out $outdir/chr"$i"

done
