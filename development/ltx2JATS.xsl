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
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ltx="http://dlmf.nist.gov/LaTeXML"  version="1.0" exclude-result-prefixes="ltx"
   xmlns="http://jats.nlm.nih.gov">
<xsl:output method="xml" indent="yes"/>
<xsl:template match="*">
	<xsl:message> The element <xsl:value-of select="name(.)"/> <xsl:if test="@*"> with attributes
	<xsl:for-each select="./@*">
		<xsl:value-of select="name(.)"/>=<xsl:value-of select="."/>
	</xsl:for-each>
	</xsl:if> 
 is currently not supported.
	</xsl:message>
	<xsl:comment> The element <xsl:value-of select="name(.)"/> <xsl:if test="@*"> with attributes
	<xsl:for-each select="./@*">
		<xsl:value-of select="name(.)"/>=<xsl:value-of select="."/>
	</xsl:for-each>
	</xsl:if> 
 is currently not supported.
	</xsl:comment>
</xsl:template>
<xsl:template match="ltx:document">
	<article>
		<front>
			<xsl:apply-templates mode="front"/>
		</front>
		<body>
			<xsl:apply-templates/>
		</body>

	</article>
</xsl:template>

<!-- Front matter section -->
<xsl:template match="text()">
	<xsl:copy-of select="."/>
</xsl:template>
<xsl:template match="ltx:document/ltx:title" mode="front">
	<title-group>
		<article-title>
			<xsl:apply-templates/>
		</article-title>
	</title-group>
</xsl:template>
<!-- End front matter section -->

<xsl:template match="ltx:document/ltx:title"/> <!-- TODO ask Bruce if we want the article title outside of the frontmatter as well -->

<!-- This section is for elements that we aren't doing anything with and just removing from the document -->
<xsl:template match="ltx:resource[@type='text/css']"/>
</xsl:stylesheet> 
