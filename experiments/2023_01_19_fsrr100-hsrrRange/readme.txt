+ run on 01/19
+ run with 30 seeds to see if we can replicate the ecto-hastens-endo-evo results with more confidence. Modifications with this experiment from that original: pin fsrr at 100, and wrap hsrr from 100, 250, 500, 750, 1000 (low fsrr helps with more rapid evolution, but see how hsrr interacts with it).
+ was run with commit: eba1efde1f9923fe337cea7e5543f51b47b2e789
+ to replicate results, run \texttt{python simple_repeat} found in 'run_scripts/', munge data (potentially changing the value of the 'run_dir' variable, depending on where raw data files were placed) using the python files in 'munge_scripts/', and then graph munged data using files in 'graph_scripts/'.  
