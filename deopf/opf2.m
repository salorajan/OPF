 function [F1 PP vv]=opf2(x,gencost)
 global busdata linedata  Pdt
 x=abs(x);
 basemva=100;
 nn1=length(gencost(:,1));
 
        for i=1:nn1-1;
           
    if x(i)<gencost(i+1,5)
        x(i)=gencost(i+1,5);
    else
    end
    if x(i)>gencost(i+1,6)
        x(i)=gencost(i+1,6);
    else
    end

       xx=gencost(i+1,1);
       busdata(xx,7)=x(i);
    end
[Pgg P vv]=pflow(busdata,linedata);
if Pgg(1)>gencost(1,6);
    Pgg(1)=gencost(1,6);
else
end
TL=basemva*sum(P);
if min(vv)<0.95
    lam2=100;
else lam2=0;
end
lam=100*abs(sum(Pgg)-TL-Pdt)+lam2;
a1=gencost(:,2);
b1=gencost(:,3);
c1=gencost(:,4);
 F1=(Pgg.*Pgg)*a1+Pgg*b1+sum(c1)+lam;
  VV=vv;
    PP=Pgg;
  end
    