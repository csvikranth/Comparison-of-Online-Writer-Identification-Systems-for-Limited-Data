%used for noise removal
function [new_points] = noise_rem2(points)
new_points=[];
if size(points,1)~=0;
th=400;
w=20;
for i=points(1,4):points(end,4)
   str_pts=points(points(:,4)==i,:);
   s1=size(str_pts,1);
   new_str_pts=[];
   for j=1:s1
       i1=max(1,j-w);
       i2=min(s1,j+w);
       nbr=str_pts(i1:i2,1:2);
       s2=size(nbr,1);
       dist=zeros(s2,1);
       for k=1:s2
           dist(k)=norm(nbr(k,:)-str_pts(j,1:2));
       end
       if sum(dist<th)>s2/2
           new_str_pts=[new_str_pts;str_pts(j,:)];
       end
   end
   new_points=[new_points;new_str_pts];   
end
end
end

