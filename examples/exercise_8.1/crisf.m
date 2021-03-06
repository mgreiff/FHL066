%% Loads and draws undeformed geometry
load('geometryC8E1.mat')

%% Sets constants
% Ieration constants 
nmax = 10;
imax = 20;
LIMIT = 1e-4;

% Material constants
E = 210e9; % [Pa]
A = 1; %    [mm^2]
v = 0.3;
t = 1; % [m,] Material thickness
ep = [E, A];

% Geometry constants
nelm = length(edof(:,1));
ndof = max(max(edof));

%% Newton iteration
% Initial iteration quantities
a = zeros(ndof,1); 
dan = zeros(ndof,1);
aold = zeros(ndof,1);

psi = 0;

% Loading pattern
P = zeros(ndof,1);
P(64) = -1;

fval = [];
uval = [];

for n = 1:nmax

    disp(['Iteration ', num2str(n)])
    
    G = zeros(ndof,1);
    
    dlambdai = 0;
    dai = zeros(ndof,1);

    for i = 1:imax

        %Convergence condition
        if norm(G) < LIMIT && i ~= 1
            disp('completed iteration')
            break
        end

        % Computes and assembles the global tangent stiffness
        Kt = zeros(ndof);
        for ii = 1:nelm
            ind = edof(ii,2:end);
            ec = [ex(ii,:);ey(ii,:)];
            ed = a(ind);
            [~, eff] = plan3gs( ec , ed );
            es = stresscal(eff, E, v);
            D = mstiff(eff, E, v);
            Ke = plan3ge( ec , t , D , ed , es );
            Kt(ind, ind) = Kt(ind, ind) + Ke;
        end

        % Computes computes pseudo displacement increments
        dag = solveq(Kt , -G , bc);
        dap = solveq(Kt , P , bc);
        
        % Finds a suitable lambda
        increment = 0.9;
        maxCount = 100;
        
        if i == 1
            if n == 1
                l = 5;
                deltalambda = l/sqrt(dap'*dap + psi.*P'*P);
            else
                s = sign(dan'*dap);
                if s == 0;
                    s = 1;
                end
                deltalambda = s*l/sqrt(dap'*dap + psi.*P'*P);
            end
        else
            count = 0;
            while count < maxCount
                count = count + 1;
                
                a1 = dap'*dap + psi.*(P'*P);
                a2 = 2.*dap'*(dai + dag) + 2.*psi.*dlambdai.*(P'*P);
                a3 = (dai + dag)'*(dai + dag) + psi.*(dlambdai.^2).*(P'*P) - l^2;

                % Solves the equation a1.*lambda^2 + a2*lambda+  a3 = 0
                lambdaSol = roots([a1, a2, a3]);
                if ~isreal(lambdaSol)
                    % TODO decrease step length and restart iteration
                    l = l.*increment;
                else
                    if lambdaSol(1) ~= lambdaSol(2)
                        % Two solutions to the equation
                        a4 = dai'*(dai + dag);
                        a5 = dai'*dap;
                        cVal = (a4 + a5.*lambdaSol)/l.^2;
                        [ ~ , index] = max(cVal);
                        deltalambda = lambdaSol(index);
                        disp('lambdaSol(1) ~= lambdaSol(2)')
                        break;
                    else
                        deltalambda = lambdaSol(1);
                        break;
                    end
                end
                if count == maxCount
                    disp('Did not converge to lambda solution, exiting loop.')
                end
            end
        end
            
        % Update displacement vector
        a = a + dag + deltalambda.*dap;
        
        % Updates lambda
        dlambdai = dlambdai + deltalambda;

        dai = dai + dag + deltalambda.*dap;
        
        % Compute internal forces
        fint = zeros(ndof,1);
        for ii = 1:nelm
            ind = edof(ii,2:end);
            ec = [ex(ii,:);ey(ii,:)];
            ed = a(ind);
            [~, eff] = plan3gs( ec , ed );
            es = stresscal(eff, E, v);
            finte = plan3gf( ec, t, ed , es );
            fint(ind) = fint(ind) + finte;
        end
 
        G = fint - dlambdai.*P;
        f = - dlambdai.*P;
    end
    
    dan = a - aold;
    aold = a;

    uval = [uval, a];
    fval = [fval, f];
end
%% Plot undeformed geometry
 if 1
    ind = [1,2,3,1];
    figure(1)
    hold on;
    for ii = 1:nelm
        defx = ex(ii,:);
        defy = ey(ii,:);
        for jj = 1:3
            plot([defx(ind(jj)) , defx(ind(jj + 1))'],...
                 [defy(ind(jj)) , defy(ind(jj + 1))'], 'b')
        end
    end
 end
%% Plot deformed geometry
 if 1
    ind = [1,2,3,1];
    figure(1)
    hold on;
    for ii = 1:nelm
        defx = ex(ii,:) + uval(edof(ii, 2:2:6),end)';
        defy = ey(ii,:) + uval(edof(ii, 3:2:7),end)';
        for jj = 1:3
            plot([defx(ind(jj)) , defx(ind(jj + 1))'],...
                 [defy(ind(jj)) , defy(ind(jj + 1))'], 'r')
        end
    end
 end