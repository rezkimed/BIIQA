function Q=eval_smooth_zone_gray(s,x,y)
k=0;
% p=[-1 -1 -1 0 0 1 1 1];
% q=[-1 0 1 -1 1 -1 0 1];
p=[-1 -1 -1 0 0 1 1 1 -2 -2 -2 -2 -2 -1 -1 0 0 1 1 2 2 2 2 2];  %pour prendre voisin 5x5
q=[-1 0 1 -1 1 -1 0 1 -2 -1 0 1 2 -2 2 -2 2 -2 2 -2 -1 0 1 2];
for i=1:length(p)
    
   if((s(x+p(i), y+q(i)).lab_mask==1)&& (s(x+p(i), y+q(i)).class==1))
       k=k+1;
       vect_moy(k)=s(x+p(i), y+q(i)).mu;
   end 
end 
if (k>=1)
    vect_moy=(abs(s(x,y).mu-vect_moy))/s(x,y).mu; %%%% arevoir
    Q=1-min(vect_moy);%/max(vect_moy));
    if(Q<0) Q=0.02; % pour eviter le zero 
    end 
else 
    Q=0.01;
end 
