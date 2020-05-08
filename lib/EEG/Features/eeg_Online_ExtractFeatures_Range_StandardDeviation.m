function [tempFeature] = eeg_Online_ExtractFeatures_Range_StandardDeviation(Data, fs, passbandInterval)
% Wu and AJG: range features were delivering suspectful high accuracies.
% Parameter deffinition for range creation was wrong. Feature functions are corrected.

% Parameters for generating ranges
windowLength	=   (size(Data,2)/fs)/8; %Half the length of the time
overlapping     =   50; %50% overlapping, half the length of the windows
% padding         =   5000;
typeWindows     =    'rect';

% Generating Range
rangeSignal = gen_rEEG(Data,fs, windowLength, overlapping, typeWindows, 0);

% Calculating the Range Assymetry
tempFeature = nanstd(rangeSignal);
if isnan(tempFeature)
    tempFeature = NaN;
else
    
end

end



function reeg=gen_rEEG(Data, Fs, windowLength, overlapping, typeWindows ,APPLY_LOG_LINEAR_SCALE)
%---------------------------------------------------------------------
% generate the peak-to-peak measure (rEEG)
%---------------------------------------------------------------------

[L_hop,L_epoch,win_epoch]=gen_epoch_window(overlapping,windowLength,typeWindows,Fs);


N=length(Data);
N_epochs=floor( (N-(L_epoch-L_hop))/L_hop );
if(N_epochs<1)
    N_epochs=1;
end
nw=0:L_epoch-1;

%---------------------------------------------------------------------
% generate short-time FT on all data:
%---------------------------------------------------------------------
reeg=NaN(1,N_epochs);
for k=1:N_epochs
    nf=mod(nw+(k-1)*L_hop,N);
    Data_epoch=Data(nf+1).*win_epoch(:)';
    
    reeg(k)=max(Data_epoch)-min(Data_epoch);
end
% no need to resample (as per [1])


% log--linear scale:
if(APPLY_LOG_LINEAR_SCALE)
    ihigh=find(reeg>50);
    if(~isempty(ihigh))
        reeg(ihigh)=50.*log(reeg(ihigh))./log(50);
    end
end
end

function [L_hop,L_epoch,win_epoch]=gen_epoch_window(L_overlap,L_epoch,win_type,Fs,GEN_PSD)
if(nargin<5 || isempty(GEN_PSD)), GEN_PSD=0; end


L_hop=(100-L_overlap)/100;


L_epoch=floor( L_epoch*Fs );

% check for window type to force constant-overlap add constraint
% i.e. \sum_m w(n-mR)=1 for all n, where R=overlap size
win_type=lower(win_type(1:4));


if(GEN_PSD)
    %---------------------------------------------------------------------
    % if PSD
    %---------------------------------------------------------------------
    L_hop=ceil( (L_epoch-1)*L_hop );
    
    win_epoch=get_window(L_epoch,win_type);
    win_epoch=circshift(win_epoch,floor(length(win_epoch)/2));
    
else
    %---------------------------------------------------------------------
    % otherwise, if using an overlap-and-add method, then for window w[n]
    % ∑ₘ w[n - mR] = 1 over all n (R = L_hop )
    %
    % Smith, J.O. "Overlap-Add (OLA) STFT Processing", in
    % Spectral Audio Signal Processing,
    % http://ccrma.stanford.edu/~jos/sasp/Hamming_Window.html, online book,
    % 2011 edition, accessed Nov. 2016.
    %
    %
    % there are some restrictions on this:
    % e.g. for Hamming window, L_hop = (L_epoch-1)/2, (L_epoch-1)/4, ...
    %---------------------------------------------------------------------
    
    switch win_type
        case 'hamm'
            L_hop=(L_epoch-1)*L_hop;
        case 'hann'
            L_hop=(L_epoch+1)*L_hop;
        otherwise
            L_hop=L_epoch*L_hop;
    end
    
    L_hop=ceil(L_hop);
    
    win_epoch=get_window(L_epoch,win_type);
    win_epoch=circshift(win_epoch,floor(length(win_epoch)/2));
    
    if( strcmpi(win_type,'hamm')==1 && rem(L_epoch,2)==1 )
        win_epoch(1)=win_epoch(1)/2;
        win_epoch(end)=win_epoch(end)/2;
    end
