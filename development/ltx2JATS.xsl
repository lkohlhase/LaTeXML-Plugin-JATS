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
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ltx="http://dlmf.nist.gov/LaTeXML"  version="1.0" exclude-result-prefixes="ltx str" xmlns:str="http://exslt.org/strings" 
   >
<xsl:output method="xml" indent="yes"         doctype-public="-//NLM//DTD Journal Archiving and Interchange DTD v3.0 20080202//EN" 
        doctype-system="archivearticle3.dtd"/>
<xsl:template match="*">
	<xsl:message> The element <xsl:value-of select="name(.)"/> <xsl:if test="@*"> with attributes
	<xsl:for-each select="./@*">
		<xsl:value-of select="name(.)"/>=<xsl:value-of select="."/>
	</xsl:for-each>
	</xsl:if> 
 is currently not supported for the main body.
	</xsl:message>
	<xsl:comment> The element <xsl:value-of select="name(.)"/> <xsl:if test="@*"> with attributes
	<xsl:for-each select="./@*">
		<xsl:value-of select="name(.)"/>=<xsl:value-of select="."/>
	</xsl:for-each>
	</xsl:if> 
 is currently not supported for the main body.
	</xsl:comment>
</xsl:template>

<xsl:template match="*" mode="front">
	<xsl:message> The element <xsl:value-of select="name(.)"/> <xsl:if test="@*"> with attributes
	<xsl:for-each select="./@*">
		<xsl:value-of select="name(.)"/>=<xsl:value-of select="."/>
	</xsl:for-each>
	</xsl:if> 
 is currently not supported for the front matter.
	</xsl:message>
	<xsl:comment> The element <xsl:value-of select="name(.)"/> <xsl:if test="@*"> with attributes
	<xsl:for-each select="./@*">
		<xsl:value-of select="name(.)"/>=<xsl:value-of select="."/>
	</xsl:for-each>
	</xsl:if> 
 is currently not supported for the front matter.
	</xsl:comment>
</xsl:template>

<xsl:template match="*" mode="back">
	<xsl:message> The element <xsl:value-of select="name(.)"/> <xsl:if test="@*"> with attributes
	<xsl:for-each select="./@*">
		<xsl:value-of select="name(.)"/>=<xsl:value-of select="."/>
	</xsl:for-each>
	</xsl:if> 
 is currently not supported for the back matter.
	</xsl:message>
	<xsl:comment> The element <xsl:value-of select="name(.)"/> <xsl:if test="@*"> with attributes
	<xsl:for-each select="./@*">
		<xsl:value-of select="name(.)"/>=<xsl:value-of select="."/>
	</xsl:for-each>
	</xsl:if> 
 is currently not supported for the back matter
	</xsl:comment>
</xsl:template>


<xsl:template match="ltx:document">
	<article>
		<front>
			<article-meta>
				<xsl:apply-templates select="ltx:title" mode="front"/>
				<contrib-group>
					<xsl:apply-templates select="ltx:creator[@role='author']" mode="front"/>
				</contrib-group>
				<xsl:apply-templates select="ltx:date[@role='creation']" mode="front"/>
				<xsl:apply-templates select="ltx:abstract" mode="front"/>
				<xsl:apply-templates select="ltx:keywords" mode="front"/>
				<xsl:apply-templates select="*[not(self::ltx:title or self::ltx:creator[@role='author'] or self::ltx:date[@role='creation'] or self::ltx:abstract or self::ltx:keywords)]" mode="front"/>
				<!-- TODO check if all the front matter is actually included. Authors and titles are in already -->
			</article-meta>
		</front>
		<body>
			<xsl:apply-templates/>
		</body>
		<back> 
			<xsl:apply-templates mode="back"/>
		</back>

	</article>
</xsl:template>

<xsl:template match="text()">
	<xsl:copy-of select="."/>
</xsl:template>
<!-- Front matter section -->

<xsl:template match="ltx:creator[@role='author']" mode="front">
	<contrib contrib-type="author">
		<xsl:apply-templates mode="front"/>
		
	</contrib>
</xsl:template>


<xsl:template match="ltx:date[@role='creation']" mode="front">
	<pub-date><string-date><xsl:apply-templates/></string-date></pub-date>
