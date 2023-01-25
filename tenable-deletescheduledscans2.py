import getpass
from tenable.sc import TenableSC
sc = TenableSC('<hostname>.<domain>.local')
p = getpass.getpass()
sc.login('<username>', p)
for scan in sc.scans.list(fields=['status', 'name', 'type', 'schedule'])['usable']:
    if scan['schedule']['name'] == 'Scheduled - Externally facing servers':
        if scan['schedule']['type'] == 'rollover':
            sc.scans.delete(scan['id']) 
