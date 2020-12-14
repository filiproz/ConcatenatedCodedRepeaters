%Test ErrorLikelihood

z1 = 0;
z2 = 0.1;
z3 = -0.2;
z4 = 0.4;

sig = 0.2;

a = ErrorLikelihood(z1,sig);
b = ErrorLikelihood(z2,sig);
c = ErrorLikelihood(z3,sig);
d = ErrorLikelihood(z4,sig);


%% Test 1: Error magnitures
assert(a<b)
assert(b<c)
assert(c<d)