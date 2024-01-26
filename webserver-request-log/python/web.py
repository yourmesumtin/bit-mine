import re
from collections import Counter

# Path to the log file
log_file_path = 'web.log'

# Regular expression for matching IP addresses
ip_regex = re.compile(r'\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b')

# Function to extract IPs from a line
def extract_ips(line):
    return ip_regex.findall(line)

# Read the log file and count IP occurrences
ip_count = Counter()
with open(log_file_path, 'r') as file:
    for line in file:
        ip_count.update(extract_ips(line))

# Display results in descending order of frequency
print("IP Address\tFrequency")
for ip, count in ip_count.most_common():
    print(f"{ip}\t\t{count}")
