function sigmav_e = vonMises( sigmax,sigmay,sigmaxy )

   sigmav_e = sqrt((sigmax^2 - sigmax * sigmay + sigmay^2 + 3*sigmaxy));
end

