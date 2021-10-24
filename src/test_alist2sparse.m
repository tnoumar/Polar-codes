clear 
close all
clc
addpath('alist')


[H] = alist2sparse('../alistf/DEBUG_6_3.alist');
[h, g] = ldpc_h2g(H)