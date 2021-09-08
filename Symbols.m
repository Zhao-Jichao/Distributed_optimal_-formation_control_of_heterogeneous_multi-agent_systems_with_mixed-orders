% 所有符号表示，用来验证思路的正确性
% Author: Zhao-Jichao
% Date: 2021-09-07
clear
clc

%% System Description
MG = 3;     % Leader UGVs 的数量
NG = 10;    % 总的 UGVs 的数量
MA = 2;     % Leader UAVs 的数量
NA = 6;     % 总的 UAVs 的数量
global L
L = [1 -1  0    0  0  0  0  0  0  0    0  0    0  0  0  0   % 1 leader1
    -1  4 -1    0  0  0  0  0  0  0   -1 -1    0  0  0  0   % 2 leader2
     0 -1  1    0  0  0  0  0  0  0    0  0    0  0  0  0   % 3 leader3
    -1  0  0    2 -1  0  0  0  0  0    0  0    0  0  0  0   % 4
    -1  0  0   -1  2  0  0  0  0  0    0  0    0  0  0  0   % 5
     0 -1  0    0  0  2 -1  0  0  0    0  0    0  0  0  0   % 6
     0  0  0    0  0 -1  2 -1  0  0    0  0    0  0  0  0   % 7
     0 -1  0    0  0  0 -1  2  0  0    0  0    0  0  0  0   % 8
     0  0 -1    0  0  0  0  0  2 -1    0  0    0  0  0  0   % 9
     0  0 -1    0  0  0  0  0 -1  2    0  0    0  0  0  0   % 10
     0 -1  0    0  0  0  0  0  0  0    2 -1    0  0  0  0   % 11 leader1
     0 -1  0    0  0  0  0  0  0  0   -1  2    0  0  0  0   % 12 leader1
     0  0  0    0  0  0  0  0  0  0   -1  0    2 -1  0  0   % 13
     0  0  0    0  0  0  0  0  0  0   -1  0   -1  2  0  0   % 14
     0  0  0    0  0  0  0  0  0  0    0 -1    0  0  2 -1   % 15
     0  0  0    0  0  0  0  0  0  0    0 -1    0  0 -1  2]; % 16
LGlGl = L(1:MG,          1:MG);  LGlGf = L(1:MG,          MG+1:NG);  LGlAl = L(1:MG,          NG+1:NG+MA);  LGlAf = L(1:MG,          NG+MA+1:NG+NA);
LGfGl = L(MG+1:NG,       1:MG);  LGfGf = L(MG+1:NG,       MG+1:NG);  LGfAl = L(MG+1:NG,       NG+1:NG+MA);  LGfAf = L(MG+1:NG,       NG+MA+1:NG+NA);
LAlGl = L(NG+1:NG+MA,    1:MG);  LAlGf = L(NG+1:NG+MA,    MG+1:NG);  LAlAl = L(NG+1:NG+MA,    NG+1:NG+MA);  LAlAf = L(NG+1:NG+MA,    NG+MA+1:NG+NA);
LAfGl = L(NG+MA+1:NG+NA, 1:MG);  LAfGf = L(NG+MA+1:NG+NA, MG+1:NG);  LAfAl = L(NG+MA+1:NG+NA, NG+1:NG+MA);  LAfAf = L(NG+MA+1:NG+NA, NG+MA+1:NG+NA);

% d means symbol delta
syms dGlPx1  dGlPy1  dGlVx1  dGlVy1  real
syms dGlPx2  dGlPy2  dGlVx2  dGlVy2  real
syms dGlPx3  dGlPy3  dGlVx3  dGlVy3  real
syms dGfPx4  dGfPy4  dGfVx4  dGfVy4  real
syms dGfPx5  dGfPy5  dGfVx5  dGfVy5  real
syms dGfPx6  dGfPy6  dGfVx6  dGfVy6  real
syms dGfPx7  dGfPy7  dGfVx7  dGfVy7  real
syms dGfPx8  dGfPy8  dGfVx8  dGfVy8  real
syms dGfPx9  dGfPy9  dGfVx9  dGfVy9  real
syms dGfPx10 dGfPy10 dGfVx10 dGfVy10 real
syms dAlPx11 dAlPy11 dAlPz11 dAlVx11 dAlVy11 dAlVz11 dAlJx11 dAlJy11 dAlJz11 dAlSx11 dAlSy11 dAlSz11  real
syms dAlPx12 dAlPy12 dAlPz12 dAlVx12 dAlVy12 dAlVz12 dAlJx12 dAlJy12 dAlJz12 dAlSx12 dAlSy12 dAlSz12  real
syms dAfPx13 dAfPy13 dAfPz13 dAfVx13 dAfVy13 dAfVz13 dAfJx13 dAfJy13 dAfJz13 dAfSx13 dAfSy13 dAfSz13  real
syms dAfPx14 dAfPy14 dAfPz14 dAfVx14 dAfVy14 dAfVz14 dAfJx14 dAfJy14 dAfJz14 dAfSx14 dAfSy14 dAfSz14  real
syms dAfPx15 dAfPy15 dAfPz15 dAfVx15 dAfVy15 dAfVz15 dAfJx15 dAfJy15 dAfJz15 dAfSx15 dAfSy15 dAfSz15  real
syms dAfPx16 dAfPy16 dAfPz16 dAfVx16 dAfVy16 dAfVz16 dAfJx16 dAfJy16 dAfJz16 dAfSx16 dAfSy16 dAfSz16  real

