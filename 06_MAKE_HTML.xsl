<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:svg="http://www.w3.org/2000/svg" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs svg" version="2.0">

  <xsl:output method="html" encoding="UTF-8" omit-xml-declaration="yes"/>

  <!-- GLOBAL VARIABLES -->

  <xsl:variable name="emblem-id">
    <xsl:analyze-string select="base-uri()" regex=".*(Fuga_[0-9]{{1,2}})\.svg">
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(1)"/>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:variable>
  
  <xsl:variable name="timetable"
    select="document(concat('04_TIMING/fugue_timing/', $emblem-id, '.xml'))/fugue" />

  <xsl:variable name="highest-pitch" select="max($timetable//@pitch-number)"/>
  <xsl:variable name="lowest-pitch" select="min($timetable//@pitch-number)"/>
  <xsl:variable name="start-time-offset" select="min($timetable//@start)"/>

  <xsl:variable name="pianoroll-bar-height" select="number(5)"/>
  <xsl:variable name="pianoroll-pixels-per-second" select="number(50)"/>

  <!-- Set to true() for HTML, false() for an include -->
  <xsl:param name="HTML-TEST-OUTPUT" select="false()" />
  <!-- <xsl:variable name="HTML-TEST-OUTPUT" select="false()"/> -->
  
  <xsl:variable name="AUDIO_DIR">
    <xsl:choose>
      <xsl:when test="$HTML-TEST-OUTPUT">
        <xsl:value-of select="'audio/'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'../assets/audio/'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="mp3-filenames-by-fugue">
    <mp3-filenames fugue-id="Fuga_01" dry1="01-A-56bpm-Dry.mp3" dry2="01-H-56bpm-Dry.mp3"
      dry3="01-P-56bpm-Dry.mp3" reverb1="01-A-56bpm-Reverb.mp3" reverb2="01-H-56bpm-Reverb.mp3"
      reverb3="01-P-56bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_02" dry1="02-A-56bpm-Dry.mp3" dry2="02-P-56bpm-Dry.mp3"
      dry3="02-H-56bpm-Dry.mp3" reverb1="02-A-56bpm-Reverb.mp3" reverb2="02-P-56bpm-Reverb.mp3"
      reverb3="02-H-56bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_03" dry1="03-A-45bpm-Dry.mp3" dry2="03-H-45bpm-Dry.mp3"
      dry3="03-P-45bpm-Dry.mp3" reverb1="03-A-45bpm-Reverb.mp3" reverb2="03-H-45bpm-Reverb.mp3"
      reverb3="03-P-45bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_04" dry1="04-P-54bpm-Dry.mp3" dry2="04-H-54bpm-Dry.mp3"
      dry3="04-A-54bpm-Dry.mp3" reverb1="04-P-54bpm-Reverb.mp3" reverb2="04-H-54bpm-Reverb.mp3"
      reverb3="04-A-54bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_05" dry1="05-A-45bpm-Dry.mp3" dry2="05-H-45bpm-Dry.mp3"
      dry3="05-P-45bpm-Dry.mp3" reverb1="05-A-45bpm-Reverb.mp3" reverb2="05-H-45bpm-Reverb.mp3"
      reverb3="05-P-45bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_06" dry1="06-P-56bpm-Dry.mp3" dry2="06-A-56bpm-Dry.mp3"
      dry3="06-H-56bpm-Dry.mp3" reverb1="06-P-56bpm-Reverb.mp3" reverb2="06-A-56bpm-Reverb.mp3"
      reverb3="06-H-56bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_07" dry1="07-H-50bpm-Dry.mp3" dry2="07-A-50bpm-Dry.mp3"
      dry3="07-P-50bpm-Dry.mp3" reverb1="07-H-50bpm-Reverb.mp3" reverb2="07-A-50bpm-Reverb.mp3"
      reverb3="07-P-50bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_08" dry1="08-P-58bpm-Dry.mp3" dry2="08-H-58bpm-Dry.mp3"
      dry3="08-A-58bpm-Dry.mp3" reverb1="08-P-58bpm-Reverb.mp3" reverb2="08-H-58bpm-Reverb.mp3"
      reverb3="08-A-58bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_09" dry1="09-H-58bpm-Dry.mp3" dry2="09-A-58bpm-Dry.mp3"
      dry3="09-P-58bpm-Dry.mp3" reverb1="09-H-58bpm-Reverb.mp3" reverb2="09-A-58bpm-Reverb.mp3"
      reverb3="09-P-58bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_10" dry1="10-A-68bpm-Dry.mp3" dry2="10-H-68bpm-Dry.mp3"
      dry3="10-P-68bpm-Dry.mp3" reverb1="10-A-68bpm-Reverb.mp3" reverb2="10-H-68bpm-Reverb.mp3"
      reverb3="10-P-68bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_11" dry1="11-H-56bpm-Dry.mp3" dry2="11-A-56bpm-Dry.mp3"
      dry3="11-P-56bpm-Dry.mp3" reverb1="11-H-56bpm-Reverb.mp3" reverb2="11-A-56bpm-Reverb.mp3"
      reverb3="11-P-56bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_12" dry1="12-H-50bpm-Dry.mp3" dry2="12-A-50bpm-Dry.mp3"
      dry3="12-P-50bpm-Dry.mp3" reverb1="12-H-50bpm-Reverb.mp3" reverb2="12-A-50bpm-Reverb.mp3"
      reverb3="12-P-50bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_13" dry1="13-H-46bpm-Dry.mp3" dry2="13-A-46bpm-Dry.mp3"
      dry3="13-P-46bpm-Dry.mp3" reverb1="13-H-46bpm-Reverb.mp3" reverb2="13-A-46bpm-Reverb.mp3"
      reverb3="13-P-46bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_14" dry1="14-A-58bpm-Dry.mp3" dry2="14-P-58bpm-Dry.mp3"
      dry3="14-H-58bpm-Dry.mp3" reverb1="14-A-58bpm-Reverb.mp3" reverb2="14-P-58bpm-Reverb.mp3"
      reverb3="14-H-58bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_15" dry1="15-A-66bpm-Dry.mp3" dry2="15-P-66bpm-Dry.mp3"
      dry3="15-H-66bpm-Dry.mp3" reverb1="15-A-66bpm-Reverb.mp3" reverb2="15-P-66bpm-Reverb.mp3"
      reverb3="15-H-66bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_16" dry1="16-H-48bpm-Dry.mp3" dry2="16-A-48bpm-Dry.mp3"
      dry3="16-P-48bpm-Dry.mp3" reverb1="16-H-48bpm-Reverb.mp3" reverb2="16-A-48bpm-Reverb.mp3"
      reverb3="16-P-48bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_17" dry1="17-H-56bpm-Dry.mp3" dry2="17-A-56bpm-Dry.mp3"
      dry3="17-P-56bpm-Dry.mp3" reverb1="17-H-56bpm-Reverb.mp3" reverb2="17-A-56bpm-Reverb.mp3"
      reverb3="17-P-56bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_18" dry1="18-H-42bpm-Dry.mp3" dry2="18-P-42bpm-Dry.mp3"
      dry3="18-A-42bpm-Dry.mp3" reverb1="18-H-42bpm-Reverb.mp3" reverb2="18-P-42bpm-Reverb.mp3"
      reverb3="18-A-42bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_19" dry1="19-A-50bpm-Dry.mp3" dry2="19-H-50bpm-Dry.mp3"
      dry3="19-P-50bpm-Dry.mp3" reverb1="19-A-50bpm-Reverb.mp3" reverb2="19-H-50bpm-Reverb.mp3"
      reverb3="19-P-50bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_20" dry1="20-H-60bpm-Dry.mp3" dry2="20-A-60bpm-Dry.mp3"
      dry3="20-P-60bpm-Dry.mp3" reverb1="20-H-60bpm-Reverb.mp3" reverb2="20-A-60bpm-Reverb.mp3"
      reverb3="20-P-60bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_21" dry1="21-H-56bpm-Dry.mp3" dry2="21-A-56bpm-Dry.mp3"
      dry3="21-P-56bpm-Dry.mp3" reverb1="21-H-56bpm-Reverb.mp3" reverb2="21-A-56bpm-Reverb.mp3"
      reverb3="21-P-56bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_22" dry1="22-H-50bpm-Dry.mp3" dry2="22-A-50bpm-Dry.mp3"
      dry3="22-P-50bpm-Dry.mp3" reverb1="22-H-50bpm-Reverb.mp3" reverb2="22-A-50bpm-Reverb.mp3"
      reverb3="22-P-50bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_23" dry1="23-H-46bpm-Dry.mp3" dry2="23-P-46bpm-Dry.mp3"
      dry3="23-A-46bpm-Dry.mp3" reverb1="23-H-46bpm-Reverb.mp3" reverb2="23-P-46bpm-Reverb.mp3"
      reverb3="23-A-46bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_24" dry1="24-H-48bpm-Dry.mp3" dry2="24-P-48bpm-Dry.mp3"
      dry3="24-A-48bpm-Dry.mp3" reverb1="24-H-48bpm-Reverb.mp3" reverb2="24-P-48bpm-Reverb.mp3"
      reverb3="24-A-48bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_25" dry1="25-A-54bpm-Dry.mp3" dry2="25-P-54bpm-Dry.mp3"
      dry3="25-H-54bpm-Dry.mp3" reverb1="25-A-54bpm-Reverb.mp3" reverb2="25-P-54bpm-Reverb.mp3"
      reverb3="25-H-54bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_26" dry1="26-A-56bpm-Dry.mp3" dry2="26-P-56bpm-Dry.mp3"
      dry3="26-H-56bpm-Dry.mp3" reverb1="26-A-56bpm-Reverb.mp3" reverb2="26-P-56bpm-Reverb.mp3"
      reverb3="26-H-56bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_27" dry1="27-H-56bpm-Dry.mp3" dry2="27-P-56bpm-Dry.mp3"
      dry3="27-A-56bpm-Dry.mp3" reverb1="27-H-56bpm-Reverb.mp3" reverb2="27-P-56bpm-Reverb.mp3"
      reverb3="27-A-56bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_28" dry1="28-H-58bpm-Dry.mp3" dry2="28-P-58bpm-Dry.mp3"
      dry3="28-A-58bpm-Dry.mp3" reverb1="28-H-58bpm-Reverb.mp3" reverb2="28-P-58bpm-Reverb.mp3"
      reverb3="28-A-58bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_29" dry1="29-A-50bpm-Dry.mp3" dry2="29-P-50bpm-Dry.mp3"
      dry3="29-H-50bpm-Dry.mp3" reverb1="29-A-50bpm-Reverb.mp3" reverb2="29-P-50bpm-Reverb.mp3"
      reverb3="29-H-50bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_30" dry1="30-A-52bpm-Dry.mp3" dry2="30-P-52bpm-Dry.mp3"
      dry3="30-H-52bpm-Dry.mp3" reverb1="30-A-52bpm-Reverb.mp3" reverb2="30-P-52bpm-Reverb.mp3"
      reverb3="30-H-52bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_31" dry1="31-H-58bpm-Dry.mp3" dry2="31-A-58bpm-Dry.mp3"
      dry3="31-P-58bpm-Dry.mp3" reverb1="31-H-58bpm-Reverb.mp3" reverb2="31-A-58bpm-Reverb.mp3"
      reverb3="31-P-58bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_32" dry1="32-P-44bpm-Dry.mp3" dry2="32-H-44bpm-Dry.mp3"
      dry3="32-A-44bpm-Dry.mp3" reverb1="32-P-44bpm-Reverb.mp3" reverb2="32-H-44bpm-Reverb.mp3"
      reverb3="32-A-44bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_33" dry1="33-P-54bpm-Dry.mp3" dry2="33-A-54bpm-Dry.mp3"
      dry3="33-H-54bpm-Dry.mp3" reverb1="33-P-54bpm-Reverb.mp3" reverb2="33-A-54bpm-Reverb.mp3"
      reverb3="33-H-54bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_34" dry1="34-P-54bpm-Dry.mp3" dry2="34-A-54bpm-Dry.mp3"
      dry3="34-H-54bpm-Dry.mp3" reverb1="34-P-54bpm-Reverb.mp3" reverb2="34-A-54bpm-Reverb.mp3"
      reverb3="34-H-54bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_35" dry1="35-P-42bpm-Dry.mp3" dry2="35-H-42bpm-Dry.mp3"
      dry3="35-A-42bpm-Dry.mp3" reverb1="35-P-42bpm-Reverb.mp3" reverb2="35-H-42bpm-Reverb.mp3"
      reverb3="35-A-42bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_36" dry1="36-A-54bpm-Dry.mp3" dry2="36-P-54bpm-Dry.mp3"
      dry3="36-H-54bpm-Dry.mp3" reverb1="36-A-54bpm-Reverb.mp3" reverb2="36-P-54bpm-Reverb.mp3"
      reverb3="36-H-54bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_37" dry1="37-P-48bpm-Dry.mp3" dry2="37-H-48bpm-Dry.mp3"
      dry3="37-A-48bpm-Dry.mp3" reverb1="37-P-48bpm-Reverb.mp3" reverb2="37-H-48bpm-Reverb.mp3"
      reverb3="37-A-48bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_38" dry1="38-P-66bpm-Dry.mp3" dry2="38-H-66bpm-Dry.mp3"
      dry3="38-A-66bpm-Dry.mp3" reverb1="38-P-66bpm-Reverb.mp3" reverb2="38-H-66bpm-Reverb.mp3"
      reverb3="38-A-66bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_39" dry1="39-P-62bpm-Dry.mp3" dry2="39-H-62bpm-Dry.mp3"
      dry3="39-A-62bpm-Dry.mp3" reverb1="39-P-62bpm-Reverb.mp3" reverb2="39-H-62bpm-Reverb.mp3"
      reverb3="39-A-62bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_40" dry1="40-A-50bpm-Dry.mp3" dry2="40-P-50bpm-Dry.mp3"
      dry3="40-H-50bpm-Dry.mp3" reverb1="40-A-50bpm-Reverb.mp3" reverb2="40-P-50bpm-Reverb.mp3"
      reverb3="40-H-50bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_41" dry1="41-A-50bpm-Dry.mp3" dry2="41-H-50bpm-Dry.mp3"
      dry3="41-P-50bpm-Dry.mp3" reverb1="41-A-50bpm-Reverb.mp3" reverb2="41-H-50bpm-Reverb.mp3"
      reverb3="41-P-50bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_42" dry1="42-A-56bpm-Dry.mp3" dry2="42-P-56bpm-Dry.mp3"
      dry3="42-H-56bpm-Dry.mp3" reverb1="42-A-56bpm-Reverb.mp3" reverb2="42-P-56bpm-Reverb.mp3"
      reverb3="42-H-56bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_43" dry1="43-A-56bpm-Dry.mp3" dry2="43-P-56bpm-Dry.mp3"
      dry3="43-H-56bpm-Dry.mp3" reverb1="43-A-56bpm-Reverb.mp3" reverb2="43-P-56bpm-Reverb.mp3"
      reverb3="43-H-56bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_44" dry1="44-A-54bpm-Dry.mp3" dry2="44-P-54bpm-Dry.mp3"
      dry3="44-H-54bpm-Dry.mp3" reverb1="44-A-54bpm-Reverb.mp3" reverb2="44-P-54bpm-Reverb.mp3"
      reverb3="44-H-54bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_45" dry1="45-P-62bpm-Dry.mp3" dry2="45-H-62bpm-Dry.mp3"
      dry3="45-A-62bpm-Dry.mp3" reverb1="45-P-62bpm-Reverb.mp3" reverb2="45-H-62bpm-Reverb.mp3"
      reverb3="45-A-62bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_46" dry1="46-A-52bpm-Dry.mp3" dry2="46-H-52bpm-Dry.mp3"
      dry3="46-P-52bpm-Dry.mp3" reverb1="46-A-52bpm-Reverb.mp3" reverb2="46-H-52bpm-Reverb.mp3"
      reverb3="46-P-52bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_47" dry1="47-H-82bpm-Dry.mp3" dry2="47-P-82bpm-Dry.mp3"
      dry3="47-A-82bpm-Dry.mp3" reverb1="47-H-82bpm-Reverb.mp3" reverb2="47-P-82bpm-Reverb.mp3"
      reverb3="47-A-82bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_48" dry1="48-P-50bpm-Dry.mp3" dry2="48-H-50bpm-Dry.mp3"
      dry3="48-A-50bpm-Dry.mp3" reverb1="48-P-50bpm-Reverb.mp3" reverb2="48-H-50bpm-Reverb.mp3"
      reverb3="48-A-50bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_49" dry1="49-P-50bpm-Dry.mp3" dry2="49-H-50bpm-Dry.mp3"
      dry3="49-A-50bpm-Dry.mp3" reverb1="49-P-50bpm-Reverb.mp3" reverb2="49-H-50bpm-Reverb.mp3"
      reverb3="49-A-50bpm-Reverb.mp3"/>
    <mp3-filenames fugue-id="Fuga_50" dry1="50-A-56bpm-Dry.mp3" dry2="50-P-56bpm-Dry.mp3"
      dry3="50-H-56bpm-Dry.mp3" reverb1="50-A-56bpm-Reverb.mp3" reverb2="50-P-56bpm-Reverb.mp3"
      reverb3="50-H-56bpm-Reverb.mp3"/>

  </xsl:variable>

  <!-- MAIN TEMPLATE -->

  <xsl:template match="/">
    
    <xsl:message> Creating HTML/INC test page </xsl:message>
    <xsl:choose>
      <xsl:when test="$HTML-TEST-OUTPUT">
        <xsl:call-template name="main-HTML-wrapper"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="main-container"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- HTML wrapper, basically for testing purposes -->

  <xsl:template name="main-HTML-wrapper">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title>Test page for <xsl:value-of select="$emblem-id"/></title>
        <script src="notation.js"> </script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.2/TweenMax.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/2.1.2/plugins/ScrollToPlugin.min.js"></script>
        <link rel="stylesheet" href="notation.css"> </link>
      </head>
      <body>
        
        <h1>Test page for <xsl:value-of select="$emblem-id"/></h1>
        <p>
          <xsl:value-of  select="current-time()"/>
        </p>
        
        <!-- NOTE: .ata-music included for compatibility with Crystal's CSS -->

        <div class="music ata-music paused">

          <!-- Add with-JS classname -->

          <div class="transport" id="my-transport">
            <xsl:call-template name="transport-bar"/>
          </div>

          <!-- Audio elements -->

          <div class="audio">
            <xsl:call-template name="audio-tracks"/>
          </div>

          <!-- Common music notation 
               NOTE: .ata-viz-cmn included for compatibility with Crystal's CSS -->

          <div class="cmn ata-viz-cmn">
            <xsl:apply-templates select="/" mode="cmn"/>
          </div>

          <!-- Piano roll -->

          <div class="pianoroll lity-hide ata-viz-pianoroll" id="pianoroll-notation">
            <xsl:apply-templates select="/" mode="pianoroll"/>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- Regular include fragment -->

  <xsl:template name="main-container">

    <!-- NOTE: .ata-music included for compatibility with Crystal's CSS -->

    <div class="music ata-music paused loading">

      <!-- Add with-JS classname -->

      <div class="transport" id="my-transport">
        <xsl:call-template name="transport-bar"/>
      </div>

      <!-- Audio elements -->

      <div class="audio">
        <xsl:call-template name="audio-tracks"/>
      </div>

      <!-- Common music notation 
               NOTE: .ata-viz-cmn included for compatibility with Crystal's CSS -->

      <div class="cmn ata-viz-cmn">
        <xsl:apply-templates select="/" mode="cmn"/>
      </div>

      <!-- Piano roll -->

      <div class="pianoroll lity-hide ata-viz-pianoroll" id="pianoroll-notation">
        <xsl:apply-templates select="/" mode="pianoroll"/>
      </div>
    </div>
  </xsl:template>


  <!-- AUDIO TRACKS -->

  <xsl:template name="audio-tracks">

    <xsl:variable name="labels"
      select="/svg:svg/svg:svg//*[@class = 'system'][1]//*[@class = 'label']"/>

    <xsl:value-of select="$mp3-filenames-by-fugue[@fugue-id = $emblem-id]/@dry1"/>

    <!-- Unhidden with JS -->

    <audio hidden="hidden" preload="auto"
      src="{$AUDIO_DIR}{$mp3-filenames-by-fugue/mp3-filenames[@fugue-id=$emblem-id]/@dry1}"
      data-track="1" class="dry" type="audio/mpeg"/>
    <audio hidden="hidden" preload="auto"
      src="{$AUDIO_DIR}{$mp3-filenames-by-fugue/mp3-filenames[@fugue-id=$emblem-id]/@reverb1}"
      data-track="1" class="reverb" type="audio/mpeg"/>
    <audio hidden="hidden" preload="auto"
      src="{$AUDIO_DIR}{$mp3-filenames-by-fugue/mp3-filenames[@fugue-id=$emblem-id]/@dry2}"
      data-track="2" class="dry" type="audio/mpeg"/>
    <audio hidden="hidden" preload="auto"
      src="{$AUDIO_DIR}{$mp3-filenames-by-fugue/mp3-filenames[@fugue-id=$emblem-id]/@reverb2}"
      data-track="2" class="reverb" type="audio/mpeg"/>
    <audio hidden="hidden" preload="auto"
      src="{$AUDIO_DIR}{$mp3-filenames-by-fugue/mp3-filenames[@fugue-id=$emblem-id]/@dry3}"
      data-track="3" class="dry" type="audio/mpeg"/>
    <audio hidden="hidden" preload="auto"
      src="{$AUDIO_DIR}{$mp3-filenames-by-fugue/mp3-filenames[@fugue-id=$emblem-id]/@reverb3}"
      data-track="3" class="reverb" type="audio/mpeg"/>
  </xsl:template>


  <!-- TRANSPORT BAR -->


  <xsl:template name="transport-bar">

    <xsl:param name="includes-pianoroll" select="true()"/>

    <!-- Hidden without JS -->

    <button class="atalanta-notation-start" aria-label="Play Music">
      <div class="play-btn__icon"/>
      <div class="play-btn__label">Play</div>
    </button>

    <button class="atalanta-notation-stop" aria-label="Pause Music">
      <div class="pause-btn__icon"/>
      <div class="pause-btn__label">Pause</div>
    </button>

    <div class="track-mute">

      <button class="atalanta-notation-mute-track" aria-label="Play or Mute Voice 1" data-track="1">
        <div class="mute-btn__icon"/>
        <div class="mute-btn__label">Hear/mute <em>
            <xsl:value-of select="normalize-space(//svg:svg//svg:g[@class = 'label'][1])"/>
          </em>
        </div>
      </button>
      <button class="atalanta-notation-mute-track" aria-label="Play or Mute Voice 2" data-track="2">
        <div class="mute-btn__icon"/>
        <div class="mute-btn__label">Hear/mute <em>
            <xsl:value-of select="normalize-space(//svg:svg//svg:g[@class = 'label'][2])"/>
          </em>
        </div>
      </button>
      <button class="atalanta-notation-mute-track" aria-label="Play or Mute Voice 3" data-track="3">
        <div class="mute-btn__icon"/>
        <div class="mute-btn__label">Hear/mute <em>
            <xsl:value-of select="normalize-space(//svg:svg//svg:g[@class = 'label'][3])"/>
          </em>
        </div>
      </button>
    </div>

    <xsl:if test="$includes-pianoroll">
      <div class="atalanta-notation__switch">
        <a href="#pianoroll-notation" data-lity="">
          <div class="piano-roll__icon"/>
          <div class="piano-roll__label">Show piano roll</div>
        </a>
      </div>
    </xsl:if>

  </xsl:template>

  <!-- COMMON MUSIC NOTATION (CMN) -->

  <xsl:template match="/svg:svg" mode="cmn">

    <xsl:variable name="lowest-element" select="max(/svg:svg/svg:svg//@y) + 1000"/>

    <xsl:copy>

      <xsl:attribute name="preserveAspectRatio" select="'xMinYMin'"/>

      <!-- Move viewBox on child SVG to parent SVG -->
      
      <xsl:attribute name="viewBox"
        select="concat(replace(/svg:svg/svg:svg/@viewBox, '(\d+ \d+ \d+ )\d+', '$1'), $lowest-element)"/>
      
      <!-- Recurse to children -->
      
      <xsl:apply-templates select="@* | node()" mode="cmn"/>
      
      <!-- Add filter for highlighted note -->
      
      <filter id="highlighting" x="-50%" y="-50%" width="200%" height="200%">
        <feFlood flood-color="#000000" result="base"></feFlood>
        <feGaussianBlur in="SourceAlpha" result="blur-out" stdDeviation="50"></feGaussianBlur>
        <feOffset in="blur-out" result="the-shadow"></feOffset>
        <feColorMatrix in="the-shadow" result="color-out" type="matrix" 
          values="0 0 0 0   0 
          0 0 0 0   0 
          0 0 0 0   0
          0 0 0 1.5 0"></feColorMatrix>
        <feComposite result="drop" in="base" in2="color-out" operator="in"></feComposite>
        <feBlend in="SourceGraphic" in2="drop" mode="normal"></feBlend>
      </filter>
    </xsl:copy>
  </xsl:template>

  <!-- Some attributes on the SVG element to delete -->

  <xsl:template match="/svg:svg/@overflow" mode="cmn"/>
  <xsl:template match="/svg:svg/@height" mode="cmn"/>
  <xsl:template match="/svg:svg/@width" mode="cmn"/>
  <xsl:template match="/svg:svg/svg:svg/@viewBox" mode="cmn"/>
  <xsl:template match="/svg:svg/@xmlns" mode="cmn"/>

  <!-- Find largest y value and add it to end of @viewBox, e.g.
    
       0 0 21000 300000 -> 0 0 21000 65000 
  
  -->

  <!-- Insert timestamp attributes on SVG nodes if present in 04_timetable.xml -->

  <xsl:template match="/svg:svg/svg:svg//*[@id]" mode="cmn">

    <xsl:copy>
      <xsl:if test="$timetable/element[@id = current()/@id]">
        <xsl:attribute name="data-time-start"
          select="$timetable/element[@id = current()/@id]/@start"/>
        <xsl:attribute name="data-time-end" select="$timetable/element[@id = current()/@id]/@end"/>
      </xsl:if>
      <xsl:apply-templates select="@* | node()" mode="cmn"/>
    </xsl:copy>
  </xsl:template>

  <!-- When all else fails: copy SVG through -->

  <xsl:template match="@* | node()" mode="cmn">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="cmn"/>
    </xsl:copy>
  </xsl:template>

  <!-- PIANOROLL -->

  <xsl:template match="/" mode="pianoroll">
    <div class="transport">
      <xsl:call-template name="transport-bar">
        <xsl:with-param name="includes-pianoroll" select="false()"/>
      </xsl:call-template>
    </div>
    <svg width="100%">
      <xsl:apply-templates select="//*[@class = 'note']" mode="pianoroll"/>
    </svg>
  </xsl:template>

  <!-- Match notes that are in the timetable -->

  <xsl:template match="//*[@class = 'note']" mode="pianoroll">

    <xsl:if test="$timetable/element[@id = current()/@id]">

      <xsl:variable name="start-time" select="$timetable/element[@id = current()/@id]/@start"/>
      <xsl:variable name="end-time" select="$timetable/element[@id = current()/@id]/@end"/>
      <xsl:variable name="pitch-number"
        select="$timetable/element[@id = current()/@id]/@pitch-number"/>
      <xsl:variable name="track-number"
        select="count(./ancestor::*[@class = 'staff']/preceding-sibling::*[@class = 'staff']) + 1"/>

      <rect class="note voice-{$track-number}" id="{@id}-pianoroll" height="{$pianoroll-bar-height}"
        data-time-start="{$start-time}" data-time-end="{$end-time}">
        <xsl:attribute name="x"
          select="($start-time - $start-time-offset) * $pianoroll-pixels-per-second"/>
        <xsl:attribute name="width"
          select="($end-time - $start-time) * $pianoroll-pixels-per-second"/>
        <xsl:attribute name="y" select="($highest-pitch - $pitch-number) * $pianoroll-bar-height"/>
      </rect>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
