%Generate sequences for use with SRT_RT
% by DVM Bishop

%rng(0,'twister');%random number generator; for testing turn on for same
%seq

nblocks=10;%This version updated 15th August 2017
%This presents just one grammatical sequence per type, and 3 random 
% NB also corrected an error that led to occasional sequences of same
% initial triplet members from probabilistic sequences
% Now saving also file with numeric codes and target positions in the .mat
% file (allmystim)
nsets=5;

breakblock=7;% currently set to take breakblock and adjacent block as random
myroutine=1;%can alter this

clear settings
clear trial_info

triplets={
    1, 'A1', 'S1', 'B1';
    2, 'C1', 'S4', 'D1';
    3,  'C1', 'S4', 'D2';
    4,  'E1', 'R', 'F1';
    5,  'Z1', 'S7', 'R';
    6, 'Y1', 'R', 'R'; %these will be totally random, ie identity of Y element varies
    7, 'Y2', 'R', 'R';
    8, 'Y3', 'R', 'R';
    };
ntriplet=length(triplets);
settings.triplts4set=ntriplet; %for compatibility with Mihaela
nnonrandom=4;%change this if more or less triplets 

settings.stms.dependencies.fnames={'A1',  'B1', ...
    'C1', 'D1', 'D2', 'E1', 'F1',  'Z1', 'Y1', 'Y2','Y3'}';%%%%%%%%%%%% altered!

dis_pool={ 'B1', 'D1', 'D2', 'F1'}';%%%%%%%%%%%% altered!

randoms={'R01', 'R02', 'R03', 'R04', 'R05', 'R06', 'R07', 'R08', 'R09', 'R10', 'R11', 'R12',...
    'R13', 'R14', 'R15', 'R16', 'R17', 'R18', 'R19', 'R20', 'R21', 'R22', 'R23','R24'...
    'R25','R26','R27','R28'}';
settings.stms.random.fnames=randoms;
smids={'S1', 'S4', 'S7'} ; %%%%%%%%%%%% altered!
settings.stms.planned.fnames=smids';

