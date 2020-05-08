function sentences = preprocess(raw, min_length)
%PREPROCESS strips non-dialog text
%   The raw text contains more than the dialogue by characters, so we need
%   to clearn them up. Fortunately, Shakespeare's plays follow a fairly
%   standardized format.
% 
%    ACT
%
%    Scene
%  
%    Name.
%    Dialogue
%
%    [Stage Direction]

if nargin == 1
    min_length = 3;
end

%% Initial processing
% We will split the text using the standard format. 

% split text into larger sections - let's call them |paragraphs|
paragraphs = regexp(raw, '\r\n\r\n', 'split');  % split double line breaks

% split |paragraphs| into sentences
sentences = regexp(paragraphs',...              % split by punctuations
    '(?<=[!.?;:])\s', 'split');
% remove non-dialogue text
for i = 1:length(sentences)                     % loop over sentences
    if length(sentences{i}) == 1                % only 1 sentence per line
        if regexp(sentences{i}{1},...           % if starts with 'ACT...'
                '^(\r\n)*(ACT|Act).+\.$')
            sentences{i} = [];                  % remove it
        elseif regexp(sentences{i}{1},...       % if enclosed in '[]'
                '^(\r\n)*\[.+\]\.?$')
            sentences{i} = [];                  % remove stage directions
        end
    else                                        % > 2 sentences per line
        if regexp(sentences{i}{1},...           % if starts with 'Scene...'
                '^(\r\n)*Scene.+\.$')
            sentences{i} = [];                  % remove the line
        elseif regexp(sentences{i}{1},...       % if name ends with '.'
                '^(\r\n)*\d?\s?\w+\s*\w+\.$')
            sentences{i}(1) = [];               % remove it
        elseif ~isempty(regexp(sentences{i}{1},...
                '^(\r\n)*\[.+', 'once')) &&...  % if starts with '[
                ~isempty(regexp(sentences{i}{end},...
                '.+\]\.?$', 'once'))            % ends with ']'
            sentences{i} = [];                  % remove it
        end
    end
end

sentences = [sentences{:}]';                    % flatten the cell array
sentences(cellfun(@isempty, sentences)) = [];   % remove empty cells

%% Dealing with exceptions
% We have some remaining issues. 

sentences = regexprep(sentences, '\[.+\]', ''); % remove stage directions
sentences = regexp(sentences, '--', 'split');   % split by double hyphens
sentences = [sentences{:}]';                    % flatten the cell array
sentences(cellfun(@isempty, sentences)) = [];   % remove empty cells
sentences = regexprep(sentences, '^\n\r', '');  % remove LFCR
sentences = regexprep(sentences, '^\r\n', '');  % remove CRLF
sentences = regexprep(sentences, '^\n', '');    % remove LF
sentences = regexprep(sentences, '^\r', '');    % remove CR
sentences = regexprep(sentences, '^:', '');     % remove colon
sentences = regexprep(sentences, '^\.', '');    % remove period
sentences = regexprep(sentences, '^\s', '');    % remove space
sentences(cellfun(@isempty, sentences)) = [];   % remove empty cells

%% Remove short ssentences
% If a sentence is too short, then it doesn't help. 

tokens = cellfun(@strsplit, sentences,...       % tokenize sentences
    'UniformOutput', false);
isShort = cellfun(@length, tokens) < min_length;% shorter than minimum?
sentences(isShort)= [];                         % remove short sentences

%% Add Sentence Markers
% Now we have mostly clean data. For further processing, we need to add <s>
% and </s> to mark the start and the end of sentences. 

for i = 1:length(sentences)
    sentences{i} = ['<s> ' strtrim(sentences{i}) ' </s>'];
end

end

