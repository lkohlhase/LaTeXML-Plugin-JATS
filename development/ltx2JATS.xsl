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
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ltx="http://dlmf.nist.gov/LaTeXML"  version="1.0" exclude-result-prefixes="ltx str m xlink xhtml" xmlns:str="http://exslt.org/strings" xmlns:m="http://www.w3.org/1998/Math/MathML"         xmlns:xhtml="http://www.w3.org/1999/xhtml"        xmlns:xlink="http://www.w3.org/1999/xlink" >

   <xsl:strip-space elements="*"/>
<xsl:output method="xml" indent="yes"         doctype-public="-//NLM//DTD Journal Archiving and Interchange DTD v3.0 20080202//EN" 
doctype-system="archivearticle3.dtd"/>

<xsl:variable name="footnotes" select="//ltx:note[@role='footnote']"/>

<xsl:include href="LaTeXML-tabular-xhtml.xsl"/>
<xsl:include href="LaTeXML-common.xsl"/>
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
			<xsl:apply-templates select="@*|node()" />
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
<xsl:template match="ltx:emph" mode="front">
	<italic>
		<xsl:apply-templates mode="front" select="@*|node()"/>
	</italic>
</xsl:template> 

<xsl:template match="ltx:creator[@role='author']" mode="front">
	<contrib contrib-type="author">
		<xsl:apply-templates mode="front"/>
		
	</contrib>
</xsl:template>


<xsl:template match="ltx:date[@role='creation']" mode="front">
	<pub-date><string-date><xsl:apply-templates select="@*|node()" /></string-date></pub-date>
</xsl:template>

<xsl:template match="ltx:contact[@role='affiliation']" mode="front">
	<aff><xsl:apply-templates select="@*|node()" /></aff>
</xsl:template>

<xsl:template match="ltx:contact[@role='email']" mode="front">
	<email><xsl:apply-templates select="@*|node()" /></email>
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
<xsl:template match="ltx:text[@font='bold']" mode="front">
	<bold>
		<xsl:apply-templates mode="front" select="@*|node()"/>
	</bold>
</xsl:template> 
<xsl:template match="ltx:abstract" mode="front">
	<abstract>
		<xsl:apply-templates select="@*|node()" />
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
			<xsl:apply-templates select="@*|node()" />
		</article-title>
	</title-group>
</xsl:template>
<!-- End front matter section -->
<!-- Start back section --> 
<!-- This is essentially for bibliography and acknowledgements-->
<xsl:template match="ltx:bibliography" mode="back"> <!-- TODO check if there is ever any issue by making ref-list from this and not biblist -->
	<ref-list>
		<xsl:apply-templates mode="back"/>
	</ref-list>
</xsl:template>

<xsl:template match="ltx:bibliography/ltx:title" mode="back">
	<title>
		<xsl:apply-templates select="@*|node()" />
	</title>
</xsl:template>

<xsl:template match="ltx:biblist" mode="back">
	<xsl:apply-templates mode="back"/> 
</xsl:template>

<xsl:template match="ltx:bibitem" mode="back">
	<ref><xsl:if test="./@xml:id"><xsl:attribute name="id"><xsl:value-of select="./@xml:id"/></xsl:attribute></xsl:if>
		<mixed-citation>
			<xsl:apply-templates select="node()" mode="back"/>
		</mixed-citation>
	</ref>
</xsl:template>

<xsl:template match="ltx:bibtag[@role='year']" mode="back">
	<year>
		<xsl:apply-templates mode="back"/>
	</year>
</xsl:template>

<xsl:template match="ltx:bibblock" mode="back">
	<xsl:apply-templates mode="back"/>
</xsl:template>

<xsl:template match="ltx:emph" mode="back">
	<italic>
		<xsl:apply-templates mode="back" select="@*|node()"/>
	</italic>
</xsl:template>

<xsl:template match="ltx:acknowledgements" mode="back">
	<ack> 
		<xsl:if test="not(./ltx:p)">
			<p>
				<xsl:apply-templates mode="back" select="@*|node()"/>
			</p> 
		</xsl:if>
		<xsl:if test="./ltx:p">
			<xsl:apply-templates mode="back" select="@*|node()"/> 
		</xsl:if>
	</ack>
