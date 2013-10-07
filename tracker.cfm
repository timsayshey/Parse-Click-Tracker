<!--- You can change the default redirect url to whatever you want - this is for my app --->
<cfparam name="url.redir" default="http://x180movie.com">

<cfset dataUrl = "https://api.parse.com/1/classes/hits">

<cffunction name="isBot" returntype="boolean">
	<cfset useragent = LCase(cgi.http_user_agent)>
	<cfloop list="bot,spider,scrape,crawl," index="bot">
		<cfif find(bot,useragent)>
			<cfreturn true>
		</cfif>
	</cfloop>
	<cfreturn false>
</cffunction>

<cfif !isBot()>
	<cfthread action="run" name="gogogo" useragent="#cgi.http_user_agent#" ip="#CGI.REMOTE_ADDR#">		 
		
		<!--- 
			Make column names all caps to prevent duplicate columns when switching between railo/cf
			CF makes column names all caps and railo doesn't 
		--->
		<cfset jsonObj = {
			COUNT = 1,
			USERAGENT = attributes.useragent,
			IP = attributes.ip,
			THEDATE = DateFormat(now(),"mm-dd-yyyy"),
			URL = url.redir
		}>
		
		<cfhttp url="#dataUrl#" method="post">
			<cfhttpparam type="header" name="X-Parse-Application-Id" value="#application.appid#">
			<cfhttpparam type="header" name="X-Parse-REST-API-Key" value="#application.restid#">
			<cfhttpparam type="header" name="Content-type" value="application/json">
			<cfhttpparam type="body" value="#SerializeJSON(jsonObj)#">
		</cfhttp>	
	
	</cfthread>
</cfif>

<cflocation url="#url.redir#" addtoken="no">