clear all;
close all;
clc;

%% Parametres
% -------------------------------------------------------------------------
R = 1; % Rendement de la communication

pqt_par_trame = 1; % Nombre de paquets par trame
bit_par_pqt   = 330;% Nombre de bits par paquet
K = pqt_par_trame*bit_par_pqt; % Nombre de bits de message par trame
N = K/R; % Nombre de bits codés par trame (codée)

M = 2; % Modulation BPSK <=> 2 symboles
phi0 = 0; % Offset de phase our la BPSK

EbN0dB_min  = -2; % Minimum de EbN0
EbN0dB_max  = 10; % Maximum de EbN0
EbN0dB_step = 1;% Pas de EbN0

nbr_erreur  = 100;  % Nombre d'erreurs à observer avant de calculer un BER
nbr_bit_max = 100e6;% Nombre de bits max à simuler
ber_min     = 1e-6; % BER min

EbN0dB = EbN0dB_min:EbN0dB_step:EbN0dB_max;     % Points de EbN0 en dB à simuler
EbN0   = 10.^(EbN0dB/10);% Points de EbN0 à simuler
EsN0   = R*log2(M)*EbN0; % Points de EsN0
EsN0dB = 10*log10(EsN0); % Points de EsN0 en dB à simuler

% Initialisation des vecteurs de résultats
ber = zeros(1,length(EbN0dB));

% -------------------------------------------------------------------------
%%
figure(1)
semilogy(EbN0dB,ber,'XDataSource','EbN0dB', 'YDataSource','ber');

load("BP_6_3_4iter.mat")
for i_iter=1:4
    hold on
    semilogy(EbN0dB,ber_5_iter(i_iter,:));
end

load("non_codee.mat")
semilogy(EbN0dB,ber);

hold all
xlim([0 10])
ylim([1e-6 1])
grid on
xlabel('$\frac{E_b}{N_0}$ en dB','Interpreter', 'latex', 'FontSize',14)
ylabel('TEB','Interpreter', 'latex', 'FontSize',14)
legend('sans codage de canal', 'BP avec 1 iteration', 'BP avec 2 iterations', ...
    'BP avec 3 iterations', 'BP avec 4 iterations')
title("Performances de BP pour le code (6,3)")