</xsl:template>

<xsl:template match="ltx:contact[@role='affiliation']" mode="front">
	<aff><xsl:apply-templates/></aff>
</xsl:template>

<xsl:template match="ltx:contact[@role='email']" mode="front">
	<email><xsl:apply-templates/></email>
</xsl:template>
<xsl:template match="ltx:personname" mode="front">
	<name>

		<surname>
			<xsl:for-each select="str:tokenize(./text(),' ')">
				<xsl:if test="position()=last()">
					 <xsl:value-of select="."/> 
				</xsl:if>
			</xsl:for-each>
		</surname>
		<given-names>
		<xsl:for-each select="str:tokenize(./text(),' ')">
			<xsl:if test="position()!=last()">
				<xsl:value-of select="."/>&#160;
			</xsl:if>
		</xsl:for-each>
		</given-names>
	</name>
</xsl:template>

<xsl:template match="ltx:abstract" mode="front">
	<abstract>
		<xsl:apply-templates/>
	</abstract>
</xsl:template>

<xsl:template match="ltx:keywords" mode="front">
<kwd-group>
	<xsl:for-each select="str:tokenize(./text(),',')">
		<kwd><xsl:value-of select="."/></kwd>
	</xsl:for-each>
</kwd-group>
</xsl:template>

<xsl:template match="ltx:document/ltx:title" mode="front">
	<title-group>
		<article-title>
			<xsl:apply-templates/>
		</article-title>
	</title-group>
</xsl:template>
<!-- End front matter section -->
<!-- Start back section --> 
<!-- This is essentially for bibliography -->
<!-- Start main section --> 


<xsl:template match="ltx:para">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="ltx:p">
	<p>
		<xsl:apply-templates/>
	</p>
</xsl:template>

<xsl:template match="ltx:section">
	<sec>
		<xsl:apply-templates/>
	</sec>
</xsl:template>

<xsl:template match="ltx:note[@role='thanks']">
	<p> 
		<xsl:apply-templates/>
	</p>
</xsl:template>

<xsl:template match="ltx:text[@font='italic']">
	<italic>
		<xsl:apply-templates/>
	</italic>
</xsl:template>

<xsl:template match="ltx:section/ltx:title">
	<title>
		<xsl:apply-templates/>
	</title>
</xsl:template>

<xsl:template match="ltx:cite"> <!-- TODO check whether idref always happens, else make more comprehensive -->
	<xref ref-type="bibr" rid="{./ltx:ref/@idref}"><xsl:apply-templates/></xref> 
</xsl:template>

<xsl:template match="ltx:cite/ltx:ref">
	<xsl:apply-templates/>
</xsl:template>
<!-- End body section -->
<xsl:template match="ltx:document/ltx:title"/> <!-- TODO ask Bruce if we want the article title outside of the frontmatter as well -->

<!-- This section is for elements that we aren't doing anything with and just removing from the document -->
<xsl:template match="ltx:resource[@type='text/css']"/>
<xsl:template match="ltx:creator[@role='author']"/>
<xsl:template match="ltx:resource[@type='text/css']" mode="front"/>
<xsl:template match="ltx:abstract"/>
<xsl:template match="ltx:keywords"/>
<xsl:template match="ltx:note[@role='thanks']" mode="front"/>
<xsl:template match="ltx:section" mode="front"/>
<xsl:template match="ltx:acknowledgements"/> <!-- TODO put this into backmatter -->
<xsl:template match="ltx:acknowledgements" mode="front"/>
<xsl:template match="ltx:bibliography"/> <!-- TODO put this into backmatter --> 
<xsl:template match="ltx:bibliography" mode="front"/>
<xsl:template match="ltx:date[@role='creation']"/>
<xsl:template match="ltx:tag"/> <!-- TODO check if Slavas stuff validates for this -->
<xsl:template match="ltx:break"/> <!-- Break isn't really supposed to be used --> 
<xsl:template match="ltx:resource[@type='text/css']" mode="back"/>
<xsl:template match="ltx:creator[@role='author']" mode="back"/>
<xsl:template match="ltx:abstract" mode="back"/>
<xsl:template match="ltx:keywords" mode="back"/>
<!-- Templates to make things more convenient -->
    
</xsl:stylesheet> 
