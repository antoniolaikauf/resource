import subprocess
import re
from tabulate import tabulate
# esecuzione dello script e ottenimento dell'output
result = subprocess.run(['bash', 'risorse.sh'], capture_output=True, text=True)
# si raccolgono tutti i processi
righe = result.stdout.split('Processo:\n')
#  rimuove tutte le occorenze di \n o 0\n
process = [ re.sub(r'(0\n|\n)', '', process).split() for process in righe if len(process) != 0 ]


field = ['PROCESSO', 'PID', 'CPU', 'MEMORIA', 'MEMORIA VIRTUALE', 'STATO', 'TIME', 'COMAND']
table = tabulate(process, headers=field, tablefmt="grid")
print(table)