num = 50000;
u2 = zeros(num,1);
u4 = zeros(num,1);

for i = 2:num
    u2(i) = max(0,min(u4(i-1)+randn/10,11));
    u4(i) = max(0,min(u4(i-1)+randn/10,11));
end


attack_start0 = floor(rand*5000);
attack_length = floor(rand*5000);
last_attack = 0;
no_attack = attack_length+ floor(rand*5000);

detect_delay = attack_length*0.1;