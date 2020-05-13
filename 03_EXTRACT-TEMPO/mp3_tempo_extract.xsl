<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:m="http://apple.com/core_audio/audio_info"
  xmlns:mei="http://www.music-encoding.org/ns/mei"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  exclude-result-prefixes="xs" version="2.0">


  <!-- Main: extract length information for each MP3 file -->
  
  <xsl:template match="/">
    <audio-lengths>
      <xsl:apply-templates select=".//m:audio_file"/>
    </audio-lengths>
  </xsl:template>

  <!-- For each audio file, get the corresponding MEI file and calculate the estimated BPM and lead time -->

  <xsl:template match="//m:audio_file">
    
    <xsl:variable name="mp3_filename" select="./m:file_name" />
    <xsl:variable name="fugue_number" select="substring-before($mp3_filename, '-')" />
    <xsl:variable name="length_in_seconds" select="number(./m:tracks/m:track[1]/m:duration)" />
    <xsl:variable name="length_in_minutes" select="$length_in_seconds div 60" />
    
    <xsl:variable name="mei_filename" select="concat('../03_MEI_CLEAN/Fuga_', $fugue_number, '.xml')" />
    <xsl:variable name="mei_doc" select="document($mei_filename)" />
    <xsl:variable name="number_of_measures" 
      select="count($mei_doc/mei:mei/mei:music[1]/mei:body[1]/mei:mdiv[1]/mei:score[1]/mei:section[1]/mei:measure)" />
    
    <xsl:variable name="beats_per_measure"
      select="number($mei_doc/mei:mei/mei:music[1]/mei:body[1]/mei:mdiv[1]/mei:score[1]/mei:scoreDef[1]/@meter.count)" />
    
    <xsl:variable name="total_beat_count"
      select="$number_of_measures * $beats_per_measure" />
    
    <xsl:variable name="bpm"
      select="$total_beat_count div $length_in_minutes"/>
    
    <audio-file 
      filename="{$mp3_filename}" 
      mei-filename="{$mei_filename}"
      length-secs="{$length_in_seconds}"
      length-mins="{$length_in_minutes}"
      number-of-measures="{$number_of_measures}"
      beats-per-measure="{$beats_per_measure}"
      beat-count="{$total_beat_count}"
      bpm="{$bpm}"
      > </audio-file>
  </xsl:template>
  
</xsl:stylesheet>
