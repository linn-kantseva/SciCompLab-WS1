%[text]{"align":"center"} Lab course Scientific Computing 
%[text]{"align":"center"} Worksheet 1
%[text] completed by Group 8:
%[text]{"align":"right"} Manou Engel
%[text]{"align":"right"} Elina Kantseva
%[text]{"align":"right"} Samuele Vignoli
%[text] Disclaimer: the following live script is not supposed to run without errors and warning. The code cells are there to highlight the edited parts of the overall program. Exceptions are the cells, that display the matrices for experimental convergence.
%[text]{"align":"right"} 
%[text] Task a)
%[text] We have modified the file mchoice.m via filling in the implementation of the function predict1.
% will not run
function next = predict1(j, transm)
    global param_a param_b;
    transm % display/print transition matrix
    if isempty(param_a) || isempty(param_b) || param_a > param_b || param_a < 0 || param_b > 1
        error('parameters should satisfy 0 <= param a <= param b <= 1');
    end
    param_c = rand();
    if param_c < param_a
        hnext = mod(j, 3) + 1;
    elseif param_c < param_b
        hnext = mod(j+1, 3) + 1;
    else
        hnext = j;
    end
    next = winchoice(hnext);
end
%[text] Task b) 
%[text] Here we analyzed 3 policy functions predicting the players next move. We have ultimately decided to interpret "Deterministic" as "not dependent on randomness", and "With memory" as "dependent on transition matrix transm" as we thought, "memory" doesn't refers to j, last entry in game history of human player, as all of the three policies depend on j in some way, but rather the collective information of all previous moves, which is stored in transition matrix.  
%[text:table]{"ignoreHeader":true}
%[text] | Method \\ Property | Deterministic | With memory |
%[text] | --- | --- | --- |
%[text] | predict1 | no | no |
%[text] | predict2 | yes | yes |
%[text] | predict3 | no | yes |
%[text:table]
%[text] 
%[text] Task c)
%[text] We have performed 3 experiments to determent the convergence limit of the transition matrix transm of the human using predict2 for computer and default get\_human\_move.m for human.
%[text] The results are stored in data\_2\_2\_10.m, data\_2\_2\_100.m, and data\_2\_2\_1000.mat for 10, 100, and 1000 experiments respectively. 
% do run
data10 = load('data_2_2_10.mat'); 
data100 = load('data_2_2_100.mat'); 
data1000 = load('data_2_2_1000.mat'); 
disp(data10.transm) 
disp(data100.transm) 
disp(data1000.transm) 
%[text] which suggests the matrix transm converges to:
%[text:table]{"ignoreHeader":true}
%[text] | 0 | 1 | 0 |
%[text] | --- | --- | --- |
%[text] | 0 | 0 | 1 |
%[text] | 1 | 0 | 0 |
%[text:table]
%[text] 
%[text] Task d)
%[text] Still in the file mchoice.m , in the main function, following the example of samplem and transm implimentation we implemented samplem2 and transm2
% will not run
% --- Main function ---
function next = mchoice(ng, i, j, i_comp, j_comp)
    % machine next move
    global samplem samplem2 transm transm2 policy
    if(ng == 1)
        % initialize matrices
        [samplem,transm]   = initmchoice;
        [samplem2, transm2] = initmchoice;
        next = randi(3);
    else
        samplem  = updatesamplem(i,j,samplem);
        samplem2 = updatesamplem(i_comp,j_comp,samplem2);
        transm   = updatetransm(samplem);
        transm2 = updatetransm(samplem2);
    
        switch policy
            case 1
                next = predict1(j,transm);
            case 2
                next = predict2(j,transm);
            case 3
                next = predict3(j,transm);
            otherwise
                error('Bad policy given!')
        end
    
    end
    transm2 % print transm2 at the end of mchoice
end

%[text] We have used i\_comp and j\_comp in analogy with i, j, but for computer. For this reason we needed to add them in the variable list of the function. We have also expended the global variables by sample2 and transm2, again in analogy with previous implementation. We have printed the transm2 at the end of mchoice function. The file game.m needed modifying to:
%[text] globals were expanded by transm2
% will not run
global transm transm2 results numrounds policy gametype % here I added the transm2
%[text] In function testChoice in the instance of calling mchoice function, we have modified the call: either 
% will not run
next = mchoice(norounds,0,0,0,0); %added 2 zeros for i_comp, j_comp
%[text] for initial call,
%[text] or
% will not run
next = mchoice(norounds,history(end-1,2),history(end,2),history(end-1,1),history(end,1));   % human same change
%[text] for later calls.
%[text] Task e)
%[text] Experimentally finding the convergence limit of the transition matrix transm2 for computer using predict3 policy and default for human. 
%[text] Such data is stored again in the files data\_2\_3\_10.m, data\_2\_3\_100.m, data\_2\_3\_1000.m for 10, 100, and 1000 experiments respectively.
% do run
data10 = load('data_2_3_10.mat'); 
data100 = load('data_2_3_100.mat'); 
data1000 = load('data_2_3_1000.mat'); 
disp(data10.transm2) 
disp(data100.transm2) 
disp(data1000.transm2)
%[text] which suggests the matrix transm converges to:
%[text:table]{"ignoreHeader":true}
%[text] | 0 | 0 | 1 |
%[text] | --- | --- | --- |
%[text] | 1 | 0 | 0 |
%[text] | 0 | 1 | 0 |
%[text:table]
%[text] 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright"}
%---
