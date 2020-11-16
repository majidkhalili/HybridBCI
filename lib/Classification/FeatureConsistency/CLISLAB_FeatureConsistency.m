function trainfeats = CLISLAB_FeatureConsistency(trainfeats_in,blockSize)
% It rejects the features with non-homogeneous distribution across p 
% independent samples (blocks) according to chi-squared homogeneity tests 
% corrected with FDR method.
% It also takes out features for which no decision could be made because
% the recommendations to perform the test were not met.
% The FDR correction for multiple tests is the one specified in
% Benjamini, Y., & Hochberg, Y. (1995). Controlling the False Discovery Rate: A Practical and Powerful Approach to Multiple Testing. Journal of the Royal Statistical Society. Series B (Methodological), 57(1), 289-300.

% Input arguments:
% 'features' structure
% 'blockSize', 1*p vector with the number of trials in each of the p blocks

% The number of blocks p must be p>1
% Each block should have sample size n_i >=15 
p=size(blockSize,2);
if p>1 && sum(blockSize<15)==0
    m=size(trainfeats_in.features,2);
    mark=[0 cumsum(blockSize)];
    pvs=zeros(1,m);
    % For each feature, we find the p-value of chi-squared homogeneity test
    % with k=3 classes and p samples
    for i=1:m
        trainfeat=trainfeats_in.features(:,i);
        % The sample space is partitioned in three classes. The limits of
        % the partition are defined, in this case, by mean-+(std/2) 
        lim=[mean(trainfeat)-(std(trainfeat)/2) mean(trainfeat)+(std(trainfeat)/2)];
        obs=zeros(p,3);
        % We find the matrix of observed frequencies of each sample in each
        % class
        for j=1:p
            sample=trainfeat(mark(j)+1:mark(j+1));
            obs(j,:)=[sum(sample<lim(1)) sum(sample>=lim(1) & sample<=lim(2)) sum(sample>lim(2))];
        end
        pvs(i)=ChiTest(obs);
    end
    % Correcting for multiple testing using the Benjamini-Hochberg method
    pvalues=pvs(pvs>=0 & pvs<=1);
    % BH method, step 1: ordering p-values, not assumed independent
    psort=sort(pvalues);
    % BH method, step 2: finding the rejection index R, with alpha=0.05
    ind=1:length(psort);
    l=(0.05*ind)./(length(psort)*sum(1./ind));
    R=max(find(psort<=l));
    % BH method, step 3: finding the BH rejection threshold T
    if ~isempty(psort(R))
        T=psort(R);
    else
        T=0;
    end
    % BH method, step 4: rejecting all H_0i such that P_i<=T and accepting
    % the rest.
    % Also taking out features for which no decision could be made because
    % the recommendations to perform the test were not met.
    fdr_out=(pvs>T & pvs<=1)';
    
    % Keeping only the features with distributions which are accepted as
    % homogeneous across blocks
    trainfeats.features = trainfeats_in.features(:,fdr_out);
    trainfeats.featuresLabels = trainfeats_in.featuresLabels(fdr_out,:);
    trainfeats.classLabels = trainfeats_in.classLabels;
else
    trainfeats = trainfeats_in;
end

end

function pv=ChiTest(obs)
% REFERENCE:
% Pearson, K. (1900) On the Criterion That a Given System of Deviations from the Probable in the Case of a Correlated System 
% of Variables Is Such That It Can Be Reasonably Supposed to Have Arisen from Random Sampling. 
% Philosophical Magazine Series 5, 50, 157-175.
% http://dx.doi.org/10.1080/14786440009463897

% The input 'obs' is a contingency matrix of the form p samples * k classes
% with the observed frequencies of each sample in each class.
% The output 'pv' is the p-value for chi-squared homogeneity test if the test
% (strong) recommendations are fulfilled and -1 otherwise.

% Details of the test can be found, for example, in:
% Devore J.L., Berk K.N. (2012) Goodness-of-Fit Tests and Categorical Data Analysis. 
% In: Modern Mathematical Statistics with Applications. Springer Texts in Statistics. Springer, New York, NY

[p,k]=size(obs);
classes=sum(obs,1);
blocks=sum(obs,2);
n=sum(blocks);
% Defining the matrix of estimated expected frequencies under the null
% hypothesis
exp=(blocks*classes)./n;
% The test (strong) recommendations are that all estimated expected
% frequencies be e_ij >=5
flat=reshape(exp,1,[]);
if sum(flat<5)==0
    % Finding the homogeneity test statistic, as well as the degrees of freedom 
    % of the chi-squared distribution
    dif=((obs-exp).^2)./exp;
    T=sum(sum(dif));
    df=(p-1)*(k-1);
    % Computing the p-value
    pv=1-chi2cdf(T,df);
else
    % The test (strong) recommendations were not fulfilled
    pv=-1;
end
end
