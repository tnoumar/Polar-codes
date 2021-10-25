% plot
figure(1)
semilogy(EbN0dB,[ber63_BP, zeros(1,3)]);
hold all
xlim([0 10])
ylim([1e-6 1])
grid on
xlabel('$\frac{E_b}{N_0}$ en dB','Interpreter', 'latex', 'FontSize',14)
ylabel('TEB','Interpreter', 'latex', 'FontSize',14)
semilogy(EbN0dB,[ber63_minsum, zeros(1,3)]);
