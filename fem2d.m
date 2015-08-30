
clc; clear;
dbstop if naninf % Debugging
%Units [mm,N,MPa]
t=10; %thickness
E=200000; %Young Modulus
NU=0.3;    %Poisson's Ratio
%-------------------------------------------------------------------------
% %Importing Nodes and Elements from .mat file.
load('DATA\nodes_210.mat');
load('DATA\elements_210.mat');
%-------------------------------------------------------------------------
% TABLE FORMAT, TO SEE WHETHER OUR DATA IS OKAY
%-------------------------------------------------------------------------
display('Node#          x               y ');
display('-----------------------------------');
for i=1:size(nodes)
    fprintf('%5d %15.5f %12.5f\n',i,nodes(i,1),nodes(i,2));
end

fprintf('\n\n');
display('Element#      i        j          m ');
display('--------------------------------------');

time = cputime; % CPU TIME Calculation before start analysis % 
%-------------------------------------------------------------------------
for i=1:size(elements);
    fprintf('%5d %9d %9d %9d\n',i,elements(i,1),elements(i,2),elements(i,3));
end

for i=1:size(elements) % Approximating and storing all elements
    % Picking nodes (x,y) coordinates with respect to connectivity matrix 
    node1=elements(i,1); node2=elements(i,2); node3=elements(i,3); 
    xi=nodes(node1,1); yi=nodes(node1,2); 
    xj=nodes(node2,1); yj=nodes(node2,2); 
    xm=nodes(node3,1); ym=nodes(node3,2);
    k{i}=Stiffness(E,NU,t,xi,yi,xj,yj,xm,ym); %Storing Element's stiffness matrix
end
%-------------------------------------------------------------------------
% Initiating K matrix which is Global K[2*size(nodes)x2*size(nodes)]
% Setting with zeros first to initiate.
K=zeros(2*length(nodes),2*length(nodes));

%-------------------------------------------------------------------------
%Assembying K matrix by inserting k{i}s
%-------------------------------------------------------------------------
for i=1:size(elements)
    node1=elements(i,1); node2=elements(i,2);node3=elements(i,3);
    K=Assemble(K,k{i},node1,node2,node3);
end



K_GLOBAL=K;
%-------------------------------------------------------------------------

% Condensed K Matrix, Removing Us and Vs with respect to hexagonal areas
% left side hole's nodes.
% As we are going to make some operation on K global, just stora it before hand.

%-------------------------------------------------------------------------
% Applying Boundry Conditions
%-------------------------------------------------------------------------
fixedboundry=189:1:212; % Fixed Locations around left hole
rows2remove=fixedboundry;
cols2remove=fixedboundry;
K(rows2remove,:)=[];
K(:,cols2remove)=[];
%K is now condensed

%F is condensed
F=zeros(2*length(nodes),1);
F(9)=2800;
F(18)=5000;
F(rows2remove,:)=[];
%-------------------------------------------------------------------------
%Displacement Vector 
%-------------------------------------------------------------------------
U=K\F;

%-------------------------------------------------------------------------
% Automatically inserting zeros to condensed U matrix to make it global.
% Converting matrix to cell to operate with no problem
for i=1:size(U)
    U_CELL{i,1}=U(i);
end

% Making U condensed Global, adding zeros(0) to removed location.
for i=1:length(rows2remove)
        
    U_CELL(rows2remove(i)+1:end+1,:) = U_CELL(rows2remove(i):end,:);
    U_CELL(rows2remove(i),:) = {0};
end
%Converting cell to matrix
U_GLOBAL=cell2mat(U_CELL); 
%
%-------------------------------------------------------------------------
%Force Vectors
%-------------------------------------------------------------------------
F=K_GLOBAL*U_GLOBAL;

%-------------------------------------------------------------------------
%In order to calculate Stresses on each element, we should first arrange
%element stiffness for each element
%-------------------------------------------------------------------------
%Element's Stiffness
%-------------------------------------------------------------------------
for i=1:size(elements)
    node1=elements(i,1);
    node2=elements(i,2);
    node3=elements(i,3); 
   
    %Picking elements stifness which is u_e = [6x1] with respect to 3 nodes
    %in each element makes 6 raws.
    u{i}=[U_GLOBAL(2*node1-1)
          U_GLOBAL(2*node1)
          U_GLOBAL(2*node2-1)
          U_GLOBAL(2*node2)
          U_GLOBAL(2*node3-1)
          U_GLOBAL(2*node3)];
end
% %-------------------------------------------------------------------------
% % STRESS CALCULATIONS
% %-------------------------------------------------------------------------
for i=1:size(elements)
    node1=elements(i,1); node2=elements(i,2); node3=elements(i,3);
    xi=nodes(node1,1); yi=nodes(node1,2); 
    xj=nodes(node2,1); yj=nodes(node2,2); 
    xm=nodes(node3,1); ym=nodes(node3,2);
    %S_e , stress of ith element with respect to its ith displacement
    %vector u_e
    S{i,1}=Stresses(E,NU,xi,yi,xj,yj,xm,ym,u{i});
end
%-------------------------------------------------------------------------
%Converting Cell to Matrix to get the maximum stress
 S_GLOBAL = cell2mat(S);
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
% von Mises Elemental Stress Calculation
%-------------------------------------------------------------------------
for i=1:size(elements)
       s_temp = S{i,1}; % Selecting first 3 stress of each element
       sigmax=s_temp(1,1);  sigmay=s_temp(2,1); sigmaxy=s_temp(3,1);
       sigmaVon_Global{i,1}=vonMises( sigmax,sigmay,sigmaxy);
      %break;   
%     
end
% Converting SigmaVon_Global cell to matrix form
sigmaVon_Global=cell2mat(sigmaVon_Global);

% Finding Maximum Stress and its location 
[maxval_vonmis, maxloc_vonmis] = max(sigmaVon_Global(:)) % donot need to add ";" , since we want to see result on command prompt.
% Maxval gives maximum von Mises stress and maxLoc gives the location.

%-------------------------------------------------------------------------
% Finding maximum displacement in x and y direction
%-------------------------------------------------------------------------
for i=1:size(U_GLOBAL)
    if mod(i,2) == 0
        UY{i,1}=U_GLOBAL(i);
    else
        UX{i,1}=U_GLOBAL(i);
    end
end
UY=cell2mat(UY);
[maxval_u_y , maxlocy] = max(UY(:))
UX=cell2mat(UX);
[maxval_u_x , maxlocx] = max(UX(:))
%-------------------------------------------------------------------------
e = cputime-time;
% Total CPU TIME when process is finished
fprintf('Computation Time : %f second',e); % 