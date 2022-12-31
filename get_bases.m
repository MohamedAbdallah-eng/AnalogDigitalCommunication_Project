function [phi,coef,energy]= get_bases(Input,Ts)
    matrix_size=size(Input);
    M=matrix_size(2); %number of signals
    n=matrix_size(1); %time divisions
    Tb=Ts/n; %Tb = bit time, Ts = signal time
    phi=zeros(n,M);
    kk=zeros(M,n);
    plot_input(Input,Ts)
    S1=Input(:,1);% the first column(signal)
    g1=S1;
    sqrt_Eg1= norm(g1)*sqrt(Tb); %norm = the sqrt of the energy
    phi(:,1)=g1/sqrt_Eg1; %get phi
    kk(1,1)=sqrt_Eg1; %s11
    k = 2;
    for i=2:M
        Si=Input(:,i);%get the signals (start with S2)
        gi=Si;
        for j=1:i-1
           sij=Si'*phi(:,j)*Tb; %calculate sij( first iteration  s21, second s31 and s32 note cant get s22 or s33 or sii)
           gi=gi-sij*phi(:,j); %calculate gi
           kk(i,j)=sij;%( first iteration  s21, second s31 and s32 note cant get s22 or s33 or sii)
        end
        sqrt_Egi= norm(gi)*sqrt(Tb); %norm = the sqrt of the energy
        energy_g=sum(gi.^2)*Tb;
       
        kk(i,j+1)=sqrt_Egi; % getting the missed coeff(s22,s33,s44..............)
      
        if (energy_g == 0 || energy_g < 1e-5) 
            continue;
        end
        phi(:,k)=gi/sqrt_Egi; %calculate phi
        k = k + 1;
    end
    phis=phi(:,any(phi)); %removing zeros in phi
    no_phis = size(phis,2);
    for i=1:no_phis
        figure(2)
        subplot(no_phis,1,i);
        plotter(phis(:,i),Ts)    
        xlabel('time');
        str = sprintf('Phi%d',i);
        ylabel(str);
        axis([0 inf -inf inf]);
    end
    no_columns=size(kk,2);
    if (no_columns<3)
        kk(:,3)=0;
    end
    yy=kk(:,3);
    gg=kk(:,2);
    cond2=norm(gg);
    cond=norm(yy);
    if (cond==0 || cond<1e-5)   %Removing zeroes in kk
        coef(:,1)=kk(:,1);
        coef(:,2)=kk(:,2);
    elseif (cond2==0 || cond2<1e-5)
        coef(:,1)=kk(:,1);
        coef(:,2)=kk(:,3);
    else
        coef(:,1)=kk(:,1);
        coef(:,2)=kk(:,2);
        coef(:,3)=kk(:,3);
    end
    [nrj]=conseltiton(coef);
    energy=energy_symb(nrj);
end 


function plotter(y,Ts)
%function gets matrices and plot them
    n=length(y);
    step=1/(1000*n);
    t=0:(step*Ts):(Ts-step);
    T=length(t);
    x=ones(1,1000*n);
    for j=1:n
        x( (j-1)*(T/n) +1 : j*(T/n)) = y(j,1);
    end
    plot(t,x,'LineWidth',2)
end

function [v]=conseltiton(coef)
% Plot the conseltiton diagram of the signals 
    cond=size(coef,2);
    if(cond==2)
        v=coef(:,1);
        g=coef(:,2);
        figure(3)    
        plot(v,g,'*')
        grid on;
        title("conseltiton digram")
        xlabel("phi1")
        ylabel("phi2")
    else
        [s,~]=size(coef);
        v=coef(1,:);
        g=zeros(s,3);
        for j=2:s
            g(j,:)=coef(j,:);
            v=[v;g(j,:)];
        end
        figure(3)
        plot3(v(:,1),v(:,2),v(:,3),'*')
        title("conseltiton digram")
        grid on;
        xlabel("phi1")
        ylabel("phi2")
        zlabel("phi3")
    end
end

function energy=energy_symb(nrj)   
%Calculates the Energy of each symbol and plot it
    [M,~]=size(nrj);
    energy=zeros(1,M);
    if (M<10)
    for i=1:M  
        energy(i)=norm(nrj(i,:)).^2;
        figure(4)
        subplot(M,1,i);
        bar(i,energy(i));
        xlabel("signal ")
        ylabel("energy")
    end
    else
        for i=1:M
        energy(i)=norm(nrj(i,:)).^2;
        end
    end
end

function plot_input(Input,Ts)
matrix_size=size(Input);
M=matrix_size(2);

if (M>4)
        for i=1:M
            Si=Input(:,i);
            plotter(Si,Ts);
            hold on;
            xlabel('time');
            ylabel('Input Signals');
            axis([0 Ts -inf inf]);
        end
else
        for i=1:M
            Si=Input(:,i);
            subplot(M,1,i)
            plotter(Si,Ts);
            xlabel('time');
            str = sprintf('S%d',i);
            ylabel(str);
            axis([0 Ts -inf inf]);
        end
end
end