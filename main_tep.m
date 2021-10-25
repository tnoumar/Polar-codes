clear
clc
close all

%% Parametres
% -------------------------------------------------------------------------
addpath('src')
simulation_name = 'non_codee';

R = 1; % Rendement de la communication


[H] = alist2sparse('alist/DEBUG_6_3.alist');
[h, G] = ldpc_h2g(H);
H=full(h);

nb_its=1:5;
pqt_par_trame = 110; % Nombre de paquets par trame
bit_par_pqt   = 3;% Nombre de bits par paquet
K = pqt_par_trame*bit_par_pqt; % Nombre de bits de message par trame
N = K/R; % Nombre de bits cod�s par trame (cod�e)

M = 2; % Modulation BPSK <=> 2 symboles
phi0 = 0; % Offset de phase our la BPSK

EbN0dB_min  = -2; % Minimum de EbN0
EbN0dB_max  = 10; % Maximum de EbN0
EbN0dB_step = 1;% Pas de EbN0

nbr_erreur  = 100;  % Nombre d'erreurs à observer avant de calculer un BER
nbr_bit_max = 5e6;% Nombre de bits max à simuler
ber_min     = 1e-9; % BER min

EbN0dB = EbN0dB_min:EbN0dB_step:EbN0dB_max;     % Points de EbN0 en dB � simuler
EbN0   = 10.^(EbN0dB/10);% Points de EbN0 � simuler
EsN0   = R*log2(M)*EbN0; % Points de EsN0
EsN0dB = 10*log10(EsN0); % Points de EsN0 en dB � simuler

% -------------------------------------------------------------------------

%% Construction du modulateur
mod_psk = comm.PSKModulator(...
    'ModulationOrder', M, ... % BPSK
    'PhaseOffset'    , phi0, ...
    'SymbolMapping'  , 'Gray',...
    'BitInput'       , true);

%% Construction du demodulateur
demod_psk = comm.PSKDemodulator(...
    'ModulationOrder', M, ...
    'PhaseOffset'    , phi0, ...
    'SymbolMapping'  , 'Gray',...
    'BitOutput'      , true,...
    'DecisionMethod' , 'Log-likelihood ratio');

%% Construction du canal AWGN
awgn_channel = comm.AWGNChannel(...
    'NoiseMethod', 'Signal to noise ratio (Es/No)',...
    'EsNo',EsN0dB(1),...
    'SignalPower',1);

%% Construction de l'objet �valuant le TEB
stat_erreur = comm.ErrorRate(); % Calcul du nombre d'erreur et du BER

%% Initialisation des vecteurs de r�sultats
ber = zeros(1,length(EbN0dB));
Pe = qfunc(sqrt(2*EbN0));

%% Pr�paration de l'affichage
figure(1)
h_ber = semilogy(EbN0dB,ber,'XDataSource','EbN0dB', 'YDataSource','ber');
hold all
ylim([1e-6 1])
grid on
xlabel('$\frac{E_b}{N_0}$ en dB','Interpreter', 'latex', 'FontSize',14)
ylabel('TEB','Interpreter', 'latex', 'FontSize',14)

%% Pr�paration de l'affichage en console
msg_format = '|   %7.2f  |   %9d   |  %9d | %2.2e |  %8.2f kO/s |   %8.2f kO/s |   %8.2f s |  %d |\n';

fprintf(      '|------------|---------------|------------|----------|----------------|-----------------|--------------|--------------|\n')
msg_header =  '|  Eb/N0 dB  |    Bit nbr    |  Bit err   |   TEB    |    Debit Tx    |     Debit Rx    | Tps restant  |    Trame     |\n';
fprintf(msg_header);
fprintf(      '|------------|---------------|------------|----------|----------------|-----------------|--------------|--------------|\n')


