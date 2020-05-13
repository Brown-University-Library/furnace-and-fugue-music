<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.music-encoding.org/ns/mei" xmlns:mei="http://www.music-encoding.org/ns/mei"
  xpath-default-namespace="http://www.music-encoding.org/ns/mei"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs" version="2.0">

  <xsl:output encoding="UTF-16"/>

  <!-- Translation table between clef attribute names for staffDef and clef elements -->

  <xsl:variable name="clef-attribute-names">
    <name in-staffDef="clef.line" in-clef="line"/>
    <name in-staffDef="clef.shape" in-clef="shape"/>
    <name in-staffDef="clef.dis" in-clef="dis"/>
    <name in-staffDef="clef.dis.place" in-clef="dis.place"/>
  </xsl:variable>

  <!-- What emblem is this? (derive from filename) -->

  <xsl:variable name="emblem-number">
    <xsl:analyze-string select="base-uri()" regex=".*Fuga_([0-9]{{1,2}})\.xml">
      <xsl:matching-substring>
        <xsl:number value="regex-group(1)" format="1"/>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:variable>

  <!-- Get table of data for each emblem -->

  <!-- <xsl:variable name="space-data" select="document('02_EMBLEM_CONFIG.xml')" /> -->

  <!-- Main -->

  <xsl:template match="/">
    <xsl:message> Creating clean version of MEI </xsl:message>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Hard code the MEI head -->

  <xsl:template match="mei:meiHead">
    <mei:meiHead>
      <fileDesc>
        <titleStmt>
          <title>Atalanta Fugiens, music for Emblem <xsl:value-of select="$emblem-number"/>
          </title>
          <respStmt>
            <persName>Robin Bier</persName>
            <persName>Patrick Rashleigh</persName>
          </respStmt>
        </titleStmt>
        <pubStmt>
          <availability>
            <useRestrict> Released under an open source license ... </useRestrict>
          </availability>
        </pubStmt>
      </fileDesc>
      <encodingDesc/>
      <workDesc>
        <work>
          <titleStmt>
            <title/>
            <respStmt/>
          </titleStmt>
        </work>
      </workDesc>
    </mei:meiHead>
  </xsl:template>

  <!-- Grab eventual clefs -->
  <!-- 
    
   line -> clef.line    shape -> clef.shape    dis -> clef.dis     dis.place -> clef.dis.place  
    
  -->

  <!-- Update staffDef -->

  <xsl:template match="/mei/music/body/mdiv/score/scoreDef//staffDef">

    <xsl:variable name="thisStaffDef" select="."/>
    <xsl:variable name="staffNumber" select="@n"/>
    <xsl:variable name="otherClefDef"
      select="/mei/music/body/mdiv/score/section/measure/staff//clef[@staff = $staffNumber][1]"/>

    <xsl:copy>

      <!-- Process existing attributes -->

      <xsl:apply-templates select="@*"/>

      <!-- Grab the attributes off of the later clef definition -->

      <xsl:for-each select="$clef-attribute-names/name">

        <xsl:variable name="att-name-in-staffDef">
          <xsl:value-of select="current()/@in-staffDef"/>
        </xsl:variable>

        <xsl:variable name="att-name-in-clef">
          <xsl:value-of select="current()/@in-clef"/>
        </xsl:variable>

        <!-- Does this exist in the other clef definition? -->

        <xsl:variable name="otherClefDefAtt" select="$otherClefDef/@*[name() = $att-name-in-clef]"/>

        <xsl:if test="$otherClefDefAtt">
          <xsl:attribute name="{$att-name-in-staffDef}">
            <xsl:value-of select="$otherClefDefAtt"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:for-each>

      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove first measure -->

  <xsl:template match="/mei/music/body/mdiv/score/section/measure[1]"/>

  <!-- Renumber remaining measures -->

  <xsl:template match="@n[parent::measure]">
    <xsl:attribute name="n">
      <xsl:value-of select="count(preceding::measure)"/>
    </xsl:attribute>
  </xsl:template>

  <!-- The next two rules are to address the fact that 
    notes can span bar-lines in early modern notation -->

  <!-- Match all final notes in a measure that have 
    an invisible note starting the next measure -->

  <!--

  <xsl:template
    match="//layer/note[last()][./ancestor::measure/following-sibling::measure[1]/staff//note[1][@visible = 'false']]">

    <!-\- If that invisible next note is in the same staff, then start a tie.
          Otherwise, just copy the note element. -\->

    <xsl:variable name="staff-number" select="../ancestor::staff/@n"/>
    <xsl:variable name="next-note-invisible"
      select="./ancestor::measure/following-sibling::measure[1]/staff[@n = $staff-number]//note[1][@visible = 'false']"/>

    <note>
      <xsl:if test="$next-note-invisible">
        <xsl:attribute name="tie" select="'i'"/>
      </xsl:if>
      <xsl:apply-templates select="@*[name() != 'visible'] | ./node()"/>
    </note>
  </xsl:template>-->

  <!-- Match all measures which have a final note that is followed by 
       an invisible note starting in the next measure -->

  <xsl:template
    match="//measure[./following-sibling::measure[1]/staff/layer/note[1][@visible = 'false']]">

    <!-- Copy the measure and add ties -->

    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
      <xsl:apply-templates select="./staff/layer/note[last()]" mode="make-tie"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="//measure/staff/layer/note[last()]/@visible[.='false']"/>

  <xsl:template match="//measure/staff/layer/note[last()]" mode="make-tie">

    <xsl:variable name="current-note" select="."/>
    <xsl:variable name="staff-number" select="$current-note/ancestor::staff/@n"/>
    <xsl:variable name="next-note"
      select="$current-note/ancestor::measure/following-sibling::measure[1]/staff[@n = $staff-number]/layer/note[1]"/>

    <xsl:if test="$next-note/@visible[. = 'false']">
      <tie startid="#e{$emblem-number}-{$current-note/@xml:id}"
        endid="#e{$emblem-number}-{$next-note/@xml:id}"/>
    </xsl:if>
  </xsl:template>

  <!-- Match all notes at the beginning of the measure that are invisible; 
        add @tie and remove @visible -->

  <xsl:template match="//layer/note[1][@visible = 'false']">
    <note>
      <!--<xsl:attribute name="tie" select="'t'"/>-->
      <xsl:apply-templates select="@*[name() != 'visible'] | ./node()"/>
    </note>
  </xsl:template>

  <!-- Notes with a @oct and oct.ges that don't match - use oct.ges -->

  <xsl:template match="//note[@oct.ges != @oct]/@oct">
    <xsl:attribute name="oct">
      <xsl:value-of select="./parent::*/@oct.ges"/>
    </xsl:attribute>
  </xsl:template>

  <!-- Add a prefix based on filename to xml:id's -->

  <xsl:template match="@xml:id">
    <xsl:attribute name="xml:id">
      <xsl:value-of select="concat('e', $emblem-number, '-', .)"/>
    </xsl:attribute>
  </xsl:template>

  <!-- 
    
    Remove redunant accidentals and those specified as invisible (manual)
  
  -->

  <xsl:template match="//note/accid[@visible = 'false']"/>

  <xsl:template match="//note/accid[not(@visible = 'false')][../preceding-sibling::note[1][accid]]">
    <xsl:variable name="this-note-pitch" select="../@pnum"/>
    <xsl:variable name="last-note-pitch" select="../preceding-sibling::note[1]/@pnum"/>
    <xsl:variable name="this-accidental" select="@accid.ges | @accid"/>
    <xsl:variable name="last-accidental"
      select="../preceding-sibling::note[1]/accid/@accid.ges | ../preceding-sibling::note[1]/accid/@accid"/>

    <xsl:if test="$this-note-pitch != $last-note-pitch or $this-accidental != $last-accidental">
      <xsl:copy>
        <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
    </xsl:if>

    <xsl:if test="not($this-note-pitch != $last-note-pitch or $this-accidental != $last-accidental)">
      <xsl:comment> DELETED </xsl:comment>
    </xsl:if>

    <xsl:comment>
        
        this-pitch= <xsl:value-of select="$this-note-pitch"/> 
        last-pitch= <xsl:value-of select="$last-note-pitch"/>
        this-acc= <xsl:value-of select="$this-accidental"/>
        last-acc= <xsl:value-of select="$last-accidental"/>
        
    </xsl:comment>
  </xsl:template>



  <!-- Clutter to remove -->

  <xsl:template match="//instrDef"/>
  <xsl:template match="//comment()"/>
  <xsl:template match="/mei/meiHead//@xml:id"/>
  <xsl:template match="/mei/@xml:id"/>
  <xsl:template match="/mei//*[descendant::measure]/@xml:id"/>
  <xsl:template match="//scoreDef//@xml:id"/>
  <xsl:template match="//@*[starts-with(name(), 'page.')]"/>
  <xsl:template match="//@lyric.name"/>
  <xsl:template match="//@text.name"/>
  <xsl:template match="//note[not(@dur = 'long' or @dur = 'breve')]/@stem.dir"/>
  <xsl:template match="//note/@oct.ges"/>
  <xsl:template match="//note/@dur.ges"/>
  <xsl:template match="//rest/@dur.ges"/>
  <xsl:template match="//measure/@right[.='dashed']"/>

  <!-- When all else fails: identity transform -->

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
