#!/bin/bash

matlab -r "out_file = ['/scratch/cluster/yichao/ic_model/data/sim/data/LXLXUXUXNXNX.seedSEED.txt']; if(exist(out_file)), exit; end; sim_ic_model_v3(XNX, XLX, XUX, SEED); exit;"
