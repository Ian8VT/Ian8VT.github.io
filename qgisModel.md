## First QGIS Model
In this week's lab, I created a [model](Distance_Degrees_CBD.model3) to calculate distance and direction of a city's census tracts from a single point. 

With this model, I made a [scatterplot](scatterplot_script.txt) and [polarplot](polarplot_upload.txt) of Burlington, VT rent prices. The scatterplot displays how median monthly rent prices change at differnet distances from the city center and the polarplot displays monthly rental prices in terms of the direction that the region is from the city center. Note that the display key on the polarplot would not update, but each dot on the graphic is the regional median rental price of that's region given degree of orientation from the city center. Distance is not a factor in the polarplot graphic. 

# Some help

I'm new to Q, and have some hiccups while doing the work. Sometimes, the hiccups are more of a steady stream of unnavigable ruts that can be a bit exhausting, but thankfully there's a robust community out there to help noobs like myself make sense of the simple mistakes we make when we first acquaint ourselves with the software.

Overall, I have had difficutly with the transform function. The goal is to make my model perform accurately irregardless of which coordinate system (or competing systems) the input feautures are. Though, after too many hours of trying to problem solve the issue, my model still will not produce answers when I include transform functions. The objective is to include transform for both the distance and direction field calculator of my model.

For distance, I attempted to inset an SQL query to calculate distance which included the transform function. In these examples, input1 is a point (city center in these cases) and input 2 are polygons (census tracts). This expression, without a transform, works correctly: 

SELECT*, 
st_distance(centroid(geometry), (SELECT geometry from input1)) as cbdDist 
FROM input2

However, when I include transform, the function fails to execute. What is wrong with the layout? 

SELECT*, 
st_distance(centroid(st_transform(geometry,4326)), (st_transform(SELECT geometry from input1,4326))) as cbdDist 
FROM input2

I have tried with transform preceding centroid, without a 'st' precursor on transform and distance, and with 
astext prior to each transform. I do not understand how merely adding in a transform prior to the geometry creates
an issue that is unexecutable. 

[Return to Main Page](index.md)
