function RUN_SRT(session_info)

% function RUN_SRT
% 
% Developed by Dr. Mihaela Duta, mihaela.duta@psy.ox.ac.uk
% Department of Experimental Psychology, University of Oxford

% Revision July 2017 - change triplet structure etc

% interpret session_info structure
sbj_dirname = ['data/' session_info.ID];
% make subject directory
mkdir(sbj_dirname);
% build output file names
outfname_info          = [sbj_dirname '/' session_info.ID '_info_'          datestr(now, 30) '.mat'];
outfname_practice_raw  = [sbj_dirname '/' session_info.ID '_practice_raw_'  datestr(now, 30) '.mat'];
outfname_practice_data = [sbj_dirname '/' session_info.ID '_practice_data_' datestr(now, 30) '.csv'];
outfname_raw           = [sbj_dirname '/' session_info.ID '_raw_'           datestr(now, 30) '.mat'];
outfname_data          = [sbj_dirname '/' session_info.ID '_data_'          datestr(now, 30) '.csv'];
outfname_probe         = [sbj_dirname '/' session_info.ID '_probe_'         datestr(now, 30) '.csv'];
outfname_recall_data   = [sbj_dirname '/' session_info.ID '_recall_data_'   datestr(now, 30) '.csv'];
outfname_recall_raw    = [sbj_dirname '/' session_info.ID '_recall_raw_'    datestr(now, 30) '.mat'];

% outfname_design        = [sbj_dirname '/' session_info.ID '_design_' datestr(now, 30) '.csv'];

% save session_info
save(outfname_info, 'session_info');

% initialise settings variable here otherwise R2016b complains about implicit init
settings = struct; 

% load random sequence for practice
fname = ['SEQ_data_BLKS1_SETS1_practice_' session_info.routine.txt '.mat'];
fprintf('Loading random sequence for practice from %s ... ', fname); load(fname); fprintf('done\n');
practice_info = trial_info; practice_settings = settings; 
clear trial_info; clear settings; 

% load random sequence for recall
fname = ['SEQ_data_BLKS1_SETS1_recall_' session_info.routine.txt '.mat'];
fprintf('Loading random sequence for recall from %s ... ', fname); load(fname); fprintf('done\n');
recall_info = trial_info; recall_settings = settings; 
clear trial_info; clear settings; 

% load random sequence for trials - always the largest sequence, 7 blocks and 10 sets
fname = ['SEQ_data_BLKS7_SETS10_learning_' session_info.routine.txt '.mat'];
% fname = ['SEQ_data_BLKS' num2str(session_info.blocks.value, '%d') '_SETS' num2str(session_info.sets.value, '%d') '_learning_' session_info.routine.txt '.mat'];
fprintf('Loading random sequence for trails from %s ... ', fname); load(fname); fprintf('done\n');
% overwrite the number of blocks and sets with the one requested via the gui
% settings.n_blocks     = session_info.blocks.value;
% settings.n_sets4block = session_info.sets.value;

% SETUP VARIOUS PARAMETERS
% %%%%%%%%%%%%%%%%%%%%%%%%

settings.development_mode = false; % turn this to false when running participants

% screen settings
settings.screen.bg_colour = [128 128 128];
settings.screen.rect      = [0 0 1920 1080];
settings.screen.wdt       = settings.screen.rect(3) - settings.screen.rect(1);
settings.screen.hgt       = settings.screen.rect(4) - settings.screen.rect(2);
settings.screen.resX      = settings.screen.rect(3) - settings.screen.rect(1);
settings.screen.resY      = settings.screen.rect(4) - settings.screen.rect(2);
settings.screen.midX      = floor(settings.screen.resX/2);
settings.screen.midY      = floor(settings.screen.resY/2);

% buttons
settings.btns.play.normal.fname  = ['stimuli/' session_info.routine.txt '/imgs/BTN_play.png'];
settings.btns.play.pressed.fname = ['stimuli/' session_info.routine.txt '/imgs/BTN_play_pressed.png'];
settings.btns.play.wdt   = floor(settings.screen.resX/20);
settings.btns.play.hgt   = settings.btns.play.wdt;
settings.btns.play.midX  = (1/2)*settings.screen.rect(3);
settings.btns.play.midY  = (1/2)*settings.screen.rect(4);
settings.btns.play.rect  = CenterRectOnPoint([0 0 settings.btns.play.wdt settings.btns.play.hgt], settings.btns.play.midX, settings.btns.play.midY);

settings.sels.qst = 'Did you notice any patterns?';
settings.sels.wdt   = floor(settings.screen.resX/10);
settings.sels.hgt   = settings.sels.wdt;
settings.sels.yes.normal.fname  = ['stimuli/' session_info.routine.txt '/imgs/SEl_yes.png'];
settings.sels.yes.pressed.fname = ['stimuli/' session_info.routine.txt '/imgs/SEL_yes_selected.png'];
settings.sels.yes.midX  = (1/4)*settings.screen.rect(3);
settings.sels.yes.midY  = (1/2)*settings.screen.rect(4);
settings.sels.yes.rect  = CenterRectOnPoint([0 0 settings.sels.wdt settings.sels.hgt], settings.sels.yes.midX, settings.sels.yes.midY);
settings.sels.no.normal.fname  = ['stimuli/' session_info.routine.txt '/imgs/SEl_no.png'];
settings.sels.no.pressed.fname = ['stimuli/' session_info.routine.txt '/imgs/SEL_no_selected.png'];
settings.sels.no.midX  = (3/4)*settings.screen.rect(3);
settings.sels.no.midY  = (1/2)*settings.screen.rect(4);
settings.sels.no.rect  = CenterRectOnPoint([0 0 settings.sels.wdt settings.sels.hgt], settings.sels.no.midX, settings.sels.no.midY);


% VISUAL STIMULI
% %%%%%%%%%%%%%%
% re-enforcement area
settings.renf.area.wdt_ratio     = 1;
settings.renf.area.hgt_ratio     = 1/4;
settings.renf.area.wdt          = settings.renf.area.wdt_ratio*settings.screen.wdt; % (1-settings.stms.area.wdt_ratio)*settings.screen.wdt;
settings.renf.area.hgt          = settings.renf.area.hgt_ratio*settings.screen.hgt; % settings.screen.hgt;
settings.renf.area.xoffset      = 0; % settings.stms.area.wdt;
settings.renf.area.yoffset      = 0; % settings.stms.area.wdt;
% settings.renf.area.rect         = [settings.renf.area.xoffset 0 settings.renf.area.xoffset+settings.renf.area.wdt settings.renf.area.hgt];
settings.renf.area.rect         = [settings.renf.area.xoffset settings.renf.area.xoffset settings.renf.area.wdt settings.renf.area.hgt];
settings.renf.stm.hgt_ratio     = 1/8;
settings.renf.stm.hgt           = settings.renf.stm.hgt_ratio*settings.renf.area.hgt; 
settings.renf.stm.wdt = settings.renf.stm.hgt;
settings.renf.img4row = 40; 
settings.renf.n_rows  = 5; 
settings.renf.bg_colour         = [255 255 255];
settings.renf.area.frame_colour = [0 255 0];
settings.renf.base_rect = [0 0 settings.renf.stm.wdt settings.renf.stm.hgt];
% re-enforcement on the right hand side
% slot_wdt = floor(settings.renf.area.wdt/settings.renf.img4row);
% slot_hgt = floor(settings.renf.area.hgt/settings.renf.n_rows);
% x_centers = settings.renf.area.rect(1) + [floor(slot_wdt/2):slot_wdt:settings.renf.area.wdt];
% y_centers = settings.renf.area.hgt - [floor(slot_hgt/2):slot_hgt:settings.renf.area.hgt];
% re-enforcement on the top
x_centers = (settings.renf.area.wdt/(settings.renf.img4row+1))*[1:settings.renf.img4row];
y_centers = (settings.renf.area.hgt/(settings.renf.n_rows+1))*[1:settings.renf.n_rows];
slots.center.x = []; slots.center.y = [];
for i_row = 1:settings.renf.n_rows,
    slots.center.x = [slots.center.x x_centers];
    slots.center.y = [slots.center.y y_centers(i_row)*ones(size(x_centers))];
end
settings.stms.vis.renf.rects     = CenterRectOnPoint(settings.renf.base_rect, slots.center.x', slots.center.y');

% stimuli area
settings.stms.area.wdt_ratio     = 1;
settings.stms.area.hgt_ratio     = 1 - settings.renf.area.hgt_ratio;
settings.stms.area.wdt           = settings.stms.area.wdt_ratio*settings.screen.wdt;
settings.stms.area.hgt           = settings.stms.area.hgt_ratio*settings.screen.hgt;
settings.stms.area.xoffset       = 0;
settings.stms.area.yoffset       = settings.renf.area.rect(4);
% % re-enforcement at the top
% settings.stms.area.rect          = [0 0 settings.stms.area.wdt settings.stms.area.hgt];
settings.stms.area.rect          = [settings.stms.area.xoffset settings.stms.area.yoffset settings.stms.area.wdt settings.stms.area.yoffset+settings.stms.area.hgt];
settings.stms.area.frame_colour  = [255 0 0];
settings.stms.vis.wdt            = settings.screen.wdt/10;
settings.stms.vis.hgt            = settings.stms.vis.wdt;
settings.stms.vis.space          = 5;
settings.stms.vis.n              = 4;
settings.stms.vis.bg_colour      = [255 255 255];
settings.stms.vis.prime.duration = 0.100;
settings.stms.vis.duration       = 0.60; % maximum duration for item 1 and 2 after audio onset based on max audio length 620
settings.stms.vis.iti.duration   = 0.200;
settings.stms.vis.dirname        = ['stimuli/' session_info.routine.txt '/imgs/'];
settings.stms.vis.prime.fname    = 'PRIME.jpg';
settings.stms.vis.iti.fname      = 'ITI.png'; % inter-triplets interval
settings.stms.vis.fbk.colour     = [255 255 0];
settings.stms.vis.fbk.wdt        = 4;

settings.stms.vis.fdbk.center.x  = settings.screen.midX;
settings.stms.vis.fdbk.center.y  = floor(settings.screen.midY/2);
settings.stms.vis.fdbk.base_rect = [0 0 settings.screen.resX floor(settings.screen.resY/2)];
settings.stms.vis.fdbk.rect      = CenterRectOnPoint(settings.stms.vis.fdbk.base_rect, settings.stms.vis.fdbk.center.x, settings.stms.vis.fdbk.center.y);
settings.stms.vis.fdbk.font.colour = [255 255 255];
settings.stms.vis.fdbk.font.size   = 40;

% audio stimuli
settings.stms.aud.dirname                    = ['stimuli/' session_info.routine.txt '/snds/'];
settings.stms.aud.warmup.fname               = 'FBK_sound.wav';
settings.stms.aud.offset                     = 0.200;

