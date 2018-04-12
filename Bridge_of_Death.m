scale = .2235;
t = (linspace(0,3.2/scale,100)');
r = [0.3960*cos(2.65*(scale*t+1.4)), -0.99*sin(scale*t+1.4)];
plot(r(:,1), r(:,2)); axis equal
v = diff(r)./diff(t);
That = v ./ sqrt(sum(v.^2,2));
N = diff(That)./diff(t(1: end - 1,:));
That(:,3) = 0;
N(:,3) = 0;
w = cross(That(1:end-1,:), N);
mag_v = sqrt(sum(v.^2,2));

d = 0.2495;
Vr = (mag_v(1:end-1,:) + (w(:,3)*(d/2)));
Vl = (mag_v(1:end-1,:) - (w(:,3)*(d/2)));

pub = rospublisher('/raw_vel');
sub_bump = rossubscriber('/bump');
msg = rosmessage(pub);

for i = 1:size(t)-2
    msg.Data = [Vl(i), Vr(i)];
    send(pub, msg);
    pause(0.1);
    bumpMessage = receive(sub_bump);
    if any(bumpMessage.Data)
        msg.Data = [0.0, 0.0];
        send(pub, msg);
        pause(0.1);
        break;
     end
end
msg.Data = [0,0];
send(pub,msg);

% pub = rospublisher('/raw_vel');
% sub_bump = rossubscriber('/bump');
% msg = rosmessage(pub);
% msg.Data = [0,0];
% send(pub,msg)
% 
% bumpMessage = receive(sub_bump);
% if any(bumpMessage.Data)
%     msg.Data = [0.0, 0.0];
%     send(pub, msg);
%     pause(0.1);
% end