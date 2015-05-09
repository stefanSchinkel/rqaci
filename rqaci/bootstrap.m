function [varargout] = bootstrap(varargin)

%BOOTSTRAP	Resample data with replacement.
%
% function [Y] = bootstrap(X [,nSamples,seed])
%
% Resample vector/matrix Y and return to caller.
% The function resamples along all dimensions, 
% hence vector use may be preferred. The number 
% resamplings can be passed as an argument. If 
% "seed" is provided. the RNG is initialized with
% "seed" to allow for repetition with the same values. 
%
% Input:
% 	X = vector/matrix
% 	nSamples = number of resamplings
%	seed = RNG seed
%
% Output:
%
% 	y = matrix holding the resampled vectors
%
% replaces: randsample.m/bootstrp.m (primitive stand-in)
%
% requires: 
%
% see also: Statistics Package

% Copyright (C) 2007 Stefan Schinkel, University of Potsdam
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

% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

% check number of input arguments
error(nargchk(1,3,nargin))

% check number of out arguments
error(nargoutchk(0,1,nargout))

varargin{4} = [];

% assign input
in = varargin{1};
if ~isempty(varargin{2}),nBoot = varargin{2};else nBoot = 10;end
if ~isempty(varargin{3}),seed = varargin{3};else seed = []; end

% reset RNG if requested
if seed, rand('state',seed);end

% size of data
sizeIn=size(in);     

% handmade ndims 
if length(sizeIn)>2, 
  error('Input data can be a vector or a 2D matrix only'); 
end;

% handmade isvector
if min(sizeIn)==1,  flagIsVector = 1;else flagIsVector = 0;end

if flagIsVector
  out=in(ceil(max(sizeIn)*rand(max(sizeIn),nBoot)));    
else         
  out=in(ceil(sizeIn(1)*sizeIn(2)*rand(sizeIn(1),sizeIn(2),nBoot))); 
end;

varargout{1} = out;
