#!/bin/bash
#SBATCH --cpus-per-task=1 
#SBATCH --gpus-per-node=1 
#SBATCH --mem-per-cpu=8000 
#SBATCH --time=10:0:0  
module purge
module load StdEnv/2020 gcc/9.3.0 cuda/11.4 openmpi/4.0.3 amber/20.12-20.15

echo "Starting solvent relaxation"
echo "starting 1min"

pmemd.cuda -O -i ../../Relaxation/1min.in -o 1min.out -p GGPP_ion.prmtop -c GGPP_ion.inpcrd -r 1min.rst7 -inf 1min.info -ref GGPP_ion.inpcrd -x mdcrd.1min

echo "ending 1min"
echo "starting 2mdheat"

pmemd.cuda -O -i ../../Relaxation/2mdheat.in -o 2mdheat.out -p GGPP_ion.prmtop -c 1min.rst7 -r 2mdheat.rst7 -inf 2mdheat.info -ref 1min.rst7 -x mdcrd.2mdheat

echo "ending 2mdheat"
echo "starting 3md"

pmemd.cuda -O -i ../../Relaxation/3md.in -o 3md.out -p GGPP_ion.prmtop -c 2mdheat.rst7 -r 3md.rst7 -inf 3md.info -ref 2mdheat.rst7 -x mdcrd.3md

echo "ending 3md"
echo "starting 4md"

pmemd.cuda -O -i ../../Relaxation/4md.in -o 4md.out -p GGPP_ion.prmtop -c 3md.rst7 -r 4md.rst7 -inf 4md.info -ref 3md.rst7 -x mdcrd.4md

echo "ending 4md"
echo "Finished solvent relaxation"

echo "Starting sidechain relaxation"
echo "starting 5min"

pmemd.cuda -O -i ../../Relaxation/5min.in -o 5min.out -p GGPP_ion.prmtop -c 4md.rst7 -r 5min.rst7 -inf 5min.info -ref 4md.rst7 -x mdcrd.5min

echo "ending 5min"
echo "starting 6md"

pmemd.cuda -O -i ../../Relaxation/6md.in -o 6md.out -p GGPP_ion.prmtop -c 5min.rst7 -r 6md.rst7 -inf 6md.info -ref 5min.rst7 -x mdcrd.6md

echo "ending 6md"
echo "starting 7md"

pmemd.cuda -O -i ../../Relaxation/7md.in -o 7md.out -p GGPP_ion.prmtop -c 6md.rst7 -r 7md.rst7 -inf 7md.info -ref 6md.rst7 -x mdcrd.7md

echo "ending 7md"
echo "starting 8md"

pmemd.cuda -O -i ../../Relaxation/8md.in -o 8md.out -p GGPP_ion.prmtop -c 7md.rst7 -r 8md.rst7 -inf 8md.info -ref 7md.rst7 -x mdcrd.8md

echo "ending 8md"
echo "Finshed sidechain relaxation"

echo "Starting relaxation without constraints"
echo "starting 9md"

pmemd.cuda -O -i ../../Relaxation/9md.in -o 9md.out -p GGPP_ion.prmtop -c 8md.rst7 -r GGPP_relaxed.rst7 -inf 9md.info -ref 8md.rst7 -x mdcrd.9md

echo "ending 9md"
echo "Finshed system relaxation"
