import {
    LineChart,
    BarChart,
    PieChart,
    ProgressChart,
    ContributionGraph,
    StackedBarChart
} from "react-native-chart-kit";

import * as React from 'react';

const ApplicationLineChart = ({
    legend = ["Rainy days"],
    width = 400,
    labels = ["January", "February", "March", "April", "May", "June"],
    datasets = [
        [20, 45, 28, 80, 99, 43],
        [10, 3, 2, 100, 10, 50]
    ]
}) => {
    const chartConfig = {
        backgroundColor: "#FFF",
        backgroundGradientFrom: "#FFF",
        backgroundGradientTo: "#FFF",
        decimalPlaces: 2, // optional, defaults to 2dp
        color: (opacity = 255) => `rgba(0, 0, 0, ${opacity})`,
        style: {
            borderRadius: 16,
        },
    };
    const data = {
        labels: labels,
        datasets: datasets.map((dataset) => ({
            data: dataset,
            color: (opacity = 1) => "#5393ff", // optional
            strokeWidth: 2 // optional
        })),
        legend: legend // optional
    };
    return <LineChart
        data={data}
        width={width}
        height={220}
        chartConfig={chartConfig}
    />
}

export default ApplicationLineChart