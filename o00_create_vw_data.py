import sys
from string import punctuation

inp_file = open(sys.argv[1])
outp_clr_file = open(sys.argv[2], "wb")
outp_con_file = open(sys.argv[3], "wb")
mod = sys.argv[4]

def convert_target(y):
	if y==0:
		y = -1
	return(y)

def light_preprocessing(text):
	text = text.lower()
	text = process_punctuation(text)
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
		if mod=="train":
			clarity = int(feats[9].strip())
			conciseness = int(feats[10].strip())
		else:
			clarity = -1
			conciseness = -1

		outp_clr = str(convert_target(clarity)) + " | " + title + "\n"
		outp_con = str(convert_target(conciseness)) + " | " + title + "\n"

		outp_clr_file.write(outp_clr)
		outp_con_file.write(outp_con)

outp_clr_file.close()
outp_con_file.close()



'''
pypy o00_create_vw_data.py ../modelling_data/Train1.tsv train1_clr.vw train1_con.vw train
pypy o00_create_vw_data.py ../modelling_data/Train2.tsv train2_clr.vw train2_con.vw train
pypy o00_create_vw_data.py ../modelling_data/Train3.tsv train3_clr.vw train3_con.vw train
pypy o00_create_vw_data.py ../modelling_data/Test.tsv test_clr.vw test_con.vw test

folder=model_clr
rm model_clr/train2_pred.vw 
rm model_clr/cache_file 
vw -d train1_clr.vw --loss_function logistic -b 29 -f $folder/current_clr.model --passes 1 --cache_file $folder/cache_file --ngram 2
cat train2_clr.vw | vw -t -i $folder/current_clr.model -p $folder/train2_pred.vw
cat train3_clr.vw | vw -t -i $folder/current_clr.model -p $folder/train3_pred.vw
cat test_clr.vw | vw -t -i $folder/current_clr.model -p $folder/test2_pred.vw


folder=model_con
rm $folder/*
vw -d train1_con.vw --loss_function logistic -b 29 -f $folder/current_con.model --passes 2 --cache_file $folder/cache_file --ngram 2 --l1 0.000001
cat train2_con.vw | vw -t -i $folder/current_con.model -p $folder/train2_pred.vw
cat train3_con.vw | vw -t -i $folder/current_con.model -p $folder/train3_pred.vw
cat test_con.vw | vw -t -i $folder/current_con.model -p $folder/test2_pred.vw
'''



