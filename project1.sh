#!/bin/bash
#Author: Richard T Swierk

#Check if the script is run as root and exits if false
if [ "$EUID" -ne 0 ]
  then echo "Must Run as Root"
  exit
fi

#Current device description and product name
sys_description(){
	echo -e "<h2>Current device description and product name</h2>\n<pre>"
	lshw | grep -m 2 "descrption\|product"
	echo "</pre>"
}

#prints out operating system, kernel, architecture
basic_info(){
	echo -e "<h2>Operating system, Kernel and Architecture</h2>/n<pre>"
	hostnamectl | grep -A 3 "Operating"
	echo "</pre>"
}

#Prints Total memory, free memory, total swap
mem_info(){
	echo -e "<h2>Total memory, Free memory and, Total swap</h2>\n<pre>"
	cat /proc/meminfo | grep "MemTotal\|MemFree\|SwapTotal"
	echo "</pre>"
}

#prints listing od the disk devices, free space on any formated partition
disk_info(){ echo -e "<h2>Listing of the disk devices and free space on any formated partition</h2>\n<pre>$(df -h --output=source,avail)</pre>" }

#prints All users who have an interactive shell prompt to include what groups they are assigned
user_info(){ echo -e "<h2>All users who have an interactive shell prompt to include what groups they are assigned</h2>\n<pre>$(groups $(users))</pre>" }

#prints system ip address
ip_address(){ echo -e "<h2>System ip address</h2>\n<pre>$(hostname -I)</pre>" }

#print usb info
usb_info(){ echo -e "<h2>Usb information</h2>\n<pre>$(lsusb)</pre>" }

#prints report title with time stamp
title(){ echo "System Information for $HOSTNAME" }

#prints the current time
time_stamp(){
	RIGHT_NOW="$(date +"%x %r %Z")"
        echo "Updated on $RIGHT_NOW by $USER"
}

#creates an html file with the information from the above functions
cat <<- _EOF_
  <html>
  <head>
      <title>$(title)</title>
  </head>

  <body>
      <h1>$(title)</h1>
      <p>$(time_stamp)</p>
      $(basic_info)
      $(mem_info)
      $(user_info)
      $(disk_info)
      $(ip_address)
      $(sys_description)
      $(usb_info)
  </body>
  </html>
_EOF_
