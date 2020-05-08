function [nUniqs, varargout] = ngrams(corpus, n, delimiters)
%NGRAMS generates n-grams from a given string
%   N-grams are grouping of sequence of words that appear together in a
%   sentence. Most commonly, we use word tokens, and they are unigrams. You
%   can also use a pair of words, and that's bigram. Trigrams use three
%   words,...all the way to N-grams for N words. This is useful to compute
%   the probabilities of word sequeneces, such as auto-complete features
%   you see on Google Search.

if nargin == 2
    delimiters = {' '};                     % default delimiter is whitespace
elseif nargin == 1
    n = 2;                                  % default is bigram
    delimiters = {' '};
end

if ischar(corpus)
    corpus  = {corpus};                     % put text into a cell array
end

tokens = cellfun(@(x) strsplit(x, ...       % split text into tokens
    delimiters), corpus, 'UniformOutput', false);

accum = cell(length(tokens),1);             % initialize accumulator
for i = 1:length(tokens)                    % loop each line
    line = tokens{i};                       % extract line
    line(cellfun(@isempty, line)) = [];     % remove empty cells
    for j = 1:(length(line) - n + 1)        % slide n-length window by 1
        seq = line(j:(j + n - 1));          % extract n-gram sequence
        seq = strjoin(seq, ' ');            % join tokens into a string
        accum{i} = [accum{i}, {seq}];       % concatenate the sequence
    end
    if mod(i,100) == 0                      % every 100 words
        fprintf('.')                        % print dots to show progress
    end
end
fprintf('\n')

accum = [accum{:}];                         % flatten the accumulator

% count the occurence of ngrams
[nUniqs, ~, idx] = unique(accum);           % remove duplicates
nCount = accumarray(idx, 1);                % count the number of duplicates

% count the occurence of unigrams
tokens = [tokens{:}];                       % flatten the cell array
tokens(cellfun(@isempty, tokens)) = [];     % remove empty token
[uniqs, ~, idx] = unique(tokens);           % remove duplicates
uniCount = accumarray(idx, 1);              % count the number of duplicates

varargout = {nCount, uniqs,...              % add optional return values
    uniCount};

end

