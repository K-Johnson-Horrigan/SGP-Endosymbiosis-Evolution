#a script to run several replicates of several treatments locally
# Assumes that symbulation-default and SymSettings.cfg are already in this folder
import sys

start_range = 2001
end_range = 2031 

if(len(sys.argv) > 1):
    start_range = int(sys.argv[1])
    end_range = int(sys.argv[2])
else:
    print("Using default seeds " + str(start_range) + " " + str(end_range))

import subprocess

def cmd(command):
    '''This wait causes all executions to run in sieries.
    For parralelization, remove .wait() and instead delay the
    R script calls unitl all neccesary data is created.'''
    return subprocess.Popen(command, shell=True).wait()

def silent_cmd(command):
    '''This wait causes all executions to run in sieries.
    For parralelization, remove .wait() and instead delay the
    R script calls unitl all neccesary data is created.'''
    return subprocess.Popen(command, shell=True, stdout=subprocess.PIPE).wait()

#needs executable ./symbulation

### user options ###
seeds = range(start_range, end_range)
vts = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
res_list = [250, 500, 750, 100, 1000] 
ecto_list = [1, 0] # is ecto on?
sym_limit_list = [1, 0] #functionally, is endo on?

### run the experiment ###
for seed in seeds:
    for vt in vts:
        for sym_limit in sym_limit_list:
	    for ecto in ecto_list:
	        for res in res_list:
            	    file_ending = '_Seed' + str(seed) + '_VT' + str(vt) + '_SHTR' + str(res) + '_FLS1_ECTO' + str(ecto) + '_ENDO' + str(sym_limit) 
                    command_str = './symbulation_sgp -SEED ' + str(seed) + ' -FREE_LIVING_SYMS 1 -FILE_NAME ' + file_ending + \
                          ' -SYM_HORIZ_TRANS_RES ' + str(res) + ' -VERTICAL_TRANSMISSION ' + str(vt) + ' -SYM_LIMIT ' + str(sym_limit) + \
                          ' -ECTOSYMBIOSIS ' + str(ecto)
                    settings_filename = 'Output' + file_ending + ".data"
            	    print(command_str)
                    cmd(command_str+" > "+settings_filename)

