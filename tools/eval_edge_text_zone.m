function Q=eval_edge_text_zone(s,x,y)
k=0;l=0;
p=[-1 -1 -1 0 0 1 1 1];
q=[-1 0 1 -1 1 -1 0 1];% pour voisin 3x3
% p=[-1 -1 -1 0 0 1 1 1 -2 -2 -2 -2 -2 -1 -1 0 0 1 1 2 2 2 2 2];  %pour prendre voisin 5x5
% q=[-1 0 1 -1 1 -1 0 1 -2 -1 0 1 2 -2 2 -2 2 -2 2 -2 -1 0 1 2];
for i=1:length(p)
    
   if((s(x+p(i),y+q(i)).lab_mask==0)&& (s(x+p(i),y+q(i)).class~=1))%%att norml ==3
%       if(s(x+p(i),y+q(i)).class~=1)%%att norml ==3
   
       k=k+1;
       vect_orient(k)=s(x+p(i), y+q(i)).orient;
       voisi_dct(k,:)=s(x+p(i), y+q(i)).dct_coef;
   end 
end 

if (k>0)
        vect_orient=(abs(s(x,y).orient-vect_orient));% comparer vavec le voisinage
        
        Q=1-(0.5*min(dist(voisi_dct , s(x,y).dct_coef'))+0.5*(min(vect_orient)/max(vect_orient))); %%
else  %%% cas poas de edge dans le voisinage 
    Q=0;
end 
