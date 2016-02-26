#!/bin/sh

cd ~/ESC_TP1/NPB3.3.1/NPB3.3-MPI/

read -r node_info<$PBS_NODEFILE

cd Results/Mx

mkdir $node_info

cd ../../bin

max_ppn=64

for file in *.x
do
	for (( ppn=2; ppn <= $max_ppn; ppn+=2 )) 
	do
		cd ../Results/Mx/$node_info
		/home/a59905/dstat -cdm --output $file.csv >> /dev/null &
		cd ../../../bin
		mpirun -np $ppn --report-bindings --mca mtl mx pml cm ./$file >> ../Results/Mx/$node_info/"$file.txt"
		kill $!
		sleep 2
	done
done
echo "Done.."
