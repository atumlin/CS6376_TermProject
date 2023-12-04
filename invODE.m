function dx = invODE(t,x)

%**************************************************************%
%This functions is to be used with the invGUI.m and invFUN.m   %
%files.  It contains the necessary information to run the non- %
%simulation of the inverted pendulum example.                  %                
%                                                              %
%Copyright (C) 1997 by the Regents of the University of        %
%Michigan.                                                     %
%**************************************************************%

%Retrieve the value of the K matrix.
   Khandle = findobj('Tag','Kframe');
   K = get(Khandle,'Value');

%Retrieve the value of Nbar.     
   Nbarhandle = findobj('Tag','Nbarframe');
   Nbar = get(Nbarhandle,'Value');

%Retrieve the step input value.
   stephandle = findobj('Tag','stepslider');
   stepval=get(stephandle,'Value');
   
  M = 0.5;
  m = 0.2;
  b = 0.1;
  i = 0.006;
  g = 9.8;
  l = 0.3;

  s1=M+m;
  s2=m*l;
  s3=b;
  s4=i+m*l^2;
  s5=m*g*l;
  s6=s2*s2/s4;
  s7=s5*s2/s4;
  s8=s2*s2/s1;
  s9=s2*s3/s1;
  s10=s2/s1;  
F=-K*[x(1) x(2) x(3) x(4)]'+Nbar*stepval;
dx=zeros(4,1);
dx(1)=x(2);
dx(2)=(-F + s2*sin(x(3))*x(2)^2 + s7*sin(x(3))*cos(x(3)) - s3*x(2)) / (s1-s6*cos(x(3))*cos(x(3)));
dx(3)=x(4);
dx(4)=(-s5*sin(x(3)) - s10*(-F)*cos(x(3)) + s8*x(4)*sin(x(3))*cos(x(3)) - s9*x(2)*cos(x(3))) / (s4-s8*cos(x(3))*cos(x(3)));
    