CXX := g++
CPP_FLAGS := -std=c++14 -fpermissive -w -O3

CUDACC := ${CUDA_ROOT}/bin/nvcc
NVCC_FLAGS := -DGPU -O3
NVCC_LIB := -L${CUDA_ROOT}/lib64 -lcudart

CPP_SRC := $(wildcard src/gerbil/*.cpp)
CPP_OBJ := $(patsubst %.cpp,%.o,$(CPP_SRC))
CPP_OBJ := $(filter-out src/gerbil/toFasta.o,$(CPP_OBJ))
INC_INT := -Iinclude/gerbil -Iinclude/cuda_ds -Iinclude/cuda_ds/CountingHashTable

CUDA_SRC := $(wildcard src/cuda_ds/*.cu)
CUDA_OBJ := $(patsubst %.cu,%.o,$(CUDA_SRC))

INC_EXT := -I${BOOST_ROOT}/include
LIB_EXT := -L${BOOST_LIB} -lboost_system -lboost_filesystem -lboost_regex -lpthread -lbz2 -lz

default: gerbil toFasta

gerbil: $(CUDA_OBJ) $(CPP_OBJ)
	$(CXX) $(CPP_FLAGS) -o bin/$@ $(CPP_OBJ) $(CUDA_OBJ) $(INC_INT) $(LIB_EXT) $(NVCC_LIB)

toFasta:
	$(CXX) $(CPP_FLAGS) -o bin/$@ src/gerbil/toFasta.cpp

%.o: %.cu
	$(CUDACC) $(NVCC_FLAGS) -c $< -o $@

%.o: %.cpp
	$(CXX) $(CPP_FLAGS) -c $< -o $@ $(INC_EXT)


test:
	@echo $(value CPP_SRC)
	@echo $(value CUDA_SRC)
	@echo $(value HEADERS)
	@echo $(value CPP_OBJ)


.PHONY: clean
clean:
	rm $(CUDA_OBJ) $(CPP_OBJ) bin/toFasta bin/gerbil
