# First QGIS Model
In this week's lab, I created a model to calculate distance, degree of orientation, and direction of a city's census tracts from a single point. I then used this model in the example of Chicago. Download the model [here](https://github.com/Ian8VT/Ian8VT.github.io/blob/master/QGIS/Lab%201%20and%202/distance_cardinaldirection.model3).

## Workflow of Model

![flow](https://github.com/Ian8VT/Ian8VT.github.io/blob/master/QGIS/Lab%201/model_final.png)

To perform this model, you will need two different input layers: City Center and Input Features.

The City Center input can be either a point or multipolygon feature. The Input Features must be have a multipolygon geometry, such as a census tracts layer. The layer that you input as the City Center is what you designate as that central point to calculate distance, degrees, and direction of the multipolygons of the Input Features layer from.

Don't worry about what coordinate system to upload your layers as! The step titled Distance/ Direction SQL automatically transforms whichever input coordinate system(s) you have into a reasonable one for the function at hand. For the measurement of direction from the City Center to Input Feautures, the calculation is performed in EPSG: 4326. As for the calculation of degrees between these two layers, the function is transformed into EPSG: 3395, which is more robust for measuring degrees. 

The final outcome has three new columns in the attribute table not found in either origianl input: distance calculation; degree of orientation measurement; interpretation of degrees into cardinal direction. In the parameter section of the model, you will be able to add a prefix to appear in these three columns. The default is 'cbd', short for Center Business District. After the model, if you used census tracts as your Input Feautures, this layer will likely have census demographic data attached to it as well. With these three output columns, you will be able to examine a number of different spatial distributions of demographic concentrations as reported by the census. 

I originally attempted to use the Field Calculator function in the model builder to perform the model's main functions, but upon revisions I decided to rely upon SQL for the whole model after repeated issues with Field Calculator's ability to execute a transform function.


![direction](https://github.com/Ian8VT/Ian8VT.github.io/blob/master/QGIS/Lab%201/Chicago_Cardinal.png)

![distance](https://github.com/Ian8VT/Ian8VT.github.io/blob/master/QGIS/Lab%201/Chicago_Distance.png)

With this model, I made a [distance plot](https://github.com/Ian8VT/Ian8VT.github.io/blob/master/QGIS/Lab%201%20and%202/scatterplot2.html) and [direction plot](https://github.com/Ian8VT/Ian8VT.github.io/blob/master/QGIS/Lab%201%20and%202/polarplot2.html) of Burlington, VT rent prices. The distance plot displays how median monthly rent prices change at differnet distances from the city center and the direction plot displays monthly rental prices in terms of the direction that the region is from the city center. 

[Return to Main Page](index.md)

[Return to QGIS Index](https://github.com/Ian8VT/Ian8VT.github.io/blob/master/QGIS/QGIS%20Index.md)
