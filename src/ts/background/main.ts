/// <reference path='../types/chrome/chrome.d.ts'/>

const ALARM_PREFIX: string = 'ALARM_';
const enum State {
    SIT,
    STAND
}

const getAlarmName = (state: State): string => {
    return ALARM_PREFIX + state.toString();
}

const abstractEvent = (nextAction: State, message?: string): void => {
    chrome.alarms.create(getAlarmName(nextAction), { delayInMinutes: 30 });

    chrome.alarms.getAll((alarms: chrome.alarms.Alarm[]): void => {
        alarms.forEach((alarm: chrome.alarms.Alarm): void => {
            console.log(alarm);
        });
    });
    console.log(message);

    if (message) {
        chrome.notifications.create({
            type: "basic",
            iconUrl: "images/icon128.png",
            title: message,
            message: message
        });
    }
}

const sitEvent = abstractEvent.bind(null, State.SIT, "Sit Down");
const standEvent = abstractEvent.bind(null, State.STAND, "Stand Up");

chrome.runtime.onInstalled.addListener((details: chrome.runtime.InstalledDetails): void => {
    chrome.alarms.clearAll();

    abstractEvent(State.SIT);

    console.log('installed');

    chrome.alarms.onAlarm.addListener((alarm: chrome.alarms.Alarm): void => {
        if (alarm.name == getAlarmName(State.SIT)) {
            standEvent();
        }
        else {
            sitEvent();
        }
    });
});



