function Q=eval_edge_zone(s,x,y)
k=0;
% p=[-1 -1 -1 0 0 1 1 1];
% q=[-1 0 1 -1 1 -1 0 1];% pour voisin 3x3
p=[-1 -1 -1 0 0 1 1 1 -2 -2 -2 -2 -2 -1 -1 0 0 1 1 2 2 2 2 2];  %pour prendre voisin 5x5
q=[-1 0 1 -1 1 -1 0 1 -2 -1 0 1 2 -2 2 -2 2 -2 2 -2 -1 0 1 2];
for i=1:length(p)
    
   if((s(x+p(i),y+q(i)).lab_mask==1)&&(s(x+p(i),y+q(i)).class~=1))%%att norml ==3
%       if(s(x+p(i),y+q(i)).class~=1)%%att norml ==3
   
       k=k+1;
       vect_orient(k)=s(x+p(i), y+q(i)).orient;
       
   end 
end 

if (k>0)
        vect_orient=(abs(s(x,y).orient-vect_orient));% comparer vavec le voisinage
        mi=min(vect_orient); 
   if(mi<=1) %%% bon edge  
        Q=1;
   elseif( mi<=5)  
        Q=1-(mi/10)*2;
   else
        Q=0.1;
   end


% Q=1-(min(vect_orient)/max(vect_orient)); %%

 else  %%% cas poas de edge dans le voisinage 
     Q=0;



end 
