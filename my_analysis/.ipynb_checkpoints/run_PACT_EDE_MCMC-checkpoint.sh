#!/bin/bash
#SBATCH --job-name=PACT_EDE_MCMC
#SBATCH --account=hill
#SBATCH --nodes=1
#SBATCH --ntasks=4                # 4 MPI processes = 4 MCMC chains
#SBATCH --cpus-per-task=8         # 8 CLASS threads per chain
#SBATCH --mem-per-cpu=3G          # ~96 GB total
#SBATCH --time=4-00:00:00         # EDE is slow and mixes slowly: expect several resubmissions (--resume continues)
#SBATCH --output=logs/%x_%j.out

module load openmpi/4.1.6-gcc11
source ~/envs/ede_cosmology/bin/activate
export LD_LIBRARY_PATH=/insomnia001/shared/apps/openmpi/4.1.6-gcc11/lib:$LD_LIBRARY_PATH
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
echo "Slurm: SLURM_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK, job $SLURM_JOB_ID"

cd $SLURM_SUBMIT_DIR

mpirun -np $SLURM_NTASKS --bind-to none --mca btl ^openib -x OMP_NUM_THREADS \
    cobaya-run PACT_EDE_MCMC.yaml -p /insomnia001/home/ja4020/CLASS_SilkConsistency/packages --resume

# Run with 
#   - (any plain login-node shell; the script activates ede_cosmology itself)
#   - sbatch run_PACT_EDE_MCMC.sh