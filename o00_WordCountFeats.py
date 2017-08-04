import sys
from string import punctuation
from stemming.porter2 import stem

inp_file = open(sys.argv[1])
outp_file = open(sys.argv[2], "wb")

def convert_target(y):
	if y==0:
		y = -1
	return(y)

def light_preprocessing(text):
	text = text.lower()
	text = process_punctuation(text)
	text = " ".join([stem(word) for word in text.split(" ")])
	return(text)

def process_punctuation(line):
    punctuation_list = punctuation
    outp_line = ""
    for p in line:
    	if p == "|":
    		pass
        elif p in punctuation_list:
            pass
            #outp_line += " " + p + " "
        else:
            outp_line += p
    return outp_line

for line in inp_file:
	if line.startswith("country")==False:
		feats = line.split("\t")
		title = light_preprocessing(feats[2])
		numW = len(title.split(" "))
		numUniqW = len(set(title.split(" ")))
		numDupW = numW - numUniqW
	else:
		numW = "numW"
		numUniqW = "numUniqW"
		numDupW = "numDupW"
	outp_line = "\t".join([str(numW), str(numUniqW), str(numDupW)]) + "\t" + line
	outp_file.write(outp_line)

outp_file.close()
