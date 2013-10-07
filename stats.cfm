<cfset dataUrl = "https://api.parse.com/1/classes/hits">
 
<cfhttp url="#dataUrl#" method="get">
    <cfhttpparam type="header" name="X-Parse-Application-Id" value="#application.appid#">
	<cfhttpparam type="header" name="X-Parse-REST-API-Key" value="#application.restid#">
</cfhttp>	
 
<cfset arrayOfStructs = deserializeJSON(cfhttp.filecontent)>
<cfset arrayOfStructs = arrayOfStructs.results>

<!--- 
	View record dump
	<cfdump var="#arrayOfStructs#"> 
--->

<cfset qHits = queryNew("ip,thedate","varchar,date")>

<cfset cnt = 1>
<cfloop array="#arrayOfStructs#" index="struct">
	<cfset queryAddRow(qHits, 1)>
	<cfset querySetCell(qHits, "ip", struct.ip, cnt)>
	<cfset querySetCell(qHits, "thedate", struct.thedate, cnt)>
	<cfset cnt++>
</cfloop>

<!doctype html>
<head>

  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
  <script src="morris/raphael-min.js"></script>
  <script src="morris/morris.js"></script>
  <script src="morris/lib/prettify.js"></script>
  <script src="morris/lib/example.js"></script>
  
  <link rel="stylesheet" href="morris/lib/example.css">
  <link rel="stylesheet" href="morris/lib/prettify.css">
  <link rel="stylesheet" href="morris/morris.css">
  
  <title>Parse Click Tracker</title>
  
</head>
<body>

<h1>Daily Hits</h1>
<div id="graph" style="width:800px; position:relative; clear:both; margin:0 auto;"></div>

<!---
Commented out yearly stats because coldfusion doesn't like year() in the QoQ
<h1>Yearly Hits</h1>
<div id="graph2" style="width:800px; position:relative; clear:both; margin:0 auto;"></div> 
--->

<cfquery dbtype="query" name="qHits"> 
	select distinct ip, thedate
	from qHits
</cfquery>

<cfquery dbtype="query" name="qDailyHits"> 
	select thedate, count(*) as qty
	from qHits
	group by thedate
	order by thedate
</cfquery>

<!--- 
<cfquery dbtype="query" name="qYearlyHits"> 
	select year(thedate) as myyear, count(*) as qty
	from qHits
	group by myyear
	order by myyear
</cfquery> 
--->

<pre id="code" class="prettyprint linenums" style="display:none;">

	var daily_data = [
	
	<cfoutput query="qDailyHits">
		{
			"period": "#dateformat(thedate,"yyyy-mm-dd")#", 
			"Hits": #qty#
		}
	<cfif qHits.recordcount neq currentrow>,</cfif>
	</cfoutput>
	
	];
	
	Morris.Line({
	  element: 'graph',
	  data: daily_data,
	  xkey: 'period',
	  ykeys: ['Hits', 'Hits'],
	  labels: ['Hits', 'Hits']
	});
	
<!---
var yearly_data = [
	
	<cfoutput query="qYearlyHits">
		{
			"period": "#myyear#", 
			"Hits": #qty#
		}
		<cfif qHits.recordcount neq currentrow>,</cfif>
	</cfoutput>
	
	];
	
	Morris.Line({
	  element: 'graph2',
	  data: yearly_data,
	  xkey: 'period',
	  ykeys: ['Hits', 'Hits'],
	  labels: ['Hits', 'Hits']
	}); 
--->

</pre>

</body>