dGl1 = [dGlPx1  dGlPy1  dGlVx1  dGlVy1]';
dGl2 = [dGlPx2  dGlPy2  dGlVx2  dGlVy2]';
dGl3 = [dGlPx3  dGlPy3  dGlVx3  dGlVy3]';
dGf4 = [dGfPx4  dGfPy4  dGfVx4  dGfVy4]';
dGf5 = [dGfPx5  dGfPy5  dGfVx5  dGfVy5]';
dGf6 = [dGfPx6  dGfPy6  dGfVx6  dGfVy6]';
dGf7 = [dGfPx7  dGfPy7  dGfVx7  dGfVy7]';
dGf8 = [dGfPx8  dGfPy8  dGfVx8  dGfVy8]';
dGf9 = [dGfPx9  dGfPy9  dGfVx9  dGfVy9]';
dGf10= [dGfPx10 dGfPy10 dGfVx10 dGfVy10]';
dAl11= [dAlPx11 dAlPy11 dAlPz11 dAlVx11 dAlVy11 dAlVz11 dAlJx11 dAlJy11 dAlJz11 dAlSx11 dAlSy11 dAlSz11]';
dAl12= [dAlPx12 dAlPy12 dAlPz12 dAlVx12 dAlVy12 dAlVz12 dAlJx12 dAlJy12 dAlJz12 dAlSx12 dAlSy12 dAlSz12]';
dAf13= [dAfPx13 dAfPy13 dAfPz13 dAfVx13 dAfVy13 dAfVz13 dAfJx13 dAfJy13 dAfJz13 dAfSx13 dAfSy13 dAfSz13]';
dAf14= [dAfPx14 dAfPy14 dAfPz14 dAfVx14 dAfVy14 dAfVz14 dAfJx14 dAfJy14 dAfJz14 dAfSx14 dAfSy14 dAfSz14]';
dAf15= [dAfPx15 dAfPy15 dAfPz15 dAfVx15 dAfVy15 dAfVz15 dAfJx15 dAfJy15 dAfJz15 dAfSx15 dAfSy15 dAfSz15]';
dAf16= [dAfPx16 dAfPy16 dAfPz16 dAfVx16 dAfVy16 dAfVz16 dAfJx16 dAfJy16 dAfJz16 dAfSx16 dAfSy16 dAfSz16]';

dGl = [dGl1'  dGl2'  dGl3']';
dGf = [dGf4'  dGf5'  dGf6'  dGf7'  dGf8'  dGf9'  dGf10']';
dAl = [dAl11' dAl12']';
dAf = [dAf13' dAf14' dAf15' dAf16']';

d   = [dGl'  dGf'  dAl'  dAf']';

% System matrixes
aG = kron([0  1;  0 0], eye(2));
bG = kron([0;  1], eye(2));
AG = kron(eye(NG), aG);
BG = kron(eye(NG), bG);
aA = kron([0 1 0 0;  0 0 1 0;  0 0 0 1;  0 0 0 0], eye(3));
bA = kron([0;  0;  0;  1], eye(3));
AA = kron(eye(NA), aA);
BA = kron(eye(NA), bA);
A = blkdiag(AG, AA);
B = blkdiag(BG, BA);

% Optimal matrixes
syms kg1 kg2 kg3 kg4 real
KG = [kg1   0  kg2   0
        0 kg3    0 kg4];
syms ka1 ka2 ka3 ka4 ka5 ka6 ka7 ka8 ka9 ka10 ka11 ka12 real
KA = [ka1  0  0  ka2  0  0  ka3  0  0  ka4  0  0
      0  ka5  0  0  ka6  0  0  ka7  0  0  ka8  0
      0  0  ka9  0  0  ka10 0  0  ka11 0  0  ka12];

mGA = [1 0 0;  0 1 0];
MGA = [mGA zeros(2,3) zeros(2,3) zeros(2,3)
       zeros(2,3) mGA zeros(2,3) zeros(2,3)];
mAG = [1 0
       0 1
       0 0];
MAG = [mAG  zeros(3,2)
       zeros(3,2)  mAG
       zeros(3,2)  zeros(3,2)
       zeros(3,2)  zeros(3,2)];

% Control input
UGl = ...
kron(eye(MG),KG) * kron(-LGlGl, eye(4)) * dGl +...
kron(eye(MG),KG) * kron(-LGlAl, eye(4)) * kron(eye(MA), MGA) * dAl;

UGf = ...
kron(eye(NG-MG),KG) * kron(-LGfGl, eye(4)) * dGl +...
kron(eye(NG-MG),KG) * kron(-LGfGf, eye(4)) * dGf;

UAl = ...
kron(eye(MA),KA) * kron(-LAlGl, eye(12)) * kron(eye(MG), MAG) * dGl +...
kron(eye(MA),KA) * kron(-LAlAl, eye(12)) * dAl;

UAf = ...
kron(eye(NA-MA),KA) * kron(-LAfAl, eye(12)) * dAl +...
kron(eye(NA-MA),KA) * kron(-LAfAf, eye(12)) * dAf;

Ud = [UGl'  UGf'  UAl'  UAf']';

dotd = A * d + B * Ud;







