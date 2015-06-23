<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:l="http://dlmf.nist.gov/LaTeXML"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:m="http://www.w3.org/1998/Math/MathML"
                xmlns:rg="http://www.researchgate.net"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:ext="java:net.researchgate.converters.latex.LatexJatsConverter"
                extension-element-prefixes="saxon"
                version="2.0">
    <xsl:import href="latexml2jats-util.xsl"/>

    <xsl:output method="xml" indent="yes"/>
    <xsl:output method="xml" 
        indent="yes" 
        doctype-public="-//NLM//DTD Journal Archiving and Interchange DTD v3.0 20080202//EN" 
        doctype-system="archivearticle3.dtd"
        encoding="UTF-8"/>
    <xsl:param name="source"/>
    <xsl:param name="externalId"/>
    <xsl:param name="paragraphTitleFont" select="'bold'"/>
    <xsl:variable name="fnId" select="0" saxon:assignable="yes"/>


    <xsl:template match="/l:document">

        <xsl:apply-templates select="l:ERROR"/>

        <article article-type="research-article"
                 xmlns:xlink="http://www.w3.org/1999/xlink"
                 xmlns:m="http://www.w3.org/1998/Math/MathML">
            <front>
                <article-meta>
                    <xsl:call-template name="article-meta">
                        <xsl:with-param name="root" select="."/>
                    </xsl:call-template>
                </article-meta>
            </front>
            <body>
                <xsl:apply-templates select="l:section | l:para | l:subsection"/>
            </body>
            <back>
                <xsl:apply-templates select="l:acknowledgements" mode="back"/>
                <xsl:apply-templates select="l:bibliography" mode="back"/>
                <xsl:if test="//l:note[@class='footnote' or @role='footnote' or @class='foot']">
                    <saxon:assign name="fnId" select="0"/>
                    <fn-group>
                        <xsl:apply-templates select="//l:note[@class='footnote' or @role='footnote']" mode="back"/>
                        <xsl:apply-templates select="//l:note[@class='foot']" mode="back"/>
                    </fn-group>
                </xsl:if>
                <xsl:if test="//l:appendix">
                    <app-group>
                        <xsl:apply-templates select="//l:appendix" mode="back"/>
                    </app-group>
                </xsl:if>
            </back>
            <floats-group>
                <xsl:apply-templates select="l:table | l:graphics | l:figure"/>
            </floats-group>
        </article>
    </xsl:template>


    <!-- FRONT -->
    <xsl:template name="article-meta">
        <xsl:param name="root"/>
        <article-id pub-id-type="{$source}"><xsl:value-of select="$externalId"/></article-id>

        <title-group>
            <article-title>
                <xsl:apply-templates select="$root/l:title"/>
            </article-title>
        </title-group>
        <contrib-group>
            <xsl:choose>
                <xsl:when test="count($root/l:creator) = 1">
                    <xsl:for-each select="tokenize(ext:getAuthorships(rg:extractAuthorshipText($root/l:creator[1]/l:personname)), ';')">
                        <xsl:element name="contrib">
                            <xsl:attribute name="contrib-type" select="$root/l:creator[1]/@role"/>
                            <name><xsl:value-of select="."/></name>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="authors">
                        <xsl:with-param name="authors" select="$root/l:creator"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </contrib-group>
        <xsl:if test="$root/l:date">
            <string-date>
                <xsl:apply-templates select="$root/l:date/text() | $root/l:date/*"/>
            </string-date>
        </xsl:if>
        <xsl:if test="$root/l:abstract">
            <abstract>
                <xsl:apply-templates select="$root/l:abstract/*"/>
            </abstract>
        </xsl:if>
    </xsl:template>

    <xsl:template name="authors">
        <xsl:param name="authors"/>
        <xsl:for-each select="$authors">
            <xsl:if test="./l:personname">
                <contrib contrib-type="{./@role}">
                    <name><xsl:value-of select="./l:personname/text()"/></name>
                </contrib>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- BODY -->
    <xsl:template match="l:section | l:subsection | l:subsubsection">
        <xsl:element name="sec">
            <xsl:call-template name="add-id"/>
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="l:note[@class='foot']">
        <saxon:assign name="fnId" select="$fnId+1"/>
        <xsl:element name="xref">
            <xsl:attribute name="rid" select="concat('FN-', $fnId)"/>
            <xsl:apply-templates select="./l:Math[1]"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="l:note[@class='footnote' or @role='footnote' and not(parent::l:title)]">
        <xsl:element name="xref">
            <xsl:attribute name="rid" select="concat('FN', @mark)"/>
            <xsl:value-of select="@mark"/>
        </xsl:element>
    </xsl:template>

    <!-- Ignore notes within titles -->
    <xsl:template match="l:note[parent::l:title]"/>


    <!-- BACK -->

    <xsl:template match="l:acknowledgements" mode="back">
        <ack>
            <p>
                <xsl:apply-templates/>
            </p>
        </ack>
    </xsl:template>

    <xsl:template match="l:bibliography" mode="back">
        <xsl:value-of select="./l:title"/>
        <xsl:apply-templates select=".//l:bibitem"/>
    </xsl:template>
    
    <xsl:template match="l:note[@class='footnote' or @role='footnote']" mode="back">
        <xsl:element name="fn">
            <xsl:attribute name="id" select="concat('FN', @mark)"/>
            <p>
                <xsl:apply-templates/>
            </p>
        </xsl:element>
    </xsl:template>

    <xsl:template match="l:appendix" mode="back">
        <app>
            <xsl:apply-templates/>
        </app>
    </xsl:template>

    <xsl:template match="l:note[@class='foot']" mode="back">
        <xsl:element name="fn">
            <saxon:assign name="fnId" select="$fnId+1"/>
            <xsl:attribute name="id" select="concat('FN-', $fnId)"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="l:cite">
        <xsl:apply-templates select="./l:ref" mode="cite"/>
    </xsl:template>

    <xsl:template match="l:ref" mode="cite">
        <xsl:copy-of select="rg:processCiteRef(.)"/>
    </xsl:template>

    <xsl:template match="l:bibitem">
        <mixed-citation>
            <xsl:attribute name="id" select="@xml:id"/>
            <xsl:apply-templates select="./l:bibblock/node()"/>
        </mixed-citation>
    </xsl:template>

    <xsl:template match="l:ERROR">
        <xsl:message terminate="yes">Latexml output contains an error element</xsl:message>
    </xsl:template>

    <xsl:template match="*">
        <xsl:message select="rg:unknownTag(.)"/>
    </xsl:template>

    <!-- COMMON -->

    <xsl:template match="l:ref">
        <xsl:element name="xref">
            <xsl:choose>
                <xsl:when test="parent::l:cite">
                    <xsl:attribute name="ref-type" select="'bibr'"/>
                    <xsl:attribute name="rid" select="./@idref"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="rid" select="./@labelref"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="./l:span">
                  <!-- TODO   <xsl:value-of select="./l:span/string(.)"/> -->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template match="l:bibref">
        <xsl:element name="xref">
            <xsl:attribute name="ref-type" select="'bibr'"/>
            <xsl:attribute name="rid" select="translate(//l:bibitem[@key=current()/@bibrefs]/@xml:id, ',', ' ')"/>
            <xsl:value-of select="//l:bibitem[@key=current()/@bibrefs]/l:bibtag[@role='refnum']/."/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="l:inline-block | l:block">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="l:paragraph">
        <xsl:choose>
            <xsl:when test="./l:title and ./l:para/l:p">
                <p>
                    <xsl:element name="{$paragraphTitleFont}">
                        <xsl:apply-templates select="./l:title/node()"/>
                    </xsl:element>
                    <xsl:value-of select="' '"/> <!-- Place a space after the title text -->
                    <xsl:apply-templates select="./l:para/l:p/node()"/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="l:para">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="l:p">
        <xsl:choose>
            <xsl:when test="l:note[@class='thanks']"/>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="l:note[@class='thanks']"/>

    <xsl:template match="l:quote">
        <disp-quote>
            <xsl:apply-templates/>
        </disp-quote>
    </xsl:template>


    <xsl:template match="l:toctitle">
        <alt-title>
            <xsl:apply-templates/>
        </alt-title>
    </xsl:template>

    <xsl:template match="l:title">
        <xsl:if test="l:tag">
            <label>
                <xsl:value-of select="l:tag"/>
            </label>
        </xsl:if>
        <title>
            <xsl:apply-templates/>
        </title>
    </xsl:template>

    <xsl:template match="l:verbatim">
        <xsl:element name="preformat">
            <xsl:copy-of select="rg:processText(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="l:text">
        <xsl:copy-of select="rg:processText(.)"/>
    </xsl:template>

    <xsl:template match="l:theorem | l:proof">
        <xsl:element name="statement">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="l:emph">
        <xsl:element name="italic">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="l:itemize | l:description">
        <xsl:element name="list">
            <xsl:call-template name="add-id"/>
            <xsl:if test="./l:item[1]/l:tag">
                <xsl:attribute name="prefix-word" select="ext:sanitizeText(./l:item[1]/l:tag)"/>
            </xsl:if>
            <xsl:for-each select="./l:item">
                <xsl:element name="list-item">
                    <xsl:if test="./l:tag">
                        <xsl:attribute name="label" select="ext:sanitizeText(./l:tag)"/>
                    </xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template match="l:tag"/>

    <xsl:template match="l:enumerate">
        <xsl:element name="list">
            <xsl:call-template name="add-id"/>
            <xsl:attribute name="list-type" select="'order'"/>
            <xsl:for-each select="./l:item">
                <xsl:element name="list-item">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template match="l:break">
        <break/>
    </xsl:template>


    <!-- TABLES -->

    <xsl:template match="l:table">
        <xsl:element name="table-wrap">
            <xsl:call-template name="add-id"/>
            <caption><p><xsl:apply-templates select="./l:caption/node()"/></p></caption>
            <xsl:if test="./l:graphics/@graphic">
                <graphic xlink:href="{./l:graphics/@graphic}"/>
            </xsl:if>

            <xsl:apply-templates select="./l:tabular"/>

            <xsl:if test="./l:p">
                <table-wrap-foot>
                    <fn-group>
                        <xsl:for-each select="./l:p">
                            <xsl:element name="fn">
                                <p><xsl:apply-templates/></p>
                            </xsl:element>
                        </xsl:for-each>
                    </fn-group>
                </table-wrap-foot>
            </xsl:if>

        </xsl:element>
    </xsl:template>

    <xsl:template match="l:tabular">
        <xsl:choose>
            <xsl:when test="not(parent::l:table)">
                <xsl:element name="table-wrap">
                    <xsl:call-template name="add-id"/>
                    <xsl:copy-of select="rg:processTable(.)"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="rg:processTable(.)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="l:thead"/>
    <xsl:template match="l:tfoot"/>
    <xsl:template match="l:tbody"/>

    <xsl:template match="l:tr">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="l:td">
        <xsl:element name="td">
            <xsl:if test="@vattach">
                <xsl:attribute name="valign" select="@vattach"/>
            </xsl:if>
            <xsl:copy-of select="@align | @colspan | @rowspan" />
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- A rule element can only have Common.attributes, Positionable.attributes, or Colorable.attributes, so ignore -->
    <xsl:template match="l:rule"/>

    <!-- We don't have an equivalent to indexes in the reader so ignore -->
    <xsl:template match="l:indexmark"/>

    <xsl:template match="l:pagination"/>

    <!-- HELPER -->

    <xsl:template match="l:figure">
        <xsl:element name="fig">
            <xsl:attribute name="id" select="@labels"/>
            <xsl:if test="./l:caption/l:tag">
                <xsl:element name="label">
                    <xsl:value-of select="./l:caption/l:tag"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="./l:caption">
                <xsl:element name="caption">
                    <p><xsl:apply-templates select="./l:caption/node()"/></p>
                </xsl:element>
            </xsl:if>
            <xsl:for-each select=".//l:graphics">
                <xsl:if test="ext:hasAngleMetadata(@options)">
                    <xsl:message terminate="no">figureAngleExists</xsl:message>
                </xsl:if>
                <xsl:element name="graphic">
                    <xsl:attribute name="xlink:href" select="@graphic"/>
                </xsl:element>
            </xsl:for-each>

        </xsl:element>
    </xsl:template>

    <xsl:template match="l:picture">
        <xsl:choose>
            <xsl:when test="./l:g">
                <xsl:message terminate="yes">SVG is not yet supported in l:picture elements</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- For any graphics that are not embedded in a figure element -->
    <xsl:template match="l:graphics">
        <xsl:element name="fig">
            <xsl:element name="graphic">
                <xsl:attribute name="xlink:href" select="@graphic"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="l:equationgroup">
        <xsl:element name="disp-formula-group">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="l:equation">
        <xsl:choose>
            <xsl:when test="@mode='inline'">
                <xsl:element name="inline-formula">
                    <xsl:call-template name="add-id"/>
                    <xsl:copy-of select="rg:copyMathML(.)"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="disp-formula">
                    <xsl:call-template name="add-id"/>
                    <label>
                        <xsl:value-of select="./@frefnum"/>
                    </label>
                    <xsl:copy-of select="rg:copyMathML(.)"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="l:Math">
        <xsl:choose>
            <xsl:when test="@mode='inline'">
                <xsl:element name="inline-formula">
                    <xsl:call-template name="add-id"/>
                    <xsl:copy-of select="rg:copyMathML(.)"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="disp-formula">
                    <xsl:call-template name="add-id"/>
                    <xsl:copy-of select="rg:copyMathML(.)"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- CUSTOM FUNCTIONS -->
    
    <xsl:function name="rg:processTable">
        <xsl:param name="pNode" as="node()"/>
        <xsl:apply-templates select="$pNode/node()"/>
        <xsl:element name="table">
            <xsl:if test="$pNode/l:thead">
                <xsl:element name="thead">
                    <xsl:apply-templates select="$pNode/l:thead/node()"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="$pNode/l:tfoot">
                <xsl:element name="tfoot">
                    <xsl:apply-templates select="$pNode/l:tfoot/node()"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="$pNode/l:tbody">
                <xsl:element name="tbody">
                    <xsl:apply-templates select="$pNode/l:tbody/node()"/>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:function>

    <xsl:function name="rg:extractAuthorshipText">
        <xsl:param name="pNode" as="node()"/>
        <xsl:value-of select="string-join($pNode//text()[not(parent::m:*)], ',')"/>
    </xsl:function>
    
    <xsl:function name="rg:processText">
        <xsl:param name="pNode" as="node()"/>
        <xsl:choose>
            <xsl:when test="not(empty($pNode/@font))">
                <xsl:copy-of select="rg:processTextWithFonts($pNode, $pNode/@font)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$pNode/node()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="rg:processCiteRef">
        <xsl:param name="pNode" as="node()"/>
        <xsl:choose>
            <xsl:when test="ext:isFormattedCitationRef($pNode)">
                <xsl:apply-templates select="$pNode"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'['"/>
                <xsl:apply-templates select="$pNode"/>
                <xsl:value-of select="']'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="rg:processTextWithFonts">
        <xsl:param name="pNode" as="node()"/>
        <xsl:param name="pFont"/>
        <xsl:variable name="separator" select="' '"/>
        <xsl:choose>
            <xsl:when test="contains($pFont, $separator)">
                <xsl:variable name="font" select="rg:translateFont(substring-before($pFont, $separator))"/>
                <xsl:choose>
                    <xsl:when test="$font != ''">
                        <xsl:element name="{$font}">
                            <xsl:copy-of select="rg:processTextWithFonts($pNode, substring-after($pFont, $separator))"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="rg:processTextWithFonts($pNode, substring-after($pFont, $separator))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$pFont != ''">
                <xsl:variable name="font" select="rg:translateFont($pFont)"/>
                <xsl:choose>
                    <xsl:when test="$font != ''">
                        <xsl:element name="{$font}">
                            <xsl:copy-of select="rg:processTextWithFonts($pNode, '')"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="rg:processTextWithFonts($pNode, '')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$pNode/node()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="rg:translateFont" >
        <xsl:param name="pFont"/>
        <xsl:choose>
            <!-- Directly translated fonts -->
            <xsl:when test="$pFont = 'bold' or $pFont = 'italic'">
                <xsl:value-of select="$pFont"/>
            </xsl:when>
            <!-- Fonts which need to be mapped to different values -->
            <xsl:when test="$pFont = 'sansserif'">
                <xsl:value-of select="'sans-serif'"/>
            </xsl:when>
            <xsl:when test="$pFont = 'smallcaps'">
                <xsl:value-of select="'sc'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:function>
    
    <xsl:function name="rg:copyMathML">
        <xsl:param name="pNode" as="node()"/>
        <xsl:for-each select="$pNode/descendant::*">
            <xsl:if test="m:merror">
                <xsl:message terminate="yes">MathML contains an error element</xsl:message>
            </xsl:if>
        </xsl:for-each>
        <xsl:copy-of select="$pNode//m:math" copy-namespaces="no"/>
    </xsl:function>

    <xsl:function name="rg:unknownTag">
        <xsl:param name="pNode" as="node()"/>

        <xsl:value-of select="'Unknown tag: '"/>
        <xsl:for-each select="$pNode/ancestor::*">
            <xsl:value-of select="name()" />
            <xsl:if test="@xml:id">
                <xsl:value-of select="concat(concat('[xml:id=', @xml:id), ']')"/>
            </xsl:if>
            <xsl:value-of select="'/'"/>
        </xsl:for-each>
        <xsl:value-of select="name($pNode)" />
    </xsl:function>

</xsl:stylesheet>
