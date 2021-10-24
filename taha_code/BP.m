function [dec_msg, check]=BP(in_msg, Lc)

% softmax

softmax= @(x,y) max(x,y) + log(1+exp(-abs(x-y)));

% softmax(1,-1)

% min-sum

minsum=@(x,y) sign(x)*sign(y)*min(abs(x),abs(y));

% minsum(1,-1)

%% define an iteration (Flooding)

% suppose we have the LLR

%%


end


