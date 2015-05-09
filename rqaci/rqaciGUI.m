function rqaciGUI(varargin)

%rqaciGUI Compare to univariate time series
%
% function rqaciGUI(X,Y [,timeScale])
%
% Purpose:
% A simple MATLAB GUI that provides a convenient access to the 
% rqaci.m routine and the required plotting routines. In order to run
% the programme you have to have the CRPtoolbox installed as a prequesite
% for computing RPs.
%
% Input:
%	X = timeseries 1
%	Y = timeseries 2
%	ts = timeScale (used for plotting, optional)
%
% Parameter:
%	dim = embedding dimension
%	tau = embedding delay
%	eps = threshold
%	method = norm for RP
%	ws = window size
%	ss = step size
%	theiler = theiler window
%	lMin = minimal diagonal line length
%	vMin = minimal vertical line length
%	nSamples = number of bootstrap samples
%	alpha = alpha level for CI estimation
%
%	all parameters adjustable via GUI
%
% requires: CRPtoolbox, prctile (Statistics Toolbox)
%
% see also: opTool
%
% References: 
%	Schinkel, S., Dimigen, O., Marwan, N. & Kurths, J.: 
%	"Confidence Bounds of recurrence based complexity measures",
%	Physics Letters A, 

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


%% debug settings
debug = 0;
if debug,warning('on','all');warning('Matlab:DivideByZero','off');else warning('off','all');end

%% check number of input arguments
error(nargchk(2,3,nargin))

%% check number of out arguments
error(nargoutchk(0,0,nargout))

%% check input
varargin{4} = [];

%% initial I/O check
if ~isvector(varargin{1}); help(mfilename);error('Bad input format');else X = varargin{1};end
if ~isvector(varargin{2}); help(mfilename);error('Bad input format');else Y = varargin{2};end
if ~isempty(varargin{3}), timeScale = varargin{3};else timeScale = [];end

% of equal length
if length(X) ~= length(Y), help(mfilename);error('X & Y have to be of equal length');end

%% consistency and stuff
if isempty(timeScale);
	timeScale = 1:1:length(X);
else
	if length(timeScale) ~= length(X);
		warndlg('Timescale is not matching data. Not using it', ...
		'Timescale Error','modal');
		timeScale=1:length(X);
	end
end

%% some default parameters
dim = 2;tau = 1;epsilon = .1;
ws = round(length(X)*.1);
ss = round(length(X)*.01);
theiler = 1;minDiag = 2;minVert = 2;valRPNorm = 1;
valPlotSizeValue = 1;

% avail measures
measures = {'DET','L','LAM','TT'};

% avail RP norms
RPNorms = {'Fixed RR','Fixed Neighbours','Order Patterns','Euclidean Norm*','Maximimum Norm*','Minimum Norm*'};
RPNormKeys = {'rr','fan','op','eucl','max','min'};

%%%%%%%%%%%%%%%%%%%%%
%	Define GUI		%
%%%%%%%%%%%%%%%%%%%%%
screenSize = get(0,'Screensize');

figHandle = figure('Name','RQACI -- GUI',... 
	'Position',[50,screenSize(4)-650,800,600],... % top left corner 50x50 padding 
	'Color',[.801 .75 .688], ... 
	'Tag','mainFigure',...
	'Menubar','None');% choose 'Menubar','figure' to run into trouble

%%%%%%%%%%%%%%%%%%%%%
%	Layout GUI		%
%%%%%%%%%%%%%%%%%%%%%

set(figHandle,'visible','off')
rqaciGUILayout;
set(figHandle,'visible','on')

% plot source data
axes(axData);
plot(timeScale,X,'b');
hold on;
plot(timeScale,Y,'r');
set(axData,'Tag','axData');
axis tight

end %% main

