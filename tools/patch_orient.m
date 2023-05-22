%%cette fonction ne marche que pour les edge_patch

function p_orient=patch_orient(Gmag_patch,Gdir_patch)
k=1;
%%ici on prend des intervles de 10° ex entre 0 et 10 =>1 entre 10 et 20 =>2; ....
u_orient=360/36;
dir_norm=fix ((Gdir_patch+180)/u_orient)+1;

for i=1:size(Gmag_patch,1)
   for j=1:size(Gmag_patch,2)
     if(Gmag_patch(i,j)) 
         v(k)= dir_norm(i,j);
         k=k+1;
    end 
   end
end
%%%-- la methode simple ---
% for i=1:size(Gmag_patch,1)
%     for j=1:size(Gmag_patch,2)
% %     if(Gmag_patch(i,j)) 
%         v(k)=Gdir_patch(i,j);
%         k=k+1;
% %     end   
%     end
% end 
%%%ici il faut ajouter les directions issenssiel 
%sum(sum(Gmag_patch))
% p_orient=max(max(Gmag_patch));%mode(v);
if (k==1)
p_orient=55; %%pour les non edge 
else
p_orient=mode(v);
end

