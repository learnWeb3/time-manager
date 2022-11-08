import * as React from 'react';
import { ScrollView, StyleSheet, View } from 'react-native';
import { Button, Text } from 'react-native-paper';
import { useSelector, useDispatch } from 'react-redux';
import { createClock } from '../../http/api';
import { useAlert } from '../../hooks/alert';
import { ApplicationDate } from '../../date/index';
import { addNewCurrentUserClock } from '../../stores/reducers/currentUserClocksReducer';
import { setCurrentUserStatus } from '../../stores/reducers/currentUserStatusReducer';

const CLockInOutForm = () => {

    const dispatch = useDispatch();
    const [timeIntervalRef, setTimeIntervalRef] = React.useState(null)
    const { alert, setAlert, component: Snackbar } = useAlert()
    const currentUser = useSelector((state) => state.currentUser.value)
    const status = useSelector((state) => state.currentUserStatus.value)

    const [elapsedTimeSinceArrival, setElapsedTimeSinceArrival] = React.useState(null)


    React.useEffect(() => {
        if (status && status.time && status.status && !timeIntervalRef) {
            setTimeIntervalRef(
                setInterval(() => {
                    setElapsedTimeSinceArrival(ApplicationDate.calculateElapsedTimeSince(status.time))
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
            const { data } = await createClock(currentUser.token, currentUser.user.id, {
                clock: {
                    time: Math.floor(
                        Date.now() / 1000
                    )
                }
            })
            dispatch(addNewCurrentUserClock(data))
            dispatch(setCurrentUserStatus(data))
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

    return (

        <ScrollView contentContainerStyle={styles.scrollView}>
            <View style={styles.container}>

                <Text variant="bodyMedium" style={{ marginBottom: 16, marginTop: 16 }}>Press to clock in/out</Text>

                <Button buttonColor={status && status.status || !status ? "#e91e63" : "#5393ff"} mode="contained" onPress={handleSubmit} style={styles.clockInOutButton}>
                    <Text variant="titleSmall" style={{ color: "#FFF" }}>
                        {elapsedTimeSinceArrival ? `${elapsedTimeSinceArrival.hours}:${elapsedTimeSinceArrival.minutes}:${elapsedTimeSinceArrival.seconds}` : "Just arrived !"}
                    </Text>
                </Button>

                <Snackbar onClose={handleCloseAlert} toggled={alert.toggled} message={alert.message} severity={alert.severity} />
            </View>
        </ScrollView>

    );
};

const styles = StyleSheet.create({
    scrollView: {
        height: "100%",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
    },
    clockInOutButton: {
        height: 180,
        width: 180,
        borderRadius: 90,
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 10 },
        shadowOpacity: 0.2,
        shadowRadius: 10,
    },
    container: {
        width: "100%",
        height: "100%",
        position: "relative",
        justifyContent: "center",
        alignItems: "center",
        flex: 1,
    },
    elapsedTimeContainer: {
        width: "100%",
        justifyContent: "center",
        alignItems: "center",
        marginBottom: 24
    }
});

export default CLockInOutForm;