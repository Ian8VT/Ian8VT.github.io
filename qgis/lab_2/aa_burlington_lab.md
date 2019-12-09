Return to [QGIS and PostGIS Index Page](../qgis.md).

Return to [Main Index Page](../../index.md).

In this lab, I used this [model](/qgis/lab_1/model_final.png). For an outline of this model's workflow and functions, check out this previous [page](../lab_1/aa_chicago_lab.md)

With this model, I made a distance plot and direction plot of Burlington, VT rent prices. The distance plot displays how median monthly rent prices change at differnet distances from the city center and the direction plot displays monthly rental prices in terms of the direction that the region is from the city center.

The following two maps represent the direction of Burlington's census tracts from the central business district and the distance of those tracts from that point, respectively. 

### Data Sources

I downloaded my 2010 census tract shapefile for Vermont from the [Vermont Open Geodata Portal](https://geodata.vermont.gov/datasets/df13910a7c9943849d6986b703e5eafd_4). This dataset is a TIGER/Line shapefile developed by the US Census. The data as accessed from the Vermont website already includes demographic data attached onto the census tracts, but does not have median monthly rent data. Currently cannot locate the source of my rent information, but it is contained within a file which only considers the median monthly rent of census tracts within the Burlington urban area. I relied upon [Google Maps](https://www.google.com/maps) to determine my city center location. 

To download my data sources: [Census Tracts](/qgis/lab_2/VT_2010_Census_Tract_Boundaries_and_Statistics.zip); [Rent Data](/qgis/lab_2/Rent_Data)

For this lab, I used [QGIS](https://www.qgis.org/en/site/) to run the model and prepare the data prior to model. After the model, I used the Data Plotly plugin in QGIS to develop a scatterplot and polarplot. 

### Steps Before Model

In order to use my model, I prepared my data to only consider the census tracts that consist of the Burlington urban area, attached the tract rent data to that layer, and created a new layer which represents the city center. First, I joined the rental data to the census tracts. Each dataset had a join column corresponding to the census tract that I used to facilitate the join. Then, in the census tract table I selected all of the tracts that contain the new rent data and extracted a new layer. This created a layer of just the census tracts of the Burlington urban area with attached rent information, which I used as one of the two model inputs. As for the second input, the downtown layer, I chose to consider Church St as the central business district of the city. I then typed "Church St Burlington, VT" into Google Maps and then copied the coordinates into an Excel file that I saved as a csv. In QGIS, I selected Layer -> Add Layer -> Add Delimited Text Layer and then selected my csv file and defined the x and y attributes and projection type, which in the end won't matter since the model transforms the inputs into a set projection type. This point is good enough to act as the city center input in the model, but I chose to select the census tract the point coincided with to be my city center so I could display the tract as I did in the maps below. To do this, I simply selected the tract then extracted selected attributes as a new layer. I then plugged my layers into the model.

![direction](/qgis/lab_2/burlington_cardinal.png)

![direction](/qgis/lab_2/burlington_dist.png)

The following polarplot represents the median monthly rental cost of Burlington's census tracts displayed over that tract's orientation from downtown. 

![polar](/qgis/lab_2/newplot.png)

The following scatterplot displays census tract median monthly rental cost over that tract's distance from downtown.

![scatter](/qgis/lab_2/scatter_use.png.png)

These two graphics demonstrate that there is not a strong correlation of rental cost based on direction or distance of the census tract from downtown. 

Return to [QGIS and PostGIS Index Page](../qgis.md).

Return to [Main Index Page](../../index.md).
