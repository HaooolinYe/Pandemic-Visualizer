# Pandemic-Visualizer
A bash script that takes in csv file(s) which contain(s) information about the spead of a flu/covid time can output orgonized data with respect to time to help doctors or scholars to better visulaize and anticipate a pandemic.
<img src="https://user-images.githubusercontent.com/90864900/152258476-f2583af6-1cdb-48e9-8e09-12f86cd2501a.png" width=500 height=400>
<!-- Before You Start -->
## Before You Start
* Download the covidata.sh file.
* If you are a Windows user, make sure you have your bash available in the Command Prompt and PowerShell. Click <a href="https://www.thewindowsclub.com/run-bash-on-windows-10"><strong>here</a></strong> if you need help on that.
* Have your csv file(s) ready. You can also use the sample files provided <a href="https://github.com/HaooolinYe/Pandemic-Visualizer/blob/main/Interactive%20data%20visualization%20of%20COVID%2019%20in%20Canada-ER.csv"><strong>here</strong></a>

<!-- Script syntax -->
## Script syntax
```
./covidata.sh -r procedure id range inputFile outputFile compareFile
```
<strong>Legal usage examples:</strong>
* ```./covidata.sh get 35 data.csv result.csv```
* ```./covidata.sh -r get 35 2020-01 2020-03 data.csv result.csv```
* ```./covidata.sh compare 10 data.csv result2.csv result.csv```
* ```./covidata.sh -r compare 10 2020-01 2020-03 data.csv result2.csv result.csv```

<!-- Capability && Guide-->
## Capability && Guide
With the -option,<strong>'get'</strong>, the script takes in <strong>an id</strong>, usually stands for the name of the region where you care about, <strong>a range</strong>, which is a optional time range, <strong>an input data file</strong> and an <strong>output data file</strong> which does not need to exist on the current directory before the execution of this script.
The output data file is going to store the selected data with the corresponding id and time range, and also has a simple anaylsis on the overall pandemic happen in that region.
The anaylsis would contain:
* The average confirmed cases
* The average death cases
* The average test cases

Without a time range, these data would be the overall analysis of all dates specified in the csv files.
However with a time range, the script is going to analyze every data in every 15 days and return the results in time in order of time.
ex.
3,10,5,1000 <-- statistics for 2020-01-01 to 2020-01-15
5,20,3,2000 <-- statistics for 2020-01-16 to 2020-01-31

The -option,<strong>'compare'</strong>, does something different than 'get'. It compares takes the same kind of input and output file as the 'get' option, yet, it accepts another file called the comparing file, which should be an existed output file returned by the 'get' option. The script then compares the comparing file with the data matched to the id and given time and analyzes the following statistics:
* The difference of the confirmed cases
* The difference of the death cases
* The difference of the cases

ex.
diffcount,diffavgconf,diffavgdeath,diffavgtests 
-2,3,-5,-300 3,4,-1,200

This gives a better sense of spread of the flu/covid in different regions.

<!-- Working on...-->
## Working on...
This program hasn't yet had any graphical interface. Such capability could be added using matplotlib and python to graph out the actually statistics.
