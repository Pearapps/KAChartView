KAChartView
===========

Line and Bar chart for iOS 7.0+ and Mac OS X 10.9+

#Features

- Fast.
- Customizable (line color, fill color (line chart), axis color, does show axises, x axis labels and their attributes)
- Uses preferred numbers (r10 series) to calculate and scale the graph automatically.
- Scales to any frame.

#### How To Use
	// Initialize the KAChartView
	KAChartView * first = [[KAChartView alloc] initWithFrame:CGRectMake(0, 0, 320, 200) andType:KAChartViewTypeLine];
	
	// Create and add the data set
	[first addDataSets:@[[[KADataSet alloc] initWithValues:[self randomizedPoints:[self generateRandomArrayOfLength:7 withNumbersBetween:0 andTop:200]] withColor:[UIColor greenColor] andFillColor:[UIColor colorWithRed:0 green:1.0 blue:0.0 alpha:0.1]]]];
	
	// Set your axis label attributes
	first.axisLabelAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:10], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
	
	// Set boolean to allow the axis lines to be drawn
	[first setDoesDrawAxisLines:YES];


![alt tag](https://raw.github.com/Pearapps/KAChartView/master/chart.png)

![alt tag](https://raw.github.com/Pearapps/KAChartView/master/chart1.png)

![alt tag](https://raw.github.com/Pearapps/KAChartView/master/chart2.png)


What's Next:
- The 'buffer' needs to be flexible to accommodate huge y axis values, while retaining right aligned y axis labels.
- API and code cleansing. (Yes it has gotten messy, and I apologize - I think KAChartView is on it's 5th in-place rewrite, and so stuff gets dirty.)