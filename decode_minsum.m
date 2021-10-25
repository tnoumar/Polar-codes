function Lc_decoded= decode_minsum(llr, H, nb_it)
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
                    %vc(j,lno) is equivalent to Lx-c

                    cv(j,vertice) = prod(sign(vc(j,lno)))*min(abs(vc(j,lno)));
                end
            end
        end
        Lc_decoded = Lc + sum(cv)';
end