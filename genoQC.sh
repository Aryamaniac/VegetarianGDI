#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=genoQC2
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=144:00:00
#SBATCH --mem=350000
#SBATCH --output=genoQC1.%j.out
#SBATCH --error=genoQC1.%j.err
#SBATCH --mail-user=as58810@uga.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-22

i=$SLURM_ARRAY_TASK_ID
cd /scratch/as58810/ProjectFall2022

ml PLINK/2.00-alpha2.3-x86_64-20210920

###-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
###STEP 1. GENOTYPE QC PLINK-=-=-=-=-=-=-=-=
###-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
echo "-=-=-=-=-=-=-=-STEP 1-=-=-=-=-=-=-=-\n\n"

genoindir=("/scratch/as58810/bgen_v1.2_UKBsource")
mfiscoredir=("/scratch/as58810/mfi/info0.5")
outdir=("/scratch/as58810/ProjectFall2022/geno")
mkdir -p $outdir

plink2 \
--bgen $genoindir/ukb_imp_chr"$i"_v3.bgen ref-first \
--sample $genoindir/ukb_imp_v3.sample \
--extract $mfiscoredir/ukb_mfi_chr"$i"_v3_0.5.txt \
--mind 0.05 \
--geno 0.02 \
--hwe 1e-06 \
--maf 0.01 \
--autosome \
--maj-ref \
--max-alleles 2 \
--keep /scratch/as58810/ProjectFall2022/filteredPheno.txt \
--export bgen-1.2 bits=8 \
--out "$outdir"/chr"$i"
