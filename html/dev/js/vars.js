const vw = Math.max(document.documentElement.clientWidth || 0, window.innerWidth || 0);
var mediaQuery = window.matchMedia('(min-width: 65em)');
// Blog
var blogCount;
var blogPanelToLoad;
var panelsPerSection;
var listView;
var listWrapper;
var postTitle;
var postDate;
var postView;
var postMDinject;
var loadMoreButton;
// Metrics
var metricsAPIurl;
var metricStartDate;
var metricStopDate;
// Projects
var projectsJSON;
var projectsCount;
var projectsWrapper;
var projectToLoad;
var projectsPanelsPerSection;
var projectsLoadMoreButton;
var githubCardsScript;
