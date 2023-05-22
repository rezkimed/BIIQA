% close all; clear all; clc; 
% load('resultats/resultat_mask1_gray.mat');
f_name='resultat8x8_mask1et3' ;
load(['resultats/' f_name '.mat']);
% mos_qal=mos_qal(9:end);
Qal1=zeros(1,length(BDD_Qal));
Qal2=zeros(1,length(BDD_Qal));
mos=zeros(1,length(BDD_Qal));

for i=1:length(Qal1)
Qal1(i)=BDD_Qal(i).score1;
Qal2(i)=BDD_Qal(i).score2;
mos(i)=BDD_Qal(i).mos;
end  
hold on ;
plot (mos,Qal2,'bo');title(f_name);
 xlabel('MOS');ylabel('Quality');
 