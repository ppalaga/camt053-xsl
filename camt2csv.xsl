<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright (C) 2012, Daniel Pocock http://danielpocock.com -->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:foo="http://whatever">
<xsl:output method="text" encoding="UTF-8"/>

<xsl:strip-space elements="*" />

<xsl:template match="/*[local-name() = 'Document']/*[local-name() = 'BkToCstmrStmt']/*[local-name() = 'GrpHdr']">
  <xsl:if test="*[local-name() = 'MsgPgntn']/*[local-name() = 'PgNb'] != 1 or *[local-name() = 'MsgPgntn']/*[local-name() = 'LastPgInd'] != 'true'">
    <xsl:message terminate="yes">
      <xsl:text>Incomplete message (not first page or subsequent pages exist)</xsl:text>
    </xsl:message>
  </xsl:if>
</xsl:template>

<xsl:template match="/*[local-name() = 'Document']/*[local-name() = 'BkToCstmrStmt']/*[local-name() = 'Stmt']">

<xsl:for-each select="*[local-name() = 'Ntry']/*[local-name() = 'NtryDtls']/*[local-name() = 'TxDtls']">
<xsl:variable name="AddtlNtryInf" select="*[local-name() = 'AddtlTxInf']/text()" />
<xsl:variable name="desc0">
  <xsl:choose>
    <xsl:when test="$AddtlNtryInf"><xsl:value-of select="$AddtlNtryInf"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="../../*[local-name() = 'AddtlNtryInf']/text()"/></xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:variable name="Ustrd" select="*[local-name() = 'RmtInf']/*[local-name() = 'Ustrd']/text()" />

<xsl:variable name="desc1">
  <xsl:choose>
    <xsl:when test="$Ustrd = substring($desc0, string-length($desc0) - string-length($Ustrd) +1)"><xsl:value-of select="$desc0"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="$desc0"/><xsl:text> </xsl:text><xsl:value-of select="$Ustrd"/></xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:variable name="CdtrNm" select="*[local-name() = 'RltdPties']/*[local-name() = 'Cdtr']/*[local-name() = 'Nm']/text()" />
<xsl:variable name="desc2">
  <xsl:choose>
    <xsl:when test="$CdtrNm != 'NOTPROVIDED' and $CdtrNm != 'Peter Palaga'"><xsl:value-of select="$desc1"/><xsl:text> </xsl:text><xsl:value-of select="$CdtrNm"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="$desc1"/></xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:variable name="DbtrNm" select="*[local-name() = 'RltdPties']/*[local-name() = 'Dbtr']/*[local-name() = 'Nm']/text()" />
<xsl:variable name="desc3">
  <xsl:choose>
    <xsl:when test="$DbtrNm != 'NOTPROVIDED' and $DbtrNm != 'Peter Palaga'"><xsl:value-of select="$desc2"/><xsl:text> </xsl:text><xsl:value-of select="$DbtrNm"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="$desc2"/></xsl:otherwise>
  </xsl:choose>
</xsl:variable>
<xsl:variable name="Amt" select="*[local-name() = 'Amt']/text()" />

<xsl:choose>
  <xsl:when test="$desc3 != 'Belastung LSV  Viseca Payment Services SA' and $desc3 != 'Vergütung Lenkinych 5000 CHF' and $desc3 != 'Übertrag' and $Amt != '4865'">
    <xsl:value-of
        select="../../*[local-name() = 'BookgDt']/*[local-name() = 'Dt']"/>,"<xsl:value-of
        select="$desc3"/>",<xsl:if
        test="*[local-name() = 'CdtDbtInd'] != 'CRDT'">-</xsl:if><xsl:value-of
        select="$Amt"/>,"<xsl:value-of
        select="*[local-name() = 'Amt']/@Ccy"/>"<xsl:text>&#xD;&#xA;</xsl:text>
  </xsl:when>
</xsl:choose>
</xsl:for-each>
</xsl:template>

<xsl:template match="/"><xsl:apply-templates select="/*[local-name() = 'Document']/*[local-name() = 'BkToCstmrStmt']/*[local-name() = 'GrpHdr']|/*[local-name() = 'Document']/*[local-name() = 'BkToCstmrStmt']/*[local-name() = 'Stmt']"/></xsl:template>

</xsl:stylesheet>
