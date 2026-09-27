function delta_X_j = ComputeUpdate(r,J,mu)
   delta_X_j = -inv((J'*J+mu*eye(size(J,2))))*J'*r;
end