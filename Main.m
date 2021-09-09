% 所有符号表示，用来验证思路的正确性
% Author: Zhao-Jichao
% Date: 2021-09-08
clear
clc

%% System Description
MG = 3;     % Leader UGVs 的数量
NG = 10;    % 总的 UGVs 的数量
MA = 2;     % Leader UAVs 的数量
NA = 6;     % 总的 UAVs 的数量
global L
L = [2 -1  0    0  0  0  0  0  0  0    0  0    0  0  0  0   % 1 leader1
    -1  5 -1    0  0  0  0  0  0  0   -1 -1    0  0  0  0   % 2 leader2
     0 -1  2    0  0  0  0  0  0  0    0  0    0  0  0  0   % 3 leader3
    -1  0  0    2 -1  0  0  0  0  0    0  0    0  0  0  0   % 4
    -1  0  0   -1  2  0  0  0  0  0    0  0    0  0  0  0   % 5
     0 -1  0    0  0  2 -1  0  0  0    0  0    0  0  0  0   % 6
     0  0  0    0  0 -1  2 -1  0  0    0  0    0  0  0  0   % 7
     0 -1  0    0  0  0 -1  2  0  0    0  0    0  0  0  0   % 8
     0  0 -1    0  0  0  0  0  2 -1    0  0    0  0  0  0   % 9
     0  0 -1    0  0  0  0  0 -1  2    0  0    0  0  0  0   % 10
     0 -1  0    0  0  0  0  0  0  0    3 -1    0  0  0  0   % 11 leader1
     0 -1  0    0  0  0  0  0  0  0   -1  3    0  0  0  0   % 12 leader1
     0  0  0    0  0  0  0  0  0  0   -1  0    2 -1  0  0   % 13
     0  0  0    0  0  0  0  0  0  0   -1  0   -1  2  0  0   % 14
     0  0  0    0  0  0  0  0  0  0    0 -1    0  0  2 -1   % 15
     0  0  0    0  0  0  0  0  0  0    0 -1    0  0 -1  2]; % 16
LGlGl = L(1:MG,          1:MG);  LGlGf = L(1:MG,          MG+1:NG);  LGlAl = L(1:MG,          NG+1:NG+MA);  LGlAf = L(1:MG,          NG+MA+1:NG+NA);
LGfGl = L(MG+1:NG,       1:MG);  LGfGf = L(MG+1:NG,       MG+1:NG);  LGfAl = L(MG+1:NG,       NG+1:NG+MA);  LGfAf = L(MG+1:NG,       NG+MA+1:NG+NA);
LAlGl = L(NG+1:NG+MA,    1:MG);  LAlGf = L(NG+1:NG+MA,    MG+1:NG);  LAlAl = L(NG+1:NG+MA,    NG+1:NG+MA);  LAlAf = L(NG+1:NG+MA,    NG+MA+1:NG+NA);
LAfGl = L(NG+MA+1:NG+NA, 1:MG);  LAfGf = L(NG+MA+1:NG+NA, MG+1:NG);  LAfAl = L(NG+MA+1:NG+NA, NG+1:NG+MA);  LAfAf = L(NG+MA+1:NG+NA, NG+MA+1:NG+NA);

