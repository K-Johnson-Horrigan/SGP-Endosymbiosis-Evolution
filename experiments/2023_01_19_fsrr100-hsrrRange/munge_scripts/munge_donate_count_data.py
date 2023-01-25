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

# set up munged file
header = "seed vt ecto endo shtr update host_count h_sym_count fl_sym_count host_points_earned h_sym_points_earned h_sym_donate_calls h_sym_points_donated h_sym_steal_calls h_sym_points_stolen f_sym_points_earned f_sym_donate_calls f_sym_points_donated f_sym_steal_calls f_sym_points_stolen\n"

outputFileName = "donate_count_munged_data.dat"

outFile = open(outputFileName, 'w')
outFile.write(header)

# write to munged file
for seed in seeds:
    for vt in vts:
        for shtr in res_list:
            for ecto in ecto_list:
                for endo in sym_limit_list:
                    file_ending = '_Seed' + str(seed) + '_VT' + str(vt) +  '_SHTR' + str(shtr) + '_FLS1_ECTO' +str(ecto) + '_ENDO' + str(endo) + '_SEED'+str(seed)+'.data'
                    count_fname = 'running_data/OrganismCounts' + file_ending
                    donated_fname = 'running_data/SymDonated' + file_ending
                    try:
                        count_file = open(count_fname, 'r')
                        donate_file = open(donated_fname, 'r')
                        for cline, dline in zip(count_file, donate_file):
                            if (dline[0] != "u"):
                                outstring = "{} {} {} {} {} ".format(seed, vt, ecto, endo, shtr)
                                outstring = outstring + " ".join(cline.strip().split(',')) + " "
                                outstring = outstring + " ".join(dline.strip().split(',')[1:])
                                outstring = outstring + "\n"
                                outFile.write(outstring)
                        count_file.close()
                        donate_file.close()
                    except IOError:
                        print("could not find files", file_ending)
outFile.close()
