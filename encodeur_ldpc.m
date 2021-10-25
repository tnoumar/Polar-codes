function msg_encode = encodeur_ldpc(msg, G)
% encodeur_ldpc : Fonction d'encodage.

%---Entrees:
% msg : un vecteur ayant pour taille le nombre de ligne de G.
% G   : la matrices génartrice du code (6,3).
%---Sorties:
% msg_code : message encode. C'est un vecteur ligne de taille valant 
% le nombre de colonne de G.
%----------

    [Nl_m, Nc_m] = size(msg);
    [Nl_G, Nc_G] = size(G);

    if (Nl_m == Nl_G)
        msg = msg';
    end
    
    msg_encode = mod((msg*G),2);
    msg_encode = msg_encode';
end