function Me = plan3gm(ec, t, rho)
    A = det([ones(3,1) ec'])./2;
    M = diag(2*ones(6,1)) + ...
        diag(1*ones(4,1),2) + ...
        diag(1*ones(4,1),-2) + ...
        diag(1*ones(2,1),4) + ...
        diag(1*ones(2,1),-4);
    Me = rho.*t.*A.*M./12;
end