allstim=[settings.stms.dependencies.fnames;smids';randoms];

allnum=[1:9,1001:1003,10001:10068]';%%%changed bcs need numbers for unused wds that feature in practice
%upper limit of allnum not precise - just allows enough

settings.stms.random.n=length(randoms);
settings.stms.dependencies.n=length(settings.stms.dependencies.fnames);
settings.stms.planned.n=length(smids);


%Word allocations taken from file all_stimuli_routines.xls;
xlrange='D2:D62';

conflictfile='all_stimuli_routines_3cond_kup_final.xlsx';

[num,mywords]=xlsread(conflictfile,1,xlrange) %need this format as 2nd read entry is for text
xlrange='F2:F62';
if myroutine==2,xlrange='G2:G62';end
if myroutine==3,xlrange='H2:H62';end
if myroutine==4,xlrange='I2:I62';end
[num,mytypes]=xlsread(conflictfile,1,xlrange); %need this format as 2nd read entry is for text
xlrange='J2:BR62';%range for conflicts
myconflicts=xlsread(conflictfile,1,xlrange);
mynwords=length(myconflicts);
%has lower triangle for conflicts, 1 for conflict, 0 for others
for i=1:mynwords-1
    for j=(i+1):mynwords
        myconflicts(i,j)=myconflicts(j,i); %turn into symmetric matrix
    end
end


%change the unused types to randoms
unused={  'A2', 'S2', 'B2',...
   'A3','S3',  'B3',...
   'C2', 'S5', 'D3','D4',...
   'C3','S6',  'D5','D6',...
   'E2', 'F2',...
   'E3','F3',...
   'Z2', 'S8', ...
   'Z3','S9'};

recodes={'R29', 'R30', 'R31', 'R32', 'R33', 'R34', 'R35', 'R36', 'R37', 'R38', 'R39', 'R40',...
    'R41', 'R42', 'R43', 'R44', 'R45', 'R46', 'R47', 'R48', 'R49', 'R50'};

for r = 1:length(unused)
rr=strmatch(unused(r),mytypes);
mytypes(rr)=recodes(r);
end

randoms=[randoms;recodes'];

settings.stms.random.fnames=randoms;
settings.stms.dependencies.n=8;%specific for current
%Mihaela-compatible codes for actual words - not used in her prog; just to
%retain these
for a =1:settings.stms.dependencies.n
    settings.stms.dependencies.words(a,1)=mywords(strmatch(settings.stms.dependencies.fnames(a),mytypes));
end
for a =1:settings.stms.random.n
    settings.stms.random.words(a,1)=mywords(strmatch(settings.stms.random.fnames(a),mytypes))';
end
for a =1:settings.stms.planned.n
    settings.stms.planned.words(a,1)=mywords(strmatch(settings.stms.planned.fnames(a),mytypes))';
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Practice block: have 20 triplets so all 60 stimuli are named, but assignation
% %at random
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear settings
clear trial_info
clear mynumcell
settings.stms.dependencies.fnames={'A1',  'B1',   'C1', 'D1', 'D2', 'E1','F1', 'Z1'}';
settings.stms.random.fnames=randoms;
settings.stms.planned.fnames=smids';
settings.stms.random.n=length(randoms);
settings.stms.dependencies.n=length(settings.stms.dependencies.fnames);
settings.stms.planned.n=length(smids);

settings.triplts4set=20;

%start by randomising order of all items
b=1;s=1;%block and set indices: just one, will be used when writing to file
allp=1:mynwords;
pracseq=allp(randperm(mynwords));
pracseq=[pracseq,pracseq(1)];%just to make 60 items for 20 sets
mycounter=-2;
for j = 1:20
    mycounter=mycounter+3;
    numword1=pracseq(mycounter);
    word1=mywords(numword1);
    type1=mytypes(numword1); %type is irrelevant for practice, but coded to mean we can use standard filewrite routine
    numword2=pracseq(mycounter+1);
    word2=mywords(numword2);
    type2=mytypes(numword2);
    numword3=pracseq(mycounter+2);
    word3=mywords(numword3);
    type3=mytypes(numword3);
    %these are the 3 named items in triplet. Now need distractors,
    %avoiding conflicts
    thisconflict=unique([find(myconflicts(numword3,:)==1),numword1,numword2]);
    %use conflicts for both target and D1, and also avoid words 1 and 2
    numword4=numword3;
    pdistractors=1:mynwords;
    while(find(thisconflict==numword4)>0)
        numword4= datasample(pdistractors,1) ; %word4 is 1st distractor:
    end
    word4=mywords(numword4);
    type4=mytypes(numword4);
    
    
    %repeat for 5th word, incrementing the set to inspect for conflict
    thisconflict=unique([thisconflict,numword1,numword2,numword4]);
    %use conflicts for both target and D1, and also avoid words 1 and 2
    numword5=numword4;
    while(find(thisconflict==numword5)>0)
        numword5= datasample(pdistractors,1) ; %word5 is 2nd distractor
    end
    word5=mywords(numword5);
    type5=mytypes(numword5);
    
    %repeat for 6th word, incrementing the set to inspect for conflict
    thisconflict=unique([thisconflict,numword1,numword2,numword4,numword5]);
    %use conflicts for prior words in 3rd part of triplet, and also avoid words 1 and 2
    numword6=numword5;
    while(find(thisconflict==numword6)>0)
        numword6= datasample(pdistractors,1) ; %word6 is last distractor
    end
    word6=mywords(numword6);
    type6=mytypes(numword6)  ;
    
    alltype=[type1,type2,type3,type4,type5,type6];
    allword=[word1,word2,word3,word4,word5,word6];
    myrandomset(j,:)=alltype;%myrandomset: 20 sets of practice items also used as fillers
    
    %Create numbrs for compatibility with Mihaela structures
    numtrio=[allnum(strmatch(allword(1),mywords)), allnum(strmatch(allword(2),mywords)), (allnum(strmatch(allword(3),mywords)))];
    for n=1:3
        mynumcell{j,n}=numtrio(n);
    end
    
    %Program will put frame around those prefixed with 'T', so do
    %this for items 1 and 2, and for the target
    
    alltype(1)=strcat('T',alltype(1));
    alltype(2)=strcat('T',alltype(2));
    myr=3;%default is item 3 is target
    alltype(myr)=strcat('T',alltype(myr)); %prefix target with 'T'
    
    %Now randomise order for the 4 pics on item 3 of triplet
    myorder=3:6;
    myperm=myorder(randperm(4));%3:6 in random seq
    alltype(3:6)=alltype(myperm);
    allword(3:6)=allword(myperm);
    
    %Copy relevant info to Mihaela structures
    settings.sets.trplts_type{1,1}=repmat(15,20,1);%all 20 practice trials have type 15
    mycell(3,1:4)=alltype(3:6);
    mycell(1,1)=alltype(1);
    mycell(2,1)=alltype(2);
    trial_info.stm{b,s,j}=mycell;
    %add new field, word, that stores actual words
    mycell(3,1:4)=allword(3:6);
    mycell(1,1)=allword(1);
    mycell(2,1)=allword(2);
    trial_info.word{b,s,j}=mycell;
end
settings.sets.trplts_order{1,1}=mynumcell;
%Write to csv file using Mihaela formats
settings.n_blocks=1;
settings.n_sets4block=1;
c_routine=strcat('Routine',num2str(myroutine));
outfname_suffix='practice';
settings.n_imgs4trial(1:2)=1;%one image for first 2 members of triplet
settings.n_imgs4trial(3)=4;%plus 3 distractors for last one
outfname = ['SEQ_' outfname_suffix '_Routine' num2str(myroutine) ];

% write the whole design into a separate file
outfname_design = [outfname '.csv'];
fdout = fopen(outfname_design, 'w');
ind4set = 0; %this is a counter that increments for each block/set
for i_blk = 1:settings.n_blocks,
    fprintf(fdout, 'Block,%d\n', i_blk);
    for i_set = 1:settings.n_sets4block,
        fprintf(fdout, 'Set,%d\n', i_set);
        ind4set = ind4set + 1;
        
        for i_trp = 1:20
            
            c_trp_type = 15;%random seq, so set code to 15
            fprintf(fdout, ',,Type,%d\n,,', c_trp_type);
            %this version prints word alongside items 1 and 2, and below
            %for the 4 choices on item 3 of triplet
            for i_trl = 1:3,
                for i_img = 1:settings.n_imgs4trial(i_trl),
                    
                    fprintf(fdout, '%s,', trial_info.stm{i_blk, i_set, i_trp}{i_trl, i_img});
                    if (i_trl<3)
                        fprintf(fdout, '%s,', trial_info.word{i_blk, i_set, i_trp}{i_trl, i_img});
                    end
                end
                fprintf(fdout, '\n,,');
            end
            for i_img = 1:settings.n_imgs4trial(i_trl),
                
                fprintf(fdout, '%s,', trial_info.word{i_blk, i_set, i_trp}{i_trl, i_img});
            end
            fprintf(fdout, '\n,,');
            fprintf(fdout, '\n');
        end
        fprintf(fdout, '\n');
    end
    
end
fclose(fdout);

save([outfname '.mat'], 'trial_info', 'settings');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now do main sequences for learning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear settings
clear trial_info
clear mynumcell
settings.triplts4set=ntriplet; %for compatibility with Mihaela

settings.stms.dependencies.fnames={'A1',  'B1', ...
    'C1', 'D1', 'D2', 'E1', 'F1',  'Z1', 'Y1', 'Y2','Y3'}';%%%%%%%%%%%% altered!
settings.stms.random.fnames=randoms;
settings.stms.planned.fnames=smids';
settings.stms.random.n=length(randoms);
settings.stms.dependencies.n=length(settings.stms.dependencies.fnames);
settings.stms.planned.n=length(smids);
settings.stms.dependencies.n=8;%specific for current
%Mihaela-compatible codes for actual words - not used in her prog; just to
%retain these

allstim=[settings.stms.dependencies.fnames;smids';randoms];
allnum=[1:9,1001:1003,10001:10068]';%%%changed bcs need numbers for unused wds that feature in practice

for a =1:settings.stms.dependencies.n
    settings.stms.dependencies.words(a,1)=mywords(strmatch(settings.stms.dependencies.fnames(a),mytypes));
end
for a =1:settings.stms.random.n
    settings.stms.random.words(a,1)=mywords(strmatch(settings.stms.random.fnames(a),mytypes))';
end
for a =1:settings.stms.planned.n
    settings.stms.planned.words(a,1)=mywords(strmatch(settings.stms.planned.fnames(a),mytypes))';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
targetpool=[triplets(1:nnonrandom,4)];%pool of targets to include in distractor set
%!!!!!! this will change according to total N triplets ; for 3 of each it
%is 12
initialpool=triplets([1,2,4,5],2);%pool of initial items, A1, C1, E1 and Z1
    outfname_suffix='learning';%
   
    ind4set=0;%counter used by Mihaela
    for b = 1:nblocks
        for s = 1:nsets
            randoms=randoms(randperm(length(randoms)));%randomise order of random items

            bs=b*s;%one for first set and first block
            if bs==1 lastt1='XX'; end;%this is to check if initial item of triplet in one series is same as first in next series
            ind4set = ind4set + 1;
            %Now randomise order of triplet type
            alli=1:ntriplet;
            thisi_seq=alli(randperm(ntriplet));
            
            %first avoid adjacent triplets within the set with same initial 2 triplet items
            mynono=1;
            while(mynono==1)
                
                myx=[2,3]; %myx2 must not follow equiv item in myx
                myx2=[3,2];
                mynono=0; %if this remains at 0, then no problems with sequence
                for jj=1:length(myx)
                    k=find(thisi_seq==myx(jj));%find where the myx items are in the sequence
                    if (k<ntriplet)
                        if(thisi_seq(k+1)==myx2(jj))%check the following item; is it corresponding myx2 item?
                            mynono=1;
                        end
                    end
                end
            
                if mynono==1, thisi_seq=alli(randperm(ntriplet));end
                
            end %redo loop with new sequence if adjacency condition met
               
            %Now check if first item in set is same as last in previous set, swap with
           
            while char(triplets{thisi_seq(1),2})==lastt1
                %reverse the sequence
                tempseq=thisi_seq;
                thisi_seq=fliplr(tempseq);
                  
            end
            lastt1=char(triplets{thisi_seq(length(thisi_seq)),2});
            
            
            
            
            
            for j = 1:ntriplet
                i=thisi_seq(j);%use the sequence selected in previous block of code
                type1=triplets(i,2);
                ybit=char(type1);
                if (ybit(1)=='Y'), type1=randoms(i);end %convert Y ones to randoms
                numword1=strmatch(type1,mytypes);
                word1=mywords(numword1);
               
                type2=triplets(i,3);
                if (char(type2)=='R'), type2=randoms(i+1);end
                numword2=strmatch(type2,mytypes);
                word2=mywords(numword2);
                
                type3=triplets(i,4);%target
                if (char(type3)=='R'), type3=randoms(i+2);end
                numword3=strmatch(type3,mytypes);%corresponding word index for this type
                word3=mywords(numword3);%word3 is target
                
                numword4=numword3;
                thisconflict=find(myconflicts(numword3,:)==1);
                addconflict=numword4;
                %Avoid alternate target as a distractor for probabiistic strings
                chartype3=char(type3);
                if (length(chartype3)<3)
                    
                    if(chartype3=='D1'), addconflict=strmatch('D2',mytypes);end
                    if(chartype3=='D2'), addconflict=strmatch('D1',mytypes);end
                  
                    thisconflict=[thisconflict,addconflict];
                end
                while(find(thisconflict==numword4)>0);
                    type4=datasample(targetpool,1);  %type4 is 1st distractor: another potential target
                    numword4=strmatch(type4,mytypes);
                end
                word4=mywords(numword4);%distractor 1
                
                
                potentialdistractors=[initialpool;dis_pool;smids'];
                numword5=numword4;
                thisconflict=unique([find(myconflicts(numword4,:)==1),thisconflict,numword1,numword2]);
                %use conflicts for both target and D1, and also avoid words 1 and 2
                while(find(thisconflict==numword5)>0);
                    type5= datasample(potentialdistractors,1) ; %type5 is 2nd distractor: drawn from randoms/initials
                    numword5=strmatch(type5,mytypes);
                end
                word5=mywords(numword5);%distractor 2
                
                if i<13 %nonrandom triplets
                    potentialdistractors=randoms;% have one random distractor for each triplet
                end
                numword6=numword5;
                thisconflict=unique([find(myconflicts(numword5,:)==1),thisconflict,numword1,numword2]);
                %use conflicts for both target and D1, and also avoid words 1 and 2
                while(find(thisconflict==numword6)>0);
                    type6= datasample(potentialdistractors,1) ; %type6 is erd distractor: drawn from randoms/initials
                    numword6=strmatch(type6,mytypes);
                end
                word6=mywords(numword6);%distractor 3
                
                %Show derived sequences: NB order to be randomised before presenting
                alltype=[type1,type2,type3,type4,type5,type6];
                allword=[word1,word2,word3,word4,word5,word6];
                
                %Numbers for compatibility with Mihaela structure
                numtrio=[allnum(strmatch(alltype(1),allstim)), allnum(strmatch(alltype(2),allstim)), (allnum(strmatch(alltype(3),allstim)))];
                for n=1:3
                    mynumcell{j,n}=numtrio(n);
                end
                
                %Program will put frame around those prefixed with 'T', so do
                %this for items 1 and 2, and for the target
                
                alltype(1)=strcat('T',alltype(1));
                alltype(2)=strcat('T',alltype(2));
                myr=3;%default is item 3 is target
                if (b==breakblock||b==(breakblock+1))
                    myr=datasample(4:6,1);%select one of the distractors (items 4-6)
                end
                alltype(myr)=strcat('T',alltype(myr)); %prefix target with 'T'
                
                %Now randomise order for the 4 pics on item 3 of triplet
                myorder=3:6;
                myperm=myorder(randperm(4));%3:6 in random seq
                alltype(3:6)=alltype(myperm);
                allword(3:6)=allword(myperm);
               
                %Copy relevant info to Mihaela structures
                settings.sets.trplts_type{1,ind4set}=thisi_seq';%Mihaela cell variable stores order of types
                mycell(3,1:4)=alltype(3:6);
                mycell(1,1)=alltype(1);
                mycell(2,1)=alltype(2);
                trial_info.stm{b,s,j}=mycell;
                %add new field, word, that stores actual words
                mycell(3,1:4)=allword(3:6);
                mycell(1,1)=allword(1);
                mycell(2,1)=allword(2);
                trial_info.word{b,s,j}=mycell;
                 targetpos(j,ind4set)=find(myperm==myr);
            end
            settings.sets.trplts_order{1,ind4set}=mynumcell;
        end
    end
    
    %Write to csv file using Mihaela formats
    %first create my decoder from type to word
    settings.decoder={mywords;mytypes};
    settings.n_blocks=nblocks;
    settings.n_sets4block=nsets;
    c_routine=strcat('Routine',num2str(myroutine));
    settings.routines=c_routine;
    
    settings.n_imgs4trial(1:2)=1;
    settings.n_imgs4trial(3)=4;
    outfname = ['SEQ_' outfname_suffix '_' c_routine ];
    % write the whole design into a separate file
    outfname_design = [outfname '.csv'];
    fdout = fopen(outfname_design, 'w');
    ind4set = 0; %this is a counter that increments for each block/set
    for i_blk = 1:settings.n_blocks,
        fprintf(fdout, 'Block,%d\n', i_blk);
        for i_set = 1:settings.n_sets4block,
            fprintf(fdout, 'Set,%d\n', i_set);
            ind4set = ind4set + 1;
            
            for i_trp = 1:ntriplet
                
                c_trp_type = settings.sets.trplts_type{ind4set}(i_trp);
                fprintf(fdout, ',,Type,%d\n,,', c_trp_type);
                %this version prints word alongside items 1 and 2, and below
                %for the 4 choices on item 3 of triplet
                for i_trl = 1:3,
                    for i_img = 1:settings.n_imgs4trial(i_trl),
                        
                        fprintf(fdout, '%s,', trial_info.stm{i_blk, i_set, i_trp}{i_trl, i_img});
                        if (i_trl<3)
                            fprintf(fdout, '%s,', trial_info.word{i_blk, i_set, i_trp}{i_trl, i_img});
                        end
                    end
                    fprintf(fdout, '\n,,');
                end
                for i_img = 1:settings.n_imgs4trial(i_trl),
                    
                    fprintf(fdout, '%s,', trial_info.word{i_blk, i_set, i_trp}{i_trl, i_img});
                end
                fprintf(fdout, '\n,,');
                fprintf(fdout, '\n');
            end
            fprintf(fdout, '\n');
        end
    end
    fclose(fdout);
    
  
    
    allmystim=[];
    for k=1:50 %this saves stimulus sequences for easy checking, with numeric
        %ccodes; first cols give block and set
        b=uint8((k+2)/5);
        s=k-((b-1)*5);
        frontb=double(repmat([b,s],ntriplet,1));
        lastb=cell2mat(settings.sets.trplts_order{1,k});
        addstim=[frontb,lastb,targetpos(:,k)];
        allmystim=[allmystim;addstim];
    end
    %allmystim has block, set, numcode1, numcode2,numcode3, targetposition
    csvwrite('OutputTest.csv',allmystim);
      save([outfname '.mat'], 'trial_info', 'settings','allmystim');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Now do main sequences for recall
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 clear settings
clear trial_info
clear mynumcell
settings.triplts4set=ntriplet; %for compatibility with Mihaela

settings.stms.dependencies.fnames={'A1',  'B1', ...
    'C1', 'D1', 'D2', 'E1', 'F1',  'Z1', 'Y1', 'Y2','Y3'}';%%%%%%%%%%%% altered!
settings.stms.random.fnames=randoms;
settings.stms.planned.fnames=smids';
settings.stms.random.n=length(randoms);
settings.stms.dependencies.n=length(settings.stms.dependencies.fnames);
settings.stms.planned.n=length(smids);
settings.stms.dependencies.n=8;%specific for current
%Mihaela-compatible codes for actual words - not used in her prog; just to
%retain these

allstim=[settings.stms.dependencies.fnames;smids';randoms];
allnum=[1:9,1001:1003,10001:10068]';%%%changed bcs need numbers for unused wds that feature in practice
    targetpool=[triplets(1:nnonrandom,4)];%pool of targets to include in distractor set
initialpool=triplets([1,2,4,5],2);%pool of initial items, A1, C1, E1 and Z1
    randoms=randoms(randperm(length(randoms)));%randomise order of random items
    
    nblocks=1;
    nsets=1;
    outfname_suffix='recall';
    
    
    ind4set=0;%counter used by Mihaela
    for b = 1:nblocks
        for s = 1:nsets
            bs=b*s;%one for first set and first block
            if bs==1 lastt1='XX'; end;%this is to check if initial item of triplet in one series is same as first in next series
            ind4set = ind4set + 1;
            %Now randomise order of triplet type
            alli=1:ntriplet;
            thisi_seq=alli(randperm(ntriplet));
            
            %first avoid adjacent triplets within the set with same initial 2 triplet items
            mynono=1;
            while(mynono==1)
                
                myx=[2,3]; %myx2 must not follow equiv item in myx
                myx2=[3,2];
                mynono=0; %if this remains at 0, then no problems with sequence
                for jj=1:length(myx)
                    k=find(thisi_seq==myx(jj));%find where the myx items are in the sequence
                    if (k<ntriplet)
                        if(thisi_seq(k+1)==myx2(jj))%check the following item; is it corresponding myx2 item?
                            mynono=1;
                        end
                    end
                end
                if mynono==1, thisi_seq=alli(randperm(ntriplet));end
            end %redo loop with new sequence if adjacency condition met
            
            %Now check if first item in set is same as last in previous set, swap with
            %7th item in set (an arbitrary choice)
            while char(triplets{thisi_seq(1),2})==lastt1
                temp=thisi_seq(1);
                myrand=1+randi(ntriplet-1);%number from 2 to ntriplet
                thisi_seq(1)=thisi_seq(myrand);%swap with a random element from seq
                thisi_seq(myrand)=temp;
            end
            lastt1=char(triplets{thisi_seq(length(thisi_seq)),2});
            
            
            
            
            
            for j = 1:ntriplet
                      i=thisi_seq(j);%use the sequence selected in previous block of code
                type1=triplets(i,2);
                ybit=char(type1);
                if (ybit(1)=='Y'), type1=randoms(i);end %convert Y ones to randoms
                numword1=strmatch(type1,mytypes);
                word1=mywords(numword1);
               
                type2=triplets(i,3);
                if (char(type2)=='R'), type2=randoms(i+1);end
                numword2=strmatch(type2,mytypes);
                word2=mywords(numword2);
                
                type3=triplets(i,4);%target
                if (char(type3)=='R'), type3=randoms(i+2);end
                numword3=strmatch(type3,mytypes);%corresponding word index for this type
                word3=mywords(numword3);%word3 is target
                
                numword4=numword3;
                thisconflict=find(myconflicts(numword3,:)==1);
                addconflict=numword4;
                %Avoid alternate target as a distractor for probabiistic strings
                chartype3=char(type3);
                if (length(chartype3)<3)
                    
                    if(chartype3=='D1'), addconflict=strmatch('D2',mytypes);end
                    if(chartype3=='D2'), addconflict=strmatch('D1',mytypes);end
                
                    thisconflict=[thisconflict,addconflict];
                end
                while(find(thisconflict==numword4)>0);
                    type4=datasample(targetpool,1);  %type4 is 1st distractor: another potential target
                    numword4=strmatch(type4,mytypes);
                end
                word4=mywords(numword4);%distractor 1
                
                
                potentialdistractors=[initialpool;dis_pool;smids'];
                numword5=numword4;
                thisconflict=unique([find(myconflicts(numword4,:)==1),thisconflict,numword1,numword2]);
                %use conflicts for both target and D1, and also avoid words 1 and 2
                while(find(thisconflict==numword5)>0);
                    type5= datasample(potentialdistractors,1) ; %type5 is 2nd distractor: drawn from randoms/initials
                    numword5=strmatch(type5,mytypes);
                end
                word5=mywords(numword5);%distractor 2
                
                if i<13 %nonrandom triplets
                    potentialdistractors=randoms;% have one random distractor for each triplet
                end
                numword6=numword5;
                thisconflict=unique([find(myconflicts(numword5,:)==1),thisconflict,numword1,numword2]);
                %use conflicts for both target and D1, and also avoid words 1 and 2
                while(find(thisconflict==numword6)>0);
                    type6= datasample(potentialdistractors,1) ; %type6 is erd distractor: drawn from randoms/initials
                    numword6=strmatch(type6,mytypes);
                end
                word6=mywords(numword6);%distractor 3
                
                %Show derived sequences: NB order to be randomised before presenting
                alltype=[type1,type2,type3,type4,type5,type6];
                allword=[word1,word2,word3,word4,word5,word6];
                
                %Numbers for compatibility with Mihaela structure
                numtrio=[allnum(strmatch(alltype(1),allstim)), allnum(strmatch(alltype(2),allstim)), (allnum(strmatch(alltype(3),allstim)))];
                for n=1:3
                    mynumcell{j,n}=numtrio(n);
                end
                
                %Program will put frame around those prefixed with 'T', so do
                %this for items 1 and 2, and for the target
                
                alltype(1)=strcat('T',alltype(1));
                alltype(2)=strcat('T',alltype(2));
                myr=3;%default is item 3 is target
                if (b==breakblock)
                    myr=datasample(4:6,1);%select one of the distractors (items 4-6)
                end
                alltype(myr)=strcat('T',alltype(myr)); %prefix target with 'T'
                
                %Now randomise order for the 4 pics on item 3 of triplet
                myorder=3:6;
                myperm=myorder(randperm(4));%3:6 in random seq
                alltype(3:6)=alltype(myperm);
                allword(3:6)=allword(myperm);
                
                %Copy relevant info to Mihaela structures
                settings.sets.trplts_type{1,ind4set}=thisi_seq';%Mihaela cell variable stores order of types
                mycell(3,1:4)=alltype(3:6);
                mycell(1,1)=alltype(1);
                mycell(2,1)=alltype(2);
                trial_info.stm{b,s,j}=mycell;
                %add new field, word, that stores actual words
                mycell(3,1:4)=allword(3:6);
                mycell(1,1)=allword(1);
                mycell(2,1)=allword(2);
                trial_info.word{b,s,j}=mycell;
            end
            settings.sets.trplts_order{1,ind4set}=mynumcell;
        end
    end
    
    %Write to csv file using Mihaela formats
    %first create my decoder from type to word
    settings.decoder={mywords;mytypes};
    settings.n_blocks=nblocks;
    settings.n_sets4block=nsets;
    c_routine=strcat('Routine',num2str(myroutine));
    settings.routines=c_routine;
    
    settings.n_imgs4trial(1:2)=1;
    settings.n_imgs4trial(3)=4;
    outfname = ['SEQ_' outfname_suffix '_' c_routine ];
    % write the whole design into a separate file
    outfname_design = [outfname '.csv'];
    fdout = fopen(outfname_design, 'w');
    ind4set = 0; %this is a counter that increments for each block/set
    for i_blk = 1:settings.n_blocks,
        fprintf(fdout, 'Block,%d\n', i_blk);
        for i_set = 1:settings.n_sets4block,
            fprintf(fdout, 'Set,%d\n', i_set);
            ind4set = ind4set + 1;
            
            for i_trp = 1:ntriplet
                
                c_trp_type = settings.sets.trplts_type{ind4set}(i_trp);
                fprintf(fdout, ',,Type,%d\n,,', c_trp_type);
                %this version prints word alongside items 1 and 2, and below
                %for the 4 choices on item 3 of triplet
                for i_trl = 1:3,
                    for i_img = 1:settings.n_imgs4trial(i_trl),
                        
                        fprintf(fdout, '%s,', trial_info.stm{i_blk, i_set, i_trp}{i_trl, i_img});
                        if (i_trl<3)
                            fprintf(fdout, '%s,', trial_info.word{i_blk, i_set, i_trp}{i_trl, i_img});
                        end
                    end
                    fprintf(fdout, '\n,,');
                end
                for i_img = 1:settings.n_imgs4trial(i_trl),
                    
                    fprintf(fdout, '%s,', trial_info.word{i_blk, i_set, i_trp}{i_trl, i_img});
                end
                fprintf(fdout, '\n,,');
                fprintf(fdout, '\n');
            end
            fprintf(fdout, '\n');
        end
    end
    fclose(fdout);
    
    save([outfname '.mat'], 'trial_info', 'settings');




