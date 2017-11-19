%Main program
%Students:
%Esthevan Romeiro
%Brett Wilson
%Amber Hamlet

% clear %clears the workspace

fileNames = dir('Data/CSVData/*.csv');
csvData = zeros(5003, 2, 10936);
csvDataONES = zeros(5003,2,5468);
csvDataZEROS = zeros(5003,2,5468);
messageData = reshape(blanks(174976),10936,16); %creates 10936x16 char array
cipherData = reshape(blanks(174976),10936,16); %creates 10936x16 char array
messageBinary = zeros(10396,64); %Stores all messages in Binary
cipherBinary = zeros(10396,64); %Stores all ciphers in Binary
keyBinary = zeros(16, 4); %Stores the key in Binary

%========================STORING OF CSV DATA==============================%
for i = 1:size(fileNames,1)
    s = sprintf('Data/CSVData/%s',fileNames(i).name);
    csvData(:,:,i) = csvread(s);
end
%=========================================================================%

%Finds the underscore delimiters separating the message, key and cipher
delimiters = strfind(fileNames(1).name, '_');

%Store the key
keyData = fileNames(1).name(36 : delimiters(7)-1);

%For loop to store the key in Binary form
for i = 1 : size(keyData, 2)
    keyBinary(i,:) = hexToBinaryVector(keyData(1,i),4);
end

%For loop to store all of the messages, key and ciphertexts
 for i = 1 : size(fileNames, 1)
    messageData(i, :) = fileNames(i).name(55 : delimiters(8)-1);
    cipherData(i, :) = fileNames(i).name(delimiters(8)+3 : 89);
 end

%For loop to store the message and cipher in Binary form

for i = 1 : size(fileNames, 1)
      
      messageBinary(i,:) =  hexToBinaryVector(messageData(i,:),64);
      cipherBinary(i,:) = hexToBinaryVector(cipherData(i,:),64);
    
end
KeyBinary = hexToBinaryVector(keyData,64);
Expansion = [32 1 2 3 4 5
              4 5 6 7 8 9
             8 9 10 11 12 13
             12 13 14 15 16 17
             16 17 18 19 20 21
             20 21 22 23 24 25
             24 25 26 27 28 29
             28 29 30 31 32 1];
         
SBox1 = [14 4 13 1 2 15 11 8 3 10 6 12 5 9 0 7
          0 15 7 4 14 2 13 1 10 6 12 11 9 5 3 8
          4 1 14 8 13 6 2 11 15 12 9 7 3 10 5 0
          15 12 8 2 4 9 1 7 5 11 3 14 10 0 6 13];

countforOne = 1;
countforZEROS = 1;
%%%%%%%%%        SBOX1     %%%%%%%%%
for i = 1:size(fileNames,1)
    
    R16 = cipherBinary(i,Expansion(1,:));
    guessKey = KeyBinary(1:6);
    XORedKey = xor(R16,guessKey);
    Srow_temp = strcat(num2str(XORedKey(1)),num2str(XORedKey(6)));
    Srow = bin2dec(Srow_temp)+1;
    Scolumn_temp = strcat(num2str(XORedKey(2:5)));
    Scolumn = bin2dec(Scolumn_temp)+1;

    Sbits = dec2bin(SBox1(Srow,Scolumn),4);
    firstBit = bin2dec(Sbits(1));
    %sprintf("%d",firstBit);
    if(firstBit == 1)
        %move file to ones
        csvDataONES(:,:,countforOne) = csvData(:,:,i);
        countforOne = countforOne+1;
    else
        %move file to zeros
        csvDataZEROS(:,:,countforZEROS) = csvData(:,:,i);
        countforZEROS = countforZEROS+1;
    end
end

for i = 1: 5458
    zerosAvg(:,i) = mean(csvDataZEROS(:,:,i),1);
    onesAvg(:,i) = mean(csvDataONES(:,:,i),1);
end

averageDifference = onesAvg(:,1:5458) - zerosAvg(:,1:5458);

figure1 = plot(onesAvg(2,:));
figure2 = plot(zerosAvg(2,:));
