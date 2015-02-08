import nmap
nm = nmap.PortScanner()
r=nm.scan('127.0.0.1', '22-443')
print(nm.scaninfo())
print(nm.csv())
