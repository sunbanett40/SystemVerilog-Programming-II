ord = 31;

low = 0.000001;
bnd = [0.2 0.4];

bM = fir1(ord-1,[low bnd]);

disp(sprintf('%d,',round(bM*32768)))

freqz(bM,1,1024);