<template>
    <div>
        <Line :data="chartData" :option="chartOption" />
    </div>
</template>

<script>
import moment from "moment";
import { Line } from 'vue-chartjs'
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'
import { baseApiUrl} from "@/components/services/api";

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)
export default {
    name:"lineChartMonthsSpecificUser",
    components: { Line },

    data() {
        return {
            chartData: null,
            filteredData: null,
            chartOption: null,
            data: null
        }
    },
    
    props: {
        selectedUserId: String
    },

    created() {
        this.workingTimeUserSelected();
    },

    methods: {

        async workingTimeUserSelected() {
            const now = moment();
            const startOfMonth = now.clone().startOf('month');
            const endOfMonth = now.clone().endOf('month');
            const start = startOfMonth.format('YYYY-MM-DD');
            const end = endOfMonth.format('YYYY-MM-DD');
            const apiUrl = `${baseApiUrl}/api/workingtimes/${this.selectedUserId}?start=${start}&end=${end}`;
            try {
                const response = await fetch(apiUrl, {
                    mode: "cors",
                    headers: {
                        "Authorization": `Bearer ${this.$store.state.xsrfToken}`
                    }
                })
                if (response.status === 200) {
                    const responseData = await response.json();
                    this.data = responseData.data;
                    this.fetchChartData();
                }
            } catch (error) {
                console.log(error);
            }
        },

        fetchChartData() {
            const workDurationByDay = {};
            const datetimeStartNight = moment('21:00:00', 'HH:mm:ss');
            const datetimeStopNight = moment('06:00:00', 'HH:mm:ss');
            let nightDuration = null;
            let dayDuration = null;
            const now = moment();
            const startOfMonth = now.clone().startOf('month');
            const endOfMonth = now.clone().endOf('month');
            
            this.data.filter(entry => {
                const entryDate = moment(entry.start);
                return entryDate.isBetween(startOfMonth, endOfMonth, null, '[]');
            });
            this.filteredData.forEach((entry) => {
                const startDate = moment(entry.start);
                const endDate = moment(entry.end);
                // Récupérer uniquement les heures du start et end pour les comparer aux horaires de nuits.
                const startTime = moment(startDate.format('HH:mm:ss'), 'HH:mm:ss');
                const endTime = moment(endDate.format('HH:mm:ss'), 'HH:mm:ss');
                const day = startDate.format('YYYY-MM-DD');

                if (startTime.isAfter(datetimeStartNight)) {
                    if (endTime.isBefore(datetimeStopNight)) {
                        nightDuration = endTime.diff(startTime, 'hours');
                        dayDuration = 0;
                    } else {
                        nightDuration = datetimeStopNight.diff(startTime, 'hours');
                        dayDuration = endTime.diff(datetimeStopNight, 'hours');
                    }
                } else {
                    if (endTime.isAfter(datetimeStartNight)) {
                        dayDuration = startTime.diff(datetimeStartNight, 'hours');
                        nightDuration = endTime.diff(datetimeStartNight, 'hours');
                    }
                    else {
                        dayDuration = endTime.diff(startTime, 'hours');
                        nightDuration = 0;
                    }
                }

                if (workDurationByDay[day]) {
                    workDurationByDay[day].night += nightDuration;
                    workDurationByDay[day].day += dayDuration;
                } else {
                    workDurationByDay[day] = {
                        night: nightDuration,
                        day: dayDuration
                    };
                }   
            });

            this.chartData = {
                labels: Object.keys(workDurationByDay),
                datasets: [{
                    label: "Nombre d'heures effectives",
                    data: Object.keys(workDurationByDay).map(day => workDurationByDay[day].night + workDurationByDay[day].day),
                    backgroundColor: '#5AB1C0'
                },
                   {
                       label: "Nombre d'heures théoriques",
                       data: Array(Object.keys(workDurationByDay).length).fill(8),
                       backgroundColor: 'rgba(178, 223, 138, 0.80)', 
                   },
               ],
            };

            this.chartOption = {
                title: {
                    text: 'Temps de travail par jours du mois en cours',
                },
                maintainAspectRatio: false,
                //le graphique s'adaptera à la taille du conteneur. Bien définir W et H de la Div
                responsive: true,
                scales: {
                    x: {
                        beginAtZero: true
                    },
                    y: {
                        beginAtZero: true
                    }
                }
            };
        },
    }
}
</script>