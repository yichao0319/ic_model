#!/bin/bash

func="sim_ic_model_v3"

num_jobs=500
cnt=0

## DAG 
rm tmp.$func.dag*
echo "" > tmp.$func.dag

Ns=(100000)
nLU=4
# Ls=(2 3 1 1)
# Us=(8 10 1 100000)
Ls=(2)
Us=(8)
# seeds=(1 2 3 4 5)
nseed=100

# for seed in ${seeds[@]}; do
seed=1
while [[ ${seed} -le nseed ]]; do
    for N in ${Ns[@]}; do
        idx=0
        while [[ ${idx} -lt nLU ]]; do
            L=${Ls[${idx}]}
            U=${Us[${idx}]}
            idx=$[${idx}+1]

            # echo 'seed='${seed}
            # echo 'N='${N}
            # echo 'idx='${idx}
            # echo 'L='${L}
            # echo 'U='${U}

            name=L${L}U${U}N${N}.seed${seed}
            echo ${name}
            sed "s/XLX/${L}/g; s/XUX/${U}/g; s/XNX/${N}/g; s/SEED/${seed}/g;" condor.${func}.mother.sh > tmp.${name}.sh
            sed "s/XXX/${name}/g;" condor.${func}.mother.condor > tmp.${name}.condor
            echo JOB J${cnt} tmp.${name}.condor >> tmp.$func.dag
            cnt=$((${cnt} + 1))
        done
    done
    seed=$[${seed}+1]
done


echo $cnt / $num_jobs
condor_submit_dag -maxjobs ${num_jobs} tmp.${func}.dag

