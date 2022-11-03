import moment from "moment";


export class ApplicationDate {

    static format(timeinseconds) {
        return moment(new Date(timeinseconds * 1000))
            .format('MMMM Do YYYY, h:mm:ss');
    }

    static addTrailingZero(value) {
        if (value < 10) {
            return `0${value}`
        }else{
            return `${value}`
        }
    }

    static calculateElapsedTimeSince = (timeinseconds) => {
        const elapsedTimeSeconds = Math.round(Date.now() / 1000) - timeinseconds
        const hours = Math.floor(elapsedTimeSeconds / 3600)
        const minutes = Math.floor((elapsedTimeSeconds - (hours * 3600)) / 60)
        const seconds = Math.floor(elapsedTimeSeconds - ((hours * 3600) + (minutes * 60)))
        return {
            hours: ApplicationDate.addTrailingZero(hours),
            minutes: ApplicationDate.addTrailingZero(minutes),
            seconds: ApplicationDate.addTrailingZero(seconds)
        }
    }

}