tg = tanner_graph(H); % Building the Tanner graph
plot(tg) % Display the Tanner graph

tg.to_tikz('hamming.tex'); %    Export to Tikz