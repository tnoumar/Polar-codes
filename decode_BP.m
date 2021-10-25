function Lc_decoded= decode_BP(llr, H, nb_it)
        Lc=llr; 
        vc = zeros(size(H));
        cv = zeros(size(H));        
        for i=1:nb_it
            [nc,nv] = size(H);
            for  l=1:nv
                lnode = find(H(:,l)');
                for vertice=lnode
                    lno = lnode(lnode~=vertice);
                    vc(vertice,l) = sum(cv(lno,l)) + Lc(l);
                end
            end            
            for  j=1:nc
                lnode = find(H(j,:));
                for vertice=lnode
                    lno = lnode(lnode~=vertice);
                    cv(j,vertice) = 2*atanh ( prod( tanh( vc(j,lno)/2 ) ) );
                end
            end
        end
        Lc_decoded = Lc + sum(cv)';
end