%script to plot the differences between inter and intra

A = load('inter.txt');
B = load('intra.txt');

nA = length(A);
nB = length(B);
n1 = min(nA,nB);

A = A(1:n1,:);
B = B(1:n1,:);

pdiff = A(:,3) ./ A(:,2);
bitdiff = A(:,4) - B(:,2);
sbitdiff = round(sum(bitdiff) / n1);

figure
plot(bitdiff,pdiff,'rx')
title(['Dyadic - Average Net Effect: ' num2str(sbitdiff) ''])
xlabel('Bit Difference')
ylabel('Difference in Images (%)')


C = load('inter_single.txt');
D = load('intra_single.txt');

nC = length(C);
nD = length(D);
n2 = min(nC,nD);

C = C(1:n2,:);
D = D(1:n2,:);

pdiff_single = C(:,3) ./ C(:,2);
bitdiff_single = C(:,4) - D(:,2);
sbitdiff_single = round(sum(bitdiff_single)/n2);
figure; 
plot(bitdiff_single,pdiff_single,'rx')
title(['Single - Average Net Effect: ' num2str(sbitdiff_single) ''])
xlabel('Bit Difference')
ylabel('Difference in Images (%)')

nimages = A(:,1);
figure; 
plot(bitdiff,nimages,'rx')
title('Bit Difference per size')
xlabel('Bit Difference')
ylabel('Number of Images in Silhouette')

nimages_single = C(:,1);
figure; 
plot(bitdiff_single,nimages_single,'rx')
title('Bit Difference per Slice')
xlabel('Bit Difference')
ylabel('Number of Images in Silhouette')