%%%%%%%%%%%%%%%%%%%%%
% 	CALLBACKS		%
%%%%%%%%%%%%%%%%%%%%%
function computeCallback(source,eventdata,X,Y,RPNormKeys,measures,timeScale)

	figHandle = get(source,'Parent');
	
	%rqa params
	dim = str2double( get( findobj(figHandle,'Tag','valDim'),'String') );
	tau = str2double( get( findobj(figHandle,'Tag','valTau'),'String') );
	epsilon = str2double( get( findobj(figHandle,'Tag','valEpsilon'),'String') );
	ws = str2double( get( findobj(figHandle,'Tag','valWindowSize'),'String') );
	ss = str2double( get( findobj(figHandle,'Tag','valStepSize'),'String') );
	theiler = str2double( get( findobj(figHandle,'Tag','valTheiler'),'String') );
	minDiag = str2double( get( findobj(figHandle,'Tag','valMinDiag'),'String') );
	minVert = str2double( get( findobj(figHandle,'Tag','valMinVert'),'String') );
	plotSize = get( findobj(figHandle,'Tag','valPlotSize'),'Value');
	RPNorm = get( findobj(figHandle,'Tag','valRPNorm'),'Value');

	% rqaci params
	nBoot = str2double( get( findobj(figHandle,'Tag','valNBoot'),'String') );
	alpha = str2double( get( findobj(figHandle,'Tag','valAlpha'),'String') );

	% rqaci only makes sense if we window
	if ws == length(X);
		errordlg(sprintf('Please use windowing or\nuse rqabounds() instead.'),...
			'Suitability Error','modal')
		return
	end

	%% params aquired, compute stuff
	hWaitbar = waitbar(0,'Computing RQA measures ...','WindowStyle','modal');	

	%% for easier plotting later on	
	indeces =[];

	%switch small/full plot
	if plotSize == 1,
		for i=1:ss:length(X)-ws;
						
			rpX = crp(X(i:i+ws),dim,tau,epsilon,RPNormKeys{RPNorm},'silent');
			rpY = crp(Y(i:i+ws),dim,tau,epsilon,RPNormKeys{RPNorm},'silent');

			[valsX(i,:) cisX(i,:,:)] = rqaci(rpX,nBoot,alpha);
			[valsY(i,:) cisY(i,:,:)] = rqaci(rpY,nBoot,alpha);

			waitbar(i/length(X),hWaitbar);

			indeces(end+1) = i;
		end
	else
		%User info
		disp('INFO: Will use adjust plot to embedding params!');
		
		for i=1:ss:length(X)-ws-dim*tau;

			rpX = crp(X(i:i+ws+dim*tau),dim,tau,epsilon,RPNormKeys{RPNorm},'nogui','silent');
			rpY = crp(Y(i:i+ws+dim*tau),dim,tau,epsilon,RPNormKeys{RPNorm},'nogui','silent');

			[valsX(i,:) cisX(i,:,:)] = rqaci(rpX,nBoot,alpha);
			[valsY(i,:) cisY(i,:,:)] = rqaci(rpY,nBoot,alpha);

			waitbar(i/length(X),hWaitbar);

			indeces(end+1) = i;
			
		end
	end	

	%close waitbar
	close(hWaitbar)
	
	% merge data to struct
	data.cisX = cisX; data.cisY = cisY;
	data.indeces = indeces;
	
	% store in GUI
	set(figHandle,'UserData',data);

	%% manually trigger plotting callback 
	plotData(source,eventdata,figHandle,timeScale)

		
end % buttonComputeCallback

function plotData(source,eventdata,figHandle,timeScale)
	
	%get axis handles
	axData = findobj(figHandle,'Tag','axData');
	axCI = findobj(figHandle,'Tag','axCI');
	axCmp = findobj(figHandle,'Tag','axCmp');
	
	%% get params
	dim = str2double( get( findobj(figHandle,'Tag','valDim'),'String') );
	tau = str2double( get( findobj(figHandle,'Tag','valTau'),'String') );
	epsilon = str2double( get( findobj(figHandle,'Tag','valEpsilon'),'String') );
	ws = str2double( get( findobj(figHandle,'Tag','valWindowSize'),'String') );
	ss = str2double( get( findobj(figHandle,'Tag','valStepSize'),'String') );

	%% for fancying the title
	RPNorms = get( findobj(figHandle,'Tag','valRPNorm'),'String');
	RPNormValue = get( findobj(figHandle,'Tag','valRPNorm'),'Value');
	measures = get( findobj(figHandle,'Tag','valMeasure'),'String');
	measureSelected = get( findobj(figHandle,'Tag','valMeasure'),'Value');
	
	%see if sth has bee computed
	data = get(figHandle,'Userdata');

	if isempty(data),
		return
	else
		cisX = data.cisX;cisY = data.cisY;
		indeces = round(data.indeces);
	end
	
	%activate axCI	
	axes(axCI)
	cla(axCI)
	
	% plot data with given data indeces
	ciplot(cisX(indeces,measureSelected,:),'b',timeScale(indeces+round(ws/2)));
	ciplot(cisY(indeces,measureSelected,:),'r',timeScale(indeces+round(ws/2)));	

	% fancy plot
	xlim([timeScale(1) timeScale(end)]);
	ylim('auto')
	set(axCI,'Tag','axCI');
	set(axCI,'XGrid','on');
	set(axCI,'YGrid','on');
	
	% and add the title
	title(axData,sprintf('%s for %s RP -- dim: %d tau: %d eps: %1.3f ws:%d ss:%d',...
		measures{measureSelected},RPNorms{RPNormValue},dim,tau,epsilon,ws,ss),...
		'Fontweight','bold');

	% compare &* plot CI comparison
	cmp = cicompare(squeeze(cisX(indeces,measureSelected,:)),...
		squeeze(cisY(indeces,measureSelected,:)));

	pcolor(axCmp,timeScale(indeces+round(ws/2)),1:2,[cmp;cmp]);
	shading(axCmp,'flat')
	xlim(axCmp,[timeScale(1) timeScale(end)]);
	caxis(axCmp,[-1 1]);
	%fancy out
	set(axCmp,'Box','off',...
	'Xtick',[],...
	'Ytick',[],...
	'tag','axCmp',...
	'visible','off');

	
	
end %plotData

	
%%%%%%%%%%%%%%%%%%%%%%%%%
% 	HELPER FUNCTIONS	%
%%%%%%%%%%%%%%%%%%%%%%%%%
function closeCallback(source,eventdata) 

	close( get(source,'Parent') )

end % buttonCloseCallback
function printCallback(source,eventdata) 
	
	% get access to figure
	figHandle = get(source,'Parent');
	
	% grab the plot axes for copying
	axData = findobj(figHandle,'Tag','axData');
	axCI = findobj(figHandle,'Tag','axCI');

	%new, hidden figure
	plotFigure = figure('visible','off');
	
	% copy data & CI axes
	copyobj(axData,plotFigure)
	copyobj(axCI,plotFigure)
	
	%serve printdlg
	printdlg(plotFigure);

end % buttonCloseCallback