</xsl:template>
<xsl:template match="ltx:bibtag[@role='authors']" mode="back">
	<person-group person-group-type="author">
		<name>
		<!-- I will not do sophisticated handling trying to split this into several authors etc. -->
			<surname>
				<xsl:for-each select="str:tokenize(./text(),' ')">
					<xsl:if test="position=last()">
						<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</surname>
			<xsl:if test="contains(./text(),' ')">
		
				<given-names>
					<xsl:for-each select="str:tokenize(./text(),' ')">
						<xsl:if test="position!=last()">
							<xsl:value-of select="."/>
						</xsl:if> 
					</xsl:for-each>
				</given-names>
			</xsl:if>
		</name>
	</person-group>
</xsl:template>

<!-- TODO check if we want to do anything with fullauthors --> 
<xsl:template match="ltx:bibtag[@role='fullauthors']" mode="back"/>
<xsl:template match="ltx:text[@font='bold']" mode="back">
	<bold>
		<xsl:apply-templates mode="back" select="@*|node()"/>
	</bold>
</xsl:template>
<xsl:template match="ltx:bibtag[@role='refnum']" mode="back"/>
<xsl:template match="ltx:bibtag[@role='number']" mode="back"/>
<!-- End back section -->
<!-- Start main section --> 
<xsl:template match="ltx:text[@font='bold']">
	<bold>
		<xsl:apply-templates select="@*|node()"/>
	</bold>
</xsl:template>
<xsl:template match="ltx:emph">
	<italic>
		<xsl:apply-templates select="@*|node()"/>
	</italic>
</xsl:template>

<xsl:template match="ltx:note[@role='footnote']">
	<fn id="{generate-id(.)}">
		<p>
			<xsl:apply-templates select="@*|node()"/> 
		</p>
	</fn>
</xsl:template><!-- TODO check whether we ever us a simplistic id like @mark. Also check whether paragraphs are always necessary -->

<xsl:template match="ltx:para">
	<xsl:apply-templates select="@*|node()" />
</xsl:template>

<xsl:template match="ltx:equationgroup">
	<disp-formula-group>
		<xsl:apply-templates select="@*|node()"/> 
	</disp-formula-group> 
</xsl:template> 

<xsl:template match="ltx:equation">
	<disp-formula>
		<xsl:apply-templates select="@*"/>
		<tex-math>
			<xsl:value-of select="./@tex"/>
		</tex-math>
	</disp-formula>
</xsl:template>

<xsl:template match="ltx:Math[@mode='inline']">
	<inline-formula>
		<xsl:apply-templates select="@*"/>
		<tex-math>
			<xsl:value-of select="./@tex"/>
		</tex-math>
	</inline-formula>
</xsl:template>

<xsl:template match="ltx:inline-block">
	<xsl:apply-templates select="@*|node()"/> 
</xsl:template>

<xsl:template match="ltx:p">
	<p>
		<xsl:apply-templates select="@*|node()" />
	</p>
</xsl:template>

<xsl:template match="ltx:section">
	<sec>
		<xsl:apply-templates select="@*|node()" />
	</sec>
</xsl:template>

<xsl:template match="ltx:figure/ltx:caption">
	<caption>
		<xsl:if test="./ltx:p">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:if>
		<xsl:if test="not(./ltx:p)">
			<p>
				<xsl:apply-templates select="@*|node()"/> 
			</p>
		</xsl:if>
	</caption>
</xsl:template>


<xsl:template match="ltx:figure"> 
	<fig>
		<xsl:apply-templates select="@*"/> 
		<xsl:apply-templates select="ltx:caption"/> 
		<xsl:apply-templates select="*[not(self::ltx:caption)]"/>
	</fig> 
</xsl:template>

<xsl:template match="ltx:table">
	<table-wrap>
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates select="ltx:caption"/>
		<xsl:apply-templates select="*[not(self::ltx:caption)]"/>
	</table-wrap>
</xsl:template>

<xsl:template match="ltx:table/ltx:caption">
	<caption>
		<xsl:if test="./ltx:p">	
			<xsl:apply-templates select="@*|node()"/>
		</xsl:if>
		<xsl:if test="not(./ltx:p)">
			<p>
				<xsl:apply-templates select="@*|node()"/>
			</p> 
		</xsl:if>
	</caption> 
