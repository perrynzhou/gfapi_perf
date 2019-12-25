all:
    gcc -pthread -g -O0  -Wall --pedantic -o gfapi_perf_tool gfapi_perf.c  -lgfapi -lrt
