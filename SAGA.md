# Mapping Water Flow of Mount Kilimanjaro

In this lab, we used the software SAGA to derive a terrain map from a digital elevation model of the Mount Kilimanjaro region to determine water flow. For my data, I accessed the Aster Digital Elevation Model version 3 from the NASA site [EarthData](https://earthdata.nasa.gov/).

The data I downloaded contained two separate zones as defined by Aster. Each zone map contains a color gradient which represents elevation. As you can see, when I attached the two zones together into a single map, there is a clear boundary between the two zones. This is because the highest point of reference within each zone is different, and as such the same color in each zone is associated with a different elevation value. -FIGURE 1-

To ammend this discrepancy, I performed a mosaic function to standardize the two zonal maps as a single map. Now, the values of each gradient of color is consistent throughout the map. For this function, I also set the geographic parameters to a more contained area focused on the mountain, that way further procedures only focus on our area of concern and don't spend excess amounts of time computing data beyond Mountain Kilimanjaro. With this map, I reprojected the coordinate system to Transverse Mercator (UTM) which is a more accurate projection for linear measurements.  -FIGURE 2-

