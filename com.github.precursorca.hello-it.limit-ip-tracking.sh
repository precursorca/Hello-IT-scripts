#!/bin/bash

#  Display Limit IP Tracking Status
#
#  Title: Limit IP Tracking Status
#  Tooltip: Limit IP Tracking recommendation
#
#
#  Requires a launch daemon running as root to run: 
#  Limit IP Tracking Status Checker - (https://github.com/brunerd)
#  Copyright (c) 2022 Joel Bruner (https://github.com/brunerd)
#  Licensed under the MIT License
# 
#    Green  - ON
#    Orange - OFF
#
#
#  Created by Alex Narvey, Precursor Systems
#
#  Written: 12/19/2022
#

### The following line load the Hello IT bash script lib
. "$HELLO_IT_SCRIPT_SH_LIBRARY/com.github.ygini.hello-it.scriptlib.sh"

limitIPTracking=$(cat /usr/local/LimitIPtrackingTest.txt)

function limitIPTrackingStatus {
    if [ "$limitIPTracking" = "ON" ]
    then
        updateTitle "Limit IP Tracking is ON"
        updateState "${STATE[0]}"
        updateTooltip "IP Tracking is being limited"
    else
        updateTitle "Limit IP Tracking is OFF"
        updateState "${STATE[1]}"
        updateTooltip "Please consider turning on LIMIT IP Tracking"
    fi
}


### This function is called when the user click on your item
function onClickAction {
    limitIPTrackingStatus
}

### This function is called when you've set Hello IT to run your script on a regular basis
function fromCronAction {
    limitIPTrackingStatus
}

### This function is called when Hello IT need to know the title to display
### Use it to provide dynamic title at load.
function setTitleAction {
    limitIPTrackingStatus
}

### The only things to do outside of a bash function is to call the main function defined by the Hello IT bash lib.
main $@

exit 0
