# Hello-IT-scripts
Some Scripts for Yoann Gini's Hello-IT.

## User Guide

> Download and install the Hello-IT.pkg from [https://github.com/ygini/Hello-IT/wiki](https://github.com/ygini/Hello-IT)

> Install the provided scripts by copying them to the Hello-IT CustomScripts directory (/Library/Application\ Support/com.github.ygini.hello-it/CustomScripts)

## The Scripts

### Display iCloud Private Relay Status

This script utilizes Joel Bruner's script (with attribution) to determine the state of iCloud Private Relay (assuming that on is good and green and off is not so good and orange). Of course you may decide differently.

### Display Limit IP Tracking Status

This script utilizes Joel Bruner's script (with attribution) to determine the state of Limit IP Tracking (assuming that on is good and green and off is not so good and orange). Of course you may decide differently.

Since Joel's script must be run as root and Hello-IT runs as the user I place Joel's script /usr/local and call it from a launchdaemon:

`ca.precursor.limit-ip-tracking-checker.plist`

The launchdaemon runs the following script every 30 minutes:

`/usr/local/limit-ip-tracking-checker.sh`

and that scripts write the status result to a text file at:

`/usr/local/LimitIPtrackingTest.txt`

And then my Hello-IT script just checks that text file.

