---
title: "The User's Manual of RXAJ"
author: "CHEN Longzan"
date: "2018-03-25"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Vignette Title}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---



  RXAJ is a hydrology model package which coded by R script and C language. This package is used for simluating and precasting the outlet discharage of basin(watershed,catchment), with the history discharge data, rainfall data and the sub-basin data. RXAJ has provided the following features:

# Data Management Module
## Data Structure figure
<img src="E:\\oneDrive\\workOnHand\\RXAJ\\数据结构.bmp" />

## modelParameter(dataframe)
the modelParameter includes the day-model and flood-model parameter, showing as the following :



|      | dayParameterValue | hourParameterValue |
| :--- | ----------------: | -----------------: |
| KC   |             0.600 |              0.600 |
| UM   |            20.000 |             20.000 |
| LM   |            90.000 |             90.000 |
| C    |             0.080 |              0.080 |
| WM   |           180.000 |            180.000 |
| B    |             0.300 |              0.300 |
| IM   |             0.030 |              0.030 |
| SM   |            10.000 |             10.000 |
| EX   |             1.200 |              1.200 |
| KG   |             0.400 |              0.350 |
| KI   |             0.300 |              0.350 |
| CI   |             0.700 |              0.650 |
| CG   |             0.995 |              0.998 |
| CS   |             0.200 |              0.085 |
| L    |             0.000 |              0.000 |
| KE   |            24.000 |              1.000 |
| XE   |             0.350 |              0.350 |

## basinInfo(list)
the basinInfo includes the sub-basin information and the basin area (km2),
### sub-baisn(dataframe)
the sub-basin information, which including the sub-basin area-weight and river-reach-number, was showing as the following :



|           | stationP1 | stationP2 | stationP3 | stationP4 | stationP5 | stationP6 | stationP7 | stationP8 | stationP9 |
| :-------- | --------: | --------: | --------: | --------: | --------: | --------: | --------: | --------: | --------: |
| sub-basin |     0.082 |     0.158 |      0.15 |     0.051 |     0.095 |     0.098 |     0.134 |     0.187 |     0.045 |
| sub-river |     1.000 |     6.000 |      5.00 |     5.000 |     3.000 |     4.000 |     2.000 |     2.000 |     1.000 |

### basin area(numeric)
the baisn area is the whole basin area, which unit is square kilometers.

## dayData(list)
the dayData includes dayStart,dayEnd,dayE,dayP,dayQ,initValue, which needed by the day model.
### dayStart and dayEnd
the dayStart is the start time of the day-model while the dayEnd means the end time of the day-model.A simple example is "2018-01-01".
### dayE(dataframe)
the dayE includes the whole basin evapotranspiration value and the  corresponding date.Showing as the following:



| Date       | stationE |
| :--------- | -------: |
| 2003-01-01 |      0.1 |
| 2003-01-02 |      0.2 |
| 2003-01-03 |      0.2 |
| 2003-01-04 |      0.2 |
| 2003-01-05 |      0.1 |
| 2003-01-06 |      0.2 |

### dayP(dataframe)
the dayP includes the sujb-baisn preciptation value and the corresponding date.Showing as the following:



| Date       | stationP1 | stationP2 | stationP3 | stationP4 | stationP5 | stationP6 | stationP7 | stationP8 | stationP9 |
| :--------- | --------: | --------: | --------: | --------: | --------: | --------: | --------: | --------: | --------: |
| 2003-01-01 |       1.4 |         0 |       1.0 |       1.8 |         0 |         0 |         0 |       0.1 |       1.6 |
| 2003-01-02 |       0.0 |         0 |       1.0 |       0.0 |         0 |         0 |         0 |       0.0 |       0.0 |
| 2003-01-03 |       0.0 |         0 |       3.4 |       0.0 |         0 |         0 |         0 |       0.0 |       0.0 |
| 2003-01-04 |       0.0 |         0 |       0.0 |       0.0 |         0 |         0 |         0 |       0.0 |       0.0 |
| 2003-01-05 |       0.0 |         0 |       0.0 |       0.0 |         0 |         0 |         0 |       0.0 |       0.0 |
| 2003-01-06 |       0.0 |         0 |       0.0 |       0.0 |         0 |         0 |         0 |       0.0 |       0.0 |

### dayQ(dataframe)
the dayQ includes the measured outlet discharge value and the corresponding date.Showing as the following:



| Date       | Qmea | Qcal |
| :--------- | ---: | ---: |
| 2003-01-01 | 1.74 | 1.74 |
| 2003-01-02 | 1.74 | 1.74 |
| 2003-01-03 | 1.74 | 1.74 |
| 2003-01-04 | 1.74 | 1.74 |
| 2003-01-05 | 1.74 | 1.74 |
| 2003-01-06 | 1.74 | 1.74 |

