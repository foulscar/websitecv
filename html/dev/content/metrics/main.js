metricsAPIurl = "https://api.dev.corbingrossen.me/metrics";

metricStartDate = document.getElementById('metrics-time-start');
metricStopDate = document.getElementById('metrics-time-stop');

fetch(metricsAPIurl)
.then(response => response.json())
.then(data => {
 metricStartDate.innerHTML = data.timestamp.STARTTIME;
 metricStopDate.innerHTML = data.timestamp.ENDTIME;

 data.items.forEach(item => {
  const element = document.getElementById(item.ID);
  element.innerHTML = item.COUNT;
 });
});
