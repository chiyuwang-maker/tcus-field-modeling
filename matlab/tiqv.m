%  lou=stimulation.p(1:290,25)'
%  for i=1:1:511
%      ouy=stimulation.p(1+290*i:290+290*i,2)'
%      lou=[lou;ouy]
%  end
% lue=lou/max(max(lou))
imshow(lou)
lou=lou/1000000
