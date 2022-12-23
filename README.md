# Hello-IT-scripts
Some Scripts for Yoann Gini's Hello-IT.

## User Guide

Download and install the Hello-IT.pkg from [https://github.com/ygini/Hello-IT/wiki](https://github.com/ygini/Hello-IT/wiki)

Install the provided scripts by copying them to the Hello-IT CustomScripts directory (/Library/Application\ Support/com.github.ygini.hello-it/CustomScripts)

## The Scripts

### Display iCloud Private Relay Status

This script utilizes Joel Bruner's script (with attribution) to determine the state of iCloud Private Relay (assuming that on is good and green and off is not so good and orange. Of course you may decide differently.

### Display Limit IP Tracking Status

This script utilizes Joel Bruner's script (with attribution) to determine the state of Limit IP Tracking (assuming that on is good and green and off is not so good and orange. Of course you may decide differently.

Since Joe's script must be run as root and Hello-IT runs as the user I use Joel's script in a launchdaemon to run the script:
limit-ip-tracking-checker.sh
and write the status result to a text file at:
/usr/local/LimitIPtrackingTest.txt
And then Hello-IT just checks that text file.

