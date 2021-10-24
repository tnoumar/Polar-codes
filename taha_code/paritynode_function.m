function node_result=f_parnode(Array)
        
        %suppose length of array is different than 0
        assert(isempty(Array)==false);
        product=1;
        for i=1:length(Array)
            product=product*tanh(Array(i)/2);
        end
        node_result=2*atanh(product);
end   