#!/bin/bash

for logname in $(ls *.log); do
    for numberedLog in $(ls -vr ${logname}.*); do
        logExtention=${numberedLog##*.}
        logExtention=$(( logExtention += 1 ))
        mv $numberedLog "$logname.$logExtention"
    done
    mv $logname $logname.1
    touch $logname
done
