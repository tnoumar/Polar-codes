close all

load 6_3.mat
[nb_its, ~]=size(BER);
% figure 1 is for BER plotting

figure(1)
h_ber = semilogy(EbN0dB,fer,'XDataSource','EbN0dB', 'YDataSource','ber');
hold all
ylim([1e-6 1])
grid on
xlabel('$\frac{E_b}{N_0}$ en dB','Interpreter', 'latex', 'FontSize',14)
ylabel('TEB','Interpreter', 'latex', 'FontSize',14)

figure(1)
 
for i=1:nb_its
hold all
semilogx(EbN0dB,BER(i,:));
end
hold off
xlim([-2 10])
ylim([1e-6 1])
grid on
xlabel('$\frac{E_b}{N_0}$ en dB','Interpreter', 'latex', 'FontSize',14)
ylabel('BER','Interpreter', 'latex', 'FontSize',14)


%%


% figure 2 is for PER plotting
figure(2)
hold on 
for i=1:length(EbN0dB)
semilogy(EbN0dB,PER(i,:));
end
hold off
xlim([-2 10])
ylim([1e-6 1])
grid on
xlabel('$\frac{E_b}{N_0}$ en dB','Interpreter', 'latex', 'FontSize',14)
ylabel('PER','Interpreter', 'latex', 'FontSize',14)


%%


% figure 3 is for FER plotting
figure(3)

hold on 
for i=1:length(EbN0dB)
semilogy(EbN0dB,FER(i,:));
end
hold off
xlim([-2 10])
ylim([1e-6 1])
grid on
xlabel('$\frac{E_b}{N_0}$ en dB','Interpreter', 'latex', 'FontSize',14)
ylabel('FER','Interpreter', 'latex', 'FontSize',14)

%%

figure(4)
