function sentences = corpusReader(corpus_file)

% load the corpus in UTF8
% corpus = fileread(corpus_file);
fid = fopen(corpus_file,'r','n','UTF-8');
corpus = fread(fid,'*char')';
fclose(fid);

% convert german letter to ascii readable
% corpus = replace(corpus,{'ä','ö','ü','ß'},{'ae','oe','ue','ss'});

% split the corpus in paragraphs
paragraphs = regexp(corpus, '\n', 'split');

% adjust each sentence removing the numbers at the beginning
sentences = regexprep(paragraphs, '^\d+\t', '');

% for i = 1:length(sentences)
%     sentences{i} = ['<s> ' strtrim(sentences{i}) ' </s>'];
% end