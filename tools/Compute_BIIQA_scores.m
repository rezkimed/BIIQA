
  close all;  clear all; clc;
  load('D:\VI_BDD_for_VQA\listes\List_VC_MOS.mat');
 load('D:\VI_BDD_for_VQA\listes\List_OR_MOS.mat');
 load('D:\VI_BDD_for_VQA\listes\List_Stabil_MOS.mat');

 S=[VC,OR,Stab];
     clear OR VC Stab

  addpath('tools\tools')
  

Qal.S=S;

% Qal.S=zeros(length(S),100);
% Qal.F=zeros(length(S),100); 
% Qal.Time=zeros(length(S),100); 
% 
%clear Qal;
   step=3 ;
   
for i=1:length(S)
   tic;
   video_name=char(S(i).Name); 
   fprintf('\n---\nComputing features for %d-th sequence: %s\n', i, video_name);
   nbr_f=length(S(i).Inpaint);
 
   c=1; p=1;
    err=0;
   
   for j=1:step:nbr_f
    
        Inp_frame= char(S(i).Inpaint(j));
        Mask_frame= char(S(i).Mask(j));


        try
            Q=inpaint_qual(Inp_frame, Mask_frame);
            Qal.Sc(i,c)=Q.score;
            Qal.frames_eval(i,c)=j;
            if(Q.score==2)
                Qal.mask_exist(i,c)=0; 
            else
                Qal.mask_exist(i,c)=1;   
                Qal.frame_scores(i,p)=Q.score;
                p=p+1;
            end
            
        catch 
            Qal.Sc(i,c)=0;
            Qal.frames(i,c)=0;
            err=1;
        end
        c=c+1 ;   fprintf('%d - ', j);
       end 

        Qal.Time(i)=toc;
        Qal.nbr_f(i)=nbr_f;
        Qal.nbr_f_eval(i)=floor((nbr_f-1)/step)+1;
        Qal.frame_scores_nbr(i)=p;
        Qal.err(i)=err;
       fprintf(' \n   ', j);
       save('results\Qal_VC_OR_Stab_New.mat','Qal');
end

% sum(arrayfun(@(x) sum(x.MOS),M))     -----------------Goooood function