% Systems states
x1  = [0  0  0  0]';                            h1  = [-20    0  0  10]';                       Uh1  = [ 0  0]';
x2  = [0  0  0  0]';                            h2  = [  0    0  0  10]';                       Uh2  = [ 0  0]';
x3  = [0  0  0  0]';                            h3  = [ 20    0  0  10]';                       Uh3  = [ 0  0]';
x4  = [0  0  0  0]';                            h4  = [-25  -10  0  10]';                       Uh4  = [ 0  0]';
x5  = [0  0  0  0]';                            h5  = [-15  -10  0  10]';                       Uh5  = [ 0  0]';
x6  = [0  0  0  0]';                            h6  = [ -5  -10  0  10]';                       Uh6  = [ 0  0]';
x7  = [0  0  0  0]';                            h7  = [  0  -20  0  10]';                       Uh7  = [ 0  0]';
x8  = [0  0  0  0]';                            h8  = [  5  -10  0  10]';                       Uh8  = [ 0  0]';
x9  = [0  0  0  0]';                            h9  = [ 15  -10  0  10]';                       Uh9  = [ 0  0]';
x10 = [0  0  0  0]';                            h10 = [ 25  -10  0  10]';                       Uh10 = [ 0  0]';
x11 = [0  0  0  0  0  0  0  0  0  0  0  0]';    h11 = [-15   10  30  0 10  0  0  0  0  0  0  0]';    Uh11 = [ 0  0  0]';
x12 = [0  0  0  0  0  0  0  0  0  0  0  0]';    h12 = [ 15   10  30  0 10  0  0  0  0  0  0  0]';    Uh12 = [ 0  0  0]';
x13 = [0  0  0  0  0  0  0  0  0  0  0  0]';    h13 = [-20    0  30  0 10  0  0  0  0  0  0  0]';    Uh13 = [ 0  0  0]';
x14 = [0  0  0  0  0  0  0  0  0  0  0  0]';    h14 = [-10    0  30  0 10  0  0  0  0  0  0  0]';    Uh14 = [ 0  0  0]';
x15 = [0  0  0  0  0  0  0  0  0  0  0  0]';    h15 = [ 10    0  30  0 10  0  0  0  0  0  0  0]';    Uh15 = [ 0  0  0]';
x16 = [0  0  0  0  0  0  0  0  0  0  0  0]';    h16 = [ 20    0  30  0 10  0  0  0  0  0  0  0]';    Uh16 = [ 0  0  0]';

X = [x1'  x2'  x3'  x4'  x5'  x6'  x7'  x8'  x9'  x10'  x11'  x12'  x13'  x14'  x15'  x16']';
X = rand(112,1) * 10;
H = [h1'  h2'  h3'  h4'  h5'  h6'  h7'  h8'  h9'  h10'  h11'  h12'  h13'  h14'  h15'  h16']';
UH =[Uh1' Uh2' Uh3' Uh4' Uh5' Uh6' Uh7' Uh8' Uh9' Uh10' Uh11' Uh12' Uh13' Uh14' Uh15' Uh16']';
% dH= [dh1' dh2' dh3' dh4' dh5' dh6' dh7' dh8' dh9' dh10' dh11' dh12' dh13' dh14' dh15' dh16'];
d = X - H;

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

QG = eye(4);
RG = 1;
[PG, lG, gG] = care(aG, bG, QG, RG);
KG = -1/(RG) * bG' * PG;

QA = eye(12);
RA = 1;
[PA, lA, gA] = care(aA, bA, QA, RA);
KA = -1/(RA) * bA' * PA;

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

% Iterations
dT = 0.02;
t = 0;
for i=1:999
    
    d(:,i) = X(:,i)-H(:,i);
    dGl = d( 1:12,  i);
    dGf = d(13:40,  i);
    dAl = d(41:64,  i);
    dAf = d(65:112, i);
    
    UGl = ...
    kron(eye(MG),KG) * kron(LGlGl, eye(4)) * dGl +...
    kron(eye(MG),KG) * kron(LGlAl, eye(4)) * kron(eye(MA), MGA) * dAl;

    UGf = ...
    kron(eye(NG-MG),KG) * kron(LGfGl, eye(4)) * dGl +...
    kron(eye(NG-MG),KG) * kron(LGfGf, eye(4)) * dGf;

    UAl = ...
    kron(eye(MA),KA) * kron(LAlGl, eye(12)) * kron(eye(MG), MAG) * dGl +...
    kron(eye(MA),KA) * kron(LAlAl, eye(12)) * dAl;

    UAf = ...
    kron(eye(NA-MA),KA) * kron(LAfAl, eye(12)) * dAl +...
    kron(eye(NA-MA),KA) * kron(LAfAf, eye(12)) * dAf;

    Ud = [UGl'  UGf'  UAl'  UAf']';
    
    H(:,i+1) = H(:,i) + dT * (A*H(:,i)+B*UH);       % UH is constant
    d(:,i+1) = d(:,i) + dT * (A*d(:,i)+B*Ud);
    X(:,i+1) = X(:,i) + dT * (A*X(:,i)+B*(Ud+UH));
    t(:,i+1) = t(:,i) + dT;
