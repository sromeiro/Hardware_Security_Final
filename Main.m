%Main program
%Students:
%Esthevan Romeiro
%Brett Wilson
%Amber Hamlet

%clear %clears the workspace

fileNames = dir('Data/CSVData/*.csv');
csvData = zeros(5003, 2, 10936);
messageData = reshape(blanks(174976),10936,16); %creates 10936x16 char array
cipherData = reshape(blanks(174976),10936,16); %creates 10936x16 char array
messageBinary = zeros(10936, 64); %Stores all messages in Binary
cipherBinary = zeros(10936, 64); %Stores all ciphers in Binary
keyBinary = zeros(1, 64); %Stores the key in Binary

%========================STORING OF CSV DATA==============================%
% for i = 1:size(fileNames,1)
%     s = sprintf('Data/CSVData/%s',fileNames(i).name);
%     csvData(:,:,i) = csvread(s);
% end
%=========================================================================%

%Finds the underscore delimiters separating the message, key and cipher
delimiters = strfind(fileNames(1).name, '_');

%Store the key
keyData = fileNames(1).name(36 : delimiters(7)-1);

%For loop to store the key in Binary form array 16x4
% for i = 1 : size(keyData, 2)
%     keyBinary(i,:) = hexToBinaryVector(keyData(1,i),4);
% end

%For loop to store all of the messages, key and ciphertexts
for i = 1 : size(fileNames, 1)
    messageData(i, :) = fileNames(i).name(55 : delimiters(8)-1);
    cipherData(i, :) = fileNames(i).name(delimiters(8)+3 : 89);
end

%======================BINARY CONVERSION OF DATA==========================%
%For loop to store the message and cipher in Binary form
% for i = 1 : size(fileNames, 1)
%     messageBinary(i,:) =  hexToBinaryVector(messageData(i,:),64);
%     cipherBinary(i,:) = hexToBinaryVector(cipherData(i,:),64);
% end
% 
% %Store the key in Binary form
% keyBinary = hexToBinaryVector(keyData,64);
%=========================================================================%

