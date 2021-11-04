ord = 62;

low = 0.000001;
bnd = [0.4 0.6];

b = fir1(15,0.5)
bM = fir1(ord,[low bnd]);

disp(sprintf('%d,',round(bM*32768)))

freqz(bM,1,1024);