### initValue(dataframe)
the initValue includes the initial condition of day-model, showing as the following:



|      | stationP1 | stationP2 | stationP3 | stationP4 | stationP5 | stationP6 | stationP7 | stationP8 | stationP9 |
| :--- | --------: | --------: | --------: | --------: | --------: | --------: | --------: | --------: | --------: |
| WU   |      20.0 |     19.59 |      20.0 |      20.0 |     19.95 |     19.95 |     19.95 |      20.0 |      20.0 |
| WL   |      90.0 |     90.00 |      90.0 |      90.0 |     90.00 |     90.00 |     90.00 |      90.0 |      90.0 |
| WD   |      70.0 |     70.00 |      70.0 |      70.0 |     70.00 |     70.00 |     70.00 |      70.0 |      70.0 |
| QS   |       1.0 |      1.00 |       1.0 |       1.0 |      1.00 |      1.00 |      1.00 |       1.0 |       1.0 |
| QI   |       0.5 |      0.50 |       0.5 |       0.5 |      0.50 |      0.50 |      0.50 |       0.5 |       0.5 |
| QG   |       0.5 |      0.50 |       0.5 |       0.5 |      0.50 |      0.50 |      0.50 |       0.5 |       0.5 |
| SO   |       0.5 |      0.50 |       0.5 |       0.5 |      0.50 |      0.50 |      0.50 |       0.5 |       0.5 |
| Fr0  |       0.5 |      0.50 |       0.5 |       0.5 |      0.50 |      0.50 |      0.50 |       0.5 |       0.5 |

## floodData(list)
the floodData is nearly similar as the dayData, including timeStart,timeEnd,hourE,hourP,hourQ,initValue.
### hourStart and hourEnd
the hourStart is the start time of the flood-model while the hourEnd means the end time of the flood-model.A simple example is "2018-01-01 08:00:00".
### hourE
the hourE includes the whole basin evapotranspiration value and the  corresponding date.Showing as the following:



|       | YMDHM               | stationE |
| :---- | :------------------ | -------: |
| 66971 | 2010-08-22 18:00:00 |   0.0125 |
| 66972 | 2010-08-22 19:00:00 |   0.0125 |
| 66973 | 2010-08-22 20:00:00 |   0.0125 |
| 66974 | 2010-08-22 21:00:00 |   0.0125 |
| 66975 | 2010-08-22 22:00:00 |   0.0125 |
| 66976 | 2010-08-22 23:00:00 |   0.0125 |

### hourP
the hourP includes the sujb-baisn preciptation value and the corresponding date.Showing as the following:



| YMDHM               | stationP1 | stationP2 | stationP3 | stationP4 | stationP5 | stationP6 | stationP7 | stationP8 | stationP9 |
| :------------------ | --------: | --------: | --------: | --------: | --------: | --------: | --------: | --------: | --------: |
| 2010-08-22 18:00:00 |       0.0 |      0.00 |      0.00 |         0 |      0.00 |      0.08 |      0.00 |       0.0 |      0.00 |
| 2010-08-22 19:00:00 |       0.0 |      0.00 |      0.00 |         0 |      0.00 |      0.08 |      0.00 |       0.0 |      0.00 |
| 2010-08-22 20:00:00 |       0.0 |      0.00 |      0.00 |         0 |      0.00 |      0.08 |      0.00 |       0.0 |      0.00 |
| 2010-08-22 21:00:00 |       0.0 |      1.12 |      1.75 |         0 |      1.73 |      0.83 |      0.78 |       0.7 |      1.58 |
| 2010-08-22 22:00:00 |       0.0 |      1.12 |      1.75 |         0 |      1.73 |      0.83 |      0.78 |       0.7 |      1.58 |
| 2010-08-22 23:00:00 |       1.6 |      1.12 |      1.75 |         0 |      1.73 |      0.83 |      0.78 |       0.7 |      1.58 |

### hourQ
the hourQ includes the measured and calculated outlet discharge value and the corresponding date, you may keep the calculated value be 0.0 first. Showing as the following:



| YMDHM               |   Qmea |   Qcal |
| :------------------ | -----: | -----: |
| 2010-08-22 18:00:00 | 110.00 | 110.00 |
| 2010-08-22 19:00:00 | 107.00 | 107.00 |
| 2010-08-22 20:00:00 | 104.00 | 104.00 |
| 2010-08-22 21:00:00 | 101.34 | 101.34 |
| 2010-08-22 22:00:00 |  98.69 |  98.69 |
| 2010-08-22 23:00:00 |  95.69 |  95.69 |

