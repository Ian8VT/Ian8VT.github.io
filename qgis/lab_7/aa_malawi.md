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



![malcomb_map](/qgis/lab_7/malcomb_vulnerability.png)


![model](/qgis/lab_7/model_2.5min.png)

[download](/qgis/lab_7/model_2.5min.model3)

![course_map](/qgis/lab_7/malawi_course.png)
