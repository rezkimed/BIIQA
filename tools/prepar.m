%cette fct 

function [s ,a,b]=prepar(img_y,mask,s_p,k,radius)
% default radius=1.5;
mask(mask~=0)=1;

se = strel('disk',s_p*k) ; mask_dil = imdilate(mask,se);se = strel('disk',3) ;mask_erod = imerode(mask,se);
mask_dil_prop = regionprops(mask_dil,'BoundingBox'); 
% mask=mask-mask_erod;%%  si on prend la totalité on comente cette cmd
% figure; subplot(1,3,1) ;imshow(mask_dil);  subplot(1,3,2); imshow(mask);  subplot(1,3,3); imshow(mask_erod);
%-----Xand Y region start -----------
x_start=floor(mask_dil_prop.BoundingBox(2));
y_start=floor(mask_dil_prop.BoundingBox(1));
if (x_start<1) x_start=1; end 
if (y_start<1) y_start=1; end 
%------- X Y regin end -------------
a=floor(mask_dil_prop.BoundingBox(4)); if (mod(a,s_p)) a=a-mod(a,s_p); end 
b=floor(mask_dil_prop.BoundingBox(3)); if (mod(b,s_p)) b=b-mod(b,s_p); end
x_end=x_start+a-1;
y_end=y_start+b-1;

if (x_end>size(img_y,1)-s_p) 
             x_end=size(img_y,1)-s_p-mod(size(img_y,1),s_p);
%              a=size(img_y,1)-x_start-mod(size(img_y,1)-x_start,s_p); 
             a=x_end - x_start;
             a=a-mod(a,s_p);
end 
if (y_end>size(img_y,2)-s_p) 
        y_end=size(img_y,2)-s_p-mod(size(img_y,2),s_p);
        b=y_end - y_start;
        b=b-mod(b,s_p);
end 



img_zone=img_y(x_start:x_end,y_start:y_end);
mask_zone=mask(x_start:x_end,y_start:y_end);

% preparer le voisinage 
% img_zone=img_y(x_start:x_start+a-1,y_start:y_start+b-1);
% mask_zone=mask(x_start:x_start+a-1,y_start:y_start+b-1);

%% preparer les stat mu, sigma , lab  
gaussFilt = getGaussianWeightingFilter(radius,2);% 2 => 2D not more 

[Gmag1, Gdir] = imgradient(img_zone,'prewitt');
   Gmag=edge(img_zone,'Canny');
   
%      Gmag(1:s_p:end ,:)=0.1;
%   Gmag(:,1:s_p:end )=0.1;
%  imshow(Gmag);title('Gmag'); 
%   img_zone(1:s_p:end,:)=0.2; img_zone(:,1:s_p:end)=0.2;
%    figure; imshow(img_zone); 
   
p=1;
for i=1:s_p:a-s_p
  q=1;
    for j=1:s_p:b-s_p
       
      img_patch= img_zone(i:i+s_p-1,j:j+s_p-1);
      msk_patch= mask_zone(i:i+s_p-1,j:j+s_p-1);
      Gmag_patch=Gmag(i:i+s_p-1,j:j+s_p-1);
      Gdir_patch=Gdir(i:i+s_p-1,j:j+s_p-1);
      p_Gmag=Gmag1(i:i+s_p-1,j:j+s_p-1);
     
      
      
%%  cas 1 deux label patch mask 1 or patch non mask 0
      %label = 0 or 1 
%       if((find( msk_patch)))
%           lab=1; %% si au moins un pixel mask
%       else
%           lab=0; %% ne contient aucun pixel mask
%       end

% %% cas 1 trois  label patch mask 1 or patch non mask 0 patch  moitié % moitié 
     nbr= numel(find( msk_patch));
     seuil1=fix(s_p^2*0.80);  seuil2=fix(s_p^2*0.2);  %% pour danner le lab on fix les seuil a 80 % et 75%
      if(nbr>seuil1)
          lab=1; %% si au moins 11 pixel E mask
      elseif(nbr>seuil2)
          lab=-1;
      else
          lab=0; %% ne contient aucun pixel mask
      end 
      

      moy = imfilter(img_patch, gaussFilt,'conv','replicate');
%       mu=mean(mean(moy));
       mu=mean(mean(img_patch));
      %mu = imgaussfilt(img_patch,sig);
      mu2 = mu.^2; % moyenne
      sigma2 = imfilter(img_patch.^2,gaussFilt,'conv','replicate') - mu2; %variance 
    
        % classer les patch en 3 categor
    [p_class,p_dct_coef]=patch_class(img_patch,Gmag_patch); %% 2=texture or 3=edge or 1=smooth region 
     % orientation de patch 
    if (p_class==2 ||p_class==3) %% les zones no smooth 
%         p_class
        p_orient= patch_orient(Gmag_patch,Gdir_patch);
    else %%==1 smooth or 2 tetx
        p_orient =200; %%fausse valeur 
    end 
        
        s(p,q)=struct('img_patch',img_patch,'mask_patch',msk_patch,'lab_mask',lab,'p_Gmag',p_Gmag,...
               'class',p_class,'orient',p_orient,'mu',mu,'sigma2',sigma2,'dct_coef',p_dct_coef );
%           'color_L',color_L,'color_a',color_a,'color_b',color_b );
% 

               %'hist_h',hist_h,'hist_s',hist_s,'hist_v',hist_v,...
     q=q+1;
    end
     p=p+1;
    
end

end 

function gaussFilt = getGaussianWeightingFilter(radius,N)

      filtRadius = ceil(radius*3); % 3 Standard deviations include >99% of the area. 
      filtSize = 2*filtRadius + 1 ;
      gaussFilt = fspecial('gaussian',[filtSize filtSize],radius);
end