### initValue
the initValue includes the initial condition of hour-model, showing as the following:



|      | stationP1 | stationP2 | stationP3 | stationP4 | stationP5 | stationP6 | stationP7 | stationP8 | stationP9 |
| :--- | --------: | --------: | --------: | --------: | --------: | --------: | --------: | --------: | --------: |
| WU   |      20.0 |     19.59 |      20.0 |      20.0 |     19.95 |     19.95 |     19.95 |      20.0 |      20.0 |
| WL   |      90.0 |     90.00 |      90.0 |      90.0 |     90.00 |     90.00 |     90.00 |      90.0 |      90.0 |
| WD   |      70.0 |     70.00 |      70.0 |      70.0 |     70.00 |     70.00 |     70.00 |      70.0 |      70.0 |
| QS   |       1.0 |      1.00 |       1.0 |       1.0 |      1.00 |      1.00 |      1.00 |       1.0 |       1.0 |
| QI   |       0.5 |      0.50 |       0.5 |       0.5 |      0.50 |      0.50 |      0.50 |       0.5 |       0.5 |
| QG   |       0.5 |      0.50 |       0.5 |       0.5 |      0.50 |      0.50 |      0.50 |       0.5 |       0.5 |
| SO   |       0.5 |      0.50 |       0.5 |       0.5 |      0.50 |      0.50 |      0.50 |       0.5 |       0.5 |
| Fr0  |       0.5 |      0.50 |       0.5 |       0.5 |      0.50 |      0.50 |      0.50 |       0.5 |       0.5 |

# Function Introduction
## check_basinData(basinData)
### Parameter
- basinData: the integrated basinData(list)
### feature
this function may help you check the integrity of your basinData, including the following checking item:
- whether the discharge data, preciptation data and the evapotraspiration data are corresponded to the start and end date.
- whether the discharge data, preciptation data and the evapotraspiration data are sequential.
- whether the discharge data, preciptation data and the evapotraspiration data have NA.
- whether the number of sub-basin is consistent in everywhere.

## dXAJ(dayModelParameter,basinInfo,dayData)
### Parameter
- dayModelParamter: the day-model parameter.
- basinInfo: the basin information including the sub-basin area-weight value ,the number of sub-river-reach and the area of the basin.
- dayData: the day data list of the basin.
### Feature
this function is used to simluate the day discharge of the basin, which output may including the following:
- dayResult: the dayResult is used for initializing the flood-model.
- resultData: the resultData includes the preciptation data, calculated discharge data, measured discharge data and the corresponding date, showing as the following:




| Date       |      P |      Qcal | Qmea |
| :--------- | -----: | --------: | ---: |
| 2003-01-01 | 0.4473 | 18.000000 | 1.74 |
| 2003-01-02 | 0.1500 |  8.156462 | 1.74 |
| 2003-01-03 | 0.5100 |  8.458752 | 1.74 |
| 2003-01-04 | 0.0000 |  7.181425 | 1.74 |
| 2003-01-05 | 0.0000 |  6.299626 | 1.74 |
| 2003-01-06 | 0.0000 |  5.752280 | 1.74 |

## initHourData(dayStart,floodData)
### Parameter
- dayStart: the start date of the flood.
- floodData: the integrated flood data.
### Feature
this function is used for providing the initValue of flood-model from the day-model output(dayResult). The return output is floodData.


## hXAJ(hourModelParameter,basinInfo,floodData)
### Parameter
- hourModelParameter: the flood-model parameter.
- basinInfo: the basin information, same as the dXAJ.
- floodData: the hour data list of the basin.
### Feature
this function is used to simluate the flood discharge of the basin, which output may including the following:
- floodResult: the floodResult inculdes the preciptation data, calculated discharge data, measured discharge data and the corresponding date, showing as the following:

## changeModelParameter(parameterValue,paraIndex,value)
### Parameter
- parameterValue: the numeric vector of the parameter, which is correspended with the parameter name vector,parameterName<-c("KC","UM","LM","C","WM","B","IM","SM","EX","KG","KI","CI","CG","CS","L","KE","XE").
- paraIndex: the parameter name(string) which will be modified.
- value: them parameter value(numeric) which will be modified.
### Feature
this function is used for change the paramter value of day-model or flood-model. The return variable is parameterValue.

## showResult(Date,P,Qcal,Qmea)
### Parameter
- Date:the Date series.
- P: the preciptation series.
- Qcal: the calculated discharge series.
- Qmea: the measured discharge series.
### Feature
this function is used for show the simluation result with package recharts.
