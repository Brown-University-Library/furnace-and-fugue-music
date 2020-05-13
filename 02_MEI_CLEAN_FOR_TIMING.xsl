<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.music-encoding.org/ns/mei" xmlns:mei="http://www.music-encoding.org/ns/mei"
  xpath-default-namespace="http://www.music-encoding.org/ns/mei"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs" version="2.0">

  <xsl:output method="html" encoding="UTF-8" omit-xml-declaration="no"/>

  <!-- MAIN -->

  <xsl:template match="/">
    <xsl:message>Creating MEI version for timing</xsl:message>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Measure layers that contain a performance-duration override 
        (to handle non-normative long/breve durations) -->
  <!--
  <xsl:template match="//measure[@perf-dur]//layer">
    <xsl:variable name="perf-dur" select="number(./ancestor::measure[1]/@perf-dur)"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:comment> Original note </xsl:comment>
      <xsl:apply-templates/>
      <xsl:comment> Filler notes </xsl:comment>
      <xsl:call-template name="fake-note">
        <xsl:with-param name="count" select="$perf-dur - 1"/>
        <xsl:with-param name="first-note-id"
          select=".//note[@dur = 'breve' or @dur = 'long'][1]/@xml:id"/>
      </xsl:call-template>
    </xsl:copy>
  </xsl:template>-->

  <!--

  <xsl:template match="//measure[@perf-dur]//layer">
    <xsl:variable name="perf-dur" select="number(./ancestor::measure[1]/@perf-dur)"/>
    

    <xsl:copy>
      <xsl:apply-templates select="@*"/>
    </xsl:copy>
  </xsl:template> -->

  <xsl:template match="//measure[@perf-dur]//layer//note[@dur = 'breve' or @dur = 'long']">
    <xsl:variable name="perf-dur" select="number(./ancestor::measure[1]/@perf-dur)"/>
    <xsl:comment> Original note </xsl:comment>
    <note>
      <xsl:attribute name="dur" select="2"/>
      <xsl:apply-templates select="@*[name() != 'dur']"/>
    </note>
    <xsl:comment> Filler notes </xsl:comment>
    <xsl:call-template name="fake-note">
      <xsl:with-param name="count" select="$perf-dur - 1"/>
      <xsl:with-param name="first-note-id" select="@xml:id"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//note[@perf-dur]">
    <xsl:variable name="perf-dur" select="number(@perf-dur)"/>
    <xsl:comment> Original note 2 </xsl:comment>
    <note>
      <xsl:attribute name="dur" select="2"/>
      <xsl:apply-templates select="@*[name() != 'dur']"/>
    </note>
    <xsl:comment> Filler notes 2 </xsl:comment>
    <xsl:call-template name="fake-note">
      <xsl:with-param name="count" select="$perf-dur - 1"/>
      <xsl:with-param name="first-note-id" select="@xml:id"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Create fake half notes for breve/long override -->

  <xsl:template name="fake-note">

    <xsl:param name="count"/>
    <xsl:param name="first-note-id"/>

    <xsl:if test="$count > 0">
      <note xml:id="{generate-id()}-FAKE-{$count}" dur="2" pnum="65" class="fake-note-for-timing">
        <xsl:if test="$count = 1">
          <xsl:attribute name="match-end" select="$first-note-id"/>
        </xsl:if>
      </note>
      <xsl:call-template name="fake-note">
        <xsl:with-param name="count" select="$count - 1"/>
        <xsl:with-param name="first-note-id" select="$first-note-id"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Ignore lyrics that are not performed -->

  <xsl:template match="*[@perf = 'false']">
    <xsl:comment>
      <xsl:text> Ignored in performance </xsl:text>
      <xsl:copy>
        <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
    </xsl:comment>
  </xsl:template>

  <!-- When all else fails: identity transform -->

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