%% Simulation
for nb_it=nb_its
%     nb_trame=0;
% for packet=1:pqt_par_trame
%     nb_trame=nb_trame+1;
for i_snr = 1:length(EbN0dB)
    reverseStr = ''; % Pour affichage en console
    awgn_channel.EsNo = EsN0dB(i_snr);% Mise a jour du EbN0 pour le canal
    
    stat_erreur.reset; % reset du compteur d'erreur
    err_stat    = [0 0 0]; % vecteur r�sultat de stat_erreur
    
    demod_psk.Variance = awgn_channel.Variance;
    
    n_frame = 0;
    % for nframe=1:pqt_par_trame

    T_rx = 0;
    T_tx = 0;
    general_tic = tic;

    while (err_stat(2) < nbr_erreur && err_stat(3) < nbr_bit_max)
        n_frame = n_frame + 1;
        %% Emetteur
        tx_tic = tic;                 % Mesure du d�bit d'encodage
        b    = randi([0,1],bit_par_pqt,1);    % G�n�ration du message al�atoire
        b_encoded=mod(b'*G,2); % Encodage du message 
        x      = step(mod_psk,  b_encoded'); % Modulation BPSK
        T_tx   = T_tx+toc(tx_tic);    % Mesure du d�bit d'encodage
        
        %% Canal
        y     = step(awgn_channel,x); % Ajout d'un bruit gaussien
        
        %% Recepteur
        rx_tic = tic;                  % Mesure du d�bit de d�codage
        Lc      = step(demod_psk,y);   % D�modulation (retourne des LLRs)
        Lc_decoded=decode_minsum(Lc, h, nb_it);
        rec_b = double(Lc_decoded(end-bit_par_pqt+1:end) < 0); % D�cision
        T_rx    = T_rx + toc(rx_tic);  % Mesure du d�bit de d�codage
        
        err_stat   = step(stat_erreur, b, rec_b); % Comptage des erreurs binaires
        
        %% Affichage du r�sultat
        if mod(n_frame,pqt_par_trame) == 1
            msg = sprintf(msg_format,...
                EbN0dB(i_snr),         ... % EbN0 en dB
                err_stat(3),           ... % Nombre de bits envoy�s
                err_stat(2),           ... % Nombre d'erreurs observ�es
                err_stat(1),           ... % BER
                err_stat(3)/8/T_tx/1e3,... % D�bit d'encodage
                err_stat(3)/8/T_rx/1e3,... % D�bit de d�codage
                toc(general_tic)*(nbr_erreur - min(err_stat(2),nbr_erreur))/(min(err_stat(2),nbr_erreur)), ...% Temps restant
                n_frame); %nombre de trames
            fprintf(reverseStr);
            msg_sz =  fprintf(msg);
            reverseStr = repmat(sprintf('\b'), 1, msg_sz);
        end
    end
    
    msg = sprintf(msg_format,...
        EbN0dB(i_snr),         ... % EbN0 en dB
        err_stat(3),           ... % Nombre de bits envoy�s
        err_stat(2),           ... % Nombre d'erreurs observ�es
        err_stat(1),           ... % BER
        err_stat(3)/8/T_tx/1e3,... % D�bit d'encodage
        err_stat(3)/8/T_rx/1e3,... % D�bit de d�codage
        0,0); % Temps restant
    fprintf(reverseStr);
    msg_sz =  fprintf(msg);
    reverseStr = repmat(sprintf('\b'), 1, msg_sz);
    
    ber(i_snr) = err_stat(1);
    refreshdata(h_ber);
    drawnow limitrate
    
    if err_stat(1) < ber_min
        break
    end
end %snr loop 
% end
fprintf('|------------|---------------|------------|----------|----------------|-----------------|--------------|--------------|\n')

%%
figure(1)
semilogy(EbN0dB,ber);
hold all
xlim([0 10])
ylim([1e-6 1])
grid on
xlabel('$\frac{E_b}{N_0}$ en dB','Interpreter', 'latex', 'FontSize',14)
ylabel('TEB','Interpreter', 'latex', 'FontSize',14)

end %iteration loop
hold off
legend(ber_legend);
save(simulation_name,'EbN0dB','ber')

