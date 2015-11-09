#!/bin/bash

func="parse_vehicular"

num_jobs=200
cnt=0

## DAG 
# rm tmp.$func.dag*
# echo "" > tmp.$func.dag


codes=("parse_shanghai_taxi_counts" "parse_rome_taxi_counts" "parse_sf_taxi_counts" "parse_seattle_bus_counts" "parse_beijing_taxi_counts")
itvls=(60 120 300 600)
ranges=(100 500 1000 5000 10000)

# codes=("parse_beijing_taxi_counts")
# itvls=(6000)
# ranges=(1000 5000)


for code in ${codes[@]}; do
    for itvl in ${itvls[@]}; do
        for range in ${ranges[@]}; do

            name=${func}.${code}.${itvl}.${range}
            sed "s/CODE_NAME/${code}/g; s/ITVL/${itvl}/g; s/RANGE/${range}/g;" condor.${func}.mother.condor > tmp.${name}.condor
            condor_submit tmp.${name}.condor
            # echo JOB J${cnt} tmp.${name}.condor >> tmp.$func.dag
            # cnt=$((${cnt} + 1))
        done
    done
done

# echo $cnt / $num_jobs
# condor_submit_dag -maxjobs ${num_jobs} tmp.${func}.dag



