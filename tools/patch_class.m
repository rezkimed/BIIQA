%% pour tester cette fonction ou regler les para P 1 2 3 4  decocher les suivants
% % % clc; close all; clear all; 
% % % img_patch= rgb2gray(im2double(imread('T10.png')));

 function [c , p_dct_coef]=patch_class(img_patch,Gmag_patch)
 if (size(img_patch,1)<7) %att  s_p inferieur a 6 
            p0=0.3;P1=1000;p2=800; p3=8000; p4=30;
            dct_img=abs(dct2(img_patch));

            % les coef H V D
            V=sum([dct_img(1,3) dct_img(1,4)  dct_img(2,3) dct_img(2,4)  ]);
            H=sum([dct_img(3,1) dct_img(3,2) dct_img(4,1) dct_img(4,2)  ]);
            D=sum([dct_img(2,3) dct_img(3,2) dct_img(3,3) dct_img(3,4) dct_img(4,3) dct_img(4,4) ]);
             c=0; %%default walo    
            Atot=sum(sum(dct_img)) -dct_img(1,1) ;
            Eg=sum(sum(Gmag_patch)) ;
            %if (Eg ) c=3; end    % un countour 
            if (Atot<p0)
                % smooth region 
                c=1;
            else
                Amax=max([V H D ]);
                Amin=min([V H D ]);
                Amid=median([V H D ]);     
                Alow=dct_img(1,2)+dct_img(2,1)+ dct_img(2,2);
                r1=100*Amax/Amid; r2 =100*Amid/Amin ; r3=100*Amax/Amin; 
                 r4=100*Alow/Atot;
                 ss=sum(sum(Gmag_patch));
                 if (r4>p4 && ss>2) c=3; %edge 
                 else%if(r1<P1 && r2<p2 && r3< p3)
                     c=2;
                      % texture
            %      else 
            %          pp=1;



                 end 
            end 

            %     if (c==0) 
            %        aaa=1;
            %     end 
            %       imshow(img_patch);
            % VEC=reshape(dct_img(1:4,1:4)',1,[]); %%% il faut prendre les stat 
            VEC=reshape(dct_img,1,[]);
             p_dct_coef=VEC;%(2:end);% si on enleve la moy 
   
 else %% %%%%%------------s_p >4----------
  % function [c , p_dct_coef]=patch_class(img_patch,Gmag_patch)%att  s_p doit etre sup ou egale a 8 
        p0=1;P1=1000;p2=800; p3=8000; p4=25;
        dct_img=abs(dct2(img_patch));

        % les coef H V D
        V=sum([dct_img(1,3) dct_img(1,4) dct_img(1,5) dct_img(2,3) dct_img(2,4) dct_img(2,5) ]);
        H=sum([dct_img(3,1) dct_img(3,2) dct_img(4,1) dct_img(4,2) dct_img(5,1) dct_img(5,2) ]);
        D=sum([dct_img(2,3) dct_img(3,2) dct_img(3,3) dct_img(3,4) dct_img(4,3) dct_img(4,4) ]);
         c=0; %%default walo    
        Atot=sum(sum(dct_img)) -dct_img(1,1) ;
        Eg=sum(sum(Gmag_patch)) ;
        %if (Eg ) c=3; end    % un countour 
        if (Atot<p0)
            % smooth region 
            c=1;
        else
            Amax=max([V H D ]);
            Amin=min([V H D ]);
            Amid=median([V H D ]);     
            Alow=dct_img(1,2)+dct_img(2,1)+ dct_img(2,2);
            r1=100*Amax/Amid; r2 =100*Amid/Amin ; r3=100*Amax/Amin; 
             r4=100*Alow/Atot;
             ss=sum(sum(Gmag_patch));
             if (r4>p4 && ss>3) c=3; %edge 
             else%if(r1<P1 && r2<p2 && r3< p3)
                 c=2;
                  % texture
        %      else 
        %          pp=1;



             end 
        end 

        %     if (c==0) 
        %        aaa=1;
        %     end 
        %       imshow(img_patch);
        VEC=reshape(dct_img(1:8,1:8)',1,[]); %%% il faut prendre les stat 
        % VEC=reshape(dct_img,1,[]);
        p_dct_coef=VEC;%(1:end);% si on enleve la moy 
end
end 