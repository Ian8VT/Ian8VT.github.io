# First QGIS Model
In this week's lab, I created a [model](modeluntransformed.py.model3) to calculate distance and direction of a city's census tracts from a single point. Check out the help section once you download to read some helpful information!

With this model, I made a [scatterplot](scatterplot_script.txt) and [polarplot](polarplot.html) of Burlington, VT rent prices. The scatterplot displays how median monthly rent prices change at differnet distances from the city center and the polarplot displays monthly rental prices in terms of the direction that the region is from the city center. Note that the display key on the polarplot would not update, but each dot on the graphic is the regional median rental price of that's region given degree of orientation from the city center. Distance is not a factor in the polarplot graphic. 

### Some help

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

Similarly, when I attempted to increase the robustness of the direction component of my model with a transform function, I had difficulties. Without the transform, the model works correctly and produces the degree that the centroids of the polygons are from the city center, which then get simplified into cardinal directions in the field calculator after direction.

degrees(azimuth( make_point(  @Mean_coordinate_s__OUTPUT_maxx , @Mean_coordinate_s__OUTPUT_maxy ), centroid($geometry)))

However, when I include a transform function into the calculator, all results become 'null'. What's the problem?

degrees(
azimuth(
transform(make_point(@Mean_coordinate_s_OUTPUT_maxx, @Mean_coordinate_s__OUTPUT_maxy), layer_property(@citycenter, 'crs'), 'EPSG:54004'),
transform(centroid($geometry),layer_property(@inputfeautres, 'crs'),'EPSG:54004'))
)

Thanks!

[Return to Main Page](index.md)
