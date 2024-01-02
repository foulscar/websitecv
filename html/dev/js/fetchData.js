// Fetch CloudWatch Data from API Gateway
window.fetchData = function() {
  fetch(websitecv_vars.metrics_api_url, {
      method: 'GET'
  })
  .then(response => {
      if (!response.ok) {
          throw new Error('Network response was not ok');
      }
      return response.json();
  })
  .then(data => {
      data.items.forEach(item => {
          const elementId = item.ID;
          const countValue = item.COUNT;
          const element = document.getElementById(elementId);
          if (element) {
              element.textContent = countValue;
          }
      });

      var datesString = data.timestamp.STARTTIME + '<br>↑↓<br>' + data.timestamp.ENDTIME;
      document.getElementById('metric-date').innerHTML = datesString;
  })
  .catch(error => {
      console.error('There was a problem with the fetch operation:', error);
  });
}