end


%% Draw results
% figure(1)
% for i=1:20:(size(X,2))
%     subplot(1,2,1)
%     scatter3(H(1,i), H(2,i), 0, 150,'p', 'r'); hold on;
%     scatter3(H(5,i), H(6,i), 0, 150,'p', 'g'); 
%     scatter3(H(9,i), H(10,i),0, 150,'p', 'b'); 
%     scatter3(H(13,i),H(14,i),0, 'r'); 
%     scatter3(H(17,i),H(18,i),0, 'r'); 
%     scatter3(H(21,i),H(22,i),0, 'g'); 
%     scatter3(H(25,i),H(26,i),0, 'g'); 
%     scatter3(H(29,i),H(30,i),0, 'g'); 
%     scatter3(H(33,i),H(34,i),0, 'b'); 
%     scatter3(H(37,i),H(38,i),0, 'b'); 
%     scatter3(H(41,i),H(42,i),H(43,i), 150,'p', 'r'); 
%     scatter3(H(53,i),H(54,i),H(55,i), 150,'p', 'g'); 
%     scatter3(H(65,i),H(66,i),H(67,i),   'r'); 
%     scatter3(H(77,i),H(78,i),H(79,i),   'r'); 
%     scatter3(H(89,i),H(90,i),H(91,i),   'g'); 
%     scatter3(H(101,i),H(102,i),H(103,i),'g'); 
%     grid on; box on;
%     axis equal; 
%     axis([-100, 100, -50,500, 0,50]);
% 
%     subplot(1,2,2)
%     scatter3(X(1,i), X(2,i), 0, 150,'p', 'r'); hold on;
%     scatter3(X(5,i), X(6,i), 0, 150,'p', 'g'); 
%     scatter3(X(9,i), X(10,i),0, 150,'p', 'b'); 
%     scatter3(X(13,i),X(14,i),0, 'r'); 
%     scatter3(X(17,i),X(18,i),0, 'r'); 
%     scatter3(X(21,i),X(22,i),0, 'g'); 
%     scatter3(X(25,i),X(26,i),0, 'g'); 
%     scatter3(X(29,i),X(30,i),0, 'g'); 
%     scatter3(X(33,i),X(34,i),0, 'b'); 
%     scatter3(X(37,i),X(38,i),0, 'b'); 
%     scatter3(X(41,i),X(42,i),X(43,i), 150,'p', 'r'); 
%     scatter3(X(53,i),X(54,i),X(55,i), 150,'p', 'g'); 
%     scatter3(X(65,i),X(66,i),X(67,i),   'r'); 
%     scatter3(X(77,i),X(78,i),X(79,i),   'r'); 
%     scatter3(X(89,i),X(90,i),X(91,i),   'g'); 
%     scatter3(X(101,i),X(102,i),X(103,i),'g'); 
%     grid on; box on;
%     axis equal; 
%     axis([-100, 100, -50,500, 0,50]);
%     disp(i)
%     pause(0.1)
%     if (i<980)
%         clf
%     end

