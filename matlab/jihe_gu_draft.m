%  a=daoru(132,132)
% %   a=a+int16(3024*ones(512,464))
%  d=max(max(a))
%  a=double(a)./double(d)
%  imshow(a)
   l=0
   qn=0 %连接判断变量
   for j=88:1:380
        if l==0 
            for i=1:1:512
                if a(i,j)>0.1
                    v(i,j)=1
                    qn=1
                else
                    v(i,j)=0
                    if i>5   
                    if a(i-5,j)>0.1
                        if a(i+5,j)>0.1
                            v(i,j)=1
                        end
                    end
% % % % % % %                     if v(i,j)==1
% % % % % % %                         q(i,j)=lugu_speed
% % % % % % %                         e(i,j)=lugu_density
% % % % % % %                         f(i,j)=lugu_absorb 
% % % % % % %                     elseif  v(i,j)==0
% % % % % % %                         q(i,j)=shui_speed
% % % % % % %                         e(i,j)=shui_density
% % % % % % %                         f(i,j)=shui_absorb
                    if qn==1
                        if  v(i,j)==0
                          if a(i-5,j)<0.1
                        l=1
                        qn=0
                        break
                          end
                        end
                    end
                end
                end
            end
        end
        if l==1
            for i=512:-1:1
                if a(i,j)>0.1
                    v(i,j)=1
                    qn=1
                else 
                    v(i,j)=0
                    if i<507
                        if a(i+5,j)>0.1
                            if a(i-5,j)>0.1
                        v(i,1)=1 
                        qn=1
                            end
                        end              

% % % % % % %                      `   if v(i,j)==1
% % % % % % %                             q(i,j)=lugu_speed
% % % % % % %                             e(i,j)=lugu_density
% % % % % % %                             f(i,j)=lugu_absorb
% % % % % % %                         elseif v(i,j)==0
% % % % % % %                             q(i,j)=shui_speed
% % % % % % %                             e(i,j)=shui_density
% % % % % % %                             f(i,j)=shui_absorb
% % % % % % %                         end
                            if v(i,j)==0
                                if qn==1
                                  if a(i+5,j)<0.1
                            l=0
                        break
                                  end
                                end
                            end
                    end
                end
            end
        end
   end
%2024.5.11,完成了对骨性介质几何的提取工作'
%  lb=edge(a)
%  imshow(lb)
%  k=imclose(a,lb)
%2024.5.7，完成了读取图像的工作。
% kgrid=makeGrid(464,0.00047,512,0.00047)
% for i=1:1:512
%     for j=1:1:464
% medium.sound_speed(i,j)=
%     end
% end
% lb=edge(a)
% lb=bwmorph(lb,'bridge')
% imshow(lb)