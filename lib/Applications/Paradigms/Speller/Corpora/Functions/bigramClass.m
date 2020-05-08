classdef bigramClass < handle
    %BIGRAMCLASS generates a bigram probability model
    %   The class uses ngrams function to parse corpus and generate bigrams
    %   Then it builds a bigram model from the generated bigrams
    
    properties
        delimiters;                             % word boundary characters
        parser;                                 % n-gram generator
        mdl;                                    % language model                     
        bigrams;                                % dictionary of bigrams
        biCount;                                % bigram counts
        unigrams;                               % dictionary of unigrams
        uniCount;                               % unigram counts
    end
    
    methods
        % constructor
        function self = bigramClass(delimiters, parser)
            if nargin == 1;
                parser = @ngrams;               % n-gram generator
            elseif nargin == 0;
                delimiters = {' '};             % default delimiter is whitespace
                parser = @ngrams;               % n-gram generator
            end
            self.delimiters = delimiters;       % populate the property
            self.parser = parser;               % initialize function handle
        end
        
        % builds a bigram model
        function build(self, corpus)            
            disp('Generating bigrams...')
            [big, bic, unig, unic] = ...        % generate bigrams
                self.parser(corpus, 2, self.delimiters);
            
            disp('Building a bigram model...')
            tbl = zeros(length(unig));          % build bigram table
            for i = 1:length(big)
                tokens = strsplit(big{i});      % split bigram to tokens
                prev = tokens{1};               % previous word
                next = tokens{2};               % next word
                row = strcmp(unig, prev);       % index of the previous
                col = strcmp(unig, next);       % index of the next
                tbl(row, col) = ...             % compute cond probability
                    bic(i)/unic(row);           % P(B|A) = c(A B) / c(A)
                if mod(i,1000) == 0             % every 1000 bigrams
                    fprintf('.')                % print dots to show progress
                end
            end
            fprintf('\n')
            self.mdl = tbl;                     % populate properties
            self.bigrams = big;                 
            self.biCount = bic;
            self.unigrams = unig;
            self.uniCount = unic;
        end
        
        % =======your code here======
        function prob = score(self, sentence, delimiters)
            % starter code you should replace
            sentence = lower(sentence);
            tokens = strsplit(sentence, delimiters);
            row = strcmp(tokens(1), self.unigrams);
            col = strcmp(tokens(2), self.unigrams);
            prob = self.mdl(row, col);
        end
        % =======end your code======
        
        % generates a text file for use with Wordle
        % http://www.wordle.net/advanced
        function wordle(self, stopwords)
            if nargin == 1
                url =...                        % source file URL
                    'http://www.textfixer.com/resources/common-english-words.txt';
                stopwords = webread(url);       % read the sourrce file
                stopwords = strsplit(...        % tokenize it
                    stopwords, ',');
            end
            words = self.unigrams;              % get words
            counts = self.uniCount;             % get counts
            drop = ismember(words, ...          % remove stopwords, etc.
                [stopwords {'<s>', '</s>'}]);
            words(drop) = [];   
            counts(drop) = [];
            
            f = fopen('words.txt', 'w');        % write to text file
            for i = 1:length(words)             % row by row
                fprintf(f,'%s:%d\n', ...        % foramt is 'word:count'
                    words{i}, counts(i));
            end
            fclose(f);                          % close the file
            
        end
    end
    
end
    