%     subplot(1,2,1)
%     scatter(H(1,i), H(2,i),  150,'p', 'r'); hold on;
%     scatter(H(5,i), H(6,i),  150,'p', 'g'); 
%     scatter(H(9,i), H(10,i), 150,'p', 'b'); 
%     scatter(H(13,i),H(14,i), 'r'); 
%     scatter(H(17,i),H(18,i), 'r'); 
%     scatter(H(21,i),H(22,i), 'g'); 
%     scatter(H(25,i),H(26,i), 'g'); 
%     scatter(H(29,i),H(30,i), 'g'); 
%     scatter(H(33,i),H(34,i), 'b'); 
%     scatter(H(37,i),H(38,i), 'b'); 
%     scatter(H(41,i),H(42,i), 150,'p', 'r'); 
%     scatter(H(53,i),H(54,i), 150,'p', 'g'); 
%     scatter(H(65,i),H(66,i),   'r'); 
%     scatter(H(77,i),H(78,i),   'r'); 
%     scatter(H(89,i),H(90,i),   'g'); 
%     scatter(H(101,i),H(102,i), 'g'); 
%     grid on; box on;
%     axis([-100, 100, -50,500, 0,50]);
% 
%     subplot(1,2,2)
%     scatter(X(1,i), X(2,i),  150,'p', 'r'); hold on;
%     scatter(X(5,i), X(6,i),  150,'p', 'g'); 
%     scatter(X(9,i), X(10,i), 150,'p', 'b'); 
%     scatter(X(13,i),X(14,i), 'r'); 
%     scatter(X(17,i),X(18,i), 'r'); 
%     scatter(X(21,i),X(22,i), 'g'); 
%     scatter(X(25,i),X(26,i), 'g'); 
%     scatter(X(29,i),X(30,i), 'g'); 
%     scatter(X(33,i),X(34,i), 'b'); 
%     scatter(X(37,i),X(38,i), 'b'); 
%     scatter(X(41,i),X(42,i), 150,'p', 'r'); 
%     scatter(X(53,i),X(54,i), 150,'p', 'g'); 
%     scatter(X(65,i),X(66,i),   'r'); 
%     scatter(X(77,i),X(78,i),   'r'); 
%     scatter(X(89,i),X(90,i),   'g'); 
%     scatter(X(101,i),X(102,i), 'g'); 
%     grid on; box on;
%     axis([-100, 100, -50,500, 0,50]);
%     disp(i)
%     pause(0.1)
%     if (i<980)
%         clf
%     end
% end

% for i=1:5
% figure(i)
% subplot(4,3,1);  plot(H(4*i-3,:),     'linewidth',1.5); title("H"+i+" PX"); grid on;
% subplot(4,3,2);  plot(X(4*i-3,:),     'linewidth',1.5); title("X"+i+" PX"); grid on;
% subplot(4,3,3);  plot(d(4*i-3,:), 'r','linewidth',1.5); title("d"+i+" PX"); grid on;
% subplot(4,3,4);  plot(H(4*i-2,:),     'linewidth',1.5); title("H"+i+" PY"); grid on;
% subplot(4,3,5);  plot(X(4*i-2,:),     'linewidth',1.5); title("X"+i+" PY"); grid on;
% subplot(4,3,6);  plot(d(4*i-2,:), 'r','linewidth',1.5); title("d"+i+" PY"); grid on;
% subplot(4,3,7);  plot(H(4*i-1,:),     'linewidth',1.5); title("H"+i+" VX"); grid on;
% subplot(4,3,8);  plot(X(4*i-1,:),     'linewidth',1.5); title("X"+i+" VX"); grid on;
% subplot(4,3,9);  plot(d(4*i-1,:), 'r','linewidth',1.5); title("d"+i+" VX"); grid on;
% subplot(4,3,10); plot(H(4*i-0,:),     'linewidth',1.5); title("H"+i+" VY"); grid on;
% subplot(4,3,11); plot(X(4*i-0,:),     'linewidth',1.5); title("X"+i+" VY"); grid on;
% subplot(4,3,12); plot(d(4*i-0,:), 'r','linewidth',1.5); title("d"+i+" VY"); grid on;
% end

figure(6)
subplot(2,2,1)
plot(t,d(4,:), t,d(8,:), t,d(12,:), 'linewidth',1.5)
legend('l1', 'l2', 'l3');
subplot(2,2,2)
plot(t,d(16,:), t,d(20,:), t,d(24,:), t,d(28,:), t,d(32,:), t,d(36,:), t,d(40,:), 'linewidth',1.5)
legend('l4', 'l5', 'l6', 'l7', 'l8', 'l9', 'l10');








