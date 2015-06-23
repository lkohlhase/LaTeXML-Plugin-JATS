<?xml version="1.0" encoding="utf-8"?>
<!--
/=====================================================================\ 
|  tex2manifest.xsl                                                   |
|  Generates a Firefox OS webapp manifest file                        |
|=====================================================================|
| not yet Part of LaTeXML: http://dlmf.nist.gov/LaTeXML/              |
|=====================================================================|
| Lukas Kohlhase                                              #_#     |
| Public domain software                                     (o o)    |
\=========================================================ooo==U==ooo=/
-->
<xsl:stylesheet
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ltx="http://dlmf.nist.gov/LaTeXML"  version="1.0" exclude-result-prefixes="ltx">
<xsl:output method="xml" indent="yes"/>
<xsl:template match="*">
	<xsl:message> The element <xsl:value-of select="name(.)"/> <xsl:if test="@*"> with attributes
	<xsl:for-each select="./@*">
		<xsl:value-of select="name(.)"/>=<xsl:value-of select="."/>
	</xsl:for-each>
	</xsl:if> 
 is currently not supported
	</xsl:message>
	<xsl:comment> The element <xsl:value-of select="name(.)"/> <xsl:if test="@*"> with attributes
	<xsl:for-each select="./@*">
		<xsl:value-of select="name(.)"/>=<xsl:value-of select="."/>
	</xsl:for-each>
	</xsl:if> 
 is currently not supported
	</xsl:comment>
</xsl:template>
<xsl:template match="ltx:document">
	<xsl:apply-templates/>
</xsl:template>
<xsl:template match="text()">
	<xsl:copy-of select="."/>
</xsl:template>
</xsl:stylesheet> 
