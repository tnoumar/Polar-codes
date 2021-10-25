function Lc_decod = decodeur_BP(Lc, m, n, Nb_iter, cel_noeuds_parite, cel_noeuds_variable)
% Fonction de decodage basee sur l'algorithme de propagation de croyances.
% Version Optimisee

%---Entrees:
% Lc       : vecteur contenant les LLRs.
% m*n      : taille de la matrice de parite du code (6,3).
% Nb_iter  : le nombre d'iteration.
% cel_noeuds_parite   : Une cellule contenant les noeuds de parite.
% cel_noeuds_variable : Une cellule contenant les noeuds de variable.
%---Sorties:
% Lc_decod : vecteur contenant les LLRs decodes.
%----------
        VC     = zeros(m, n); %Variable -> Check
        CV     = zeros(m, n); %Check -> Variable  
        
        for i=1:Nb_iter
            % Noeud de variable vers noeud de parite
            for j=1:n
                liste_noeuds_parite = cel_noeuds_parite{1,j};
                for np=liste_noeuds_parite
                    liste_np = liste_noeuds_parite(liste_noeuds_parite~=np);
                    VC(np,j) = sum(CV(liste_np,j)) + Lc(j);
                end
            end     
            
            % Noeud de parite vers noeud de variable 
            for j=1:m
                liste_noeuds_variable = cel_noeuds_variable{1,j};
                for nv=liste_noeuds_variable
                    liste_nv = liste_noeuds_variable(liste_noeuds_variable~=nv);
                    CV(j,nv) = 2*atanh(prod(tanh(VC(j,liste_nv)/2)));
                end
            end
        end
        Lc_decod = Lc + sum(CV)';
end