% VARIOUS CALCULATIONS FOR STIMULI AND RANDOMIZATION
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % all in a row, reenforcements on the right hand side
% settings.stms.vis.centers.x = settings.stms.area.wdt*[1/8 3/8 5/8 7/8]';
% settings.stms.vis.centers.y = settings.screen.hgt/2*ones(settings.stms.vis.n, 1);
% % all in a row, re-enforcement at the top
% settings.stms.vis.centers.x = settings.stms.area.wdt*[1/8 3/8 5/8 7/8]';
% settings.stms.vis.centers.y = (settings.stms.area.yoffset+settings.stms.area.hgt/2)*ones(settings.stms.vis.n, 1);
% all in a row, re-enforcement at the top
% settings.stms.vis.centers.x = settings.stms.area.wdt*[3/8 5/8 3/8 5/8]'; % settings.stms.area.wdt*[1/4 3/4 1/4 3/4]';
% settings.stms.vis.centers.y = settings.stms.area.yoffset + settings.stms.area.hgt*[1/4 1/4 3/4 3/4]';
% settings.stms.vis.centers.x = settings.stms.area.wdt*[7/16 9/16 7/16 9/16]';
% settings.stms.vis.centers.y = settings.stms.area.yoffset + floor(settings.stms.area.hgt*[2.75/8 2.75/8 5.25/8 5.25/8]');
settings.stms.vis.centers.x    = floor(settings.stms.area.wdt*[7.1/16 8.9/16 7.1/16 8.9/16]');
settings.stms.vis.centers.y    = settings.stms.area.yoffset + floor(settings.stms.area.hgt*[2.95/8 2.95/8 5.05/8 5.05/8]');
settings.stms.vis.base_rect    = [0 0 settings.stms.vis.wdt settings.stms.vis.hgt];
settings.stms.vis.rects        = CenterRectOnPointd(settings.stms.vis.base_rect, settings.stms.vis.centers.x, settings.stms.vis.centers.y);
settings.stms.vis.frame.colour = [0 0 0];
settings.stms.vis.frame.wdt    = 2;
settings.stms.vis.frame.base_rect = [0 0 settings.stms.vis.wdt+settings.stms.vis.frame.wdt settings.stms.vis.hgt+settings.stms.vis.frame.wdt];
settings.stms.vis.frame.rects     = CenterRectOnPointd(settings.stms.vis.frame.base_rect, settings.stms.vis.centers.x, settings.stms.vis.centers.y);

settings.stms.vis.named.midX       = mean([settings.stms.area.rect(1) settings.stms.area.rect(3)]);
settings.stms.vis.named.midY       = mean([settings.stms.area.rect(2) settings.stms.area.rect(4)]);
settings.stms.vis.named.rect       = CenterRectOnPoint(settings.stms.vis.base_rect, settings.stms.vis.named.midX, settings.stms.vis.named.midY);
settings.stms.vis.named.frame.rect = CenterRectOnPoint(settings.stms.vis.frame.base_rect, settings.stms.vis.named.midX, settings.stms.vis.named.midY);
settings.stms.vis.iti.midX  = mean([settings.stms.area.rect(1) settings.stms.area.rect(3)]);
settings.stms.vis.iti.midY  = mean([settings.stms.area.rect(2) settings.stms.area.rect(4)]);
settings.stms.vis.iti.rect  = CenterRectOnPoint(settings.stms.vis.base_rect, settings.stms.vis.iti.midX, settings.stms.vis.iti.midY);

settings.stms.vis.renf.fnames = { 
    'image0.ico';
    'image1.ico';
    'image2.ico';
    'image3.ico';
    'image4.ico';
    'image5.ico';
    'image6.ico';
    'image7.ico';
    'image8.ico';
    'image9.ico';
    'image10.ico';
    'image11.ico';
    'image12.ico';
    'image13.ico';
    'image14.ico';
    'image15.ico';
    'image16.ico';
    'image17.ico';
    'image18.ico';
    'image19.ico';
    'image20.ico';
    'image21.ico';
    'image22.ico';
    'image23.ico';
    'image24.ico';
    'image25.ico';
    'image26.ico';
    'image27.ico';
    'image28.ico';
    'image29.ico';
    'image30.ico';
    'image31.ico';
    'image32.ico';
    'image33.ico';
    'image34.ico';
    'image35.ico';
    'image36.ico';
    'image37.ico';
    'image38.ico';
    'image39.ico';
    'image40.ico';
    'image41.ico';
    'image42.ico';
    'image43.ico';
    'image44.ico';
    'image45.ico';
    'image46.ico';
    'image47.ico';
    'image48.ico';
    'image49.ico';
    'image50.ico';
    'image51.ico';
    'image52.ico';
    'image53.ico';
    'image54.ico';
    'image55.ico';
    'image56.ico';
    'image57.ico';
    'image58.ico';
    'image59.ico';
    'image60.ico';
    'image61.ico';
    'image62.ico';
    'image63.ico';
    'image64.ico';
    'image65.ico';
    'image66.ico';
    'image67.ico';
    'image68.ico';
    'image69.ico';
    'image70.ico';
    'image71.ico';
    'image72.ico';
    'image73.ico';
    'image74.ico';
    'image75.ico';
    'image76.ico';
    'image77.ico';
    'image78.ico';
    'image79.ico';
    'image80.ico';
    'image81.ico';
    'image82.ico';
    'image83.ico';
    'image84.ico';
    'image85.ico';
    'image86.ico';
    'image87.ico';
    'image88.ico';
    'image89.ico';
    'image90.ico';
    'image91.ico';
    'image92.ico';
    'image93.ico';
    'image94.ico';
    'image95.ico';
    'image96.ico';
    'image97.ico';
    'image98.ico';
    'image99.ico';
    };

% re-seed the random number generator
rng('shuffle');
% unify key names so that code work across platformssz
KbName('UnifyKeyNames');

% READ STIMULI
% %%%%%%%%%%%%
% visual
[stms.vis.prime.data, ~, ~]  = imread([settings.stms.vis.dirname settings.stms.vis.prime.fname]);
[img_data , temp_map, temp_alpha] = imread([settings.stms.vis.dirname settings.stms.vis.iti.fname]); img_data(:,:,4)    = temp_alpha(:,:);
stms.vis.iti.data = img_data;

for i_file = 1:settings.stms.dependencies.n
    [img_data , temp_map, temp_alpha]        = imread([settings.stms.vis.dirname settings.stms.dependencies.fnames{i_file} '.png']); img_data(:,:,4)    = temp_alpha(:,:);
    stms.vis.dependencies.data{i_file}  = img_data;
    stms.vis.dependencies.fname{i_file} = settings.stms.dependencies.fnames{i_file};
    stms.vis.dependencies.code{i_file}  = 1000 + i_file;
    % if images are png and have alpha layer add wit to the image data
    % stms.vis.dependencies.data{i_file}(:, :, 4) = the_alpha;
end
for i_file = 1:settings.stms.random.n
    [img_data , temp_map, temp_alpha]  = imread([settings.stms.vis.dirname settings.stms.random.fnames{i_file} '.png']); img_data(:,:,4)    = temp_alpha(:,:); 
    stms.vis.random.data{i_file}  = img_data;
    stms.vis.random.fname{i_file} = settings.stms.random.fnames{i_file};
    stms.vis.random.code{i_file}  = 100 + i_file;
end
for i_file = 1:settings.stms.planned.n
    [img_data , temp_map, temp_alpha] = imread([settings.stms.vis.dirname settings.stms.planned.fnames{i_file} '.png']); img_data(:,:,4)    = temp_alpha(:,:);
    stms.vis.planned.data{i_file}  = img_data;
    stms.vis.planned.fname{i_file} = settings.stms.planned.fnames{i_file};
    stms.vis.planned.code{i_file}  = i_file;
end

% re-enforcements
for i_file = 1:length(settings.stms.vis.renf.fnames),
    [img_data, the_map, ~] = imread([settings.stms.vis.dirname settings.stms.vis.renf.fnames{i_file}]);
    img_data = im2uint8(ind2rgb(img_data, the_map));
    stms.vis.renf.data{i_file}  = img_data;
    stms.vis.renf.fname{i_file} = settings.stms.vis.renf.fnames{i_file};
end

% audio
if(exist('audioread') == 0)
    stms.aud.warmup.data = wavread([settings.stms.aud.dirname settings.stms.aud.warmup.fname])';
else
    stms.aud.warmup.data = audioread([settings.stms.aud.dirname settings.stms.aud.warmup.fname])';
end

i_snd = 1;
all_lens.dependencies = [];
for i_file = 1:settings.stms.dependencies.n,
    if(exist('audioread') == 0)
        [aud_data fs nbits] = wavread([settings.stms.aud.dirname settings.stms.dependencies.fnames{i_file} '.wav']); aud_data = aud_data';
    else
        [aud_data fs] = audioread([settings.stms.aud.dirname settings.stms.dependencies.fnames{i_file} '.wav']); aud_data = aud_data';
    end
    the_command = ['stms.aud.' settings.stms.dependencies.fnames{i_file} '.data      = aud_data;'];               eval(the_command);
    the_command = ['stms.aud.' settings.stms.dependencies.fnames{i_file} '.len       = size(aud_data, 2)/fs;'];   eval(the_command);
    the_command = ['stms.aud.' settings.stms.dependencies.fnames{i_file} '.delay4rsp = size(aud_data, 2)/fs/2;']; eval(the_command);
    all_lens.dependencies = [all_lens.dependencies ceil(1000*size(aud_data, 2)/fs)];
    % stms.aud.data{i_snd} = aud_data;
    i_snd = i_snd + 1;
end

all_lens.random = [];
for i_file = 1:settings.stms.random.n,
    if(exist('audioread') == 0)
        [aud_data fs nbits] = wavread([settings.stms.aud.dirname settings.stms.random.fnames{i_file} '.wav']); aud_data = aud_data';
    else
        [aud_data fs] = audioread([settings.stms.aud.dirname settings.stms.random.fnames{i_file} '.wav']); aud_data = aud_data';
    end
    the_command = ['stms.aud.' settings.stms.random.fnames{i_file} '.data      = aud_data;'];               eval(the_command);
    the_command = ['stms.aud.' settings.stms.random.fnames{i_file} '.len       = size(aud_data, 2)/fs;'];   eval(the_command);
    the_command = ['stms.aud.' settings.stms.random.fnames{i_file} '.delay4rsp = size(aud_data, 2)/fs/2;']; eval(the_command);
    all_lens.random = [all_lens.random ceil(1000*size(aud_data, 2)/fs)];
    % stms.aud.data{i_snd} = aud_data; 
    i_snd = i_snd + 1;
end

all_lens.planned = [];
for i_file = 1:settings.stms.planned.n,
    if(exist('audioread') == 0)
        [aud_data fs nbits] = wavread([settings.stms.aud.dirname settings.stms.planned.fnames{i_file} '.wav']); aud_data = aud_data';
    else
        [aud_data fs] = audioread([settings.stms.aud.dirname settings.stms.planned.fnames{i_file} '.wav']); aud_data = aud_data';
    end
    the_command = ['stms.aud.' settings.stms.planned.fnames{i_file} '.data      = aud_data;'];                 eval(the_command);
    the_command = ['stms.aud.' settings.stms.planned.fnames{i_file} '.len       = size(aud_data, 2)/fs;'];     eval(the_command);
    the_command = ['stms.aud.' settings.stms.planned.fnames{i_file} '.delay4rsp = size(aud_data, 2)/fs/2;']; eval(the_command);
    all_lens.planned = [all_lens.planned ceil(1000*size(aud_data, 2)/fs)];
    % stms.aud.data{i_snd} = aud_data;
    i_snd = i_snd + 1;
end
save('audio_lens', 'all_lens');

sca;
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Draw to the external screen if avaliable
screens = Screen('Screens'); screenNumber = max(screens);
% Open an on screen window
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, black, screen_rect);
[theWin, windowRect] = Screen('OpenWindow', screenNumber, settings.screen.bg_colour, settings.screen.rect);
% enable alpha blending
Screen('BlendFunction', theWin, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

Screen('TextSize', theWin, settings.stms.vis.fdbk.font.size);

% Open the audio device
% opening_mode: 1: playback, 2: record, 3: duplex
InitializePsychSound
freq = 22050; reqlatencyclass = 0; opening_mode = 1; nchans = 2;
try
    pahandle = PsychPortAudio('Open', [], opening_mode, reqlatencyclass, freq, nchans);
catch Me
    fprintf('ERROR: could not open device at wanted playback frequency of %d Hz\n', freq);
    return
end
fprintf('Audio device succesfully opened with mode %d\n', opening_mode);

% make textures for play button
[img_data , ~, the_alpha] = imread(settings.btns.play.normal.fname); img_data(:,:,4) = the_alpha;
btn.play.normal.tex = Screen('MakeTexture', theWin, img_data);
[img_data , ~, the_alpha] = imread(settings.btns.play.pressed.fname); img_data(:,:,4) = the_alpha;
btn.play.pressed.tex = Screen('MakeTexture', theWin, img_data);

% make textures for probing response
[img_data , ~, the_alpha] = imread(settings.sels.yes.normal.fname); img_data(:,:,4) = the_alpha;
sel.yes.normal.tex = Screen('MakeTexture', theWin, img_data);
[img_data , ~, the_alpha] = imread(settings.sels.yes.pressed.fname); img_data(:,:,4) = the_alpha;
sel.yes.pressed.tex = Screen('MakeTexture', theWin, img_data);
[img_data , ~, the_alpha] = imread(settings.sels.no.normal.fname); img_data(:,:,4) = the_alpha;
sel.no.normal.tex = Screen('MakeTexture', theWin, img_data);
[img_data , ~, the_alpha] = imread(settings.sels.no.pressed.fname); img_data(:,:,4) = the_alpha;
sel.no.pressed.tex = Screen('MakeTexture', theWin, img_data);

% make texture for prime stimuli
stms.vis.prime.tex = Screen('MakeTexture', theWin, stms.vis.prime.data); stms.vis.prime.data = [];
stms.vis.iti.tex   = Screen('MakeTexture', theWin, stms.vis.iti.data);   stms.vis.iti.data   = [];
% make textures for dependencies
for i_tex = 1:length(stms.vis.dependencies.data),
    the_tex  = Screen('MakeTexture', theWin, stms.vis.dependencies.data{i_tex}); stms.vis.dependencies.data{i_tex} = [];
    the_code = stms.vis.dependencies.code{i_tex};
    % stms.vis.dependencies.tex(i_tex) = the_tex;
    the_command = ['stms.vis.' stms.vis.dependencies.fname{i_tex} '.tex  = the_tex;']; eval(the_command); 
    the_command = ['stms.vis.' stms.vis.dependencies.fname{i_tex} '.code = the_code;']; eval(the_command); 
end
% make textures for random stimuli
for i_tex = 1:length(stms.vis.random.data),
    the_tex  = Screen('MakeTexture', theWin, stms.vis.random.data{i_tex}); stms.vis.random.data{i_tex} = [];
    the_code = stms.vis.random.code{i_tex};
    % stms.vis.random.tex(i_tex) = the_tex;
    the_command = ['stms.vis.' stms.vis.random.fname{i_tex} '.tex  = the_tex;']; eval(the_command); 
    the_command = ['stms.vis.' stms.vis.random.fname{i_tex} '.code = the_code;']; eval(the_command); 
end
% make textures for planned stimuli
for i_tex = 1:length(stms.vis.planned.data),
    the_tex  = Screen('MakeTexture', theWin, stms.vis.planned.data{i_tex}); stms.vis.planned.data{i_tex} = [];
    the_code = stms.vis.planned.code{i_tex};
    % stms.vis.planned.tex(i_tex) = the_tex;
    the_command = ['stms.vis.' stms.vis.planned.fname{i_tex} '.tex  = the_tex;']; eval(the_command); 
    the_command = ['stms.vis.' stms.vis.planned.fname{i_tex} '.code = the_code;']; eval(the_command); 
end
% make textures for re-enforcement stimuli
for i_tex = 1:length(stms.vis.renf.data),
    the_tex = Screen('MakeTexture', theWin, stms.vis.renf.data{i_tex}); stms.vis.renf.data{i_tex} = [];
    stms.vis.renf.tex(i_tex) = the_tex;
%     the_command = ['stms.vis.' stms.vis.renf.fname{i_tex} ' = the_tex;']; eval(the_command); 
end

prime_tex_all = stms.vis.prime.tex*ones(1, settings.stms.vis.n);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTINUE-TO-PRACTICE SCREEN
% %%%%%%%%%%%%%%%%%%%%%%%%%%%

% HideCursor
the_tex                = [btn.play.normal.tex];
the_tex_play_pressed   = [btn.play.pressed.tex];
the_rect               = [settings.btns.play.rect];

% Screen('FillRect', theWin, settings.stms.vis.bg_colour, settings.stms.vis.rects');
Screen('DrawTextures', theWin, the_tex, [], the_rect');
Screen('Flip', theWin, 0, 0);

% wait for mouse input
while 1,
    [x,y,buttons] = GetMouse(theWin);
    if(buttons(1))
        % the_rects = [settings.btns.play.rect; settings.btns.pause.rect];
        diffs = [x - the_rect(:,1) y - the_rect(:,2) the_rect(:,3) - x the_rect(:,4) - y];
        diffs_sign = sign(diffs);  diffs_sign_sum = sum(diffs_sign, 2);
        sum4 = find(diffs_sign_sum == 4);
        if(~isempty(sum4))
            % we have a selection inside an image, check that we have the correct answer
            switch sum4,
                case 1,
                    % play
                    Screen('DrawTextures', theWin, the_tex_play_pressed, [], the_rect');
                    Screen('Flip', theWin, 0, 0);                  
            end
            % wait for release
            while(1), [~,~,buttons] = GetMouse(theWin); if(~buttons(1)), break; end, end
            Screen('DrawTextures', theWin, the_tex, [], the_rect');
            Screen('Flip', theWin, 0, 0);
            break;
        end
    end
end

Screen('Flip', theWin, 0, 0);

WaitSecs(1);


% RUN THE PRACTICE
% %%%%%%%%%%%%%%%%
i_blk = 1;
i_set = 1;
ind4set = 1;
data.start_tstamp = now;
data.start_tstamp_text = LOCAL_datestr_mdd;
when2flip = 0;
c_set_info = practice_settings.sets.trplts_order{ind4set};
data.trld = [];
data.RTs_running_window = NaN(1, size(c_set_info, 1));
size(c_set_info, 1)
for i_practice = 1:size(c_set_info, 1)
    
    clear trld
    c_trplt      = practice_info.stm{i_blk, i_set, i_practice};
    c_trplt_type = practice_settings.sets.trplts_type{ind4set}(i_practice);
    
    trld.i_blk      = i_blk;
    trld.i_set      = i_set;
    trld.ind4set    = (i_blk - 1)*practice_settings.n_sets4block + i_set;
    trld.i_trp      = i_practice;
    trld.trial_info = practice_info;
    trld.settings   = practice_settings;
    trld.trplt      = c_trplt;
    trld.trplt_type = c_trplt_type;
    
    fprintf('Block %d Set %d Triplet %d, type %d\n\t\t', i_blk, i_set, i_practice, c_trplt_type);
    for i_trl = 1:3,
        for i_img = 1:settings.n_imgs4trial,
            fprintf('%s\t', practice_info.stm{i_blk, i_set, i_practice}{i_trl, i_img});
        end
        fprintf('\n\t\t');
    end
    fprintf('\n');
%     if(c_trplt_type == 7), i_trl = 3; for i_img = 1:practice_settings.n_imgs4trial, if(strcmp(practice_info.stm{i_blk, i_set, i_practice}{i_trl, i_img}(1), 'T')), fprintf('Target %s\n', practice_info.stm{i_blk, i_set, i_practice}{i_trl, i_img}); end, end, end
    
    % identify the targets
    tgt_pos = NaN(1,3);
    for i_trl = 1:3,
        for i_img = 1:length({c_trplt{i_trl,:}}),
            if(strcmp(c_trplt{i_trl,i_img}(1), 'T'))
                tgt_pos(i_trl) = i_img; break;
            end
        end
    end
    trld.tgt_pos = tgt_pos;
    
    % %%%%%%%%%%%%%%%%%%%%%%
    % TRIAL 1 IN THE TRIPLET
    % %%%%%%%%%%%%%%%%%%%%%%
    i_trl = 1;
    % Fill the audio buffer and start playback with infinite start time and no wait
    the_command = ['sound2play = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.data;']; eval(the_command);
    the_command = ['delay4rsp  = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.delay4rsp;']; eval(the_command);
    the_command = ['audio_len  = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.len;']; eval(the_command);
    PsychPortAudio('FillBuffer', pahandle, sound2play);
    PsychPortAudio('Start',      pahandle, 1, Inf, 0);
    
    i_img = 1;
    the_command = ['tex4trial            = stms.vis.' c_trplt{i_trl,i_img}(2:end) '.tex;']; eval(the_command);
    the_command = ['trld.code4tgt(i_trl) = stms.vis.' c_trplt{i_trl,i_img}(2:end) '.code;']; eval(the_command);
    
    % PRIME 1
    % %%%%%%%
    i_prime = 1;
    Screen('FillRect',     theWin, settings.stms.vis.bg_colour, settings.stms.vis.named.rect');
    Screen('DrawTextures', theWin, prime_tex_all(1), [],        settings.stms.vis.named.rect);
    Screen('FillRect',     theWin, settings.renf.bg_colour,     settings.renf.area.rect');
    
    trld.tstamps.vis.prime_onset(i_prime) = Screen(theWin, 'Flip', when2flip);
    when2flip = trld.tstamps.vis.prime_onset(i_prime) + settings.stms.vis.prime.duration;
    
    % NAMED ITEM 1
    % 5%%%%%%%%%%%
    i_named = 1;
    trld.audio.named.len(i_named) = audio_len;
    
    Screen('FillRect',     theWin, settings.stms.vis.bg_colour, settings.stms.vis.named.rect);
    Screen('DrawTextures', theWin, tex4trial, [],               settings.stms.vis.named.rect);
    Screen('FrameRect',    theWin, settings.stms.vis.frame.colour, settings.stms.vis.named.rect, settings.stms.vis.frame.wdt);
    Screen('FillRect',     theWin, settings.renf.bg_colour,     settings.renf.area.rect');
    
    trld.tstamps.vis.named_onset(i_named)  = Screen(theWin, 'Flip', when2flip);
    when2flip = trld.tstamps.vis.named_onset(i_named) + settings.stms.aud.offset;
    % reschedule audio start to coincide with frame onset, don't wait for start
    PsychPortAudio('RescheduleStart', pahandle, when2flip, 0, 1);
    
    trld.tstamps.vis.prime_duration(i_prime)                = trld.tstamps.vis.named_onset(i_named) - trld.tstamps.vis.prime_onset(i_prime);
    
    % frame the target in sync with audio onset
    Screen('FillRect',     theWin, settings.stms.vis.bg_colour,    settings.stms.vis.named.rect);
    Screen('DrawTextures', theWin, tex4trial, [],                  settings.stms.vis.named.rect);
    Screen('FrameRect',    theWin, settings.stms.vis.fbk.colour,   settings.stms.vis.named.frame.rect, settings.stms.vis.fbk.wdt);
    Screen('FillRect',     theWin, settings.renf.bg_colour,        settings.renf.area.rect');
    
    trld.tstamps.vis.named_frame_onset(i_named)  = Screen(theWin, 'Flip', when2flip);
    when2flip = trld.tstamps.vis.named_frame_onset(i_named) + settings.stms.vis.duration;
    
    % wait for audio to finish
    while 1
        audio_status = PsychPortAudio('GetStatus', pahandle);
        if(audio_status.Active == 0), break; end
    end
    trld.tstamps.aud.named.sound_offset(i_named)       = GetSecs;
    trld.audio_info.named(i_named)                     = audio_status;
    trld.tstamps.aud.named.sound_onset(i_named)        = audio_status.StartTime;
    trld.tstamps.aud.named.sound2visual_delay(i_named) = trld.tstamps.aud.named.sound_onset(i_named) - trld.tstamps.vis.named_onset(i_named);
        
    % %%%%%%%%%%%%%%%%%%%%%%
    % TRIAL 2 IN THE TRIPLET
    % %%%%%%%%%%%%%%%%%%%%%%
    i_trl = 2;
    % Fill the audio buffer and start playback with infinite start time and no wait
    the_command = ['sound2play = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.data;']; eval(the_command);
    the_command = ['delay4rsp = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.delay4rsp;']; eval(the_command);
    the_command = ['audio_len = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.len;']; eval(the_command);
    % PsychPortAudio('FillBuffer', pahandle, stms.aud.data{trialsound(1)});
    PsychPortAudio('FillBuffer', pahandle, sound2play);
    PsychPortAudio('Start',      pahandle, 1, Inf, 0);
    
    % build the texture array
    i_img = 1;
    the_command = ['tex4trial            = stms.vis.' c_trplt{i_trl,i_img}(2:end) '.tex;']; eval(the_command);
    the_command = ['trld.code4tgt(i_trl) = stms.vis.' c_trplt{i_trl,i_img}(2:end) '.code;']; eval(the_command);    
    
    % PRIME 2
    % %%%%%%%
    i_prime = i_prime + 1;
    Screen('FillRect',     theWin, settings.stms.vis.bg_colour, settings.stms.vis.named.rect);
    Screen('DrawTextures', theWin, prime_tex_all, [], settings.stms.vis.named.rect);
    Screen('FillRect',     theWin, settings.renf.bg_colour, settings.renf.area.rect');
    
    trld.tstamps.vis.prime_onset(i_prime) = Screen(theWin, 'Flip', when2flip);    
    when2flip = trld.tstamps.vis.prime_onset(i_prime) + settings.stms.vis.prime.duration;
    trld.tstamps.vis.named_duration(i_named) = trld.tstamps.vis.prime_onset(i_prime) - trld.tstamps.vis.named_onset(i_named);
    
    % NAMED ITEM 2
    % %%%%%%%%%%%%
    i_named = 2;
    trld.audio.named.len(i_named) = audio_len;
    Screen('FillRect',     theWin, settings.stms.vis.bg_colour, settings.stms.vis.named.rect);
    Screen('DrawTextures', theWin, tex4trial, [], settings.stms.vis.named.rect);
    Screen('FrameRect',    theWin, settings.stms.vis.frame.colour, settings.stms.vis.named.rect, settings.stms.vis.frame.wdt);
    Screen('FillRect',     theWin, settings.renf.bg_colour, settings.renf.area.rect');
    
    trld.tstamps.vis.named_onset(i_named) = Screen(theWin, 'Flip', when2flip);
    trld.tstamps.vis.prime_duration(i_prime) = trld.tstamps.vis.named_onset(i_named) - trld.tstamps.vis.prime_onset(i_prime);
    
    when2flip = trld.tstamps.vis.named_onset(i_named) + settings.stms.aud.offset;
    % reschedule audio start to coincide with frame onset, don't wait for start
    PsychPortAudio('RescheduleStart', pahandle, when2flip, 0, 1);
    
    trld.tstamps.vis.prime_duration(i_prime)                = trld.tstamps.vis.named_onset(i_named) - trld.tstamps.vis.prime_onset(i_prime);
    
    % frame the target in sync with audio onset
    Screen('FillRect',     theWin, settings.stms.vis.bg_colour,    settings.stms.vis.named.rect);
    Screen('DrawTextures', theWin, tex4trial, [],                  settings.stms.vis.named.rect);
    Screen('FrameRect',    theWin, settings.stms.vis.fbk.colour,   settings.stms.vis.named.frame.rect, settings.stms.vis.fbk.wdt);
    Screen('FillRect',     theWin, settings.renf.bg_colour,        settings.renf.area.rect');
    
    trld.tstamps.vis.named_frame_onset(i_named)  = Screen(theWin, 'Flip', when2flip);
    when2flip = trld.tstamps.vis.named_frame_onset(i_named) + settings.stms.vis.duration;
    
    % wait for audio to finish
    while 1
        audio_status = PsychPortAudio('GetStatus', pahandle);
        if(audio_status.Active == 0), break; end
    end
    trld.tstamps.aud.named.sound_offset(i_named)       = GetSecs;
    trld.audio_info.named(i_named)                     = audio_status;
    trld.tstamps.aud.named.sound_onset(i_named)        = audio_status.StartTime;
    trld.tstamps.aud.named.sound2visual_delay(i_named) = trld.tstamps.aud.named.sound_onset(i_named) - trld.tstamps.vis.named_onset(i_named);
    
    % %%%%%%%%%%%%%%%%%%%%%%
    % TRIAL 3 IN THE TRIPLET
    % %%%%%%%%%%%%%%%%%%%%%%
    i_trl = 3;
    % Fill the audio buffer and start playback with infinite start time and no wait
    the_command = ['sound2play = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.data;']; eval(the_command);
    the_command = ['delay4rsp  = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.delay4rsp;']; eval(the_command);
    the_command = ['audio_len  = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.len;']; eval(the_command);
    PsychPortAudio('FillBuffer', pahandle, sound2play);
    PsychPortAudio('Start',      pahandle, 1, Inf, 0);
    
    % build the texture array
    tex4trial = [];
    for i_img = 1:length({c_trplt{i_trl,:}}),
        if(strcmp(c_trplt{i_trl,i_img}(1), 'T'))
            the_command = ['tex4trial            = [tex4trial stms.vis.' c_trplt{i_trl,i_img}(2:end) '.tex];']; eval(the_command);
            the_command = ['trld.code4tgt(i_trl) = stms.vis.' c_trplt{i_trl,i_img}(2:end) '.code;']; eval(the_command);
        else
            the_command = ['tex4trial = [tex4trial stms.vis.' c_trplt{i_trl,i_img} '.tex];']; eval(the_command);
        end
    end
    
    % PRIME 3
    % %%%%%%%
    i_prime = i_prime + 1;
    Screen('FillRect', theWin, settings.stms.vis.bg_colour, settings.stms.vis.rects');
    Screen('DrawTextures', theWin, prime_tex_all, [], settings.stms.vis.rects');
    Screen('FillRect', theWin, settings.renf.bg_colour, settings.renf.area.rect');
    
    trld.tstamps.vis.prime_onset(i_prime) = Screen(theWin, 'Flip', when2flip);
    when2flip = trld.tstamps.vis.prime_onset(i_prime) + settings.stms.vis.prime.duration;
    trld.tstamps.vis.named_duration(i_named) = trld.tstamps.vis.prime_onset(i_prime) - trld.tstamps.vis.named_onset(i_named);
    
    % TARGET SELECTION
    % %%%%%%%%%%%%%%%%
    trld.audio.target.len = audio_len;
    Screen('FillRect',     theWin, settings.stms.vis.bg_colour, settings.stms.vis.rects');
    Screen('DrawTextures', theWin, tex4trial, [],               settings.stms.vis.rects');
    Screen('FrameRect',    theWin, settings.stms.vis.frame.colour, settings.stms.vis.frame.rects', settings.stms.vis.frame.wdt);
    Screen('FillRect',     theWin, settings.renf.bg_colour,     settings.renf.area.rect');    
    
    trld.tstamps.vis.target_onset = Screen(theWin, 'Flip', when2flip);
    when2snd = trld.tstamps.vis.target_onset + settings.stms.aud.offset;
    PsychPortAudio('RescheduleStart', pahandle, when2snd, 0, 1); % do not wait for start
    trld.tstamps.vis.prime_duration(i_prime) = trld.tstamps.vis.target_onset - trld.tstamps.vis.prime_onset(i_prime);
    
    % wait for selection immediatelly after the audio started
    correctSelection = tgt_pos(i_trl);
    % initialise the responses recorded
    trld.rsp.target.ind4imgs = [];
    trld.rsp.target.accuracy = [];
    trld.rsp.target.tstamp   = [];
    while 1,
        [x,y,buttons] = GetMouse(theWin); mouseTime = GetSecs;
        if(buttons(1))
            the_rects = settings.stms.vis.rects;
            diffs = [x - the_rects(:,1) y - the_rects(:,2) the_rects(:,3) - x the_rects(:,4) - y];
            diffs_sign = sign(diffs);  diffs_sign_sum = sum(diffs_sign, 2);
            sum4 = find(diffs_sign_sum == 4);
            if(~isempty(sum4))
                % we have a selection inside an image
                trld.rsp.target.ind4imgs = [trld.rsp.target.ind4imgs sum4];
                trld.rsp.target.tstamp   = [trld.rsp.target.tstamp   mouseTime];
                % check that we have the correct answer
                if(sum4 == correctSelection),
                    % we have the correct answer
                    trld.rsp.target.accuracy = [trld.rsp.target.accuracy 1];
                    % give visual feedback                             Screen('DrawTextures', theWin, tex4trial, [], settings.stms.vis.rects');
                    Screen('FillRect',     theWin, settings.stms.vis.bg_colour, settings.stms.vis.rects');
                    Screen('DrawTextures', theWin, tex4trial, [],               settings.stms.vis.rects');
                    Screen('FrameRect',    theWin, settings.stms.vis.frame.colour, settings.stms.vis.frame.rects', settings.stms.vis.frame.wdt);                    
                    Screen('FillRect',     theWin, settings.renf.bg_colour, settings.renf.area.rect');
                    Screen('FrameRect',    theWin, settings.stms.vis.fbk.colour, settings.stms.vis.frame.rects(correctSelection, :), 2*settings.stms.vis.fbk.wdt);
                    Screen(theWin, 'Flip');
                    % wait for mouse lift
                    while 1, [~,~,buttons] = GetMouse(theWin); if(~buttons(1)), break; end, end
                    % restore display without feedback
                    Screen('FillRect',     theWin, settings.stms.vis.bg_colour, settings.stms.vis.rects');
                    Screen('DrawTextures', theWin, tex4trial, [], settings.stms.vis.rects');
                    Screen('FillRect',     theWin, settings.renf.bg_colour, settings.renf.area.rect');
                    Screen('FrameRect',    theWin, settings.stms.vis.frame.colour, settings.stms.vis.frame.rects', settings.stms.vis.frame.wdt);                    
                    Screen('FillRect',     theWin, settings.renf.bg_colour, settings.renf.area.rect');
                    Screen(theWin, 'Flip', 0);
                    
                    % wait for audio to finish 
                    while 1
                        audio_status = PsychPortAudio('GetStatus', pahandle);
                        if(audio_status.Active == 0), break; end
                    end
                    trld.tstamps.aud.target.sound_offset       = GetSecs;
                    trld.audio_info.target                     = audio_status;
                    trld.tstamps.aud.target.sound_onset        = audio_status.StartTime;
                    trld.tstamps.aud.target.sound2visual_delay = trld.tstamps.aud.target.sound_onset - trld.tstamps.vis.target_onset;
                    break;
                else
                    trld.rsp.target.accuracy = [trld.rsp.target.accuracy 0];
                end
            end
        end
    end
    % wait for audio to finish
    while 1
        audio_status = PsychPortAudio('GetStatus', pahandle);
        if(audio_status.Active == 0), break; end
    end
    % INTER-TRIPLET
    % %%%%%%%%%%%%%
    % Screen('FillRect', theWin, settings.stms.vis.bg_colour, settings.stms.vis.rects');
    Screen('FillRect', theWin, settings.renf.bg_colour, settings.renf.area.rect');
    Screen('DrawTextures', theWin, stms.vis.iti.tex, [], settings.stms.vis.iti.rect);
    
    trld.tstamps.vis.iti = Screen(theWin, 'Flip', 0);
    when2flip = trld.tstamps.vis.iti + settings.stms.vis.iti.duration;
    
    trld.rsp.target.RT.ref2audonset = trld.rsp.target.tstamp(end) - trld.tstamps.aud.target.sound_onset;

    data.RTs_running_window(i_practice) = trld.rsp.target.RT.ref2audonset;
        
    trld.info.type = c_trplt_type;    
    
    data.trld = [data.trld trld];
    
end


% save raw practice data
save(outfname_practice_raw, 'data');   

% save summmary file
d2output.header = {'ID', 'Age', 'Gender', 'Group', 'Routine', 'NBlocks', 'NSets4Block', 'Block', 'Set', 'SetInd', 'Triplet', 'Type', 'Prime1Dur', 'Prime2Dur', 'Prime3Dur', 'Named1Dur', 'Named2Dur', 'Named1Snd2VisDelay', 'Named2Snd2VisDelay', 'TargetSnd2VisDelay', 'Named1StmCode', 'Named2StmCode', 'TargetCode', 'TargetNRsp', 'TargetACC', 'TargetRT'};
d2output.data   = [    ];
for i_trl =1:length(data.trld),
    trld = data.trld(i_trl);
    d2output.data = [d2output.data;
        trld.i_blk trld.i_set trld.ind4set trld.i_trp ...
        trld.info.type ...
        round(1000*trld.tstamps.vis.prime_duration(1:3)) ...
        round(1000*trld.tstamps.vis.named_duration(1:2)) ...
        round(1000*trld.tstamps.aud.named.sound2visual_delay(1)) ...
        round(1000*trld.tstamps.aud.named.sound2visual_delay(2)) ...
        round(1000*trld.tstamps.aud.target.sound2visual_delay) ...
        trld.code4tgt ...
        length(trld.rsp.target.accuracy) ...
        trld.rsp.target.accuracy(1) ...
        round(1000*trld.rsp.target.RT.ref2audonset) ...
        ];
end

fdout = fopen(outfname_practice_data, 'w');
for i_h = 1:length(d2output.header), fprintf(fdout, '%s,', d2output.header{i_h}); end, fprintf(fdout, '\n');
for i_trl =1:length(data.trld),
    % write the ID, age and gender
    fprintf(fdout, '%s,', session_info.ID);
    fprintf(fdout, '%d,', session_info.age.value);
    fprintf(fdout, '%d,', session_info.gender.code);
    fprintf(fdout, '%d,', session_info.group.code);
    fprintf(fdout, '%d,', session_info.routine.code);
    fprintf(fdout, '%d,', settings.n_blocks);
    fprintf(fdout, '%d,', settings.n_sets4block);
    for i_d = 1:length(d2output.data(i_trl, :)), fprintf(fdout, '%d,',d2output.data(i_trl, i_d)); end, fprintf(fdout, '\n');
end
fclose(fdout);

% process reaction time - initialise running buffer and calculate first threshold
threshold.running_window = data.RTs_running_window;
threshold.value          = median(threshold.running_window);

% RUN THE STUDY
% %%%%%%%%%%%%%

tex4renf = [stms.vis.renf.tex stms.vis.renf.tex];
alphas4renf = zeros(size(tex4renf));

clear data;
data.trld      = [];
% initial values for threshold and running window as derived from the practice
data.threshold = threshold;
data.start_tstamp = now;
data.start_tstamp_text = LOCAL_datestr_mdd;
ind4next_renf = 1;
when2flip = 0;
total_rewards = 0;
ind4set = 0;
for i_blk = 1:settings.n_blocks,
    % %%%%%%%%%%%%%%%%%%
    % BREAK BEFORE BLOCK
    % %%%%%%%%%%%%%%%%%%
    
    the_tex                = [btn.play.normal.tex];
    the_tex_play_pressed   = [btn.play.pressed.tex];
    the_rect               = [settings.btns.play.rect];
    
    % Screen('FillRect', theWin, settings.stms.vis.bg_colour, settings.stms.vis.rects');
    Screen('DrawTextures', theWin, the_tex, [], the_rect');
    if(i_blk > 1),  
        total_rewards = total_rewards + length(find(alphas4renf == 1));
        fdbk_str = ['You have won ' num2str(total_rewards) ' points'];
        [nx, ny, textbounds] = DrawFormattedText(theWin, fdbk_str, 'center', 'center', settings.stms.vis.fdbk.font.colour, 70, 0, 0, 1.5, 0, settings.stms.vis.fdbk.rect); 
        alphas4renf = zeros(size(tex4renf));
        ind4next_renf = 1;
    end
    Screen('Flip', theWin, 0, 0);
    
    % wait for mouse input
    while 1,
        [x,y,buttons] = GetMouse(theWin);
        if(buttons(1))
            % the_rects = [settings.btns.play.rect; settings.btns.pause.rect];
            diffs = [x - the_rect(:,1) y - the_rect(:,2) the_rect(:,3) - x the_rect(:,4) - y];
            diffs_sign = sign(diffs);  diffs_sign_sum = sum(diffs_sign, 2);
            sum4 = find(diffs_sign_sum == 4);
            if(~isempty(sum4))
                % we have a selection inside an image, check that we have the correct answer
                switch sum4,
                    case 1,
                        % play
                        Screen('DrawTextures', theWin, the_tex_play_pressed, [], the_rect');
                        Screen('Flip', theWin, 0, 0);
                end
                % wait for release
                while(1), [~,~,buttons] = GetMouse(theWin); if(~buttons(1)), break; end, end
                Screen('DrawTextures', theWin, the_tex, [], the_rect');
                Screen('Flip', theWin, 0, 0);
                break;
            end
        end
    end
    
    Screen('Flip', theWin, 0, 0);
    
    WaitSecs(1);
    
    fprintf('Block %d\n', i_blk);
    for i_set = 1:settings.n_sets4block,
        fprintf('\tSet %d\n\t\t', i_set);
        ind4set = ind4set + 1;
     
        c_set_info = settings.sets.trplts_order{ind4set};
        for i_trp = 1:size(c_set_info, 1)
            
            clear trld
            c_trplt      = trial_info.stm{i_blk, i_set, i_trp};
            c_trplt_type = settings.sets.trplts_type{ind4set}(i_trp);
                        
            trld.i_blk      = i_blk;
            trld.i_set      = i_set;
            trld.ind4set    = (i_blk - 1)*settings.n_sets4block + i_set;
            trld.i_trp      = i_trp;
            trld.trial_info = trial_info;
            trld.settings   = settings;
            trld.trplt      = c_trplt;
            trld.trplt_type = c_trplt_type;
            
            data.threshold.value = median(data.threshold.running_window);
            fprintf('Block %d Set %d Triplet %d, type %d\n\t\t', i_blk, i_set, i_trp, c_trplt_type);
            for i_trl = 1:3,
                for i_img = 1:settings.n_imgs4trial,
                    fprintf('%s\t', trial_info.stm{i_blk, i_set, i_trp}{i_trl, i_img});
                end
                fprintf('\n\t\t');
            end
            fprintf('\n');
            if(c_trplt_type == 7), i_trl = 3; for i_img = 1:settings.n_imgs4trial, if(strcmp(trial_info.stm{i_blk, i_set, i_trp}{i_trl, i_img}(1), 'T')), fprintf('Target %s\n', trial_info.stm{i_blk, i_set, i_trp}{i_trl, i_img}); end, end, end
            
            % identify the targets
            tgt_pos = NaN(1,3);
            for i_trl = 1:3,
                for i_img = 1:length({c_trplt{i_trl,:}}),
                    if(strcmp(c_trplt{i_trl,i_img}(1), 'T'))
                        tgt_pos(i_trl) = i_img; break;
                    end
                end
            end
            trld.tgt_pos = tgt_pos;
            
            % %%%%%%%%%%%%%%%%%%%%%%
            % TRIAL 1 IN THE TRIPLET
            % %%%%%%%%%%%%%%%%%%%%%%
            i_trl = 1;
            % Fill the audio buffer and start playback with infinite start time and no wait
            the_command = ['sound2play = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.data;']; eval(the_command);
            the_command = ['delay4rsp  = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.delay4rsp;']; eval(the_command);
            the_command = ['audio_len  = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.len;']; eval(the_command);
            PsychPortAudio('FillBuffer', pahandle, sound2play);
            PsychPortAudio('Start',      pahandle, 1, Inf, 0);
                                                
            i_img = 1;
            the_command = ['tex4trial            = stms.vis.' c_trplt{i_trl,i_img}(2:end) '.tex;']; eval(the_command);
            the_command = ['trld.code4tgt(i_trl) = stms.vis.' c_trplt{i_trl,i_img}(2:end) '.code;']; eval(the_command);
                        
            % PRIME 1
            % %%%%%%%
            i_prime = 1;
            Screen('FillRect',     theWin, settings.stms.vis.bg_colour, settings.stms.vis.named.rect');
            Screen('DrawTextures', theWin, prime_tex_all(1), [],        settings.stms.vis.named.rect);
            Screen('FillRect',     theWin, settings.renf.bg_colour,     settings.renf.area.rect');
            Screen('DrawTextures', theWin, tex4renf, [],                settings.stms.vis.renf.rects', [], [], alphas4renf); 
            
            trld.tstamps.vis.prime_onset(i_prime) = Screen(theWin, 'Flip', when2flip);
            when2flip = trld.tstamps.vis.prime_onset(i_prime) + settings.stms.vis.prime.duration;                        
            
            % NAMED ITEM 1
            % 5%%%%%%%%%%%
            i_named = 1;
            trld.audio.named.len(i_named) = audio_len;
            
            Screen('FillRect',     theWin, settings.stms.vis.bg_colour, settings.stms.vis.named.rect);            
            Screen('DrawTextures', theWin, tex4trial, [],               settings.stms.vis.named.rect);            
            Screen('FrameRect',    theWin, settings.stms.vis.frame.colour, settings.stms.vis.named.rect, settings.stms.vis.frame.wdt);
            Screen('FillRect',     theWin, settings.renf.bg_colour,     settings.renf.area.rect');
            Screen('DrawTextures', theWin, tex4renf, [],                settings.stms.vis.renf.rects', [], [], alphas4renf);     
            
            trld.tstamps.vis.named_onset(i_named)  = Screen(theWin, 'Flip', when2flip);
            when2flip = trld.tstamps.vis.named_onset(i_named) + settings.stms.aud.offset;
            % reschedule audio start to coincide with frame onset, don't wait for start           
            PsychPortAudio('RescheduleStart', pahandle, when2flip, 0, 1);
            
            trld.tstamps.vis.prime_duration(i_prime) = trld.tstamps.vis.named_onset(i_named) - trld.tstamps.vis.prime_onset(i_prime);            
            
            % frame the target in sync with audio onset
            Screen('FillRect',     theWin, settings.stms.vis.bg_colour,    settings.stms.vis.named.rect);            
            Screen('DrawTextures', theWin, tex4trial, [],                  settings.stms.vis.named.rect);
            Screen('FrameRect',    theWin, settings.stms.vis.fbk.colour,   settings.stms.vis.named.frame.rect, settings.stms.vis.fbk.wdt);             
            Screen('FillRect',     theWin, settings.renf.bg_colour,        settings.renf.area.rect');
            Screen('DrawTextures', theWin, tex4renf, [],                   settings.stms.vis.renf.rects', [], [], alphas4renf); 
            
            trld.tstamps.vis.named_frame_onset(i_named)  = Screen(theWin, 'Flip', when2flip);
            when2flip = trld.tstamps.vis.named_frame_onset(i_named) + settings.stms.vis.duration;
                       
            % wait for audio to finish 
            while 1
                audio_status = PsychPortAudio('GetStatus', pahandle);
                if(audio_status.Active == 0), break; end
            end
            trld.tstamps.aud.named.sound_offset(i_named) = GetSecs;
            trld.audio_info.named(i_named) = audio_status;
            trld.tstamps.aud.named.sound_onset(i_named) = audio_status.StartTime;
            trld.tstamps.aud.named.sound2visual_delay(i_named) = trld.tstamps.aud.named.sound_onset(i_named) - trld.tstamps.vis.named_onset(i_named);
                                   
            % %%%%%%%%%%%%%%%%%%%%%%
            % TRIAL 2 IN THE TRIPLET
            % %%%%%%%%%%%%%%%%%%%%%%
            i_trl = 2;
            % Fill the audio buffer and start playback with infinite start time and no wait
            the_command = ['sound2play = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.data;']; eval(the_command);
            the_command = ['delay4rsp  = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.delay4rsp;']; eval(the_command);
            the_command = ['audio_len  = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.len;']; eval(the_command);
            % PsychPortAudio('FillBuffer', pahandle, stms.aud.data{trialsound(1)});
            PsychPortAudio('FillBuffer', pahandle, sound2play);
            PsychPortAudio('Start',      pahandle, 1, Inf, 0);
            
            % build the texture array
            i_img = 1;
            the_command = ['tex4trial            = stms.vis.' c_trplt{i_trl,i_img}(2:end) '.tex;']; eval(the_command);
            the_command = ['trld.code4tgt(i_trl) = stms.vis.' c_trplt{i_trl,i_img}(2:end) '.code;']; eval(the_command);
            
            
            % PRIME 2
            % %%%%%%%
            i_prime = i_prime + 1;
            Screen('FillRect', theWin, settings.stms.vis.bg_colour, settings.stms.vis.named.rect);
            Screen('DrawTextures', theWin, prime_tex_all, [], settings.stms.vis.named.rect);
            Screen('FillRect', theWin, settings.renf.bg_colour, settings.renf.area.rect');
            Screen('DrawTextures', theWin, tex4renf, [], settings.stms.vis.renf.rects', [], [], alphas4renf);
    
            trld.tstamps.vis.prime_onset(i_prime) = Screen(theWin, 'Flip', when2flip);            
            when2flip = trld.tstamps.vis.prime_onset(i_prime) + settings.stms.vis.prime.duration;           
            trld.tstamps.vis.named_duration(i_named) = trld.tstamps.vis.prime_onset(i_prime) - trld.tstamps.vis.named_onset(i_named);
            
            % NAMED ITEM 2
            % %%%%%%%%%%%%
            i_named = 2;
            trld.audio.named.len(i_named) = audio_len;
            Screen('FillRect',     theWin, settings.stms.vis.bg_colour, settings.stms.vis.named.rect);            
            Screen('DrawTextures', theWin, tex4trial, [], settings.stms.vis.named.rect);
            Screen('FrameRect', theWin, settings.stms.vis.frame.colour, settings.stms.vis.named.rect, settings.stms.vis.frame.wdt);
            Screen('FillRect',     theWin, settings.renf.bg_colour, settings.renf.area.rect');
            Screen('DrawTextures', theWin, tex4renf, [], settings.stms.vis.renf.rects', [], [], alphas4renf);
            
            trld.tstamps.vis.named_onset(i_named) = Screen(theWin, 'Flip', when2flip);
            trld.tstamps.vis.prime_duration(i_prime) = trld.tstamps.vis.named_onset(i_named) - trld.tstamps.vis.prime_onset(i_prime);
                  
            when2flip = trld.tstamps.vis.named_onset(i_named) + settings.stms.aud.offset;
            % reschedule audio start to coincide with frame onset, don't wait for start         
            PsychPortAudio('RescheduleStart', pahandle, when2flip, 0, 1);
            
            trld.tstamps.vis.prime_duration(i_prime)                = trld.tstamps.vis.named_onset(i_named) - trld.tstamps.vis.prime_onset(i_prime);            
            
            % frame the target in sync with audio onset
            Screen('FillRect',     theWin, settings.stms.vis.bg_colour,    settings.stms.vis.named.rect);            
            Screen('DrawTextures', theWin, tex4trial, [],                  settings.stms.vis.named.rect);
            Screen('FrameRect',    theWin, settings.stms.vis.fbk.colour,   settings.stms.vis.named.frame.rect, settings.stms.vis.fbk.wdt);             
            Screen('FillRect',     theWin, settings.renf.bg_colour,        settings.renf.area.rect');
            Screen('DrawTextures', theWin, tex4renf, [],                   settings.stms.vis.renf.rects', [], [], alphas4renf); 
            
            trld.tstamps.vis.named_frame_onset(i_named) = Screen(theWin, 'Flip', when2flip);
            when2flip = trld.tstamps.vis.named_frame_onset(i_named) + settings.stms.vis.duration;

            % wait for audio to finish 
            while 1
                audio_status = PsychPortAudio('GetStatus', pahandle);
                if(audio_status.Active == 0), break; end
            end
            trld.tstamps.aud.named.sound_offset(i_named) = GetSecs;
            trld.audio_info.named(i_named) = audio_status;
            trld.tstamps.aud.named.sound_onset(i_named)        = audio_status.StartTime;
            trld.tstamps.aud.named.sound2visual_delay(i_named) = trld.tstamps.aud.named.sound_onset(i_named) - trld.tstamps.vis.named_onset(i_named);           
            
            % %%%%%%%%%%%%%%%%%%%%%%
            % TRIAL 3 IN THE TRIPLET
            % %%%%%%%%%%%%%%%%%%%%%%
            i_trl = 3;
            % Fill the audio buffer and start playback with infinite start time and no wait
            the_command = ['sound2play = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.data;']; eval(the_command);
            the_command = ['delay4rsp  = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.delay4rsp;']; eval(the_command);
            the_command = ['audio_len  = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.len;']; eval(the_command);
            % PsychPortAudio('FillBuffer', pahandle, stms.aud.data{trialsound(1)});
            PsychPortAudio('FillBuffer', pahandle, sound2play);
            PsychPortAudio('Start',      pahandle, 1, Inf, 0);
            
            % build the texture array
            tex4trial = [];
            for i_img = 1:length({c_trplt{i_trl,:}}),
                    if(strcmp(c_trplt{i_trl,i_img}(1), 'T'))
                        the_command = ['tex4trial            = [tex4trial stms.vis.' c_trplt{i_trl,i_img}(2:end) '.tex];']; eval(the_command);
                        the_command = ['trld.code4tgt(i_trl) = stms.vis.' c_trplt{i_trl,i_img}(2:end) '.code;']; eval(the_command);
                    else
                        the_command = ['tex4trial = [tex4trial stms.vis.' c_trplt{i_trl,i_img} '.tex];']; eval(the_command);
                    end
            end

            % PRIME 3
            % %%%%%%%
            i_prime = i_prime + 1;
            Screen('FillRect',     theWin, settings.stms.vis.bg_colour, settings.stms.vis.rects');
            Screen('DrawTextures', theWin, prime_tex_all, [], settings.stms.vis.rects');           
            Screen('FillRect',     theWin, settings.renf.bg_colour, settings.renf.area.rect');
            Screen('DrawTextures', theWin, tex4renf, [], settings.stms.vis.renf.rects', [], [], alphas4renf);
            
            trld.tstamps.vis.prime_onset(i_prime) = Screen(theWin, 'Flip', when2flip);
            when2flip = trld.tstamps.vis.prime_onset(i_prime) + settings.stms.vis.prime.duration;
            trld.tstamps.vis.named_duration(i_named) = trld.tstamps.vis.prime_onset(i_prime) - trld.tstamps.vis.named_onset(i_named);
            
            % TARGET SELECTION
            % %%%%%%%%%%%%%%%%           
            trld.audio.target.len = audio_len;
            Screen('FillRect',     theWin, settings.stms.vis.bg_colour, settings.stms.vis.rects');
            Screen('DrawTextures', theWin, tex4trial, [],               settings.stms.vis.rects');
            Screen('FrameRect', theWin, settings.stms.vis.frame.colour, settings.stms.vis.frame.rects', settings.stms.vis.frame.wdt);
            Screen('FillRect',     theWin, settings.renf.bg_colour,     settings.renf.area.rect');
            Screen('DrawTextures', theWin, tex4renf, [],                settings.stms.vis.renf.rects', [], [], alphas4renf);           
            
            trld.tstamps.vis.target_onset = Screen(theWin, 'Flip', when2flip);
            when2snd = trld.tstamps.vis.target_onset + settings.stms.aud.offset;
            PsychPortAudio('RescheduleStart', pahandle, when2snd , 0, 1); % do not wait for start
            trld.tstamps.vis.prime_duration(i_prime) = trld.tstamps.vis.target_onset - trld.tstamps.vis.prime_onset(i_prime);
            
            correctSelection = tgt_pos(i_trl);
            % initialise the responses recorded
            trld.rsp.target.ind4imgs = [];
            trld.rsp.target.accuracy = [];
            trld.rsp.target.tstamp   = [];
            while 1,
                [x,y,buttons] = GetMouse(theWin); mouseTime = GetSecs;
                if(buttons(1))
                    the_rects = settings.stms.vis.rects;
                    diffs = [x - the_rects(:,1) y - the_rects(:,2) the_rects(:,3) - x the_rects(:,4) - y];
                    diffs_sign = sign(diffs);  diffs_sign_sum = sum(diffs_sign, 2);
                    sum4 = find(diffs_sign_sum == 4);
                    if(~isempty(sum4))
                        % we have a selection inside an image
                        trld.rsp.target.ind4imgs = [trld.rsp.target.ind4imgs sum4];
                        trld.rsp.target.tstamp   = [trld.rsp.target.tstamp mouseTime];
                        % check that we have the correct answer
                        if(sum4 == correctSelection),
                            % we have the correct answer
                            trld.rsp.target.accuracy = [trld.rsp.target.accuracy 1];
                            % give visual feedback%                             Screen('DrawTextures', theWin, tex4trial, [], settings.stms.vis.rects');          
                            Screen('FillRect',     theWin, settings.stms.vis.bg_colour, settings.stms.vis.rects');
                            Screen('DrawTextures', theWin, tex4trial, [],               settings.stms.vis.rects');
                            Screen('FrameRect',    theWin, settings.stms.vis.frame.colour, settings.stms.vis.frame.rects', settings.stms.vis.frame.wdt);

                            Screen('FillRect',     theWin, settings.renf.bg_colour, settings.renf.area.rect');
                            Screen('DrawTextures', theWin, tex4renf, [], settings.stms.vis.renf.rects', [], [], alphas4renf);
                            Screen('FrameRect',    theWin, settings.stms.vis.fbk.colour, settings.stms.vis.frame.rects(correctSelection, :), settings.stms.vis.fbk.wdt); 
                            Screen(theWin, 'Flip');
                            % wait for mouse lift
                            while 1, [~,~,buttons] = GetMouse(theWin); if(~buttons(1)), break; end, end
                            % restore display without feedback
                            Screen('DrawTextures', theWin, tex4trial, [], settings.stms.vis.rects');           
                            Screen('FillRect',     theWin, settings.renf.bg_colour, settings.renf.area.rect');
                            Screen('DrawTextures', theWin, tex4renf, [], settings.stms.vis.renf.rects', [], [], alphas4renf);                        
                            Screen(theWin, 'Flip', 0);
                            
                            % wait for audio to finish
                            while 1
                                audio_status = PsychPortAudio('GetStatus', pahandle);
                                if(audio_status.Active == 0), break; end
                            end
                            trld.tstamps.aud.target.sound_offset       = GetSecs;
                            trld.audio_info.target                     = audio_status;
                            trld.tstamps.aud.target.sound_onset        = audio_status.StartTime;
                            trld.tstamps.aud.target.sound2visual_delay = trld.tstamps.aud.target.sound_onset - trld.tstamps.vis.target_onset;
                            break;
                        else
                            trld.rsp.target.accuracy = [trld.rsp.target.accuracy 0];
                        end
                    end
                end
            end
            % wait for audio to finish
            while 1
                audio_status = PsychPortAudio('GetStatus', pahandle);
                if(audio_status.Active == 0), break; end
            end
            
            % INTER-TRIPLET 
            % %%%%%%%%%%%%%            
            % Screen('FillRect', theWin, settings.stms.vis.bg_colour, settings.stms.vis.rects');
            Screen('FillRect',     theWin, settings.renf.bg_colour, settings.renf.area.rect');
            Screen('DrawTextures', theWin, stms.vis.iti.tex, [], settings.stms.vis.iti.rect);
            Screen('DrawTextures', theWin, tex4renf, [], settings.stms.vis.renf.rects', [], [], alphas4renf);
            
            trld.tstamps.vis.iti = Screen(theWin, 'Flip', 0);
            when2flip = trld.tstamps.vis.iti + settings.stms.vis.iti.duration;  
            
            trld.rsp.target.RT.ref2audonset   = trld.rsp.target.tstamp(end) - trld.tstamps.aud.target.sound_onset;
                        
            % decide on the re-enforcement based on RT running window 
            trld.renf.target.threshold = data.threshold.value;
            trld.renf.target.reward    = 0;
            if(trld.rsp.target.RT.ref2audonset < data.threshold.value),
                alphas4renf(ind4next_renf) = 1; ind4next_renf = ind4next_renf + 1;
            end
            
            % update RT running window and threshold
            data.threshold.running_window = [data.threshold.running_window(2:end) trld.rsp.target.RT.ref2audonset];
            data.threshold.value = median(data.threshold.running_window);
            
            trld.info.type = c_trplt_type;            
                        
            data.trld = [data.trld trld];
            % do not save raw data after every trial -lengthens itt
            % save(outfname_raw, 'data');            
            trld.renf.target.threshold = data.threshold.value;
            trld.renf.target.reward    = 0;
                 
        end
    end
end

% save raw data
save(outfname_raw, 'data');   

% save summmary file
d2output.header = {'ID', 'Age', 'Gender', 'Group', 'Routine', 'NBlocks', 'NSets4Block', 'Block', 'Set', 'SetInd', 'Triplet', 'Type', 'Prime1Dur', 'Prime2Dur', 'Prime3Dur', 'Named1Dur', 'Named2Dur', 'Named1Snd2VisDelay', 'Named2Snd2VisDelay', 'TargetSnd2VisDelay', 'Named1StmCode', 'Named2StmCode', 'TargetCode', 'TargetNRsp', 'TargetACC', 'TargetRT', 'TargetRTThresh', 'TargetRewardGiven?'};
d2output.data   = [    ];
for i_trl =1:length(data.trld),
    trld = data.trld(i_trl);
    d2output.data = [d2output.data;
        trld.i_blk trld.i_set trld.ind4set trld.i_trp ...
        trld.info.type ...
        round(1000*trld.tstamps.vis.prime_duration(1:3)) ...
        round(1000*trld.tstamps.vis.named_duration(1:2)) ...
        round(1000*trld.tstamps.aud.named.sound2visual_delay(1)) ...
        round(1000*trld.tstamps.aud.named.sound2visual_delay(2)) ...
        round(1000*trld.tstamps.aud.target.sound2visual_delay) ...
        trld.code4tgt ...
        length(trld.rsp.target.accuracy) ...
        trld.rsp.target.accuracy(1) ...
        round(1000*trld.rsp.target.RT.ref2audonset) ...
        round(1000*trld.renf.target.threshold) ...
        trld.renf.target.reward ...
        ];
end

fdout = fopen(outfname_data, 'w');
for i_h = 1:length(d2output.header), fprintf(fdout, '%s,', d2output.header{i_h}); end, fprintf(fdout, '\n');
for i_trl =1:length(data.trld),
    % write the ID, age and gender
    fprintf(fdout, '%s,', session_info.ID);
    fprintf(fdout, '%d,', session_info.age.value);
    fprintf(fdout, '%d,', session_info.gender.code);
    fprintf(fdout, '%d,', session_info.group.code);
    fprintf(fdout, '%d,', session_info.routine.code);
    fprintf(fdout, '%d,', settings.n_blocks);
    fprintf(fdout, '%d,', settings.n_sets4block);
    for i_d = 1:length(d2output.data(i_trl, :)), fprintf(fdout, '%d,',d2output.data(i_trl, i_d)); end, fprintf(fdout, '\n');
end
fclose(fdout);

% %%%%%%%%%%%%%%%%%%%%%%%%
% FEEDBACK FOR WHOLE STUDY
% %%%%%%%%%%%%%%%%%%%%%%%%

the_tex                = [btn.play.normal.tex];
the_tex_play_pressed   = [btn.play.pressed.tex];
the_rect               = [settings.btns.play.rect];

% Screen('FillRect', theWin, settings.stms.vis.bg_colour, settings.stms.vis.rects');
Screen('DrawTextures', theWin, the_tex, [], the_rect');
total_rewards = total_rewards + length(find(alphas4renf == 1));
fdbk_str = ['You have won ' num2str(total_rewards) ' points'];
[nx, ny, textbounds] = DrawFormattedText(theWin, fdbk_str, 'center', 'center', settings.stms.vis.fdbk.font.colour, 70, 0, 0, 1.5, 0, settings.stms.vis.fdbk.rect);
Screen('Flip', theWin, 0, 0);

% wait for mouse input
while 1,
    [x,y,buttons] = GetMouse(theWin);
    if(buttons(1))
        % the_rects = [settings.btns.play.rect; settings.btns.pause.rect];
        diffs = [x - the_rect(:,1) y - the_rect(:,2) the_rect(:,3) - x the_rect(:,4) - y];
        diffs_sign = sign(diffs);  diffs_sign_sum = sum(diffs_sign, 2);
        sum4 = find(diffs_sign_sum == 4);
        if(~isempty(sum4))
            % we have a selection inside an image, check that we have the correct answer
            switch sum4,
                case 1,
                    % play
                    Screen('DrawTextures', theWin, the_tex_play_pressed, [], the_rect');
                    [nx, ny, textbounds] = DrawFormattedText(theWin, fdbk_str, 'center', 'center', settings.stms.vis.fdbk.font.colour, 70, 0, 0, 1.5, 0, settings.stms.vis.fdbk.rect); 
                    Screen('Flip', theWin, 0, 0);
            end
            % wait for release
            while(1), [x,y,buttons] = GetMouse(theWin); if(~buttons(1)), break; end, end
            Screen('DrawTextures', theWin, the_tex, [], the_rect');
            [nx, ny, textbounds] = DrawFormattedText(theWin, fdbk_str, 'center', 'center', settings.stms.vis.fdbk.font.colour, 70, 0, 0, 1.5, 0, settings.stms.vis.fdbk.rect); 
            Screen('Flip', theWin, 0, 0);
            break;
        end
    end
end

Screen('Flip', theWin, 0, 0);

% %%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTINUE-TO-PROBING SCREEN
% %%%%%%%%%%%%%%%%%%%%%%%%%%
the_tex                = [btn.play.normal.tex];
the_tex_play_pressed   = [btn.play.pressed.tex];
the_rect               = [settings.btns.play.rect];

% Screen('FillRect', theWin, settings.stms.vis.bg_colour, settings.stms.vis.rects');
Screen('DrawTextures', theWin, the_tex, [], the_rect');
Screen('Flip', theWin, 0, 0);

% wait for mouse input
while 1,
    [x,y,buttons] = GetMouse(theWin);
    if(buttons(1))
        % the_rects = [settings.btns.play.rect; settings.btns.pause.rect];
        diffs = [x - the_rect(:,1) y - the_rect(:,2) the_rect(:,3) - x the_rect(:,4) - y];
        diffs_sign = sign(diffs);  diffs_sign_sum = sum(diffs_sign, 2);
        sum4 = find(diffs_sign_sum == 4);
        if(~isempty(sum4))
            % we have a selection inside an image, check that we have the correct answer
            switch sum4,
                case 1,
                    % play
                    Screen('DrawTextures', theWin, the_tex_play_pressed, [], the_rect');
                    Screen('Flip', theWin, 0, 0);                  
            end
            % wait for release
            while(1), [~,~,buttons] = GetMouse(theWin); if(~buttons(1)), break; end, end
            Screen('DrawTextures', theWin, the_tex, [], the_rect');
            Screen('Flip', theWin, 0, 0);
            break;
        end
    end
end

Screen('Flip', theWin, 0, 0);

WaitSecs(1);

% %%%%%%%%%%%%%%%%
% PROBING QUESTION
% %%%%%%%%%%%%%%%%
the_tex               = [sel.yes.normal.tex  sel.no.normal.tex];
the_tex_yes_pressed   = [sel.yes.pressed.tex sel.no.normal.tex];
the_tex_no_pressed    = [sel.yes.normal.tex  sel.no.pressed.tex];
the_rect              = [settings.sels.yes.rect; settings.sels.no.rect;];

Screen('DrawTextures', theWin, the_tex, [], the_rect');
[nx, ny, textbounds] = DrawFormattedText(theWin, settings.sels.qst, 'center', 'center', settings.stms.vis.fdbk.font.colour, 70, 0, 0, 1.5, 0, settings.stms.vis.fdbk.rect);
Screen('Flip', theWin, 0, 0);

% wait for mouse input
while 1,
    [x,y,buttons] = GetMouse(theWin);
    if(buttons(1))
        % the_rects = [settings.btns.play.rect; settings.btns.pause.rect];
        diffs = [x - the_rect(:,1) y - the_rect(:,2) the_rect(:,3) - x the_rect(:,4) - y];
        diffs_sign = sign(diffs);  diffs_sign_sum = sum(diffs_sign, 2);
        sum4 = find(diffs_sign_sum == 4);
        if(~isempty(sum4))
            % we have a selection inside an image, check that we have the correct answer
            switch sum4,
                case 1,
                    % yes
                    Screen('DrawTextures', theWin, the_tex_yes_pressed, [], the_rect');
                    [nx, ny, textbounds] = DrawFormattedText(theWin, settings.sels.qst, 'center', 'center', settings.stms.vis.fdbk.font.colour, 70, 0, 0, 1.5, 0, settings.stms.vis.fdbk.rect);
                    Screen('Flip', theWin, 0, 0);
                    rsp.code = sum4; rsp.txt = 'yes';
                case 2,
                    % yes
                    Screen('DrawTextures', theWin, the_tex_no_pressed, [], the_rect');
                    [nx, ny, textbounds] = DrawFormattedText(theWin, settings.sels.qst, 'center', 'center', settings.stms.vis.fdbk.font.colour, 70, 0, 0, 1.5, 0, settings.stms.vis.fdbk.rect);
                    Screen('Flip', theWin, 0, 0);
                    rsp.code = sum4; rsp.txt = 'no';
            end
            % wait for release
            while(1), [~,~,buttons] = GetMouse(theWin); if(~buttons(1)), break; end, end
            Screen('DrawTextures', theWin, the_tex, [], the_rect');
            Screen('Flip', theWin, 0, 0);
            break;
        end
    end
end
Screen('Flip', theWin, 0, 0);
% save summmary file
d2output.header = {'ID', 'Age', 'Gender', 'Group', 'Routine', 'PrbRsp'};
fdout = fopen(outfname_probe, 'w');
for i_h = 1:length(d2output.header), fprintf(fdout, '%s,', d2output.header{i_h}); end, fprintf(fdout, '\n');
fprintf(fdout, '%s,', session_info.ID);
fprintf(fdout, '%d,', session_info.age.value);
fprintf(fdout, '%d,', session_info.gender.code);
fprintf(fdout, '%d,', session_info.group.code);
fprintf(fdout, '%d,', session_info.routine.code);
fprintf(fdout, '%d,', rsp.code);    
fclose(fdout);

WaitSecs(1);

% %%%%%%%%%%%%%%%%%%%%%%%%%
% CONTINUE-TO-RECALL SCREEN
% %%%%%%%%%%%%%%%%%%%%%%%%%
the_tex                = [btn.play.normal.tex];
the_tex_play_pressed   = [btn.play.pressed.tex];
the_rect               = [settings.btns.play.rect];

% Screen('FillRect', theWin, settings.stms.vis.bg_colour, settings.stms.vis.rects');
Screen('DrawTextures', theWin, the_tex, [], the_rect');
Screen('Flip', theWin, 0, 0);

% wait for mouse input
while 1,
    [x,y,buttons] = GetMouse(theWin);
    if(buttons(1))
        % the_rects = [settings.btns.play.rect; settings.btns.pause.rect];
        diffs = [x - the_rect(:,1) y - the_rect(:,2) the_rect(:,3) - x the_rect(:,4) - y];
        diffs_sign = sign(diffs);  diffs_sign_sum = sum(diffs_sign, 2);
        sum4 = find(diffs_sign_sum == 4);
        if(~isempty(sum4))
            % we have a selection inside an image, check that we have the correct answer
            switch sum4,
                case 1,
                    % play
                    Screen('DrawTextures', theWin, the_tex_play_pressed, [], the_rect');
                    Screen('Flip', theWin, 0, 0);                  
            end
            % wait for release
            while(1), [~,~,buttons] = GetMouse(theWin); if(~buttons(1)), break; end, end
            Screen('DrawTextures', theWin, the_tex, [], the_rect');
            Screen('Flip', theWin, 0, 0);
            break;
        end
    end
end

Screen('Flip', theWin, 0, 0);

WaitSecs(1);

% %%%%%%%%%%%
% RECALL TASK
% %%%%%%%%%%%
i_blk = 1;
i_set = 1;
ind4set = 1;
data.start_tstamp = now;
data.start_tstamp_text = LOCAL_datestr_mdd;
when2flip = 0;
c_set_info = recall_settings.sets.trplts_order{ind4set};
data.trld = [];
size(c_set_info, 1)
for i_recall = 1:size(c_set_info, 1)
    
    % pause and wait for play tap after first trial
    if(i_recall == 2)
        the_tex                = [btn.play.normal.tex];
        the_tex_play_pressed   = [btn.play.pressed.tex];
        the_rect               = [settings.btns.play.rect];
        
        % Screen('FillRect', theWin, settings.stms.vis.bg_colour, settings.stms.vis.rects');
        Screen('DrawTextures', theWin, the_tex, [], the_rect');
        Screen('Flip', theWin, 0, 0);
        
        % wait for mouse input
        while 1,
            [x,y,buttons] = GetMouse(theWin);
            if(buttons(1))
                % the_rects = [settings.btns.play.rect; settings.btns.pause.rect];
                diffs = [x - the_rect(:,1) y - the_rect(:,2) the_rect(:,3) - x the_rect(:,4) - y];
                diffs_sign = sign(diffs);  diffs_sign_sum = sum(diffs_sign, 2);
                sum4 = find(diffs_sign_sum == 4);
                if(~isempty(sum4))
                    % we have a selection inside an image, check that we have the correct answer
                    switch sum4,
                        case 1,
                            % play
                            Screen('DrawTextures', theWin, the_tex_play_pressed, [], the_rect');
                            Screen('Flip', theWin, 0, 0);
                    end
                    % wait for release
                    while(1), [~,~,buttons] = GetMouse(theWin); if(~buttons(1)), break; end, end
                    Screen('DrawTextures', theWin, the_tex, [], the_rect');
                    Screen('Flip', theWin, 0, 0);
                    break;
                end
            end
        end
        
        Screen('Flip', theWin, 0, 0);
        
        WaitSecs(1);
        when2flip = 0;
    end
    
    clear trld
    c_trplt      = recall_info.stm{i_blk, i_set, i_recall};
    c_trplt_type = recall_settings.sets.trplts_type{ind4set}(i_recall);
    
    trld.i_blk      = i_blk;
    trld.i_set      = i_set;
    trld.ind4set    = (i_blk - 1)*recall_settings.n_sets4block + i_set;
    trld.i_trp      = i_recall;
    trld.trial_info = recall_info;
    trld.settings   = recall_settings;
    trld.trplt      = c_trplt;
    trld.trplt_type = c_trplt_type;
    
    fprintf('Block %d Set %d Triplet %d, type %d\n\t\t', i_blk, i_set, i_recall, c_trplt_type);
    for i_trl = 1:3,
        for i_img = 1:settings.n_imgs4trial,
            fprintf('%s\t', recall_info.stm{i_blk, i_set, i_recall}{i_trl, i_img});
        end
        fprintf('\n\t\t');
    end
    fprintf('\n');
%     if(c_trplt_type == 7), i_trl = 3; for i_img = 1:recall_settings.n_imgs4trial, if(strcmp(recall_info.stm{i_blk, i_set, i_recall}{i_trl, i_img}(1), 'T')), fprintf('Target %s\n', recall_info.stm{i_blk, i_set, i_recall}{i_trl, i_img}); end, end, end
    
    % identify the targets
    tgt_pos = NaN(1,3);
    for i_trl = 1:3,
        for i_img = 1:length({c_trplt{i_trl,:}}),
            if(strcmp(c_trplt{i_trl,i_img}(1), 'T'))
                tgt_pos(i_trl) = i_img; break;
            end
        end
    end
    trld.tgt_pos = tgt_pos;
    
    % %%%%%%%%%%%%%%%%%%%%%%
    % TRIAL 1 IN THE TRIPLET
    % %%%%%%%%%%%%%%%%%%%%%%
    i_trl = 1;
    % Fill the audio buffer and start playback with infinite start time and no wait
    the_command = ['sound2play = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.data;']; eval(the_command);
    the_command = ['audio_len  = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.len;']; eval(the_command);
    PsychPortAudio('FillBuffer', pahandle, sound2play);
    PsychPortAudio('Start',      pahandle, 1, Inf, 0);
    
    i_img = 1;
    the_command = ['tex4trial            = stms.vis.' c_trplt{i_trl,i_img}(2:end) '.tex;']; eval(the_command);
    the_command = ['trld.code4tgt(i_trl) = stms.vis.' c_trplt{i_trl,i_img}(2:end) '.code;']; eval(the_command);
    
    % PRIME 1
    % %%%%%%%
    i_prime = 1;
    Screen('FillRect',     theWin, settings.stms.vis.bg_colour, settings.stms.vis.named.rect');
    Screen('DrawTextures', theWin, prime_tex_all(1), [],        settings.stms.vis.named.rect);
    Screen('FillRect',     theWin, settings.renf.bg_colour,     settings.renf.area.rect');
    
    trld.tstamps.vis.prime_onset(i_prime) = Screen(theWin, 'Flip', when2flip);
    when2flip = trld.tstamps.vis.prime_onset(i_prime) + settings.stms.vis.prime.duration;
    
    % NAMED ITEM 1
    % 5%%%%%%%%%%%
    i_named = 1;
    trld.audio.named.len(i_named) = audio_len;
    
    Screen('FillRect',     theWin, settings.stms.vis.bg_colour, settings.stms.vis.named.rect);
    Screen('DrawTextures', theWin, tex4trial, [],               settings.stms.vis.named.rect);
    Screen('FillRect',     theWin, settings.renf.bg_colour,     settings.renf.area.rect');
    
    trld.tstamps.vis.named_onset(i_named)  = Screen(theWin, 'Flip', when2flip);
    when2flip = trld.tstamps.vis.named_onset(i_named) + settings.stms.aud.offset;
    % reschedule audio start to coincide with frame onset, don't wait for start
    PsychPortAudio('RescheduleStart', pahandle, when2flip, 0, 1);
    
    trld.tstamps.vis.prime_duration(i_prime)                = trld.tstamps.vis.named_onset(i_named) - trld.tstamps.vis.prime_onset(i_prime);
    
    % frame the target in sync with audio onset
    Screen('FillRect',     theWin, settings.stms.vis.bg_colour,    settings.stms.vis.named.rect);
    Screen('DrawTextures', theWin, tex4trial, [],                  settings.stms.vis.named.rect);
    Screen('FrameRect',    theWin, settings.stms.vis.fbk.colour,   settings.stms.vis.named.frame.rect, settings.stms.vis.fbk.wdt);
    Screen('FillRect',     theWin, settings.renf.bg_colour,        settings.renf.area.rect');
    
    trld.tstamps.vis.named_frame_onset(i_named)  = Screen(theWin, 'Flip', when2flip);
    when2flip = trld.tstamps.vis.named_frame_onset(i_named) + settings.stms.vis.duration;
    
    % wait for audio to finish
    while 1
        audio_status = PsychPortAudio('GetStatus', pahandle);
        if(audio_status.Active == 0), break; end
    end
    trld.tstamps.aud.named.sound_offset(i_named)       = GetSecs;
    trld.audio_info.named(i_named)                     = audio_status;
    trld.tstamps.aud.named.sound_onset(i_named)        = audio_status.StartTime;
    trld.tstamps.aud.named.sound2visual_delay(i_named) = trld.tstamps.aud.named.sound_onset(i_named) - trld.tstamps.vis.named_onset(i_named);
        
    % %%%%%%%%%%%%%%%%%%%%%%
    % TRIAL 2 IN THE TRIPLET
    % %%%%%%%%%%%%%%%%%%%%%%
    i_trl = 2;
    % Fill the audio buffer and start playback with infinite start time and no wait
    the_command = ['sound2play = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.data;']; eval(the_command);
    the_command = ['audio_len = stms.aud.' c_trplt{i_trl,tgt_pos(i_trl)}(2:end) '.len;']; eval(the_command);
    % PsychPortAudio('FillBuffer', pahandle, stms.aud.data{trialsound(1)});
    PsychPortAudio('FillBuffer', pahandle, sound2play);
    PsychPortAudio('Start',      pahandle, 1, Inf, 0);
    
    % build the texture array
    i_img = 1;
    the_command = ['tex4trial            = stms.vis.' c_trplt{i_trl,i_img}(2:end) '.tex;']; eval(the_command);
    the_command = ['trld.code4tgt(i_trl) = stms.vis.' c_trplt{i_trl,i_img}(2:end) '.code;']; eval(the_command);    
    
    % PRIME 2
    % %%%%%%%
    i_prime = i_prime + 1;
    Screen('FillRect', theWin, settings.stms.vis.bg_colour, settings.stms.vis.named.rect);
    Screen('DrawTextures', theWin, prime_tex_all, [], settings.stms.vis.named.rect);
    Screen('FillRect', theWin, settings.renf.bg_colour, settings.renf.area.rect');
    
    trld.tstamps.vis.prime_onset(i_prime) = Screen(theWin, 'Flip', when2flip);    
    when2flip = trld.tstamps.vis.prime_onset(i_prime) + settings.stms.vis.prime.duration;
    trld.tstamps.vis.named_duration(i_named) = trld.tstamps.vis.prime_onset(i_prime) - trld.tstamps.vis.named_onset(i_named);
    
    % NAMED ITEM 2
    % %%%%%%%%%%%%
    i_named = 2;
    trld.audio.named.len(i_named) = audio_len;
    Screen('FillRect', theWin, settings.stms.vis.bg_colour, settings.stms.vis.named.rect);
    Screen('DrawTextures', theWin, tex4trial, [], settings.stms.vis.named.rect);
    Screen('FillRect', theWin, settings.renf.bg_colour, settings.renf.area.rect');
    
    trld.tstamps.vis.named_onset(i_named) = Screen(theWin, 'Flip', when2flip);
    trld.tstamps.vis.prime_duration(i_prime) = trld.tstamps.vis.named_onset(i_named) - trld.tstamps.vis.prime_onset(i_prime);
    
    when2flip = trld.tstamps.vis.named_onset(i_named) + settings.stms.aud.offset;
    % reschedule audio start to coincide with frame onset, don't wait for start
    PsychPortAudio('RescheduleStart', pahandle, when2flip, 0, 1);
    
    trld.tstamps.vis.prime_duration(i_prime)                = trld.tstamps.vis.named_onset(i_named) - trld.tstamps.vis.prime_onset(i_prime);
    
    % frame the target in sync with audio onset
    Screen('FillRect',     theWin, settings.stms.vis.bg_colour,    settings.stms.vis.named.rect);
    Screen('DrawTextures', theWin, tex4trial, [],                  settings.stms.vis.named.rect);
    Screen('FrameRect',    theWin, settings.stms.vis.fbk.colour,   settings.stms.vis.named.frame.rect, settings.stms.vis.fbk.wdt);
    Screen('FillRect',     theWin, settings.renf.bg_colour,        settings.renf.area.rect');
    
    trld.tstamps.vis.named_frame_onset(i_named)  = Screen(theWin, 'Flip', when2flip);
    when2flip = trld.tstamps.vis.named_frame_onset(i_named) + settings.stms.vis.duration;
    
    % wait for audio to finish
    while 1
        audio_status = PsychPortAudio('GetStatus', pahandle);
        if(audio_status.Active == 0), break; end
    end
    trld.tstamps.aud.named.sound_offset(i_named)       = GetSecs;
    trld.audio_info.named(i_named)                     = audio_status;
    trld.tstamps.aud.named.sound_onset(i_named)        = audio_status.StartTime;
    trld.tstamps.aud.named.sound2visual_delay(i_named) = trld.tstamps.aud.named.sound_onset(i_named) - trld.tstamps.vis.named_onset(i_named);
    
    % %%%%%%%%%%%%%%%%%%%%%%
    % TRIAL 3 IN THE TRIPLET
    % %%%%%%%%%%%%%%%%%%%%%%
    i_trl = 3;    
    % build the texture array
    tex4trial = [];
    for i_img = 1:length({c_trplt{i_trl,:}}),
        if(strcmp(c_trplt{i_trl,i_img}(1), 'T'))
            the_command = ['tex4trial            = [tex4trial stms.vis.' c_trplt{i_trl,i_img}(2:end) '.tex];']; eval(the_command);
            the_command = ['trld.code4tgt(i_trl) = stms.vis.' c_trplt{i_trl,i_img}(2:end) '.code;']; eval(the_command);
        else
            the_command = ['tex4trial = [tex4trial stms.vis.' c_trplt{i_trl,i_img} '.tex];']; eval(the_command);
        end
    end
    
    % PRIME 3
    % %%%%%%%
    i_prime = i_prime + 1;
    Screen('FillRect', theWin, settings.stms.vis.bg_colour, settings.stms.vis.rects');
    Screen('DrawTextures', theWin, prime_tex_all, [], settings.stms.vis.rects');
    Screen('FillRect', theWin, settings.renf.bg_colour, settings.renf.area.rect');
    
    trld.tstamps.vis.prime_onset(i_prime) = Screen(theWin, 'Flip', when2flip);
    when2flip = trld.tstamps.vis.prime_onset(i_prime) + settings.stms.vis.prime.duration;
    trld.tstamps.vis.named_duration(i_named) = trld.tstamps.vis.prime_onset(i_prime) - trld.tstamps.vis.named_onset(i_named);
    
    % TARGET SELECTION
    % %%%%%%%%%%%%%%%%
    trld.audio.target.len = audio_len;
    Screen('FillRect',     theWin, settings.stms.vis.bg_colour, settings.stms.vis.rects');
    Screen('DrawTextures', theWin, tex4trial, [],               settings.stms.vis.rects');
    Screen('FrameRect',    theWin, settings.stms.vis.frame.colour, settings.stms.vis.frame.rects', settings.stms.vis.frame.wdt);
    Screen('FillRect',     theWin, settings.renf.bg_colour,     settings.renf.area.rect');    
    
    trld.tstamps.vis.target_onset = Screen(theWin, 'Flip', when2flip);
    trld.tstamps.vis.prime_duration(i_prime) = trld.tstamps.vis.target_onset - trld.tstamps.vis.prime_onset(i_prime);
    
    % wait for selection immediatelly after the audio started
    correctSelection = tgt_pos(i_trl);
    while 1,
        [x,y,buttons] = GetMouse(theWin); mouseTime = GetSecs;
        if(buttons(1))
            the_rects = settings.stms.vis.rects;
            diffs = [x - the_rects(:,1) y - the_rects(:,2) the_rects(:,3) - x the_rects(:,4) - y];
            diffs_sign = sign(diffs);  diffs_sign_sum = sum(diffs_sign, 2);
            sum4 = find(diffs_sign_sum == 4);
            if(~isempty(sum4))
                % we have a selection inside an image
                trld.rsp.target.ind4img = sum4;
                trld.rsp.target.tstamp   = mouseTime;
                % check that we have the correct answer
                if(sum4 == correctSelection),
                    % we have the correct answer
                    trld.rsp.target.accuracy = 1;
                else
                    trld.rsp.target.accuracy = 0;
                end
                % give visual feedback%                             Screen('DrawTextures', theWin, tex4trial, [], settings.stms.vis.rects');
                Screen('FillRect',     theWin, settings.stms.vis.bg_colour,    settings.stms.vis.rects');
                Screen('DrawTextures', theWin, tex4trial, [],                  settings.stms.vis.rects');
                Screen('FrameRect',    theWin, settings.stms.vis.frame.colour, settings.stms.vis.frame.rects',           settings.stms.vis.frame.wdt);
                Screen('FrameRect',    theWin, settings.stms.vis.frame.colour, settings.stms.vis.frame.rects(sum4, :), 2*settings.stms.vis.frame.wdt);
                Screen('FillRect', theWin, settings.renf.bg_colour, settings.renf.area.rect');
                    
                Screen(theWin, 'Flip');
                % wait for mouse lift
                while 1, [~,~,buttons] = GetMouse(theWin); if(~buttons(1)), break; end, end
                % restore display without feedback
                Screen('FillRect',     theWin, settings.stms.vis.bg_colour,    settings.stms.vis.rects');
                Screen('DrawTextures', theWin, tex4trial, [],                  settings.stms.vis.rects');
                Screen('FrameRect',    theWin, settings.stms.vis.frame.colour, settings.stms.vis.frame.rects',           settings.stms.vis.frame.wdt);
                Screen('FillRect', theWin, settings.renf.bg_colour, settings.renf.area.rect');
                Screen(theWin, 'Flip', 0);

                break; 
            end
        end
    end
    
    % INTER-TRIPLET
    % %%%%%%%%%%%%%
    Screen('DrawTextures', theWin, stms.vis.iti.tex, [], settings.stms.vis.iti.rect);
    Screen('FillRect', theWin, settings.renf.bg_colour, settings.renf.area.rect');
    
    trld.tstamps.vis.iti = Screen(theWin, 'Flip', 0);
    when2flip = trld.tstamps.vis.iti + settings.stms.vis.iti.duration;
    
    trld.rsp.target.RT.ref2visonset = trld.rsp.target.tstamp - trld.tstamps.vis.target_onset;
         
    trld.info.type = c_trplt_type;    
    
    data.trld = [data.trld trld];
    
end


% save raw recall data
save(outfname_recall_raw, 'data');   

% save summmary file
d2output.header = {'ID', 'Age', 'Gender', 'Group', 'Routine', 'NBlocks', 'NSets4Block', 'Block', 'Set', 'SetInd', 'Triplet', 'Type', 'Prime1Dur', 'Prime2Dur', 'Prime3Dur', 'Named1Dur', 'Named2Dur', 'Named1StmCode', 'Named2StmCode', 'TargetCode', 'TargetACC', 'TargetRT'};
d2output.data   = [    ];
for i_trl =1:length(data.trld),
    trld = data.trld(i_trl);
    d2output.data = [d2output.data;
        trld.i_blk trld.i_set trld.ind4set trld.i_trp ...
        trld.info.type ...
        round(1000*trld.tstamps.vis.prime_duration(1:3)) ...
        round(1000*trld.tstamps.vis.named_duration(1:2)) ...        
        trld.code4tgt ...        
        trld.rsp.target.accuracy ...
        round(1000*trld.rsp.target.RT.ref2visonset) ...
        ];
end

fdout = fopen(outfname_recall_data, 'w');
for i_h = 1:length(d2output.header), fprintf(fdout, '%s,', d2output.header{i_h}); end, fprintf(fdout, '\n');
for i_trl =1:length(data.trld),
    % write the ID, age and gender
    fprintf(fdout, '%s,', session_info.ID);
    fprintf(fdout, '%d,', session_info.age.value);
    fprintf(fdout, '%d,', session_info.gender.code);
    fprintf(fdout, '%d,', session_info.group.code);
    fprintf(fdout, '%d,', session_info.routine.code);
    fprintf(fdout, '%d,', settings.n_blocks);
    fprintf(fdout, '%d,', settings.n_sets4block);
    for i_d = 1:length(d2output.data(i_trl, :)), fprintf(fdout, '%d,',d2output.data(i_trl, i_d)); end, fprintf(fdout, '\n');
end
fclose(fdout);

Screen CloseAll; PsychPortAudio('Close');

function tstamp = LOCAL_datestr_mdd

tnow = datevec(now);

tstamp = [num2str(tnow(1)-2000, '%02d') num2str(tnow(2), '%02d') num2str(tnow(3), '%02d') 'T' num2str(tnow(4), '%02d') num2str(tnow(5), '%02d')];

