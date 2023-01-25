import os.path
import gzip
# the directory the raw data files are in
data_dir = "running_data/"

### user options ###
start_range = 2001
end_range = 2031
seeds = range(start_range, end_range)
vts = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
res_list = [250, 500, 750, 100, 1000]
ecto_list = [1, 0] # is ecto on?
sym_limit_list = [1, 0] #functionally, is endo on?

header = "seed vt ecto endo shtr impact_index sym_impact\n" 

outputFileName = "impact_munged_data.dat"

outFile = open(outputFileName, 'w')
outFile.write(header)
for seed in seeds:
    for vt in vts:
        for shtr in res_list:
            for ecto in ecto_list:
                for endo in sym_limit_list:
                    file_ending = '_Seed' + str(seed) + '_VT' + str(vt) +  '_SHTR' + str(shtr) + '_FLS1_ECTO' +str(ecto) + '_ENDO' + str(endo) + '_SEED'+str(seed)+'.data'
                    
                    fname = 'running_data/SymImpact' + file_ending
                    try:
                        ifile = open(fname, 'r')
                        count = 0
                        for dline in ifile:
                            if (dline[0] != "u"):
                                count = count + 1
                                outstring = "{} {} {} {} {} {} ".format(seed, vt, ecto, endo, shtr, str(count))
                                outstring = outstring + dline 
                            outFile.write(outstring)
                        ifile.close()
                    except IOError:
                        print("not found", file_ending)
outFile.close()
