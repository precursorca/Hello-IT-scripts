#!/bin/bash

#  Display whether or not macOS updates are waiting
#
#  Title: macOS Update status
#  Tooltip: Update recommendation
#
#  Status:
#    Green  - softwareupdate --list = "No new software available."
#    Orange - softwareupdate --list shows that updates are listed.
#    Red    - not used in this version
#
#  Created by Alex Narvey, Precursor Systems
#
#  Written: 02/16/23


### The following line load the Hello IT bash script lib
. "$HELLO_IT_SCRIPT_SH_LIBRARY/com.github.ygini.hello-it.scriptlib.sh"


#POSITIVE="No new software available."
LOC="/Users/Shared/update_status.txt"
softwareupdate --list 2>$LOC
STATUS="$(cat $LOC)"
#echo $STATUS
if [ "${STATUS}" = "No new software available." ]
    then 
    echo "No macOS updates for you!"
    else
    echo "macOS updates are available for your computer."
fi

function updateStatus {
    if [ "${STATUS}" = "No new software available." ] # No new software available
    then
        updateTitle "macOS is up-to-date!"
        updateState "${STATE[0]}"
        updateTooltip '"macOS is patched and up-to-date."'
	else # macOS update(s) are available. 
        updateTitle "macOS has an update waiting."
        updateState "${STATE[1]}"
        updateTooltip "Please update using System Settings: Software Udpate"
    fi
}

### This function is called when the user click on your item
function onClickAction {
    updateStatus
}

### This function is called when you've set Hello IT to run your script on a regular basis
function fromCronAction {
    updateStatus
}

### This function is called when Hello IT need to know the title to display
### Use it to provide dynamic title at load.
function setTitleAction {
    updateStatus
}

### The only things to do outside of a bash function is to call the main function defined by the Hello IT bash lib.
main $@

exit 0
