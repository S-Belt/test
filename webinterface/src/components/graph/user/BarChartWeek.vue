<template>
    <p>Temps de travail de la semaine en cours</p>
    <div>
        <Bar v-if="chartData" :data="chartData" :options="chartOption" />
    </div>
</template>

<script>
import moment from "moment";
import { Bar } from 'vue-chartjs'
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'
import { baseApiUrl } from "@/components/services/api";

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)
export default {
    name:"barchartWeek",
    components: { Bar },
    
    data() {
        return {
            chartData: null,
            data: null,
            chartOption: null
        }
    },
    
    created() {
        this.getWT();
    },
    
    computed: {
        //get user from store
        user () {
            return this.$store.state.user;
        },
    },
    
    methods: {

        async getWT() {
            const now = moment();
            const startOfWeek = now.clone().startOf('isoWeek');
            const endOfWeek = now.clone().endOf('isoWeek');
            const start = startOfWeek.format('YYYY-MM-DD');
            const end = endOfWeek.format('YYYY-MM-DD');
            const apiUrl = `${baseApiUrl}/workingtimes/${this.user.id}?start:${start}&end:${end}`;
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
                console.log(error)
            }
        },
        
        fetchChartData() {
            const workDurationByDay = {};
            const datetimeStartNight = moment('21:00:00', 'HH:mm:ss');
            const datetimeStopNight = moment('06:00:00', 'HH:mm:ss');
            let nightDuration = null;
            let dayDuration = null;
            this.data.forEach((entry) => {
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
                    text: 'Temps de travail de la semaine en cours',
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