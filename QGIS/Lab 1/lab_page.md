# First QGIS Model
In this week's lab, I created a model to calculate distance, degree of orientation, and direction of a city's census tracts from a single point. I then used this model in the example of Chicago. Download the model [here](https://github.com/Ian8VT/Ian8VT.github.io/blob/master/QGIS/Lab%201%20and%202/distance_cardinaldirection.model3).

## Workflow of Model

![flow](https://github.com/Ian8VT/Ian8VT.github.io/blob/master/QGIS/Lab%201/model_final.png)

To perform this model, you will need two different inputs: City Center and Input Feature.

The City Center input can be either a point or multipolygon feature. The Input Features must be have a multipolygon geometry, such as a census tracts layer. The layer that you input as the City Center is what you designate as that central point to calculate distance, degrees, and direction of the multipolygons from. 


![direction](https://github.com/Ian8VT/Ian8VT.github.io/blob/master/QGIS/Lab%201/Chicago_Cardinal.png)

![distance](https://github.com/Ian8VT/Ian8VT.github.io/blob/master/QGIS/Lab%201/Chicago_Distance.png)

With this model, I made a [distance plot](https://github.com/Ian8VT/Ian8VT.github.io/blob/master/QGIS/Lab%201%20and%202/scatterplot2.html) and [direction plot](https://github.com/Ian8VT/Ian8VT.github.io/blob/master/QGIS/Lab%201%20and%202/polarplot2.html) of Burlington, VT rent prices. The distance plot displays how median monthly rent prices change at differnet distances from the city center and the direction plot displays monthly rental prices in terms of the direction that the region is from the city center. 

[Return to Main Page](index.md)

[Return to QGIS Index](https://github.com/Ian8VT/Ian8VT.github.io/blob/master/QGIS/QGIS%20Index.md)
