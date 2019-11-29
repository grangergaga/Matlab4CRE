%-------------------------------------------------------------------------%
%        ___  ___      _   _       _       ___ _____ ______ _____         |
%        |  \/  |     | | | |     | |     /   /  __ \| ___ \  ___|        |
%        | .  . | __ _| |_| | __ _| |__  / /| | /  \/| |_/ / |__          |
%        | |\/| |/ _` | __| |/ _` | '_ \/ /_| | |    |    /|  __|         |
%        | |  | | (_| | |_| | (_| | |_) \___  | \__/\| |\ \| |___         |
%        \_|  |_/\__,_|\__|_|\__,_|_.__/    |_/\____/\_| \_\____/         |
%                                                                         |
%                                                                         |
%   Author: Alberto Cuoci <alberto.cuoci@polimi.it>                       |
%   CRECK Modeling Group <http://creckmodeling.chem.polimi.it>            |
%   Department of Chemistry, Materials and Chemical Engineering           |
%   Politecnico di Milano                                                 |
%   P.zza Leonardo da Vinci 32, 20133 Milano                              |
%                                                                         |
%-------------------------------------------------------------------------|
%                                                                         |
%   This file is part of Matlab4CRE framework.                            |
%                                                                         |
%   License                                                               |
%                                                                         |
%   Copyright(C) 2019 Alberto Cuoci                                       |
%   Matlab4CRE is free software: you can redistribute it and/or modify    |
%   it under the terms of the GNU General Public License as published by  |
%   the Free Software Foundation, either version 3 of the License, or     |
%   (at your option) any later version.                                   |
%                                                                         |
%   Matlab4CRE is distributed in the hope that it will be useful,         |
%   but WITHOUT ANY WARRANTY; without even the implied warranty of        |
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         |
%   GNU General Public License for more details.                          |
%                                                                         |
%   You should have received a copy of the GNU General Public License     |
%   along with Matlab4CRE. If not, see <http://www.gnu.org/licenses/>.    |
%                                                                         |
%-------------------------------------------------------------------------%
close all; clear variables;

%% Experimental data
nExp = 18;
PCO  = [ 1 1.8 4.08 1   1   1 2   2   2 1 1.8 4.08 3   3   3 1 1.8 4.08 ]';
PH2  = [ 1 1   1    0.1 0.5 4 0.1 0.5 4 2 2   2    0.1 0.5 4 3 3   3    ]';
rCH4 = [ 0.0072; 0.0129; 0.0292;  0.0049; 0.0073; 0.0053; 0.0098; ...
         0.0146; 0.0106; 0.0064; 0.0115;  0.0260; 0.0147; 0.0219; ...
         0.0159; 0.0058; 0.0104; 0.0235;];

     
%% Plot of raw data
figure; title('Experimental data');
scatter3(PCO, PH2, rCH4);
xlabel('P_{CO} [atm]'); ylabel('P_{H2} [atm]'); 
zlabel('r [mol/kg/min]');
     

%% Linear regression analysis
% Yexp = a0 + a1*x1 + a2*x2
% Yexp = ln(r), a0 = ln(k), a1 = n, X = [1, ln(PCO0), ln(PH20)]
Yexp = log(rCH4);
lnPCO0 = log(PCO);
lnPH20 = log(PH2);
X = [ ones(nExp,1) lnPCO0 lnPH20 ];

% Linear regression
% (X'*X)a = X'*Yexp
a = (X'*X)\(X'*Yexp);

% Recover original parameters
k = exp(a(1));
nCO = a(2);
nH2 = a(3);

% Statistics (linear model)
Ymod = X*a;
SSres = (Yexp-Ymod)'*(Yexp-Ymod);
SStot = (Yexp-mean(Yexp))'*(Yexp-mean(Yexp));
R2 = 1 - SSres/SStot;

% Print on the screen 
fprintf('Kinetic constant:  %e \n', k);
fprintf('Reaction order CO: %f \n', nCO);
fprintf('Reaction order H2: %f \n', nH2);
fprintf('R2 coefficient:    %f \n', R2);

% Plot linearized experimental data
figure; title('Linearized experimental data');
scatter3(lnPCO0, lnPH20, Yexp);
xlabel('ln(P_{CO})'); xlabel('ln(P_{H2})'); 
zlabel('ln(r)');
