Return to [QGIS and PostGIS Index Page](../qgis.md).

Return to [Main Index Page](../../index.md).

In this lab, I used this [model](/qgis/lab_1/model_final.png). For an outline of this model's workflow and functions, check out this previous [page](../lab_1/aa_chicago_lab.md)

With this model, I made a distance plot and direction plot of Burlington, VT rent prices. The distance plot displays how median monthly rent prices change at differnet distances from the city center and the direction plot displays monthly rental prices in terms of the direction that the region is from the city center.

The following two maps represent the direction of Burlington's census tracts from the central business district and the distance of those tracts from that point, respectively. 

### Data Sources

I downloaded my 2010 census tract shapefile for Vermont from the [Vermont Open Geodata Portal](https://geodata.vermont.gov/datasets/df13910a7c9943849d6986b703e5eafd_4). This dataset is a TIGER/Line shapefile developed by the US Census. The data as accessed from the Vermont website already includes demographic data attached onto the census tracts, but does not have median monthly rent data. 

![direction](/qgis/lab_2/burlington_cardinal.png)

![direction](/qgis/lab_2/burlington_dist.png)

The following polarplot represents the median monthly rental cost of Burlington's census tracts displayed over that tract's orientation from downtown. 

![polar](/qgis/lab_2/newplot.png)

The following scatterplot displays census tract median monthly rental cost over that tract's distance from downtown.

![scatter](/qgis/lab_2/scatter_use.png.png)

These two graphics demonstrate that there is not a strong correlation of rental cost based on direction or distance of the census tract from downtown. 

Return to [QGIS and PostGIS Index Page](../qgis.md).

Return to [Main Index Page](../../index.md).
