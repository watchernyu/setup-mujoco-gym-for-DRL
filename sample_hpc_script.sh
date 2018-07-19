#!/bin/sh
#
#SBATCH --verbose
#SBATCH -p aquila 
#SBATCH --job-name=test_job
#SBATCH --output=test_job_%j.out
#SBATCH --error=test_job_%j.err
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --mem=16GB
#SBATCH --mail-type=ALL
#SBATCH --mail-user=netid@nyu.edu

module load anaconda3
module load cuda/9.0
source activate rl
python test.py

