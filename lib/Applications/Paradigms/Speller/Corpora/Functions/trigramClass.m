classdef trigramClass < bigramClass
    %TRIGRAMCLASS extends bigramClass to support a trigram probability model
    %   The class uses ngrams function to parse corpus and generate trigrams
    %   Then it builds a trigram model from the generated trigrams and a
    %   bigram model.
    
    properties
        trigrams;                               % dictionary of trigrams
        triCount;                               % trigram counts
        bigMdl;                                 % bigram language model
    end
    
    methods
        % constructor
        function self = trigramClass(delimiters, parser)
            if nargin == 1;
                parser = @ngrams;               % n-gram generator
            elseif nargin == 0;
                delimiters = {' '};             % default delimiter is whitespace
                parser = @ngrams;               % n-gram generator
            end
            % call superclass constructor
            self@bigramClass(delimiters, parser);
        end   
        
        % builds a trigram model
        function build(self, corpus, biMdl)        
            disp('Generating trigrams...')
            [trig, tric, ~, ~] = ...            % generate trigrams
                self.parser(corpus, 3, self.delimiters);
            
            disp('Building a trigram model...')
            big = biMdl.bigrams;                % retrieve biMdl properties
            bic = biMdl.biCount;
            unig = biMdl.unigrams;
            unic = biMdl.uniCount;
                  
            tbl = zeros(length(big), ...        % build trigram table 
                length(unig));
            for i = 1:length(trig)
                tokens = strsplit(trig{i});     % split trigram to tokens
                prev = strjoin(tokens(1:2),' ');% join the first two
                next = tokens{3};               % next word
                row = strcmp(big, prev);        % index of the previous
                col = strcmp(unig, next);       % index of the next
                tbl(row, col) = ...             % compute cond probability
                    tric(i)/bic(row);           % P(B|A) = c(A B) / c(A)
                if mod(i,1000) == 0             % every 1000 trigrams
                    fprintf('.')                % print dots to show progress
                end
            end
            fprintf('\n')
            self.trigrams = trig;               % populate properties
            self.triCount = tric;
            self.mdl = tbl;
            self.bigMdl = biMdl.mdl;
            self.bigrams = big;                 
            self.biCount = bic;
            self.unigrams = unig;
            self.uniCount = unic;
        end
    end
    
end

