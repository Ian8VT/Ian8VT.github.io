### Introduction

In 2014, Malcomb et al. published an extensive paper which outlined their methodology and research into the devleopment of a multi-faceted climatic vulnerability assessment for Malawi. The authors positioned this household resilience assessment as an accurate and reliable tool to measure vulnerability due to the multiple types of data sources used for the model. Further, the authors suggested that this vulnerability assessment can be replicated for a number of different countries and that the results obtained from this assessment is a valuable contribution to the information utilized by experts and policy-makers. Since the authors position their model assessment as such a pivotal tool for climate change adaptation, it is reasonable to ensure that their work is reproducable and that the results obtained from their workflow agree with their asserted claims. As such, in this lab I will follow the methodology of Malcomb et al. and attempt to reproduce their final outputs for Malawi.

### Malcomb et al.'s Methodology

![assessment](/qgis/lab_7/malcomb_assessment.png)

The graphic above, accessed from Malcomb et al. (2014) outlines how the authors weighted input data sets to create their vulnerability assesment. As you can see, the assessment incorporates data from three different sources. The authors performed their analysis at the administrative district scale of Traditional Authorities, of which there is 250 in Malawi.

#### Adaptive Capacity

The 'adaptive capacity' input consists of twelve categories of survey data about the socioeconomic assets and access of individual households. These categories are components of the extensive Demographic and Health Surveys (DHS) conducted by the U.S. Agency of International Development (USAID) between 2004 and 2010. According to Malcomb et al., this input enhances the vulnerability assessment as it considers socio-ecological issues of Malawi at the scale of household dynamics. When all 12 of the categories are combined, the authors chose to weight their adaptive capacity score as 40% of the overall vulnerability assessment. As you can see next to each category in the above figure, the authors applied a weight to each survey category which combined to equal the total adapaptive capacity score.The data from the DHS is provided in cluster points at the scale of districts, of which Malawi has 28. However, the authors note that this large scale of data display is inappropiate to represent household scale vulnerability, so they disaggregated the data to the scale of TA. At this scale, the authors applied a quintile breakdown of the quantitative data obtained from the surveys to interpret the survey values on a scale that represents household resiliency, with a value of 5 meaning the most resilient and 1 meaning the least resilient. These quntile values were then multiplied by the weight of their corresponding survey category, collectively totaling  to 40% of each TAs overall vulnerability assessment.

#### Livelihood Sensitivity

#### Physical Exposure

### Methodolody to Reproduce

#### Adaptive Capacity

In order to access the DHS data, my professor Joseph Holler applied for special permission from USAID to use the data for a classroom teaching exercise. However, he had to agree to legal conditions, one of which was that only he would actually see the data in its raw form. As such, I never saw the DHS data. In response, the entirety of my class brainstormed to develop the SQL script necessary to take the DHS data and apply the same weighting that Malcomb et al. used, in which we sent to the professor to perform the analysis with the data. You can download the SQL file [here] that we collaboratively worked on as a class. Through this process, we realized that some DHS categories did not consist of a gradient of quantitative values which a quintile breakdown can be applied onto. Some categories were binary results, such as owning a cell phone or if the household was rural or urban. Malcomb et al. did not state in the paper which values on the scale of 1-5 they applied onto these binary survey questions. The different way this data could have been classified is important as it does effect how much weight the answers have in the final adaptive capacity score. For example, choosing to weight these binary responses with the extremes of 1 and 5 will maximize the difference in effect that the two different answewrs will have on the total adaptive capacity. This may not be a fair outcome, as it assumes the same level of difference as the 1 and 5 rankings of the gradient categories. In other words, owning a cell phone, which would be a rank of 5, would be valued as just as important in household resilience as being a household with the top tier number of livestock. When we ranked these categories as a class, some students applied the 1 and 5 ranking onto the some of the binary categories while others applied a 3 and 4 ranking.


![malcomb_map](/qgis/lab_7/malcomb_vulnerability.png)B


![model](/qgis/lab_7/model_2.5min.png)

[download](/qgis/lab_7/model_2.5min.model3)

![course_map](/qgis/lab_7/malawi_course.png)
