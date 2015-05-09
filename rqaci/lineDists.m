function varargout = lineDists(varargin)

%lineDists - get line distributions of an RP
%
% function [diagLines vertLines] = lineDists(RP,[theiler,minL,minV])
%
% Extract diagonal and vertical lines larger than minL/minV 
% from an RP. The chosen Theiler window is respected. 
%
% Input:
%	RP =  RP 
% 	theiler = size of the theiler window (def: 1)
% 	minL = minimal size of diagonal lines (def: 0)
% 	minV = minimal size of vertical lines (def: 0)
%
% Output:
%	diagLines = distribution of diagonal lines
%	vertLines = distribution of vertical lines
%
% requires: 
%
% see also: opTool
%

% Copyright (C) 2008 Stefan Schinkel, University of Potsdam
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
	if (nargchk(1,4,nargin)), help(mfilename),error(lasterr); end
	if (nargchk(0,4,nargout)), help(mfilename),error(lasterr); end

	varargin{5} = [];

	% input assignment 
	X = varargin{1};
	if ~isempty(varargin{2}), theiler = varargin{2}; else theiler = 1;end
	if ~isempty(varargin{3}), minLenDiag = varargin{3}; else minLenDiag = 0;end
	if ~isempty(varargin{4}), minLenVert = varargin{4}; else minLenVert = 0;end


	%% remove Theiler if requested
	if theiler > 0 
		RP = double(triu(X,theiler))+double(tril(X,-theiler));
	end
	
	%get diagonal Lines & pad with zeros
	diagonals = spdiags(RP);
	diagonals = [zeros(1,size(diagonals,2)) ; diagonals ; zeros(1,size(diagonals,2))];

	% get vertical Lines & pad with zeros
	verticals = double([zeros(1,length(RP)) ; RP ; zeros(1,length(RP))]);

	% get the actual line distributions
	diagLines = maxConsElements(diagonals(:));
	vertLines = maxConsElements(verticals(:));

	% if requested, exclude short lines
	if minLenDiag > 0, diagLines(diagLines < minLenDiag) = [];end
	if minLenVert > 0, vertLines(vertLines < minLenVert) = [];end

	% return to caller
	varargout{1} = diagLines;
	varargout{2} = vertLines;

end % function lineDists

function consElements = maxConsElements(vector)

	% extract the length of all consecutive elements in a vector
	tmp = diff(vector);
	ind1 = find(tmp == 1);
	ind2 = find(tmp == -1);
	consElements = ind2-ind1;
	
end % function maxConsElements
 
