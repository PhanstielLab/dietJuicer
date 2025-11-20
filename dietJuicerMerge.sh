#! /bin/bash -login
#SBATCH -J dietJuicerMerge
#SBATCH -t 10-00:00:00
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1  
#SBATCH -p general
#SBATCH --mem=2gb
#SBATCH -o "%x-%j.out"
#SBATCH --mail-type=END,FAIL,TIME_LIMIT_80

## Exit if any command fails
set -e

## Load required modules
module load python/3.12.4

## Create and activate virtual environment with requirements
python3 -m venv env && source env/bin/activate && pip3 install -r config/requirements.txt && pip3 install pandas && pip install snakemake-executor-plugin-slurm

## Make directory for slurm logs
mkdir -p output/logs_slurm

## Execute buildHIC snakemake workflow
snakemake -j 100 --rerun-incomplete --restart-times 3 -p -s workflows/buildHIC --latency-wait 500 --configfile "config/cluster.yaml" --profile profiles/slurm

## Success message
echo "Entire workflow completed successfully!"
