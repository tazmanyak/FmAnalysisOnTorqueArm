# FmAnalysisOnTorqueArm


##Finite Element Analysis On Torque arm in MATLAB

The main purpose of this project is to establish 2D Finite Element formulation on the torque arm – an automobile component to obtain the location and magnitude of maximum von Mises stress, and the magnitude of maximum vertical and horizontal displacements the arm experiences under the specified loading condition. It is also required that finer mesh should be satisfied so that better approximation can be achieved




My observations show that quality and the number of the mesh influence stress distribution along the part. The more elements model has, the better result there will be. It is also clear that, commercial finite element software, which is Marc and Mentant, analysis give better result than finite element modeling in MATLAB. However, my approach is almost same with commercial fem analysis. 
As a benchmark, I created 210 elements in Marc and Mentat. After submitting analysis files on software, I directly used given output file to obtain nodes coordinates and connectivity matrix. In result section of Marc and Mentat, once model is monitored with respect von Misses Stress Distribution, I did realize that what I have found in MATLAB regarding von Mises Stress is exactly same as what Marc and Mentat points out on Graph. I can safely say that MATLAB is also capable of analyzing finite element model regardless of number of elements. Only problem may be computational time once it is compared with commercial FEM products. 
Also, some recommendations can be done on experience taken with this project.
Recommendations for use of CST
1. Use in areas where strain gradients are small
2. Use in mesh transition areas (fine mesh to coarse mesh)
3. Avoid CST in critical areas of structures (e.g., stress concentrations, edges of holes, corners)
4. In general CSTs are not recommended for general analysis purposes as a very large number of these elements are required for reasonable accuracy.
