/// Created using the page template: Default
Class DataBases.Page.Chart Extends %ZEN.Component.page [ Language = objectscript ]
{

/// The class name of the application to which this page belongs.
Parameter APPLICATION;

/// The name of the displayed page.
Parameter PAGENAME = "Chart";

/// Domain used for localization.
Parameter DOMAIN;

Property DBNAME [ InitialExpression = "ENSLIB" ];

/// This style block contains page specific CSS style definitions.
XData Style
{
<style type="text/css">

</style>
}

/// This XML block defines the content of this page
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="TrendChart">
	<html id="description"  OnDrawContent="DrawContent1"/>
</page>
}

Method DrawContent1(pSeed As %String) As %Status
{
	
	// Databases
	
	Set List = ##class(DataBases.SYS.Detail).DBList()
	Set iter = List.%GetIterator()
	Set selectSrt =""
	While iter.%GetNext(.key , .value ) {
		Set:key=0 ..DBNAME=value 
		Set selectSrt =selectSrt_"<option value ='"_value_"'>"_value_"</option>"
	}
	Set ObjectString = ..TrendChartData()
	
	&html<
<html>
  <head>
    
    <script src="../user/echarts.min.js"></script>
  </head>
  <body>
  DataBase
	 <select id="dataBaseSelect" class="select" onchange="zenPage.GetTrendChart()" >
        #(selectSrt)#
     </select>
    <!-- Prepare a DOM with defined width and height for ECharts -->
    <div id="main" style="width: 100%;height:500px;"></div>
    >
    &html<
    <script type="text/javascript">

      // Initialize echarts instance based on prepared DOM
      var myChart = echarts.init(document.getElementById('main'));

	
	function option(){

		var ObjectString='#(ObjectString)#'
		var Object =JSON.parse(ObjectString)
		var option ={
			  tooltip: {
			    trigger: 'axis'
			  },
			  legend: {
			    data: ['Available Space', 'Actual Size', 'Size']
			  },
			  grid: {
			    left: '3%',
			    right: '4%',
			    bottom: '3%',
			    containLabel: true
			  },
			  toolbox: {
			    feature: {
			      saveAsImage: {}
			    }
			  },
			  xAxis: {
			    type: 'category',
			    boundaryGap: false,
			    data: Object.xData
			  },
			  yAxis: {
			    type: 'value'
			  }
		};
		
		var series = [
		    {
		      name: 'Available Space',
		      type: 'line',
		      smooth: true,
		      data: Object.FreeSizeData
		    },
		    {
		      name: 'Actual Size',
		      type: 'line',
		      smooth: true,
		      data: Object.ActualSizeData
		    },
		    {
		      name: 'Size',
		      type: 'line',
		      smooth: true,
		      data: Object.SizeData
		    }
		];
	 option.series=series
		
	 return option
	
	}

	var option  =option();
	
     
     myChart.setOption(option);
      
      
      
    </script>
  </body>
</html>
	
	>
	Quit $$$OK
}

ClientMethod GetTrendChart() [ Language = javascript ]
{
	
	var obj = document.getElementById('dataBaseSelect'); 
	var index = obj.selectedIndex;  
	var value = obj.options[index].value;  
	var ObjectString = this.TrendChartData(value)
	var Object =JSON.parse(ObjectString)
	var option ={
			  tooltip: {
			    trigger: 'axis'
			  },
			  legend: {
			    data: ['Available Space', 'Actual Size', 'Size']
			  },
			  grid: {
			    left: '3%',
			    right: '4%',
			    bottom: '3%',
			    containLabel: true
			  },
			  toolbox: {
			    feature: {
			      saveAsImage: {}
			    }
			  },
			  xAxis: {
			    type: 'category',
			    boundaryGap: false,
			    data: Object.xData
			  },
			  yAxis: {
			    type: 'value'
			  }
		};
		
		var series = [
		    {
		      name: 'Available Space',
		      type: 'line',
		      smooth: true,
		      data: Object.FreeSizeData
		    },
		    {
		      name: 'Actual Size',
		      type: 'line',
		      smooth: true,
		      data: Object.ActualSizeData
		    },
		    {
		      name: 'Size',
		      type: 'line',
		      smooth: true,
		      data: Object.SizeData
		    }
		];
	 option.series=series
	 myChart.setOption(option);
}

Method TrendChartData(Name As %String = "") As %String [ ZenMethod ]
{
 
	Set Object = {}
	Set xData = []
	Set ActualSizeData = []
	Set FreeSizeData = []
	Set SizeData = []
	Set:$L(Name)=0 Name=..DBNAME
	Set Time =  ##class(Ens.Util.FunctionSet).ConvertDateTime($zd($now(),3), "%Y-%m-%d","%Y-%m-%d %H:%M:%S")
	Set sql = " SELECT ActualSize, DataBaseTime,   FreeSize, Name, Size "
			 _" FROM DataBases_DB.Size where Name = ? and DataBaseTime > ? order by  DataBaseTime "
	Set tStatment = ##class(%SQL.Statement).%New()
	Set tSC = tStatment.%Prepare(sql)
	Set Rest = tStatment.%Execute(Name,Time)
	While Rest.%Next(){
		d xData.%Push(Rest.%Get("DataBaseTime"))
		d ActualSizeData.%Push(Rest.%Get("ActualSize"))
		d FreeSizeData.%Push(Rest.%Get("FreeSize"))
		d SizeData.%Push(Rest.%Get("Size"))
	}
	Set Object.Name = Name
	Set Object.xData = xData
	Set Object.ActualSizeData = ActualSizeData
	Set Object.FreeSizeData = FreeSizeData
	Set Object.SizeData = SizeData
	
	Quit Object.%ToJSON()
}

}

