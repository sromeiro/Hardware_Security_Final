%Script to convert binary files to CSV
%Students:
%Esthevan Romeiro
%Brett Wilson
%Amber Hamlet

clear

fileNames = dir('Data1/*.bin');

for i = 1:size(fileNames,1)
   s = sprintf('Data1/%s',fileNames(i).name);
   x = s(1:end-4);
   x = strcat(x, '.csv');
   CommandStr = ['bin2Csv.exe ', s, ' ', x];
   system(CommandStr);
end
