smake:
	module load cuda
	mpicc -xhost -openmp -O3 -c fractal_hyb2.cpp -o Cfractal.o
	nvcc -O3 -arch=sm_35 -c fractal_hyb2.cu -o CUfractal.o
	mpicc -xhost -openmp -O3 Cfractal.o CUfractal.o -lucudart \
	 -L$(TACC_CUDA_LIB) -o fractal_hyb2

make:
	module add openmpi-x86_64
	mpicxx -march=native -O3 -fopenmp -c fractal_hyb2.cpp -o fractal_hyb2.cpp -o Cfractal.o
	nvcc -O3 -arch=sm_35 -c fractal_hyb2.cu -o CUfractal.o
	mpicc -xhost -openmp -O3 Cfractal.o CUfractal.o -lcudart \ 
	 -L /usr/local/cuda/lib64/ -o fractal_hyb2

gif:
	convert -delay 1x30 fractal1*.bmp fractal.gif

test:
	diff fractal.gif /home/Students/yyz1/cs/4380burtcher/testfiles/fractal.gif

clean:
	rm fractal*.bmp

run:
	mpirun -n 2 ./fractal_hyb2 250 10 20

srun:
	sbatch fractal_hyb1.sub
