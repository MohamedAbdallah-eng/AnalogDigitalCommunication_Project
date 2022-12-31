%Part(1)
clc
clear
close all
Input=input('Input signals as matrix form: ');
Ts=input('Input The time of the signals as an integer: ');
[phi,coef,energy]=get_bases(Input,Ts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%test case one [1 1 0 1;0 1 1 1;0 0 1 1]
%%%test case two [2 -4 3;0 -4 3;0 0 3]