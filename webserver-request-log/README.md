BASH SCRIPT web.sh

## This line specifies that the script should be interpreted using the Bash shell

#!/bin/bash

##  A variable log_file is declared and assigned the value "web.log", which is the name of the log file to be processed

log_file="web.log"

## The below line uses grep to extract IP addresses from the log file. The regular expression \b([0-9]{1,3}\.){3}[0-9]{1,3}\b matches IPv4 addresses. The -o option tells grep to only output the matched parts, and the -E option enables extended regular expressions. The result is stored in the variable ips.

ips=$(grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" "$log_file")

## The below line declares an associative array named ip_count. In Bash, associative arrays allow you to create key-value pairs.

declare -A ip_count


## for loop explanation -- This loop iterates over each IP address in the ips variable and increments the corresponding entry in the ip_count associative array.
for ip in $ips; do
    ((ip_count[$ip]++))
done



## The below lines print the header for the output, indicating the columns for IP addresses and their frequencies.
echo "IP Address   Frequency"
echo "-----------------------"

## Explanation for below for loop -- This loop iterates over the keys (IP addresses) in the ip_count associative array. It prints each IP address along with its frequency. The sort -k2,2nr command sorts the output based on the second column (frequency) in descending numerical order.

for ip in "${!ip_count[@]}"; do
    echo "$ip       ${ip_count[$ip]}"
done | sort -k2,2nr


RUN  ./web.sh >> result.tx  (This command will run the script and append to result.txt)

## Output
IP Address      Frequency
192.168.21.34           4
192.168.22.11           3
10.32.89.34             2
172.32.9.12             1


## PYTHON SCRIPT web.py

# IP Address Frequency Analysis Script

This Python script is designed to analyze a web server log file and calculate the frequency of each IP address found within the log. It outputs a sorted list of IP addresses along with their corresponding occurrence counts.

## Script Functionality

- **Regex Matching**: Utilizes regular expressions to identify and extract IP addresses from each line of the log file.
- **Frequency Counting**: Counts the occurrences of each unique IP address.
- **Sorting and Output**: Displays the IP addresses and their frequencies in descending order of occurrence.

## Requirements

- Python 3.x
- A web server log file formatted with one entry per line, where each line contains an IP address.
- 

## Setup and Execution

1. **Installation**: Ensure Python 3.x is installed on your system. You can download Python from the [official site](https://www.python.org/downloads/).

2. **Log File**: Place your web server log file in the same directory as the script. The default expected filename is `web.log`, but you can modify this within the script.

3. **Running the Script**: Execute the script via the command line:

   python web.py >> result.tx  (This command will run the script and append to result.txt)

## Output
IP Address      Frequency
192.168.21.34           4
192.168.22.11           3
10.32.89.34             2
172.32.9.12             1
