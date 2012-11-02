import sys, re, os

def switch():
	file = sys.argv[1]
	
	data = open(file, 'rb').read()
	newdata = replace(data)
	
	f = open(file, 'wb')
	f.write(newdata)
	f.close()
	
def replace(line):
	m = re.search(r'\r\n', line)
	if m:
		newline = line.replace('\r\n', '\n')
	else:
		newline = re.sub("\r?\n", "\r\n", line)
	
	return newline
			
def run():
	run = False
	run = len(sys.argv) == 2
	filepath = sys.argv[1]
	run = os.path.exists(filepath)
	run = os.path.isfile(filepath)
	return run

if __name__ == '__main__':
	if(run()):
		switch()