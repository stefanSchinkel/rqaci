axData = axes('Parent',figHandle,...
	'Position',[.05 .76 .9 .18],...
	'Tag', 'axData',...
	'NextPlot','replace',...
	'Box','on',...
	'Xtick',[],...
	'Ytick',[]);

axCmp = axes('Parent',figHandle,...
	'Position',[.05 .68 .9 .045],...
	'Tag', 'axCmp',...
	'NextPlot','replace',...
	'Box','off',...
	'Xtick',[],...
	'Ytick',[],...
	'visible','off');

axCI = axes('Parent',figHandle,...
	'Position',[.05 .275 .9 .4],...
	'Tag', 'axCI',...
	'NextPlot','replace',...
	'Box','on');


buttons = uibuttongroup('Position', [.05 .05 .55 .18],...
	'Title','RQA - parameters',...
	'visible','on');

	textDim = uicontrol('Parent',buttons, ...
		'Units', 'normalized', ...
		'Position', [.05 .71 .15 .18],...
		'BackgroundColor',[0.7020 0.7020 0.7020], ...
		'Style','text',...
		'String','Dimension:',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','Enter the embedding dimension.');

	textTau = uicontrol('Parent',buttons, ...
		'Units', 'normalized', ...
		'Position', [.05 .51 .15 .18],...
		'BackgroundColor',[0.7020 0.7020 0.7020], ...
		'Style','text',...
		'String','Delay:',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','Enter the embedding delay.');

	textWindowSize = uicontrol('Parent',buttons, ...
		'Units', 'normalized', ...
		'Position', [.04 .31 .16 .18],...
		'BackgroundColor', [0.7020 0.7020 0.7020], ...
		'Style','text',...
		'String','Window size :',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','The size of the shifting window.');

	textStepSize = uicontrol('Parent',buttons, ...
		'Units', 'normalized', ...
		'Position', [.05 .11 .15 .18],...
		'BackgroundColor',[0.7020 0.7020 0.7020], ...
		'Style','text',...
		'String','Step size :',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','The number of steps by which the window is shifted.');

	valDim = uicontrol('Parent',buttons,...
		'Units', 'normalized', ...
		'Position', [.225 .71 .1 .18],...
		'BackgroundColor',[.801 .75 .688], ...
		'Style','edit',...
		'String',num2str(dim),...
		'Tag','valDim',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','Insert the dimension (2-13)');

	valTau = uicontrol('Parent',buttons,...
		'Units', 'normalized', ...
		'Position', [.225 .51 .1 .18],...
		'BackgroundColor',[.801 .75 .688], ...
		'Style','edit',...
		'String',num2str(tau),...
		'Tag','valTau',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','Insert the time delay');

	valWindowSize= uicontrol('Parent',buttons,...
		'Units', 'normalized', ...
		'Position', [.225 .31 .1 .18],...
		'BackgroundColor',[.801 .75 .688], ...
		'Style','edit',...
		'String',num2str(ws),...
		'Tag','valWindowSize',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','Insert the window size.');

	valStepSize = uicontrol('Parent',buttons,...
		'Units', 'normalized',...
		'Position', [.225 .11 .1 .18],...
		'BackgroundColor',[.801 .75 .688],...
		'Style','edit',...
		'String',num2str(ss),...
		'Tag','valStepSize',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','Insert the step size.');

	textEpsilon = uicontrol('Parent',buttons, ...
		'Units', 'normalized', ...
		'Position', [.35 .71 .15 .18],...
		'BackgroundColor',[0.7020 0.7020 0.7020], ...
		'Style','text',...
		'String','Threshold:',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','The threshold used in computing the RP.');

	textTheiler = uicontrol('Parent',buttons, ...
		'Units', 'normalized', ...
		'Position', [.35 .51 .15 .18],...
		'BackgroundColor',[0.7020 0.7020 0.7020], ...
		'Style','text',...
		'String','Theiler:',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','The size of the theiler window.');

	textMinDiag = uicontrol('Parent',buttons, ...
		'Units', 'normalized', ...
		'Position', [.35 .31 .15 .18],...
		'BackgroundColor',[0.7020 0.7020 0.7020], ...
		'Style','text',...
		'String','min. Diag.:',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','The minimal length of diagonal lines to be quantified');

	textMinVert = uicontrol('Parent',buttons, ...
		'Units', 'normalized', ...
		'Position', [.35 .11 .15 .18],...
		'BackgroundColor',[0.7020 0.7020 0.7020], ...
		'Style','text',...
		'String','min. Vert.:',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','The minimal length of vertical lines to be quantified');

	valEpsilon = uicontrol('Parent',buttons,...
		'Units', 'normalized', ...
		'Position', [.55 .71 .1 .18],...
		'BackgroundColor',[.801 .75 .688], ...
		'Style','edit',...
		'String',num2str(epsilon),...
		'Tag','valEpsilon',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','Enter the size of the Theiler Window.');

	valTheiler = uicontrol('Parent',buttons,...
		'Units', 'normalized', ...
		'Position', [.55 .51 .1 .18],...
		'BackgroundColor',[.801 .75 .688], ...
		'Style','edit',...
		'String',num2str(theiler),...
		'Tag','valTheiler',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','Enter the size of the Theiler Window.');

	valMinDiag = uicontrol('Parent',buttons,...
		'Units', 'normalized', ...
		'Position', [.55 .31 .1 .18],...
		'BackgroundColor',[.801 .75 .688], ...
		'Style','edit',...
		'String',num2str(minDiag),...
		'Tag','valMinDiag',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','Enter the minimal length of diagonal lines.');

	valMinVert = uicontrol('Parent',buttons,...
		'Units', 'normalized', ...
		'Position', [.55 .11 .1 .18],...
		'BackgroundColor',[.801 .75 .688], ...
		'Style','edit',...
		'String',num2str(minVert),...
		'Tag','valMinVert',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','Enter the minimal length of vertical lines.');

	textNorm = uicontrol('Parent',buttons, ...
		'Units', 'normalized', ...
		'Position', [.7 .75 .29 .18],...
		'BackgroundColor',[0.7020 0.7020 0.7020], ...
		'Style','text',...
		'String','Neighbourhood:',...
		'HorizontalAlignment','left',...
		'Visible','on',...
		'Tooltip',sprintf('Select how to define neighbourhood\n Asterisk denotes discouraged choices.'));

	valNorm = uicontrol('Parent',buttons,...
		'Units', 'normalized',...
		'Position', [.7 .575 .29 .18],...
		'BackgroundColor',[0.7020 0.7020 0.7020], ...
		'Style','popupmenu',...
    	'String',RPNorms,...
		'Tag','valRPNorm',...
		'Value',valRPNorm,...
		'Tooltip',sprintf('Select how to define neighbourhood\n Asterisk denotes discouraged choices.'));

	textPlotSize = uicontrol('Parent',buttons, ...
		'Units', 'normalized', ...
		'Position', [.7 .3 .29 .18],...
		'BackgroundColor',[0.7020 0.7020 0.7020], ...
		'Style','text',...
		'String','Size adjustment:',...
		'HorizontalAlignment','left',...
		'Visible','on',...
		'Tooltip','Adjust the size of the RP to compensate for embedding.');


	valPlotSize = uicontrol('Parent',buttons,...
		'Units', 'normalized',...
		'Position', [.7 .11 .29 .18],...
		'BackgroundColor',[0.7020 0.7020 0.7020], ...
		'Style','popupmenu',...
    	'String',{'Use small RP','Use full RP'},...
		'Tag','valPlotSize',...
		'Value',valPlotSizeValue,...
		'Tooltip','Choose small for default CRPtool routines or full to adjust for embedding');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	measures, bootstrap params	%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

buttons2 = uibuttongroup('Position', [.63 .05 .2 .18],...
	'Title','RQACI - parameters',...
	'visible','on');

	textMeasure = uicontrol('Parent',buttons2, ...
		'Units', 'normalized', ...
		'Position', [.1 .61 .5 .3],...
		'BackgroundColor',[0.7020 0.7020 0.7020], ...
		'Style','text',...
		'String',sprintf('Measure:\n to plot'),...
		'HorizontalAlignment','left',...
		'Visible','on',...
		'Tooltip','Choose the RQA measure you would like to plot');

	valMeasure = uicontrol('Parent',buttons2,...
		'Units', 'normalized', ...
		'Position',[.65 .71 .3 .18],...
		'Style','popupmenu',...
    	'String',measures,...
		'Tag','valMeasure',...
		'Value',1,...
		'Callback',{@plotData,figHandle,timeScale});

	textNBoot = uicontrol('Parent',buttons2, ...
		'Units', 'normalized', ...
		'Position', [.1 .31 .5 .18],...
		'BackgroundColor',[0.7020 0.7020 0.7020], ...
		'Style','text',...
		'String','n Samples',...
		'HorizontalAlignment','left',...
		'Visible','on',...
		'Tooltip','The number of bootstrapped samples.');

	valNBoot = uicontrol('Parent',buttons2,...
		'Units', 'normalized', ...
		'Position',[.65 .31 .3 .18],...
		'BackgroundColor',[.801 .75 .688], ...
		'Style','edit',...
    	'String','500',...
		'HorizontalAlignment','right',...
		'Tag','valNBoot');

	textAlpha = uicontrol('Parent',buttons2, ...
		'Units', 'normalized', ...
		'Position', [.1 .11 .5 .18],...
		'BackgroundColor',[0.7020 0.7020 0.7020], ...
		'Style','text',...
		'String','alpha',...
		'HorizontalAlignment','left',...
		'Visible','on',...
		'Tooltip','Alpha level in percent. Determines the spread of CIs.');

	valAlpha = uicontrol('Parent',buttons2,...
		'Units', 'normalized', ...
		'Position',[.65 .11 .3 .18],...
		'BackgroundColor',[.801 .75 .688], ...
		'Style','edit',...
    	'String','5',...
		'HorizontalAlignment','right',...
		'Tag','valAlpha');


%%%%%%%%%%%%%%%%%%%%%%%%%
%	Define buttons 		%
%%%%%%%%%%%%%%%%%%%%%%%%%

	buttonStore = uicontrol('Parent',figHandle, ...
		'Units', 'normalized', ...
		'Position', [.85 .17 .1 .06],...
		'BackgroundColor',[.801 .75 .688], ...
		'Style','pushbutton',...
		'String','Print',...
		'Visible','on', ...
		'Tooltip','Save the current figure to file.',...
		'Callback',{@printCallback});

	buttonClose = uicontrol('Parent',figHandle, ...
		'Units', 'normalized', ...
		'Position', [.85 .11 .1 .06],...
		'BackgroundColor',[.801 .75 .688], ...
		'Style','pushbutton',...
		'String','Close',...
		'Visible','on', ...
		'Tooltip','Close the GUI',...
		'Callback',{@closeCallback});

	buttonCompute = uicontrol('Parent',figHandle,...
		'Units', 'normalized',...
		'Position', [.85 .05 .1 .06],...
		'BackgroundColor',[.801 .75 .688],...
		'Style','pushbutton',...
		'String','Compute',...
		'FontWeight','bold',...
		'Visible','on', ...
		'Tooltip','Start the computation',...
		'Callback',{@computeCallback,X,Y,RPNormKeys,measures,timeScale});

%%%%%%%%%%%%%%%%%%%%%
%	fancy stuff 	%
%%%%%%%%%%%%%%%%%%%%%

	textNLD = uicontrol('Parent',figHandle,...
		'Units', 'normalized', ...
		'Position',[.1 .01 .85 .03],...
		'Style','text',...
		'BackgroundColor',[.801 .75 .688], ...
		'Tag', 'NLD ',...
		'FontSize',9,...
		'String',sprintf('Stefan Schinkel - HU Berlin (c) 2008-12'),...
		'Tooltip','Visit http://tocsy.pik-potsdam.de for details and other programmes',...
		'HorizontalAlignment','right');
