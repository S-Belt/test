<template>
    <p>Temps de travail annuel par mois</p>
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
    name:"barchartMonths",
    components: { Bar },
    
    data() {
        return {
            chartData: null,
            filteredData: null,
            chartOption: null
        }
    },
    
    created() {
        this.getWT()
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
            const startOfMonth = now.clone().startOf('month');
            const endOfMonth = now.clone().endOf('month');
            const start = startOfMonth.format('YYYY-MM-DD');
            const end = endOfMonth.format('YYYY-MM-DD');
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
                console.log(error);
            }
        },
        

        fetchChartData() {
            const workDurationByMonths = {};
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
                const months = startDate.format('MM');

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

                if (workDurationByMonths[months]) {
                    workDurationByMonths[months].night += nightDuration;
                    workDurationByMonths[months].day += dayDuration;
                } else {
                    workDurationByMonths[months] = {
                        night: nightDuration,
                        day: dayDuration
                    };
                }   
            });

            this.chartData = {
                labels: Object.keys(workDurationByMonths),
                datasets: [{
                    label: "Nombre d'heures effectives",
                    data: Object.keys(workDurationByMonths).map(months => workDurationByMonths[months].night +workDurationByMonths[months].day),
                    backgroundColor: 'rgba(241.19, 219.68, 26.13, 0.70)'
                },
               {
                   label: "Nombre d'heures théoriques",
                   data: Array(Object.keys(workDurationByMonths).length).fill(140),
                   backgroundColor: 'rgba(106, 61, 154, 0.87)', 
               },
               ],
            };
            
            this.chartOption = {
                title: {
                    text: 'Temps de travail annuel par mois',
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