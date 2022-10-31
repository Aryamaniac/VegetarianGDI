#!/bin/bash
#SBATCH --job-name=infoscoreGenS2	       # Job name (testBowtie2)
#SBATCH --partition=highmem_p               # Partition name (batch, highmem_p, or gpu_p)
#SBATCH --ntasks=1                      # Run job in single task, by default using 1 CPU core on a single node
#SBATCH --cpus-per-task=4               # CPU core count per task, by default 1 CPU core per task
#SBATCH --mem=300G                        # Memory per node (4GB); by default using M as unit
#SBATCH --time=6-1:00:00                  # Time limit hrs:min:sec or days-hours:minutes:seconds
#SBATCH --export=NONE                   # Do not export any user’s explicit environment variables to compute node
#SBATCH --output=%infoscore_%j.out              # Standard output log, e.g., testBowtie2_12345.out
#SBATCH --error=%infoscore_%j.err               # Standard error log, e.g., testBowtie2_12345.err
#SBATCH --mail-user=as58810@uga.edu     # Where to send mail
#SBATCH --mail-type=ALL                 # Mail events (BEGIN, END, FAIL, ALL)
#SBATCH --array=1-22

i=$SLURM_ARRAY_TASK_ID 
#Change directory
cd /scratch/as58810/

#Load Modules
ml PLINK/2.00-alpha2.3-x86_64-20210920-dev

#Steps
step1=false
step2=true

#Set IO Directories
if [ $step1 = true ]; then

#Filter UKB imputations SNPS by 0.5

mfidir='/scratch/as58810/mfi'
outdir=$mfidir/info0.5/

mkdir -p $outdir

for i in {1..22}
	do
awk '{if ($8>=0.5) print $2}' $mfidir/ukb_mfi_chr"$i"_v3.txt > $outdir/ukb_mfi_chr"$i"_v3_0.5.txt

done

fi #end step 1 

if [ $step2 = true ]; then
#STEP 2: MAKE NEW GENOTYPE FILES WITH ONLY INFO>=0.5

genoindir=('/scratch/as58810/bgen_v1.2_UKBSource')
outdir='/scratch/as58810/ProjectFall2022/genotypeQC'
mfidir='/scatch/as58810/mfi/info0.5'

mkdir -p $outdir

plink2 \
--bgen $genoindir/ukb_imp_chr"$i"_v3  \
--extract $mfidir/ukb_mfi_chr"$i"_v3_0.5.txt \
--make-pgen \
--out $outdir/chr"$i" 

fi
