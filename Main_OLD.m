%Declare variables needed for the entire program

clear

RO_data = zeros(512,100,193);
fileNames = dir('fullFreqData/*.csv');
mean_data = zeros(512,193);
PUF_signatures = zeros(256,193);
intra_chip_signatures = zeros(256,100,193);
intra_chip_hamming = zeros(1,4950,193);

%Part A & B
%Import all the data into a 512x100x193 array
%Compute the mean accross all the 193 FPGA's and rearrange into a 16x32
%layout.

for i = 1:size(fileNames,1)
    s = sprintf('fullFreqData/%s',fileNames(i).name);
    RO_data(:,:,i) = csvread(s);
    mean_data(:,i) = mean(RO_data(:,:,i),2);
end

RO_mean = mean(mean_data,2);
RO_meanReshape = reshape(RO_mean,16,32);
figure1 = figure('name', 'FPGA Frequencies');
imagesc(RO_meanReshape);
colorbar;

mean_data2 = reshape(mean_data,193,512);
%Part C
%Compare PUF response between pair of RO's in each FPGA then compare
%the hamming distance between the signature response across all FPGAs

for j = 1:size(mean_data, 2)
    for i = 1:2:size(mean_data, 1)-1
        if(mean_data(i,j) > mean_data(i+1,j))
            bit = 0;
        else
            bit = 1;
        end
        PUF_signatures(ceil(i/2),j) = bit;
    end
end

PUF_signatures = PUF_signatures'; %Need to reshape for hamming
inter_chip_hamming = pdist(PUF_signatures, 'hamming');

figure2 = figure('name', 'Inter-Chip Hamming Distance');
hist(inter_chip_hamming, 16);
title('Inter-Chip Hamming Distance');

hamming_mean = mean(inter_chip_hamming);
hamming_std = std(inter_chip_hamming);
set(annotation(figure2, 'textbox', [.6 .75 .1 .1]), 'String', {sprintf('Mean = %.5f', hamming_mean), sprintf('Std Dev = %.5f', hamming_std)});

%Part D
%Compare frequencies for each measurement and produce a bit response
for k = 1:size(RO_data,3)
    for j = 1:size(RO_data,2)
        for i = 1:2:size(RO_data,1)-1
            if(RO_data(i,j,k) > RO_data(i+1,j,k))
                bit = 0;
            else
                bit = 1;
            end
            intra_chip_signatures(ceil(i/2),j,k) = bit;
        end
    end
end

%Reshape needed for pdist hamming function
%intra_chip_signatures = reshape(intra_chip_signatures,100,256,193);
intra_chip_signatures = permute(intra_chip_signatures, [2 1 3]); 

%Intra-chip hamming between all measurements across all 193 FPGAs
for i = 1:size(intra_chip_signatures, 3)
    intra_chip_hamming(:,:,i) = pdist(intra_chip_signatures(:,:,i), 'hamming');
end

%Mean of the hamming distance for each measurement across all 193 FPGAs
intra_chip_mean = mean(intra_chip_hamming, 3);
intra_chip_std = std(intra_chip_mean);

%Plot it

figure3 = figure('name', 'Intra-Chip Hamming Distance Mean');
hist(intra_chip_mean, 16);
set(annotation(figure3, 'textbox', [.6 .75 .1 .1]), 'String', {sprintf('Mean = %.5f', mean(intra_chip_mean)), sprintf('Std Dev = %.5f', intra_chip_std)});
title('Intra-Chip Hamming Distance Mean');


%Bonus
%Compute a 256-bit response from an RO and the neighbor below it
%To get the neighbor "below it" we need to reshape into a 16x32x193 format
%This will allow me to compare column-wise at each row (ex: RO1 & RO17)
Bonus_RO_meanReshape = reshape(mean_data,16,32,193);
Bonus_PUF_signatures = zeros(16,16,193);
for k = 1:size(Bonus_RO_meanReshape, 3)
    for j = 1:2:size(Bonus_RO_meanReshape, 2)-1
        for i = 1:size(Bonus_RO_meanReshape, 1)
            if(Bonus_RO_meanReshape(i,j,k) > Bonus_RO_meanReshape(i,j+1,k))
                bit = 0;
            else
                bit = 1;
            end
            Bonus_PUF_signatures(i,ceil(j/2),k) = bit;
        end
    end
end

%Reshape it into a format to compute the hamming distance
Bonus_PUF_signatures_reshape = reshape(Bonus_PUF_signatures,256,193);
%Transpose it to have 193 rows of 256-bit responses to compare
Bonus_PUF_signatures_reshape = transpose(Bonus_PUF_signatures_reshape);
Bonus_hamming = pdist(Bonus_PUF_signatures_reshape, 'hamming');

figure4 = figure('name', 'Bonus Hamming Distance');
hist(Bonus_hamming, 16);
set(annotation(figure4, 'textbox', [.6 .75 .1 .1]), 'String', {sprintf('Mean = %.5f', mean(Bonus_hamming)), sprintf('Std Dev = %.5f', std(Bonus_hamming))});
title('Bonus Hamming Distance');
