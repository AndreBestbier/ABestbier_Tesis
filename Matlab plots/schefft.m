function [SFT,F]=schefft(x,varargin);
% SCHEFFT Compute the FFT of signal with averages and a Hanning window.
% [SFT,F] = schefft(X,Fs,AVG) calculates an N-point one-sided absolute
% value fft for the input signal X. The signal X is divided into AVG
% number of sections and each section is windowed with a Hanning window
% and detrended. The fft is then calculated by averaging the ffts
% of the windowed sections. The value for N is calculated automatically
% for best results, and will depend on the length of X and AVG.
%
% Inputs:
% X - time signal (NB: Most accurate result if length(X)=2^n)
% Fs - sampling frequency in Hz [optional, default = 1]
% AVG - the number of averages to be calculated [optional, default = 1]
%
% Outputs:
% SFT - the N point one-sided fft of signal X
% F - frequency vector for the fft
%
% SCHEFFT with no output arguments will plot the calculated fft.
%
% NOTE: This software is intended for R & D purposes and is
% not intended for commercial use.
%
% See also: SCHEFFT2
%
% C. SCHEFFER (updated 14-5-2001)
% Inputs
x=x(:);
m=mean(x);
x=x-m;
[dum,D]=size(varargin);
if D==2
 fs=varargin{1};
 avg=varargin{2};end
if D==1
 fs=varargin{1};
 avg=[];end
if D==0
 fs=[];
 avg=[];end
if isempty(fs)==1
 fs=1;end
if isempty(avg)==1
 avg=1;end
N=length(x);
if avg==1
 % Window
 [row,col]=size(x);
 window=hanning(row);
 s=x.*window;

 % Detrend the input
 s=detrend(s);

 % Take the fft
 ans=(fft(s,N));
 spec=2*ans(1:floor(N/2));

 % Compensate for enegy loss through window & real sampling rate
 SFT=2*spec/N;

 % Construct frequency vector
 delF=fs/N;
 endF=(N/2-1)*delF;
 F=(0:delF:endF);
 F=F(:);
end
if avg>1

 % Divide the signal in sections
 lx=length(x);
 nx=fix(lx/avg);
 idx=1;
 for i=1:avg
 s(:,i)=x(idx:idx+nx-1);
 idx=(nx*i)+1;
 end
 [row,col]=size(s);

 % Take the fft
 for i=1:avg
 [spec(:,i),F]=schefft(s(:,i),fs);
 end
 [row,col]=size(spec);

 % Add all for the average
 SFT=0;
 for i=1:col
 SFT=SFT+abs(spec(:,i));
 %SFT=SFT+(spec(:,i));
 end
 SFT=SFT/avg;

end
SFT=abs(SFT);
%SFT=SFT;
% Plot the result
if nargout==0
 figure
 plot(F,SFT)
 xlabel('frequency [Hz]')
 ylabel('magnitude')
 zoom on
 title('FFT computed with SCHEFFT')
end