function pipeline(varargin)

% This pipeline computes averages from the participants.tsv file
%
% Use as 
%    pipeline [options] <inputdir> <outputdir> <level>
% where the input and output directory must be specified, and the 
% level is either "group" or "participant".
%
% Optional arguments:
%   -h,--help           Show this help and exit.
%   --verbose           Enable verbose output.
%   --start-idx <num>   Start index for participant selection.
%   --stop-idx <num>    Stop index for participant selection.

% This code is shared under the CC0 license
%
% Copyright (C) 2024, SIESTA workpackage 15 team

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parse the command-line options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% optional arguments can be "flags" that come by themselves, like '-h' or '--help'
% optional arguments can also have values, like '--species {human,rat}'

% flags are represented as true/false
options.help       = false;
options.verbose    = false;
% other options each have their own value, either a string or a number
options.start_idx  = [];
options.stop_idx   = [];

% deal with the flags
isflag = false(size(varargin));
for i=1:numel(varargin)
  switch varargin{i}
    case {'-h', '--help'}
      options.help = true;
      isflag(i) = true;
    case {'-v', '--verbose'}
      options.verbose = true;
      isflag(i) = true;
  end % switch
end % for

% remove the flags
varargin = varargin(~isflag);
clear isflag

% deal with the optional arguments
isoption = false(size(varargin));
for i=1:2:numel(varargin)
  switch varargin{i}
    case {'--start-idx'}
      options.start_idx = str2double(varargin{i+1});
      isoption(i) = true;
      isoption(i+1) = true;
    case {'--stop-idx'}
      options.stop_idx = str2double(varargin{i+1});
      isoption(i) = true;
      isoption(i+1) = true;
  end % switch
end % for

% remove the optional arguments
varargin = varargin(~isoption);
clear isoption

% show the help (if requested)
if options.help
  help(mfilename);
  return
end

% deal with the positional arguments
if length(varargin)<3
  error('not enough input arguments')
elseif length(varargin)>3
  str = sprintf('%s ', varargin{1:end-3});
  error('unsupported input arguments: %s ', str);
end

% the last three arguments must be inputdir, outputdir and level
inputdir  = varargin{end-2};
outputdir = varargin{end-1};
level     = varargin{end}; % participant or group

% the last three arguments must be strings
if ~isa(inputdir, 'char') && ~isa(inputdir, 'string')
  error('incorrect specification of inputdir');
elseif ~isa(outputdir, 'char') && ~isa(outputdir, 'string')
  error('incorrect specification of inputdir');
elseif ~isa(level, 'char') && ~isa(level, 'string')
  error('incorrect specification of inputdir');
end

if ~strcmpi(level, 'participant') && ~strcmpi(level, 'group')
  error('level should either be ''participant'' or ''group''');
end

if ~exist(inputdir, 'dir')
  error('input directory does not exist');
end

if ~exist(outputdir, 'dir')
  warning('creating output directory');
  [success, message] = mkdir(outputdir);
  if ~success
    error(message);
  end
end

% add these to the options structure
options.inputdir  = inputdir;
options.outputdir = outputdir;
options.level     = level;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% call the actual code to execute the pipeline
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if options.verbose
  fprintf('options =\n');
  disp(options);
end

if strcmp(options.level, 'participant')
  disp("nothing to do at the participant level")
  return
end

inputfile  = fullfile(options.inputdir, 'participants.tsv');
outputfile = fullfile(options.outputdir, 'results.tsv');

participants = readtable(inputfile, 'FileType', 'text', 'Delimiter', '\t', 'VariableNamingRule', 'preserve');

if options.verbose
  fprintf('data contains %d participants\n', size(participants, 1));
end

% select participants
if ~isempty(options.stop_idx)
  participants = participants(1:options.stop_idx,:);
end
if ~isempty(options.start_idx)
  participants = participants(options.start_idx:end,:);
end

if options.verbose
  fprintf('selected %d participants\n', size(participants, 1));
end

averagedage  = mean(participants.age, 'omitnan');
averagedHeight = mean(participants.Height, 'omitnan');
averagedWeight = mean(participants.Weight, 'omitnan');

% put the results in a table
result = table(averagedage, averagedHeight, averagedWeight);

if options.verbose
  disp(result);
end

if options.verbose
  disp(['writing to ' outputfile]);
end

writetable(result, outputfile, 'FileType', 'text', 'Delimiter', '\t', 'WriteVariableNames', false);
