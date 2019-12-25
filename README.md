gfapi-perf-tool
=================

benchmark for distributed, multi-thread test of Gluster libgfapi performance

This page describes a new benchmark for measuring small-file performance with libgfapi.  As libgfapi is increasingly used for Gluster applications, questions have arisen about metadata-intensive workload performance with libgfapi and how this scales with bricks, libgfapi instances, etc.   This benchmark takes advantage of the similarity between libgfapi and POSIX interfaces so that the same tests can be run either with libgfapi or in a POSIX filesystem (example: Gluster FUSE mountpoint).  This makes it easy to compare libgfapi performance with FUSE or XFS performance, for example.

This may be the best way to get RDMA to perform well with Gluster as well.  RDMA is based on avoiding data copies between the application and the kernel, but the FUSE (Filesystem in User SpacE) implementation of glusterfs forces data copies between the application and the glusterfs FUSE mountpoint process.  By using libgfapi, an application can bypass these copies.

* fork from other branch 

   origin branch base on glusterfs 3.x,but we need to update version of gluster,so we fixed some error that can running on glusterfs 6.x,this tool just testing performance between fuse accessing and gfapi access (update by perrynzhou@gmail.com)

* low-level test program

The "C" program that runs in each process is gfapi_perf_tool.c .  You can run this program by itself.  The command line syntax is a little odd because it uses environment variables.   This is less user-friendly but also easier in some ways.   For example, you don't have to keep entering the same parameters.  To compile, see the command at the top of the program.

To print out environment variables that it supports:

    # ./gfapi_perf_tool -h
    usage: ./gfapi_perf_tool
    environment variables may be inserted at front of command or exported
    defaults are in parentheses
    DEBUG (0 means off)     - print everything the program does
    GFAPI_VOLNAME           - Gluster volume to use
    GFAPI_HOSTNAME          - Gluster server participating in the volume
    GFAPI_TRANSPORT (tcp)   - transport protocol to use, can be tcp or rdma
    GFAPI_PORT (24007)      - port number to connect to
    GFAPI_RECSZ (64)        - I/O transfer size (i.e. record size) to use
    GFAPI_FSZ (1M)          - file size
    GFAPI_BASEDIR(/tmp)     - directory for this thread to use
    GFAPI_LOAD (seq-wr)     - workload to apply, can be one of seq-wr, seq-rd, rnd-wr, rnd-rd, unlink, seq-rdwrmix
    GFAPI_IOREQ (0 = all)   - for random workloads , how many requests to issue
    GFAPI_DIRECT (0 = off)  - force use of O_DIRECT even for sequential reads/writes
    GFAPI_FUSE (0 = false)  - if true, use POSIX (through FUSE) instead of libgfapi
    GFAPI_TRCLVL (0 = none) - trace level specified in glfs_set_logging
    GFAPI_FILES (100)       - number of files to access
    GFAPI_STARTING_GUN (none) - touch this file to begin test after all processes are started
    GFAPI_STARTING_GUN_TIMEOUT (60) - each thread waits this many seconds for starting gun file before timing out
    GFAPI_FILES_PER_DIR (1000) - maximum files placed in a leaf directory
    GFAPI_APPEND (0)        - if 1, then append to existing file, instead of creating it
    GFAPI_OVERWRITE (0)     - if 1, then overwrite existing file, instead of creating it
    GFAPI_PREFIX (none)     - insert string in front of filename
    GFAPI_USEC_DELAY_PER_FILE (0) - if non-zero, then sleep this many microseconds after each file is accessed
    GFAPI_FSYNC_AT_CLOSE (0) - if 1, then issue fsync() call on file before closing

Here's a sample run:
[root@bogon /home/perrynzhou/]$ GFAPI_VOLNAME=train1_vol GFAPI_FILES=5000  GFAPI_FUSE=1  GFAPI_LOAD=rnd-rd GFAPI_HOSTNAME=172.21.78.11  GFAPI
_BASEDIR=/mnt/data/11095119   ./gfapi_perf_tool
GLUSTER: 
  volume=train1_vol
  transport=tcp
  host=172.25.78.11
  port=24007
  fuse?Yes
  trace level=0
  start timeout=60
WORKLOAD:
  type = rnd-rd 
  threads/proc = 1
  base directory = /mnt/data/11095119
  prefix=f
  file size = 1024 KB
  file count = 5000
  record size = 64 KB
  files/dir=1000
  fsync-at-close? No 
  random read/write requests = 16
thread   0:   files read = 5000
  files done = 5000
  I/O (record) transfers = 80000
  total bytes = 5242880000
  elapsed time    = 248.10    sec
  throughput      = 20.15     MB/sec
  file rate       = 20.15     files/sec
  IOPS            = 322.45    (random read)
aggregate:   files read = 5000
  files done = 5000
  I/O (record) transfers = 80000
  total bytes = 5242880000
  elapsed time    = 248.10    sec
  throughput      = 20.15     MB/sec
  file rate       = 20.15     files/sec
  IOPS            = 322.45    (random read)


