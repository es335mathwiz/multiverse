<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
version="1.0"
xmlns:java="http://xml.apache.org/xslt/java"
exclude-result-prefixes="java">
<xsl:output method="text"/>
<xsl:template match="/">

AMAModelDefinition["<xsl:value-of select="/AMAModel/@modelName"/>"]:=
{
{<xsl:for-each select="/AMAModel/endogenousVariable">
<xsl:value-of select="@name"/>
<xsl:if test="position()&lt;count(/AMAModel/endogenousVariable)">,</xsl:if>
</xsl:for-each>},
{<xsl:for-each select="/AMAModel/exogenousVariable"><xsl:value-of select="@name"/>
<xsl:if test="position()&lt;count(/AMAModel/exogenousVariable)">,</xsl:if>
</xsl:for-each>},
{<xsl:for-each select="/AMAModel/parameter">{<xsl:value-of select="@name"/>,<xsl:if test="string(@defaultValue)=''">$noDefaultValue</xsl:if><xsl:if test="@defaultValue!=''"><xsl:value-of select="@defaultValue"/></xsl:if>}<xsl:if test="position()&lt;count(/AMAModel/parameter)">,</xsl:if>
</xsl:for-each>},
{<xsl:for-each select="/AMAModel/innovation">{<xsl:value-of select="@name"/>,
<xsl:if test="string(@distribution)=''">$noDefaultDistribution</xsl:if><xsl:if test="@distribution!=''"><xsl:value-of select="@distribution"/></xsl:if>
}<xsl:if test="position()&lt;count(/AMAModel/innovation)">,</xsl:if></xsl:for-each>},
Transpose[{<xsl:for-each select="/AMAModel/equation">
{"<xsl:value-of select="@name"/>",<xsl:value-of select="."/>}<xsl:if test="position()&lt;count(/AMAModel/equation)">,</xsl:if>
</xsl:for-each>}],
Thread[{<xsl:for-each select="/AMAModel/innovation"><xsl:value-of select="@name"/><xsl:if test="position()&lt;count(/AMAModel/innovation)">,</xsl:if></xsl:for-each>}->Table[eps[i][t],{i,<xsl:value-of select="count(/AMAModel/innovation)"/>}]],
{<xsl:for-each select="/AMAModel/substitutions">
{<xsl:value-of select="@name"/>,<xsl:value-of select="@replacementRules"/>}
</xsl:for-each>
}
};
"<xsl:value-of select="/AMAModel/@modelName"/>"
</xsl:template>
</xsl:stylesheet>

