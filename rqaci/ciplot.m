function varargout = ciplot(varargin)
%
%CIPLOT - plot confidence intervals as shaded area
%
% function hPatch = ciplot(ci, [,colour, timeScale])
%
% The function plots a confidence interval, or rather
% any interval, defined by lower/upper as a shaded 
% area - a patch object. The patch handle is returned to
% the caller. Alpha is set to .2 (see-through). Further 
% the egdes are faded out. 
% Change this with >> set(hPatch,'EdgeAlpha',0)
%
% The area will be added by to the plot. It won't clear
% any existing object. 
%
% Input:
%	ci = condfidence interval(Nx2, with :,1 == upper bound)
%	colour = colour of the area 
%	tScale = time scale
%
% requires: 
%
% see also: 
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
if (nargchk(1,3,nargin)), help(mfilename),error(nargchk(2,3,nargin)); end
if (nargchk(0,1,nargout)), help(mfilename),error(nargchk(0,1,nargout)); end

varargin{5} = [];

ci = varargin{1};
if isempty(varargin{2}), colour = [.7 .7 .7]; else colour = varargin{2};end
if isempty(varargin{3}); tScale = 1:length(ci); else tScale = varargin{3};end

% make sure shape matches
if size(ci,2) > size(ci,1); ci = ci';end

% NaN check: if there's NaN is the Patch defintion, 
% it won't render properly, there for we erase those
% from the ci AND the timeScale
if any(isnan(ci(:)))

	disp('CIPLOT Warning: NaNs in data. Erasing.')

	%first check upper limit
	idNan = find(isnan(ci(:,1)));
	ci(idNan,:) = [];
	tScale(idNan) = [];
	
	%no check lower limit
	idNan = find(isnan(ci(:,2)));
	ci(idNan,:) = [];
	tScale(idNan) = [];	

end


%reshape for fill (requires row vectors)
upperBound = ci(:,1)';
lowerBound = ci(:,2)';

%make sure we don't overwrite things
if ~ishold(gca),
	set(gca,'NextPlot','add');
end

% create the patch  - NOTE: x(end:-1:1) == fliplr(x) 
hPatch = fill([tScale(1:1:end) tScale(end:-1:1)], [upperBound lowerBound(end:-1:1)],colour);

% hide edges
set(hPatch,'EdgeAlpha',.1);

% make it see-through
alpha(hPatch,.2)

if nargout
	varargout{1} = hPatch;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	alternative solution to NaN problem, but causes		%
%	problems if too few NaNs in data					%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
if any(isnan(ci(:)));	
	
	% interpolate along NaNs,
	% might not be THE best thing, 
	% but it does ensure plotting
	disp('CIPLOT Warning: NaNs in data. Will interpolate to ensure plotting.')
	
	upperBound(isnan(upperBound)) = interp1(find(~isnan(upperBound)), ...
		upperBound(~isnan(upperBound)), ...
		find(isnan(upperBound)), 'cubic'); 
	lowerBound(isnan(lowerBound)) = interp1(find(~isnan(lowerBound)), ...
		lowerBound(~isnan(lowerBound)), ....
		find(isnan(lowerBound)), 'cubic'); 
end
%}
