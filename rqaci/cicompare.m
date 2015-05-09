function out = cicompare(X,Y)

%
%CICOMPARE - compare confidence interval(s)
%
% function out = compareci(X,Y)
%
% The function compares to confidence intervals (CI) or
% a CI and a vector (univariate timeseries, eg. mean)
% provided in X and Y and encodes their relations as:
%
%	X > Y = -1
%	X = Y = 0
%	Y > X = 1
%
% With the default pcolor colourmap that ensures that X > Y is
% is blue, X=Y is green and Y > X is red in a pcolor plot
% (which will be shown if no output is required)
%
% Input:
%	X = confidence interval A
%	Y = confidence interval B
%	with
%		X/Y(1,:) = upper conf. bound
%		X/Y(2,:) = lower conf. bound
%	or
%	Y = vector B (eg mean of B)
%
% Output:
%	out = vector denoting relation
%
% requires:
%
% see also: ciplot.m rqaci.m
%

% Copyright (C) 2007-2015 Stefan Schinkel <mail@dreeg.org>
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
if (nargchk(2,2,nargin)), help(mfilename),error(nargchk(2,2,nargin)); end
if (nargchk(0,1,nargout)), help(mfilename),error(nargchk(0,2,nargout)); end

if length(X) ~= length(Y)
	error('Length of confidence intervals must match.')
end

% make sure the array as are 2xN
% actually pointless, but even I forget
% to provide correct size, sigh!
if size(X,1) > size(X,2); X = X'; end
if size(Y,1) > size(Y,2); Y = Y'; end

if isvector(Y)

	%compare CI and vector

	xLarger = X(2,:) > Y;
	yLarger = X(1,:) < Y;

else
	%to find overlaps as well use:
	%overlaps = max(X(2,:),Y(2,:)) <= min(X(1,:),Y(1,:));

	%compare 2 CIs
	xLarger = X(2,:) > Y(1,:);
	yLarger = X(1,:) < Y(2,:);

end

%alloc output for all is equal
out=zeros(1,length(X));

%assign comparison outcome
out(xLarger) = -1;
out(yLarger) = 1;

%plot if not assigned
if ~nargout
	pcolor([out;out]);
	caxis([-1 1]);
	shading flat;
end
