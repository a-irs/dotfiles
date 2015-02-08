import nmap
nm = nmap.PortScanner()
r=nm.analyse_nmap_xml_scan(open('nmap_output.xml', 'r').read())
print(nm.scaninfo())
print(nm.csv())
