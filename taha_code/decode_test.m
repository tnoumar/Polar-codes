function Lc_x=decode_test(llr, h, nb_it)
%% init
 
Lc_x=llr; % inital Lc_x (or LLR)
[nb_par, nb_var]=size(h);
msg_c=zeros(1, nb_par); %array storing parity nodes msgs
% Lc_x=zeros(1, nb_var); %array storing variable node msgs

%% automatically dispatching msgs through the graph (for generalization)
[ii,jj,~] = find(h);
matching_mat= [];
[sorted, indexes]=sort(ii); 
matching_mat(:,2) = jj(indexes);
matching_mat(:,1)=sorted;


v2c_msgs=zeros(size(h));
c2v_msgs=zeros(size(h));
nb_input_each=groupcounts(ii);
for m=1:nb_par
    
end


%% loop
for l=1:nb_it
    %demi iteration (flooder les noeuds de parite)
    msg_c0=f_parnode([Lc_x(1), Lc_x(3)]);
    msg_c1=f_parnode([Lc_x(2), Lc_x(4), Lc_x(5)]);
    msg_c2=f_parnode([Lc_x(3), Lc_x(4), Lc_x(6)]);
    % Noeud de variables (moitie de l'iteration)
    Lc_x=[Lc_x(1)+msg_c0, Lc_x(2)+msg_c1, Lc_x(3)+msg_c0+msg_c2, Lc_x(4)+msg_c1+msg_c2, Lc_x(5)+msg_c1, Lc_x(6)+msg_c2];
end
end

