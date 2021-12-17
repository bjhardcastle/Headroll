This repository contains the processed data (.mat files) and Matlab functions/scripts for making all plots as they appear in the manuscript (tested on Matlab 2017a & later). 

1. Clone repository or download as .zip file and extract the contents.
2. Run `makePlots.m` and the required folders will be added to path temporarily, then each of the `scripts\plot_*.m` files will be run in order.
3. Each plot will appear on-screen as a new figure. It will automatically save to disk in a new directory `plots\`, then the figure will close. (note: plots containing all individual cycles may take a up to a minute to save)
4. Details of the analysis can be found in `scripts\remake_*.m` files.
