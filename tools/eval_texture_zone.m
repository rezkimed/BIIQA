function Q=eval_texture_zone(s,x,y)
k=0;
% p=[-1 -1 -1 0 0 1 1 1];
% q=[-1 0 1 -1 1 -1 0 1];
p=[-1 -1 -1 0 0 1 1 1 -2 -2 -2 -2 -2 -1 -1 0 0 1 1 2 2 2 2 2];  %pour prendre voisin 5x5
q=[-1 0 1 -1 1 -1 0 1 -2 -1 0 1 2 -2 2 -2 2 -2 2 -2 -1 0 1 2];

%%%%%-------  utilisant les volef dct -----
for i=1:length(p)
    
   if((s(x+p(i), y+q(i)).lab_mask==1)&& (s(x+p(i), y+q(i)).class~=1)) %% rexture ou edge 
       k=k+1;
       voisi_dct2(k,:)=s(x+p(i), y+q(i)).dct_coef;
       ss(k)=sum(sum(s(x+p(i), y+q(i)).p_Gmag));
   end 
end 

if (k>0)
    
%  aa=[ 1 2 3 5 6 9  11] ;
%  aa=[2 3 4 7 8 13 14 15 19 ] ;  % 6x6
%  aa=[1 2 3 4 9 10 11  17 18 19 25 26 ] ;

 aa=1:16;
% aa=2:15;
voisi_dct=voisi_dct2(:,aa );

%      [ mi ind]=min(vect_orient); 
%       Gmag_vois=ss(ind);
 
  
 
%    Q=1-min(dist(voisi_dct , s(x,y).dct_coef(aa)'))/sum(s(x,y).dct_coef(aa));
   [mi ind] =min(dist(voisi_dct , s(x,y).dct_coef(aa)'));
   Q1=1-mi/sum(s(x,y).dct_coef(aa));
   Gmag_vois=ss(ind);
  Gmag=sum(sum(s(x,y).p_Gmag));
     Q_t=2*(Gmag_vois*Gmag)/(Gmag_vois^2+Gmag^2);
    Q=Q_t;%*Q1;
%     Q=1-(min(dist(voisi_dct , s(x,y).dct_coef(aa)'))/max(dist(voisi_dct ,s(x,y).dct_coef(aa)')));
else 
    Q=0;
end 


%%%---------utilisant ssim ------
% for i=1:length(p)
%     
%    if((s(x+p(i), y+q(i)).lab_mask==1)&& (s(x+p(i), y+q(i)).class~=1)) %% rexture ou edge 
%        k=k+1;
%        voisi_ssim(k)=ssim( s(x,y).img_patch, s(x+p(i), y+q(i)).img_patch);
%        
%    end 
% end 
% if (k>0)
%    Q=max(voisi_ssim);
% 
% else 
%     Q=0;
% end 
% 
