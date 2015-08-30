function y = Assemble(K,k,i,j,m)

referance= [2*i-1 2*i 2*j-1 2*j 2*m-1 2*m ];
K(referance, referance)=K(referance, referance)+k;
y=K;
end