end
end

function win = get_window( win_length, win_type, win_param, DFT_WINDOW, Npad )
if( nargin<3 ) win_param=[]; end
if( nargin<4 ) DFT_WINDOW=0; end
if( nargin<5 ) Npad=0; end


win=get_win(win_length,win_type,win_param,DFT_WINDOW);
win=shift_win(win);

if(Npad>0)
    win=pad_win(win,Npad);
end
end

function win=get_win(win_length, win_type, win_param, DFT_WINDOW )
%--------------------------------------------------------------------------------
% Get the window. Negative indices are first.
%--------------------------------------------------------------------------------

switch win_type
    case {'delt', 'delta'}
        win=zeros(win_length,1);
        wh = floor(win_length/2);
        win(wh+1)=1;
    case {'rect' , 'rectangular'}
        win(1:win_length) = 1;
    case {'bart', 'bartlett'}
        win = bartlett( win_length );
    case {'hamm', 'hamming'}
        win = hamming( win_length );
    case {'hann', 'hanning'}
        win = hanning( win_length );
    case {'tuke', 'tukey' }
        % NOTE: seems to be problem with Octave's (v2.9.12) tukeywin.m for N odd.
        if(isempty(win_param))
            win = tukeywin( win_length );
        else
            win = tukeywin( win_length, win_param );
        end
    case {'gaus','gauss'}
        if(isempty(win_param))
            win = gausswin( win_length );
        else
            win = gausswin( win_length, win_param );
        end
    case 'cosh'
        win_hlf = fix( win_length / 2);
        
        if(isempty(win_param))
            win_param = 0.01;
        end
        for m = -win_hlf:win_hlf
            win(mod(m,win_length)+1) = cosh( m ).^( -2 * win_param );
        end
        win = fftshift(win);
        
        
    otherwise
        error(['Unknown window type ' win_type]);
end


%---------------------------------------------------------------------
% If want the DFT of win
%---------------------------------------------------------------------
if(DFT_WINDOW)
    win=circshift(win(:),ceil(win_length/2));
    win=fft(win);
    win=circshift(win(:),floor(win_length/2));
end
end

function w=shift_win(w)
%--------------------------------------------------------------------------------
% Shift the window so that positive indices are first.
%--------------------------------------------------------------------------------
N=length(w);
w=circshift(w(:),ceil(N/2));
end

function w_pad=pad_win(w,Npad)
%--------------------------------------------------------------------------------
%
% Pad window to Npad.
%
% Presume that positive window indices are first.
%
% When N is even use method described in [1]
%
%   References:
%     [1] S. Lawrence Marple, Jr., Computing the discrete-time analytic
%     signal via FFT, IEEE Transactions on Signal Processing, Vol. 47,
%     No. 9, September 1999, pp.2600--2603.
%
%--------------------------------------------------------------------------------
w=w(:);
w_pad=zeros(Npad,1);
N=length(w);
Nh=floor(N/2);
if(Npad<N) error('Npad is less than N'); end


% Trival case:
if(N==Npad)
    w_pad=w;
    return;
end


% For N odd:
if( rem(N,2)==1 )
    n=0:Nh;
    w_pad(n+1)=w(n+1);
    n=1:Nh;
    w_pad(Npad-n+1)=w(N-n+1);
    
    % For N even:
    % split the Nyquist frequency in two and distribute over positive
    % and negative indices.
else
    n=0:(Nh-1);
    w_pad(n+1)=w(n+1);
    w_pad(Nh+1)=w(Nh+1)/2;
    
    n=1:Nh-1;
    w_pad(Npad-n+1)=w(N-n+1);
    w_pad(Npad-Nh+1)=w(Nh+1)/2;
end

end
