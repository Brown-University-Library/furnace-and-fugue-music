
# This is a sample script to take the file 01_INIT_MEI/Fuga_01.xml
# (exported from Sibelius) through to its final publication
# format: a HTML/SVG fragment that is inserted into the larger 
# publication pipeline.

# The full script repeats the same process for all files (1 through 50)
# All XSLT processing was done using Saxon (http://www.saxonica.com/)
#    THANK YOU Michael Kay and team Saxon!

# 1: Clean the MEI exported from Sibelius and run it through HTML tidy (https://www.w3.org/People/Raggett/tidy/)
#    THANK YOU Dave Raggett!

java -jar saxon.jar -s:01_INIT_MEI/Fuga_01.xml -xsl:02_MEI_CLEAN.xsl | tidy -xml -i -q -w 0 > "03_MEI_CLEAN/Fuga_01.xml"

# 2: Create common music notation using Verovio (https://www.verovio.org/)
#    THANK YOU team Verovio!

verovio --no-footer --page-height 30000 --scale 30 -o "05_SVG/Fuga_01.svg" 03_MEI_CLEAN/Fuga_01.xml

# 3: Prepare the clean MEI for timing extraction using XSL Transform

tail -n +2 "03_MEI_CLEAN/Fuga_01.xml" | java -jar saxon.jar -s:- -xsl:02_MEI_CLEAN_FOR_TIMING.xsl > "03_MEI_CLEAN_FOR_TIMING/Fuga_01.xml"

# 4: Create an XML file in 04_TIMING/fugue_timing/ that maps SVG notation elements
#    to a begin time and an end time in the audio recording

04_TIMING/makeTimingJSON-node.js Fuga_01.xml

# 5: Create the HTML+SVG fragment, ready for input into larger publication pipeline

java -jar saxon.jar -s:05_SVG/Fuga_01.svg -xsl:06_MAKE_HTML.xsl ?HTML-TEST-OUTPUT="false()"  > "06_HTML/01_emblem-music.inc"
