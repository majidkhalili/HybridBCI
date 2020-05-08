function features = CLISLAB_FeaturesDimensionReductionNewVersion(features, K)
% A modified minimum Redundance-Maximum Relevance algorithm

% Based on the original one by Hanchuan Peng
% [TPAMI05] Hanchuan Peng, Fuhui Long, and Chris Ding, "Feature selection based on mutual information: criteria of max-dependency, max-relevance, and min-redundancy," IEEE Transactions on Pattern Analysis and Machine Intelligence, Vol. 27, No. 8, pp.1226-1238, 2005.
% [JBCB05] Chris Ding, and Hanchuan Peng, "Minimum redundancy feature selection from microarray gene expression data," Journal of Bioinformatics and Computational Biology, Vol. 3, No. 2, pp.185-205, 2005.
% [CSB03] Chris Ding, and Hanchuan Peng, "Minimum redundancy feature selection from microarray gene expression data," Proc. 2nd IEEE Computational Systems Bioinformatics Conference (CSB 2003), pp.523-528, Stanford, CA, Aug, 2003.
% [IS05] Hanchuan Peng, Chris Ding, and Fuhui Long, "Minimum redundancy maximum relevance feature selection," IEEE Intelligent Systems, Vol. 20, No. 6, pp.70-71, November/December, 2005.
% [Bioinfo07] Jie Zhou, and Hanchuan Peng, "Automatic recognition and annotation of gene expression patterns of fly embryos," Bioinformatics, Vol. 23, No. 5, pp. 589-596, 2007.
% The mRMR software packages can be downloaded and used, subject to the following conditions: Software and source code Copyright (C) 2000-2007 Written by Hanchuan Peng. These software packages are copyright under the following conditions: Permission to use, copy, and modify the software and their documentation is hereby granted to all academic and not-for-profit institutions without fee, provided that the above copyright notice and this permission notice appear in all copies of the software and related documentation and our publications (TPAMI05, JBCB05, CSB03, etc.) are appropriately cited. Permission to distribute the software or modified or extended versions thereof on a not-for-profit basis is explicitly granted, under the above conditions. However, the right to use this software by companies or other for profit organizations, or in conjunction with for profit activities, and the right to distribute the software or modified or extended versions thereof for profit are NOT granted except by prior arrangement and written consent of the copyright holders. For these purposes, downloads of the source code constitute "use" and downloads of this source code by for profit organizations and/or distribution to for profit institutions in explicitly prohibited without the prior consent of the copyright holders. Use of this source code constitutes an agreement not to criticize, in any way, the code-writing style of the author, including any statements regarding the extent of documentation and comments present. The software is provided "AS-IS" and without warranty of any kind, expressed, implied or otherwise, including without limitation, any warranty of merchantability or fitness for a particular purpose. In no event shall the authors be liable for any special, incidental, indirect or consequential damages of any kind, or any damages whatsoever resulting from loss of use, data or profits, whether or not advised of the possibility of damage, and on any theory of liability, arising out of or in connection with the use or performance of these software packages.

% Adapted by Berrendero, Cuevas and Torrecilla replacing 'mutual 
% information' with 'square distance correlation', a measure introduced by 
% Szekely, Rizzo and Bakirov.
% J.R. Berrendero, A. Cuevas & J.L. Torrecilla (2016) The mRMR variable selection method: a comparative study for functional data, Journal of Statistical Computation and Simulation, 86:5, 891-907, DOI: 10.1080/00949655.2015.1042378


% Input arguments:
% features.features:           N*M matrix, indicating N trials, each having M features.
% features.classLabels:        N*1 vector, indicating the class/category of each N trial. Must be categorical
% features.featuresLabels:     M*3 matrix, indicating the labels identifying each of the extracted feature 
% K:                           The percentage of features to select, to be determined by the user

% Main function of mRMR
X=features.features;
Y=features.classLabels;
k=round(size(features.features,2)*K/100);
[n,p]=size(X);
indexes=1:p;
% Finding the most relevant feature
relevance=zeros(1,p);
for i=1:p
    relevance(i)=dcor2(X(:,i),Y);
end
S=zeros(1,k);
[~,S(1)]=max(relevance);
indexes(indexes==S(1))=[];
redundance=zeros(p,p);
% In each iteration until k, selecting the feature which maximizes the
% 'relevance minus redundance' criterion
for i=2:k
    % Finding the redundancies of the last selected variable
    for j=1:p
        redundance(S(i-1),j)=dcor2(X(:,S(i-1)),X(:,j));
        redundance(j,S(i-1))=redundance(S(i-1),j);
    end
    % Finding the variable which maximizes the criterion out of all the ones
    % that have not yet been selected
    [~,ind]=max(relevance(indexes)-mean(redundance(S(1:i-1),indexes),1));
    S(i)=indexes(ind);
    indexes(indexes==S(i))=[];
end
index_selected_features=S;

% Replacing the actual "features" structure, by the selected shortened version
features.features = features.features(:,index_selected_features);
features.featuresLabels = features.featuresLabels(index_selected_features,:);

end

function r2=dcor2(x,y)
% Empirical square distance correlation between two column vectors of arbitrary
% dimensions, introduced by Szekely, Rizzo and Bakirov
% Székely, Gábor J.; Rizzo, Maria L.; Bakirov, Nail K. Measuring and testing dependence by correlation of distances. Ann. Statist. 35 (2007), no. 6, 2769--2794. doi:10.1214/009053607000000505. https://projecteuclid.org/euclid.aos/1201012979

% We find the distance matrices A and B
A=pdist2(x,x);
B=pdist2(y,y);
[n,~]=size(x);

% We follow the procedure described by Székely et al.
a0l=ones(n,1)*(sum(A,1)/n);
ak0=(sum(A,2)/n)*ones(1,n);
a00=((1/n^2)*ones(n,n)).*sum(sum(A));
AA=A-a0l-ak0+a00;

b0l=ones(n,1)*(sum(B,1)/n);
bk0=(sum(B,2)/n)*ones(1,n);
b00=((1/n^2)*ones(n,n)).*sum(sum(B));
BB=B-b0l-bk0+b00;

% We find the empirical (square) distance correlation
vAB=(1/n^2)*sum(sum(AA.*BB));
if vAB==0
    r2=vAB;
else
    vAA=(1/n^2)*sum(sum(AA.*AA));
    vBB=(1/n^2)*sum(sum(BB.*BB));
    r2=vAB/sqrt(vAA*vBB);
end

end
