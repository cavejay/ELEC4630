
%%region prop to sort object
 STATS = regionprops(E,'MajorAxisLength', 'MinorAxisLength', ...
     'Area','Extrema', 'Centroid');
       
%get largest value
 shapes = size(STATS);

 sml = 10000;
 pos = 1;
 for i = 1 :shapes(1);
     
     area =STATS(i).Area;
     plot(STATS(i).Centroid(1), STATS(i).Centroid(2), 'b*');
	 
	 %plot centroid of current blob and print area to console
     area
	 pause;
	 
     if  (area < sml) && (area > 200)
         sml = STATS(i).Area;
         pos = i;

     end
 end
        
		%plot largest blobs centroid
		plot(STATS(pos).Centroid(1), STATS(pos).Centroid(2), 'g*');             
		pause;