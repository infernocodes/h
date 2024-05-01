
a= [ 2 3; 3 7; 4 5]  % input matrix
b=[ 8; 9; 15]

m= size(a,1)  % calculating size of a
n= size(a,2)

A= [2 3 1 0 0 8; 3 7 0 1 0 9; 4 5 0 0 1 15]  % Construct the basic matrix
cost= [3 5 0 0 0 0]  % cost= co-efficients of objective function

bv= n+1:size(A,2)-1  % basic variables
abc= 1
while (abc==1)
bv_cost= cost(bv) %cost= co-efficient of basic variables
zj= bv_cost*A   
zjcj= zj-cost
zc= zjcj(1,1:end-1) % storing zj-cj into zc except zj-cj of solution
if any(zc<0)  % stopping criteria | analysing any -ve zj-cj
[m1,ev]= min(zjcj) % ev= entering variable
pc= A(:,ev) % pivot column
b1= A(:,end)
ratio= b1./pc
inf=ratio(find(pc<0)) % inf= infinity | we have defined the infinity here
[m12, lr]= min(ratio) % lr= leaving row
bv(lr)=ev
pe= A(lr,ev) %pivot element
A(lr,:)= A(lr,:)/pe
for i=1:size(A,1)
    if i~=lr
        A(i,:)= A(i,:)- A(lr,:)*A(i,ev)
    end
end
zjcj(1,:)= zjcj(1,:)- A(lr,:)*zjcj(1,ev)
else 
    disp('optimal solution')
    abc= 2
end
end
