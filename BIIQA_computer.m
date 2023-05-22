% cette fonction clcule score d'inapinting d'une image 


function Qal=BIIQA_computer(image_f,mask_f) 
% tic
 s_p=8;k=3;
mask  = im2double(imread(mask_f));
if(size(mask,3)>1)
mask=rgb2gray(mask);
end 

if(sum(sum(mask))<20)
    Qal=struct('score',2,...%'Ex_time',Extime,...
  'score_edge',2,'score_text',2,'score_smooth',2,...
 'nbr_edge',0,'nbr_text',0,'nbr_smooth',0);
    return;
end
image_rgb= im2double(imread(image_f)); 
img_ycbcr  = rgb2ycbcr(image_rgb);
img_y=img_ycbcr(:,:,1);  clear img_ycbcr ;
img_hsv  = rgb2hsv(image_rgb);


if(size(mask,1)~=size(img_y,1)||size(mask,2)~=size(img_y,2))
    mask=imresize(mask,size(img_y),'nearest');
    mask(mask>0)=1;
end

% imshow(mask);
[s,a,b]=prepar(img_y,mask,s_p,k,1.5);

nbr_voisin_mask=zeros(size(s));
img_class=zeros(size(s));
orient=zeros(size(s));
k=1;

for i=1:size(s,1)%  find mask patch 
    for j=1:size(s,2)
      label_mask(i,j)=s(i,j).lab_mask;%% mask 1 no mask 0 
      img_class(i,j)=s(i,j).class; %1 smoth 2 txt 3 edge
      orient(i,j)=s(i,j).orient;
    end 
end 


%% label_mask2=-1*(label_mask-1);%% le mask inverse 
    label_mask2=zeros(size(label_mask)); label_mask2(label_mask==0)=1;%%  le zone non inpainted 
    label_mask3=zeros(size(label_mask)); label_mask3(label_mask==1)=1; %% que les patchs  plus 80% dans  mask
    label_mask4=(~label_mask2);
    n_s=0;n_e=0;n_t=0;    oo=zeros(size(s));
%%
    for i=2:size(s,1)-1%%%% boucle pour extraire le % de chaque class ds voisinnage (info de voisinage )  
        for j=2:size(s,2)-1
          if (label_mask2(i,j)) 
          nbr_voisin_mask(i,j)=sum(sum(label_mask4(i-1:i+1,j-1:j+1))); % le nembre de voisin inter au  mask =0
          end 

        end 
    end 
%%% calculer la qualité
i_s=1;i_t=1; i_e=1;     
 p_no_class=zeros(size(s)); p_non_eval=zeros(size(s));


for i=3:size(s,1)-2 
for j=3:size(s,2)-2
   if(nbr_voisin_mask(i,j)>1) %ou moin deux voisin  mask=0
                switch s(i,j).class
                            case 1 % zone lisse
                               scor_v_s(i_s)=eval_smooth_zone_gray(s,i,j);
%                                scor_v_s(i_s)=eval_smooth_zone(s,i,j);
                                oo(i,j)=scor_v_s(i_s);
                               i_s=i_s+1;
                               
                                
                            case  2 % textutre patch
                                 scor_v_t(i_t)=eval_texture_zone(s,i,j);
                                  oo(i,j)=10+scor_v_t(i_t);
                                  i_t=i_t+1;                                 
                            case 3 % edge parch 
                                scor_v_e(i_e)=eval_edge_zone(s,i,j);
                                oo(i,j)=20+scor_v_e(i_e);
                                i_e=i_e+1;
                               %% esq on calcule que la cohérence avec l exterieur au mm linterieure                            
                            otherwise  p_no_class(i,j)=1;            
                        end
                    else % n'est pas dans les frontiere //un seul voisin ou makach *
          p_non_eval(i,j)=1;
            end 
    end 
end

%%------smooth 
if (i_s>1)
score_smooth=mean (scor_v_s);
else 
    score_smooth=1;
end
%%%-----edge 
if (i_e>1)
score_edge=mean (scor_v_e);
else 
   score_edge=1;
end 
%%---textt
if (i_t>1)
score_text=mean (scor_v_t);
else 
   score_text=1;
end 

som=i_s+i_e+i_t; i_s=i_s/som ; i_e=i_e/som;  i_t=i_t/som;

% scor_g=(score_smooth+3*score_edge+2*score_text)/6;
 scor_g2=(i_s*score_smooth+i_e*score_edge+i_t*score_text);

% Extime=toc;
Qal=struct('score',scor_g2,...%'Ex_time',Extime,...
  'score_edge',score_edge,'score_text',score_text,'score_smooth',score_smooth,...
 'nbr_edge',i_e*100,'nbr_text',i_t*100,'nbr_smooth',i_s*100);

%%-----les graphes---------------
%   figure;  image((label_mask+1)*10); title ('label')
% figure;  image(img_class *20+(label_mask3-label_mask)*-100);title('20 smoth 40 txt 60 edge');
%  figure;  imshow(orient/180);
%   orient(orient==100)=0;%   figure;  image(orient*5); title('orientation normalisé x5');
% 
% for i=1:size(s,1)%  find mask patch 
%     for j=1:size(s,2)
%          if(s(i,j).class==3 || s(i,j).class==2)
%       u(k)=0.1*cos( (orient(i,j)*10-180)*3.14/180); %% revenir a l orientation normale
%       v(k)=0.1*sin( (orient(i,j)*10-180)*3.14/180);
%       x(k)=j;
%       y(k)=i;
%       k=k+1;
%       end
%     end 
% end 
% cl(label_mask==0)=img_class(label_mask==0)/2;
% image (img_class*20);
% % image (200*ones(i,j))
% hold on
% quiver(x,y,u,v,'r')
% hold off

end 
