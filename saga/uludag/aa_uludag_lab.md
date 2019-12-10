# Measuring Uncerntainty
## A Comparison of ASTER and SRTM Digital Elevation Models

Return to [SAGA Index Page](../saga_index.md).

Return to [Main Index Page](../../index.md).

### Introduction

After an introduction into the anlyses of Digital Elevation Models in this previous [lab](../kilimanjaro/aa_kilimanjaro.md), I sought to contrast the differences which result from two differnet DEM data sources. In this lab, I performed two hydrology analysis batch scripts of the region around Mount Uludag, Turkey. For each of these batch scripts, the steps of analysis were exactly the same. The only difference between the two scripts is that the sources of the initial elevation input were different. I conducted one batch script with ASTER elevation data as the initial elevation input and a second script with SRTM data, each of which are satelittes which develop elevation models of the Earth's surface. After the completion of the script, I analyzed differences in the predicted channel network outputs and attempted to explain the presence of uncertainty and error. My output is a map of channel network with commentary directly on the map.

For this hydrology analysis, I conducted one analysis with ASTER data as the initial elevation data and a second analysis with SRTM as the initial input. With each, I performed the analysis with Saga tools in the Windows Command Prompt. Each map displayed contains commentary written on the map to explain what is visualized. Further, the layers that each satelittle mission gathered information from is considered in an attempt to explain patterns in elevation error that is manifested in the hydrology analysis process. 

### Data Sources and Platforms

I acquired both my ASTER and SRTM digital elevation data from the NASA operated site [EarthData](https://earthdata.nasa.gov/). Tile types? For my batch script, I used [SAGA](http://www.saga-gis.org/) and accessed the online tool documentation to determine how to structure the syntax of my batch processing steps. I developed my batch scripts on Notepad2 and executed them with Windows Command Prompt. 

For my ASTER data, the spatial extent of my analysis consisted of the following granules: ASTGTMV003_N39E029; ASTGTMV003_N40E029.


### Methodology

```

:: Developed by Ian8VT

::set the path to your SAGA program
SET PATH=%PATH%;c:\saga6

::set the prefix to use for all names and outputs
SET pre=ASTERdem

::set the directory in which you want to save ouputs. In the example below, part of the directory name is the prefix you entered above
SET od=W:\lab3\data\num\aster_dem_mosaic

:: the following creates the output directory if it doesn't exist already
if not exist %od% mkdir %od%

:: Mosaicking tool - combines the two elevation grids into a single one
saga_cmd grid_tools 3 -GRIDS=ASTGTMV003_N39E029_dem.sgrd;ASTGTMV003_N40E029_dem.sgrd -NAME=%pre%Mosaic -TYPE=9 -RESAMPLING=0 -OVERLAP=1 -MATCH=0 -TARGET_OUT_GRID=%od%\%pre%mosaic.sgrd

:: UTM Pojection tool - reprojects the grid into the proper UTM code for this region in Turkey
saga_cmd pj_proj4 24 -SOURCE=%od%\%pre%mosaic.sgrd -RESAMPLING=0 -KEEP_TYPE=1 -GRID=%od%\%pre%mosaicUTM.sgrd -UTM_ZONE=35 -UTM_SOUTH=0

:: Analytical Hillshading - 
saga_cmd ta_lighting 0 -ELEVATION=%od%\%pre%Mosaic_reclassified.sgrd -SHADE=%od%\%pre%hillshade.sgrd

:: Sink Route -
saga_cmd ta_preprocessor 1 -ELEVATION=%od%\%pre%Mosaic_reclassified.sgrd -SINKROUTE=%od%\%pre%sinkroute.sgrd

:: Sink Removal -
saga_cmd ta_preprocessor 2 -DEM=%od%\%pre%Mosaic_reclassified.sgrd -SINKROUTE=%od%\%pre%sinkroute.sgrd -DEM_PREPROC=%od%\%pre%sinkfilled.sgrd

:: Flow Accumulation -
saga_cmd ta_hydrology 0 -ELEVATION=%od%\%pre%sinkfilled.sgrd -SINKROUTE=%od%\%pre%sinkroute.sgrd -FLOW=%od%\%pre%flowaccumulation.sgrd -METHOD=4

:: Channel Network - 
saga_cmd ta_channels 0 -ELEVATION=%od%\%pre%sinkfilled.sgrd -CHNLNTWRK=%od%\%pre%channelnetwork.sgrd -CHNLROUTE=%od%\%pre%channelroute.sgrd -SHAPES=%od%\%pre%channelnetworktable -INIT_GRID=%od%\%pre%flowaccumulation.sgrd -INIT_VALUE=1000

::print a completion message so that uneasy users feel confident that the batch script has finished!
ECHO Processing Complete!
PAUSE

```

### Results and Discussion

![aster_batch](/saga/uludag/aster_dem_complete.txt)

![srtm_batch](/saga/uludag/mosaic_srtm_complete.txt)


![final_image](/saga/uludag/final_2.png)

A closer look at the northern cluster of information.

![image_zoom_north](/saga/uludag/final_zoom_north.png)

A closer look at the southern cluster. 

![image_zoom_south](/saga/uludag/final_zoom_south.png)

Return to [SAGA Index Page](../saga_index.md).

Return to [Main Index Page](../../index.md).
