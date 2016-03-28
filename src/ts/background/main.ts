/// <reference path='../types/chrome/chrome.d.ts'/>

const ALARM_PREFIX: string = 'ALARM_';
const DELAY_KEY: string = 'delay';
const MINUTE: number = 60 * 1000;

enum Action {
    SIT,
    STAND
}

//default time to 30m
if (localStorage.getItem(DELAY_KEY) == null) {
    localStorage.setItem(DELAY_KEY, String(30));
}

const debug = (): void => {
    chrome.alarms.getAll((alarms: chrome.alarms.Alarm[]): void => {
        alarms.forEach((alarm: chrome.alarms.Alarm): void => {
            console.log(alarm.name, (new Date(alarm.scheduledTime)).toLocaleString());
        });
    });
}


/**

Create the events

**/
const abstractEvent = (nextAction: Action, message?: string): void => {
    chrome.alarms.getAll((alarms: chrome.alarms.Alarm[]): void => {
        //clear out any other alarms
        alarms.forEach((alarm: chrome.alarms.Alarm): void => {
            chrome.alarms.clear(alarm.name);
        });

        //create the next alarm
        const delay: number = parseInt(localStorage.getItem(DELAY_KEY));
        chrome.alarms.create(Action[nextAction], { delayInMinutes: delay });
    });

    //show the notification
    if (message) {
        chrome.notifications.create({
            type: "basic",
            iconUrl: "images/icon128.png",
            title: message,
            message: message
        });
    }
}
const sitEvent = abstractEvent.bind(null, Action.STAND, "Sit Down");
const standEvent = abstractEvent.bind(null, Action.SIT, "Stand Up");


/**

Register the events

**/
chrome.alarms.onAlarm.addListener((alarm: chrome.alarms.Alarm): void => {
    const currentTime = new Date().getTime();

    //if our event is too old make sure an alarm exists, and ignore this one
    if ((currentTime - MINUTE) > alarm.scheduledTime || (currentTime + MINUTE) < alarm.scheduledTime) {
        ensureAlarm();

        return;
    }

    if (alarm.name === Action[Action.STAND]) {
        standEvent();
    }
    else {
        sitEvent();
    }
});


/**

Create alarms on startup

**/
const ensureAlarm = (): void => {
    //start a new alarm if we don't have an existing one
    chrome.alarms.getAll((alarms: chrome.alarms.Alarm[]): void => {
        if (alarms.length <= 0) {
            abstractEvent(Action.SIT);
        }
    });
}

chrome.runtime.onInstalled.addListener(ensureAlarm);
chrome.runtime.onStartup.addListener(ensureAlarm);