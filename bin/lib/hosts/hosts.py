#!/usr/bin/env python

scan_range = '192.168.2.0/24'
own_ip = '192.168.2.42'
custom = {}
custom['74:DE:2B:EB:11:32'] = 'Ju:Liteon'
custom['4C:0F:6E:F7:B7:1E'] = 'L:HonHai'
custom['94:94:26:13:E4:F7'] = 'L:iPhone'
custom['A4:17:31:EC:35:D3'] = 'V:HonHai'

custom['1C:B0:94:B5:4F:8C'] = 'R?:HTCAndroid'
custom['00:26:C6:BE:59:92'] = 'Intel'
custom['78:92:9C:38:CD:BA'] = 'IntelAsus'
custom['B4:18:D1:3E:30:C3'] = 'Apple'
custom['00:26:E8:86:AB:E2'] = 'MurataAndroid'
custom['34:4B:50:9D:CA:45'] = 'ZTE'
custom['10:68:3F:33:70:5F'] = 'LG'
custom['E0:B9:A5:9C:F4:86'] = 'AzurewaveAsus'
custom['98:3B:16:49:41:D0'] = 'AMPAKAndroid'

import nmap
import sys
import os
from socket import inet_aton
import struct
from prettytable import PrettyTable

if os.getuid() != 0:
    print('run as root')
    sys.exit(1)

print('Starting pings on', scan_range, '\n')

def initTable():
    """
    inits the PrettyTable with the header lines
    returns the PrettyTable object
    """
    tableIp = 'IP-Address'
    tableHost = 'Hostname'
    tableMac = 'MAC-Address'
    tableReason = 'Reason'
    table = PrettyTable([tableIp, tableHost, tableMac, tableReason])
    table.align[tableIp] = "l"
    table.align[tableHost] = "l"
    table.align[tableMac] = "l"
    table.align[tableReason] = "l"
    return table

nm = nmap.PortScanner()
scan = nm.scan(hosts=scan_range, arguments='-sP -PE -PA21,23,80,3389 --system-dns --exclude ' + own_ip)
hosts = sorted(nm.all_hosts(), key=lambda ip: struct.unpack("!L", inet_aton(ip))[0])

table = initTable()
for ip in hosts:
    reason = nm[ip]['status']['reason']
    mac_addr = scan['scan'][ip]['addresses'].get('mac')

    hostname = ''
    if nm[ip].hostname() != '':
        hostname = nm[ip].hostname()
    elif custom.get(mac_addr) != None:
        hostname = '\033[1;33m' + custom.get(mac_addr) + '\033[0m'

    table.add_row([ip, hostname, mac_addr, reason])

print(nm.scanstats()['uphosts'], 'online hosts:')
print(table)
