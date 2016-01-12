#!/bin/bash

if [[ $1 -eq "" ]]
then
    ls -alh ~/ic_model/data/sim/condor/log/ | grep err | sed "s/'/\\\\'/g" | awk -F' ' '{if($5!=108 && $5!=0) print $9}' | awk -F'.err' '{print "condor_submit ./tmp."$1".condor"}'
elif [[ $1 -eq "1" ]]; then
    ls -alh ~/ic_model/data/sim/condor/log/ | grep err | sed "s/'/\\\\'/g" | awk -F' ' '{if($5!=108 && $5!=0) print $0}'
# else
    # ls -alh ~/adn_control/data/sim/condor/log/ | grep err | sed "s/'/\\\\'/g" | | awk -F' ' '{if($5!=108 && $5!=0) print $9}' | sed "s/'/\\\\'/g" | xargs cat
fi

ls -alh ~/ic_model/data/sim/data/*.txt | wc -l
