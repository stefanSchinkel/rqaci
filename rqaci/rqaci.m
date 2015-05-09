function varargout = rqaci(varargin)

%RQACI - compute confidence bounds of RQA measures from RP
%
% function [val ci] = rqaci(RP,[nBoot,alpha,theiler,minL,minV])
%
% Compute confidence bounds of RQA measures from an RP
% by bootstrapping the diagonal and vertical line structures.
% A GUI for this programme is provided by: rqaciGUI
%
% Input:
% 	nBoot = number of bootstrap samples (def: 500)
% 	alpha = confidence level in % (def: 5-two-sided)
% 	theiler = size of the theiler window (def: 1)
% 	minL = minimal size of diagonal lines in RQA (def: 2)
% 	minV = minimal size of vertical lines in RQA (def: 2)
%
% Output:
%	val(1) = reference values for DET
%	val(2) = reference values for L
%	val(3) = reference values for LAM
%	val(4) = reference values for TT
%
%	ci = confidence bounds of values in val
%
% requires: prctile (Statistics Toolbox)
%
% see also: opTool, opcrqa.m, opcrp.m, CRPtool
%
% References: 
% S. Schinkel, N. Marwan, O. Dimigen & J. Kurths (2009): 
% "Confidence Bounds of recurrence-based complexity measures"
% Physics Letters A,  373(26), pp. 2245-2250
%

% Copyright (C) 2009 Stefan Schinkel, University of Potsdam
% http://www.agnld.uni-potsdam.de 
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

% $Log$


%% I/O check
if (nargchk(1,6,nargin)), help(mfilename),return; end
if (nargchk(0,2,nargout)), help(mfilename),return; end

varargin{7} = [];

% input assignment 
RP = varargin{1};
if ~isempty(varargin{2}), nBoot = varargin{2}; else nBoot = 500;end
if ~isempty(varargin{3}), alpha = varargin{3}; else alpha = 1;end
if ~isempty(varargin{4}), theiler = varargin{4}; else theiler = 1;end
if ~isempty(varargin{5}), minLenDiag = varargin{5}; else minLenDiag = 2;end
if ~isempty(varargin{6}), minLenVert = varargin{6}; else minLenVert = 2;end


% necessary params
confBounds = [100-alpha/2 0+alpha/2];

% get line distributions (all length)
[diagLines vertLines] = lineDists(RP,theiler);

% compute RQA reference values
sumDL = sum(diagLines);
sumVL = sum(vertLines);

diagReference = diagLines(diagLines >= minLenDiag);
vertReference = vertLines(vertLines >= minLenVert);

out(1) = sum(diagReference)/sumDL;
out(2) = mean(diagReference);
out(3) = sum(vertReference)/sumVL;
out(4) = mean(vertReference);

% bootstrap one sample at a time, otherwise it kills the box

% alloc memory of bootstrapped values
bsDET = zeros(1,nBoot);
bsL = zeros(1,nBoot);
bsLAM = zeros(1,nBoot);
bsTT = zeros(1,nBoot);

for i=1:nBoot
	
	% avoid 100s of divideByZero etc. errors
	warning('off','all')

	% bootstap line distribution
	bsDistDl = bootstrap(diagLines,1);
	bsDistVl = bootstrap(vertLines,1);

	%total no. of lines in bootstrapped distributions
	sumTempDL = sum(bsDistDl);
	sumTempVl = sum(bsDistVl);

	% exclude too short lines
	bsDistDl(bsDistDl < minLenDiag) = [];
	bsDistVl(bsDistVl < minLenVert) = [];

	% complexity measures
	bsDET(i) = sum(bsDistDl)/sumTempDL;
	bsL(i)  = mean(bsDistDl);
	bsLAM(i) = sum(bsDistVl)/sumTempVl;
	bsTT(i) = mean(bsDistVl);
end

ci(1,:) = prctile(bsDET,confBounds);
ci(2,:) = prctile(bsL,confBounds);
ci(3,:) = prctile(bsLAM,confBounds);
ci(4,:) = prctile(bsTT,confBounds);


varargout{1} = out;
varargout{2} = ci;



