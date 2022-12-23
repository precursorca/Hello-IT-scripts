#!/bin/bash

#  Display iCloud Private Relay Status
#
#  Title: iCloud Private Relay status
#  Tooltip: iCloud Private Relay recommendation
#
#  Status:
#    Green  - ON
#    Orange - OFF
#
#
#  Created by Alex Narvey, Precursor Systems
#  Relying on Joel Bruner's script - see below
#  Written: 12/19/2022
#

### The following line load the Hello IT bash script lib
. "$HELLO_IT_SCRIPT_SH_LIBRARY/com.github.ygini.hello-it.scriptlib.sh"


#!/bin/bash
: <<-LICENSE_BLOCK
iCloud Private Relay Status Checker - (https://github.com/brunerd)
Copyright (c) 2022 Joel Bruner (https://github.com/brunerd)
Licensed under the MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
LICENSE_BLOCK

#############
# FUNCTIONS #
#############

#include this self-contained function in your script
function iCloudPrivateRelay(){

	#only for Moneterey and up, 11 and under need not apply
	[ "$(sw_vers -productVersion | cut -d. -f1)" -le 11 ] && return 1
	
	#parent pref domain
	domain="com.apple.networkserviceproxy"
	#key that contains base64 encoded Plist within parent domain
	key="NSPServiceStatusManagerInfo"

	#child key within base64 embedded plist
	childKey="PrivacyProxyServiceStatus"

	#get the top level data from the main domain
	parentData=$(launchctl asuser $(stat -f %u /dev/console) sudo -u $(stat -f %Su /dev/console) defaults export ${domain} -)

	#if domain does not exist, fail
	[ -z "${parentData}" ] && return 1

	#export the base64 encoded data within the key as PlistBuddy CF style for grepping (it resists JSON extraction)
	childData=$(/usr/libexec/PlistBuddy -c "print :" /dev/stdin 2>/dev/null <<< $(plutil -extract "${key}" xml1 -o - /dev/stdin <<< "${parentData}" | xmllint --xpath "string(//data)" - | base64 --decode | plutil -convert xml1 - -o -))

	#if child key does not exist, fail
	[ -z "${childData}" ] && return 1

	#match the status string, then get the value using awk (quicker than complex walk, this is sufficient), sometimes written in multiple places
	keyStatusCF=$(awk -F '= ' '/'${childKey}' =/{print $2}' <<< "${childData}" | uniq)
	
	#if we have differing results that don't uniq down to one line, throw an error
	[ $(wc -l <<< "${keyStatusCF}") -gt 1 ] && return 2
	
	#if true/1 it is on, 0/off (value is integer btw not boolean)
	[ "${keyStatusCF}" = "1" ] && return 0 || return 1
}

########
# MAIN #
########

#example - one line calling with && and ||
#iCloudPrivateRelay && echo "iCloud Private Relay is: ON" || echo "iCloud Private Relay is: OFF"

function iCloudPrivateRelayStatus {
    if iCloudPrivateRelay;
    then
        updateTitle "iCloud Private Relay is ON"
        updateState "${STATE[0]}"
        updateTooltip "Your communications are obscured"
    else
        updateTitle "iCloud Private Relay is OFF"
        updateState "${STATE[1]}"
        updateTooltip "Please obscure communications"
    fi
}


### This function is called when the user click on your item
function onClickAction {
    iCloudPrivateRelayStatus
}

### This function is called when you've set Hello IT to run your script on a regular basis
function fromCronAction {
    iCloudPrivateRelayStatus
}

### This function is called when Hello IT need to know the title to display
### Use it to provide dynamic title at load.
function setTitleAction {
    iCloudPrivateRelayStatus
}

### The only things to do outside of a bash function is to call the main function defined by the Hello IT bash lib.
main $@

exit 0
