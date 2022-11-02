import * as React from 'react';
import { StyleSheet, View } from 'react-native';
import { Avatar, Button, Text } from 'react-native-paper';
import { useSelector } from 'react-redux';
import { createClock, getUserStatus } from '../../http/api';
import { useAlert } from '../../hooks/alert';

const toAbbreviateIconLabel = (string = "") => string.slice(0, 2).toUpperCase()

const CLockInOutForm = () => {


    const [timeIntervalRef, setTimeIntervalRef] = React.useState(null)
    const { alert, setAlert, component: Snackbar } = useAlert()
    const currentUser = useSelector((state) => state.currentUser.value)

    const [status, setStatus] = React.useState(null)
    const [elapsedTimeSinceArrival, setElapsedTimeSinceArrival] = React.useState(null)

    React.useEffect(() => {
        if (currentUser) {
            getUserStatus(currentUser.token, currentUser.user.id).then((status) => setStatus(status.data ? status.data : "no data"))
        }
    }, [currentUser])


    React.useEffect(() => {
        if (status && status.time && status.status && !timeIntervalRef) {
            setTimeIntervalRef(
                setInterval(() => {
                    setElapsedTimeSinceArrival(calculateElapsedTimeSinceArrival(status.time))
                }, 1000)
            )
        }
        if (status && !status.status && timeIntervalRef) {
            clearInterval(timeIntervalRef)
            setTimeIntervalRef(null)
            setElapsedTimeSinceArrival(null)
        }
    }, [status, timeIntervalRef])


    React.useEffect(() => () => {
        if (timeIntervalRef) {
            clearInterval(timeIntervalRef)
            setTimeIntervalRef(null)
            setElapsedTimeSinceArrival(null)
        }
    }, []);


    const handleCloseAlert = () => {
        setAlert({
            toggled: false,
            message: "",
            severity: "error"
        })
    }

    const handleSubmit = async () => {
        let message = "";
        let severity = "error"
        try {
            const { data } = await createClock(currentUser.token, currentUser.user.id)
            setStatus(data)
            message = data.status ? "Arrival registered with success" : "Departure registered with success";
            severity = "success";
        } catch (error) {
            message = "An unexpected error has been encountered, please try again later or contact tour administrator"
        } finally {
            setAlert({
                toggled: true,
                message,
                severity
            })
        }
    }

    const calculateElapsedTimeSinceArrival = (arrivalTimeSeconds) => {
        const elapsedTimeSeconds = Math.round(Date.now() / 1000) - arrivalTimeSeconds
        const hours = Math.floor(elapsedTimeSeconds / 3600)
        const minutes = Math.floor((elapsedTimeSeconds - (hours * 3600)) / 60)
        const seconds = Math.floor(elapsedTimeSeconds - ((hours * 3600) + (minutes * 60)))
        return {
            hours,
            minutes,
            seconds
        }
    }

    return (
        <>
            <View style={styles.container}>
                <View style={styles.avatarContainer}>
                    <Avatar.Text size={200} label={
                        toAbbreviateIconLabel(currentUser ? currentUser.user.email : "")
                    } />
                </View>
                <View style={styles.elapsedTimeContainer}>
                    {elapsedTimeSinceArrival &&
                        <Text variant="headlineMedium">
                            {elapsedTimeSinceArrival.hours}:
                            {elapsedTimeSinceArrival.minutes}:
                            {elapsedTimeSinceArrival.seconds}
                        </Text>
                    }
                </View>
                {status && <Button mode="contained" onPress={handleSubmit}>
                    {!status.status ? "Just arrived !" : "Going back home !"}
                </Button>}
            </View>
            <Snackbar onClose={handleCloseAlert} toggled={alert.toggled} message={alert.message} severity={alert.severity} />
        </>
    );
};

const styles = StyleSheet.create({
    container: {
        width: "100%",
    },
    avatarContainer: {
        width: "100%",
        justifyContent: "center",
        alignItems: "center",
        marginBottom: 24
    },
    elapsedTimeContainer: {
        width: "100%",
        justifyContent: "center",
        alignItems: "center",
        marginBottom: 24
    }
});

export default CLockInOutForm;