% Test ReminderModTest

modval = 4;
a = 2;
b = 0;
c = 3;

%% Test 1
assert(ReminderMod(a,modval) == -2)
assert(ReminderMod(b,modval) == 0)
assert(ReminderMod(c,modval) == -1)