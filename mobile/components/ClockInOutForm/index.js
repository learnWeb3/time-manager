import React , {useEffect,useState} from 'react';
import { ScrollView, StyleSheet, View, Image, Dimensions } from 'react-native';
import { Button, Text } from 'react-native-paper';
import { useSelector, useDispatch } from 'react-redux';
import { createClock, getUserStatus } from '../../http/api';
import { useAlert } from '../../hooks/alert';
import { ApplicationDate } from '../../date/index';
import { addNewCurrentUserClock } from '../../stores/reducers/currentUserClocksReducer';

const CLockInOutForm = () => {

    const dispatch = useDispatch();
    const [timeIntervalRef, setTimeIntervalRef] = React.useState(null)
    const { alert, setAlert, component: Snackbar } = useAlert()
    const currentUser = useSelector((state) => state.currentUser.value)
    const [status, setStatus] = React.useState(null)
    const [elapsedTimeSinceArrival, setElapsedTimeSinceArrival] = React.useState(null);
    const [isLandscape, setIsLandscape] = React.useState(false);

    React.useEffect(() => {
        if (currentUser) {
            getUserStatus(currentUser.token, currentUser.user.id).then((status) => setStatus(status.data ? status.data : "no data"))
        }
    }, [currentUser])

    // useEffect(()=>{
    //     console.log("test")
    //     const dim = Dimensions.get('screen');
    //     if (dim.width >= dim.height){
    //         setIsLandscape(true);
    //     }else{
    //         setIsLandscape(false);
    //     }
    //     })


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

    return (

        <ScrollView contentContainerStyle={styles.scrollView}>
            <View style={styles.container}>
                <View style={{flex:2}}>
                    <Text variant="bodyMedium" style={{marginTop:"100%",fontSize:40, color:"#001f54", fontFamily:"Poppins" }}> {!elapsedTimeSinceArrival ?  "Clock in" : " Clock Out" }</Text>
                </View>
                <View  style={{flex:2,alignItems: 'center', justifyContent: 'center'}}>
                    <Button  onPress={handleSubmit}>
                        {!elapsedTimeSinceArrival ?<Image style={{height:250 ,width:250, resizeMode: 'stretch', shadowColor: '#171717',shadowOffset: {width: -2, height: 4},shadowOpacity: 0.2,shadowRadius: 3 }} source={require('../../assets/addClockin.png')} ></Image> 
                        :<Image  style={{height: 250 ,width:250, resizeMode: 'stretch', shadowColor: '#171717',shadowOffset: {width: -2, height: 4},shadowOpacity: 0.2,shadowRadius: 3 }} source={require('../../assets/addClockOut.png')} ></Image>  }
                    </Button> 
                </View>
                
                <View style={{flex:2, alignItems: 'center', justifyContent: 'center'}}>
                    <Text style={{color:"#001f54", fontSize:40, fontFamily:"Poppins"}}>Presence time </Text>
                    <Text variant="titleSmall" style={{marginTop:30,fontSize:40, fontFamily:"Orbitron"}}>
                        {elapsedTimeSinceArrival ? `${elapsedTimeSinceArrival.hours}:${elapsedTimeSinceArrival.minutes}:${elapsedTimeSinceArrival.seconds}` : "00:00:00"}
                    </Text>
                </View>


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
        borderRadius: "50%",
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