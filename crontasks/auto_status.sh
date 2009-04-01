#!/bin/bash
# Start Date: Wednesday April 1, 2009
# Current Version: 0.9
# Author: Joseph Pecoraro
# Contributor: Sean McDermott - RIT Host Idea
# Contact: joepeck02@gmail.com
# Decription: Automatically update my status
# By determining where I am, and what time it is.

# Debug mode just means provide any cmd lne argument
DEBUG=$1

# Exit Immediately if Adium is not running
check=$(/usr/bin/osascript -e 'tell application "Finder" to name of processes' | /usr/bin/grep Adium)
if [ -z "$check" ]; then
	[ -n "$DEBUG" ] && echo "Adium Not Running"
	exit 1
fi

# Current Date Time (used for Class Times)
day_hour=`/bin/date +"%A %H"`
	
# Mac Address of my Router At Home
if [ -n "$(/usr/sbin/arp -a | /usr/bin/grep 0:1e:2a:76:17:98)" ]; then
	[ -n "$DEBUG" ] && echo '@Home'
	/usr/bin/osascript -e 'tell application "Adium" to go online with message "@Home (testing applescript)"'

# Monday and Wednesday Classes and Times
elif [ -n "`echo {Monday\ {12,13,16,17},Wednesday\ {12,13,16,17}} | /usr/bin/grep \"$day_hour\"`" ]; then
	[ -n "$DEBUG" ] && echo '@Class'
	/usr/bin/osascript -e 'tell application "Adium" to go away with message "@Class (testing applescript)"'

# RIT Hostname should only exist when at rit
elif [ "0" -ne "$(/sbin/ping -c 1 jpecoraro.rit.edu | wc -l | tr -d ' ')" ]; then
	[ -n "$DEBUG" ] && echo '@RIT'
	/usr/bin/osascript -e 'tell application "Adium" to go online with message "@RIT (testing applescript)"'	

# Default
else
	[ -n "$DEBUG" ] && echo '@Unknown'
	/usr/bin/osascript -e 'tell application "Adium" to go online with message "@Unknown (testing applescript)"'	

fi