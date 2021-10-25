function Lc_decod = decodeur_BP2(Lc, H, Nb_iter)
% Fonction de decodage basee sur l'algorithme de propagation de croyances.

%---Entrees:
% Lc       : vecteur contenant les LLRs.
% H        : matrice de parite du code (6,3).
% Nb_iter  : le nombre d'iteration.
%---Sorties:
% Lc_decod : vecteur contenant les LLRs decodes.
%----------

        [m, n] = size(H);
        VC     = zeros(m, n); %Variable -> Check
        CV     = zeros(m, n); %Check -> Variable  
        for i=1:Nb_iter
            % Noeud de variable vers noeud de parite
            for j=1:n
                liste_noeuds_parite = find(H(:,j));
                for np=liste_noeuds_parite
                    liste_np = liste_noeuds_parite(liste_noeuds_parite~=np);
                    VC(np,j) = sum(CV(liste_np,j)) + Lc(j);
                end
            end     
            
            % Noeud de parite vers noeud de variable 
            for j=1:m
                liste_noeuds_variable = find(H(j,:));
                for nv=liste_noeuds_variable
                    liste_nv = liste_noeuds_variable(liste_noeuds_variable~=nv);
                    CV(j,nv) = 2*atanh(prod(tanh(VC(j,liste_nv)/2)));
                end
            end
        end
        Lc_decod = Lc + sum(CV)';
end