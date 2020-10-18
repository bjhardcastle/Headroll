tf_numerator = [1 1]'
tf_denominator = [3 2 1]' %a_n a_n-1 ... a_0

dt = 0.0001
T = 5
N = 5000
t = linspace(0,T,N)

n = size(tf_denominator,1)
m = size(tf_numerator,1)

syms z
x = sin(5*z)
X = ones(1,m)*x
for i = 2:m
    X(i) = diff(x,i-1)
end

M = eye(n-1)
M(n-1,:) = tf_denominator(1:n-1)'

bx = matlabFunction(X*tf_numerator)

function dy = vdp1(t,y)
    

