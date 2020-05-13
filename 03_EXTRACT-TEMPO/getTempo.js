



// const out = document.body;

let timeTable = {};

const 
  MAX_TIME = 10000,
  TIME_INCREMENT = 20,
  MEI_FILE_DIR = '../03_MEI_CLEAN/',
  meiFilenameStems = [
    'Fuga_01' ,	'Fuga_09',	'Fuga_16',	'Fuga_23',	'Fuga_30',	'Fuga_37',	'Fuga_44',
    'Fuga_02',	'Fuga_10',	'Fuga_17',	'Fuga_24',	'Fuga_31',	'Fuga_38',	'Fuga_45',
    'Fuga_03',	'Fuga_11',	'Fuga_18',	'Fuga_25',	'Fuga_32',	'Fuga_39',	'Fuga_46',
    'Fuga_04',	'Fuga_12',	'Fuga_19',	'Fuga_26',	'Fuga_33',	'Fuga_40',	'Fuga_47',
    'Fuga_05',	'Fuga_13',	'Fuga_20',	'Fuga_27',	'Fuga_34',	'Fuga_41',	'Fuga_48',
    'Fuga_06',	'Fuga_14',	'Fuga_21',	'Fuga_28',	'Fuga_35',	'Fuga_42',	'Fuga_49',
    'Fuga_08',	'Fuga_15',	'Fuga_22',	'Fuga_29',	'Fuga_36',	'Fuga_43',	'Fuga_50'
  ],

  // Tempos taken from the Google sheet at 
  //  https://docs.google.com/spreadsheets/d/12t4MRI9iEHTgDqw9dvnAegun80iOw2NpVNAxHykvhmc/edit?usp=sharing

  TEMPOS = {									
		'Fuga_01': { 	"lead":	0.5	,	"tempo":	39	}	,
		'Fuga_02': { 	"lead":	2	,	"tempo":	77	}	,
		'Fuga_03': { 	"lead":	1	,	"tempo":	45	}	,
		'Fuga_04': { 	"lead":	0	,	"tempo":	54	}	,
		'Fuga_05': { 	"lead":	0	,	"tempo":	90	}	,
		'Fuga_06': { 	"lead":	0	,	"tempo":	56	}	,
		'Fuga_07': { 	"lead":	0	,	"tempo":	50	}	,
		'Fuga_08': { 	"lead":	0	,	"tempo":	50	}	,
		'Fuga_09': { 	"lead":	0	,	"tempo":	58	}	,
		'Fuga_10': { 	"lead":	0.5	,	"tempo":	68	}	,
		'Fuga_11': { 	"lead":	0.5	,	"tempo":	56	}	,
		'Fuga_12': { 	"lead":	1	,	"tempo":	50	}	,
		'Fuga_13': { 	"lead":	0	,	"tempo":	46	}	,
		'Fuga_14': { 	"lead":	1	,	"tempo":	58	}	,
		'Fuga_15': { 	"lead":	0	,	"tempo":	66	}	,
		'Fuga_16': { 	"lead":	1	,	"tempo":	48	}	,
		'Fuga_17': { 	"lead":	0	,	"tempo":	77	}	,
		'Fuga_18': { 	"lead":	1	,	"tempo":	42	}	,
		'Fuga_19': { 	"lead":	1	,	"tempo":	50	}	,
		'Fuga_20': { 	"lead":	1	,	"tempo":	60	}	,
		'Fuga_21': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_22': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_23': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_24': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_25': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_26': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_27': { 	"lead":	0	,	"tempo":	39	}	,
		'Fuga_28': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_29': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_30': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_31': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_32': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_33': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_34': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_35': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_36': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_37': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_38': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_39': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_40': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_41': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_42': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_43': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_44': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_45': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_46': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_47': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_48': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_49': { 	"lead":	0	,	"tempo":	55	}	,
		'Fuga_50': { 	"lead":	0	,	"tempo":	55	}	
};

let mei_count = 0;

// Go through each filename stem and get the MEI, then call doVerovio()

function main() {
  meiFilenameStems.forEach(meiFilenameStem => {
    const meiFilename = `${MEI_FILE_DIR}${meiFilenameStem}.xml`
    console.log(`Getting timing for ${meiFilename}`);
    fetch(meiFilename)
      .then(response => response.text())
      .then(mei => doVerovio(mei, meiFilenameStem));
  });
}

// Load MEI in verovio and add note times to timeTable

function doVerovio(mei, meiFilenameStem) {

  let thisMeiTimeTable = {};
// console.log(mei);
  let verovioToolkit = new verovio.toolkit();
  verovioToolkit.loadData(mei);
  verovioToolkit.renderToMIDI();

  // Incrementally move through times

  for (let timeInMilliseconds = 0; 
        timeInMilliseconds < MAX_TIME; 
        timeInMilliseconds += TIME_INCREMENT) {

    // Get xml:id's of notes playing at current time

    verovioToolkit.getElementsAtTime(timeInMilliseconds).notes.forEach(
      noteId => {
        if (thisMeiTimeTable[noteId] === undefined) {
          thisMeiTimeTable[noteId] = [ convertBeatsToSeconds(timeInMilliseconds, meiFilenameStem) ];
        } else {
          thisMeiTimeTable[noteId][1] = convertBeatsToSeconds(timeInMilliseconds, meiFilenameStem);
        }
      }
    );
  }

  timeTable[meiFilenameStem] = thisMeiTimeTable;
  mei_count++;
  console.log(`MEI FILES PROCESSED: ${mei_count}/${meiFilenameStems.length}`);
  document.body.innerHTML = `<pre>${prettyPrintTimeTableXML(timeTable)}</pre>`;
}


function convertBeatsToSeconds(timeInBeats, meiFilenameStem) {
  const timeInMinutes  = timeInBeats / 60000,
        bpm = TEMPOS[meiFilenameStem].tempo,
        leadInSeconds = TEMPOS[meiFilenameStem].lead; // TODO: Finish this 
console.log(TEMPOS[meiFilenameStem].lead);
  return (bpm * timeInMinutes) + leadInSeconds;
}

function prettyPrintTimeTableJSON(timeTable) {
  let text = '';

  Object.keys(timeTable).sort().forEach(filename => {
    const e = JSON.stringify(timeTable[filename]);
    text += `  "${filename}":${e}\n`;
  });

  return `{\n${text}\n}`;
}

function prettyPrintTimeTableXML(timeTable) {

  let text = '';

  Object.keys(timeTable).sort().forEach(filename => {
    const e = Object.entries(timeTable[filename])
      .map(entry => `
        &lt;element id='${entry[0]}' start='${entry[1][0]}' end='${entry[1][1]}' />`)
      .join('');
    text += `  &lt;fugue id="${filename}">${e}\n  &lt;/fugue>\n`;
  });

  return `&lt;timetable>\n${text}\n&lt;/timetable>`;
}





main();


