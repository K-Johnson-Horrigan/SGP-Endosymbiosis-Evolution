import os.path
import gzip

input_file_name = "donate_count_munged_data.dat"

output_file_name = "donate_data_endo_on.dat"
out_file = open(output_file_name, 'w')
# seed vt ecto endo shtr update host_count h_sym_count fl_sym_count host_points_earned h_sym_points_earned h_sym_donate_calls h_sym_points_donated h_sym_steal_calls h_sym_points_stolen f_sym_points_earned f_sym_donate_calls f_sym_points_donated f_sym_steal_calls f_sym_points_stolen
try:
    input_file = open(input_file_name, 'r')
    out_file.write(next(input_file))
    for line in input_file:
        split_line = line.split(' ')
        if(split_line[3] != '1'): continue
        if(split_line[1] != '0.4'): continue
        out_file.write(line)

except IOError:
    print("Error in opening", input_file_name)

input_file.close()
out_file.close()