</xsl:template>

<xsl:template match="ltx:graphics"> 
	<graphic xlink:href="{./@graphic}"> <!-- Probably could have made this an empty element, but I just wanted to go sure -->
		<xsl:apply-templates select="@*|node()"/>
	</graphic>
</xsl:template>
<xsl:template match="ltx:text[@class='ltx_ref_tag']">
	<xsl:apply-templates select="@*|node()"/>
</xsl:template>

<xsl:template match="ltx:note[@role='thanks']">
	<p> 
		<xsl:apply-templates select="@*|node()" />
	</p>
</xsl:template>

<xsl:template match="ltx:text[@font='italic']">
	<italic>
		<xsl:apply-templates select="@*|node()" />
	</italic>
</xsl:template>

<xsl:template match="ltx:section/ltx:title">
	<title>
		<xsl:apply-templates select="@*|node()" />
	</title>
</xsl:template>

<xsl:template match="ltx:cite"> <!-- TODO check whether idref always happens, else make more comprehensive -->
	<xref ref-type="bibr" rid="{./ltx:ref/@idref}"><xsl:apply-templates select="@*|node()" /></xref> 
</xsl:template>

<xsl:template match="ltx:cite/ltx:ref[@idref]">
	<xsl:apply-templates select="@*|node()" />
</xsl:template>

<xsl:template match="ltx:ref[@labelref and not(@idref)]">
	<xref ref-type="labelref" rid="{./@labelref}">
		<xsl:apply-templates select="@*|node()"/> 
	</xref>
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
<xsl:template match="ltx:note[@role='thanks']" mode="back"/>
<xsl:template match="ltx:section" mode="back"/><!-- TODO check if there is any real possiblity for sections in back matter. I don't think so, since they all get dealt with by normal stuff -->
<xsl:template match="ltx:date[@role='creation']" mode="back"/>
<xsl:template match="ltx:document/ltx:title" mode="back"/>
<xsl:template match="ltx:para" mode="front"/>
<xsl:template match="ltx:para" mode="back"/>
<xsl:template match="ltx:toccaption"/>
<!-- hackish stuff for references -->

<xsl:template match="@labels">
	<xsl:attribute name="id"><xsl:value-of select="."/></xsl:attribute>
</xsl:template>
<xsl:template match="ltx:para/@xml:id"/> <!-- TODO append this to the next <p> or something -->
<xsl:template match="ltx:document/@xml:id"/>
<xsl:template match="@xml:id">
	<xsl:if test="not(../@labels)">
	<xsl:attribute name="id"><xsl:value-of select="."/></xsl:attribute>
	</xsl:if>
</xsl:template>

<xsl:template match="ltx:para/@xml:id" mode="front"/> <!-- TODO append this to the next <p> or something -->
<xsl:template match="@xml:id" mode="front">
	<xsl:if test="not(../@labels)">
	<xsl:attribute name="id"><xsl:value-of select="."/></xsl:attribute>
	</xsl:if>
</xsl:template>

<xsl:template match="ltx:para/@xml:id" mode="back"/> <!-- TODO append this to the next <p> or something -->
<xsl:template match="@xml:id" mode="back">
	<xsl:if test="not(../@labels)">
	<xsl:attribute name="id"><xsl:value-of select="."/></xsl:attribute>
	</xsl:if>
</xsl:template>

<xsl:template match="@*"/>
<xsl:template match="@*" mode="back"/>
<xsl:template match="@*" mode="front"/>
<!-- end of hackish references stuff --> 
<!-- font section --> 
<xsl:template match="ltx:text[@font='medium']">
	<xsl:apply-templates select="@*|node()"/>
</xsl:template>

<xsl:template match="ltx:text[@font='medium']" mode="back">
	<xsl:apply-templates select="@*|node()"/>
</xsl:template>

<xsl:template match="ltx:text[@font='medium']" mode="front">
	<xsl:apply-templates select="@*|node()"/>
</xsl:template>

<xsl:template match="ltx:text[@fontsize='90%']">
	<xsl:apply-templates select="@*|node()"/> 
</xsl:template>
<!-- Templates to make things more convenient -->
</xsl:stylesheet> 
