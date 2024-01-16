const pageList = [
  'blog',
  'contact',
  'home',
  'metrics',
  'projects',
  'resume'
]
var currentPage = 2;
const navMainElements = document.querySelectorAll('.nav-main');
const arrowUpElement = document.getElementById('nav-main-up');
const arrowDownElement = document.getElementById('nav-main-down');
const mainPanelNav = document.getElementById('main-panel-top-nav');
const sidePanelNav = document.getElementById('pfp-sidepanel-nav');

const capFirstLetter = str => str.charAt(0).toUpperCase() + str.slice(1);

function handleHashChange() {
  var hash = window.location.hash.substring(1).split('?')[0];
  if (pageList.indexOf(hash) == currentPage)
    return;
  if (!pageList.includes(hash)) {
    currentPage = 2;
    hash = 'home';
  } else {
    currentPage = pageList.indexOf(hash);
  }
  navMainElements.forEach(function(element) {
    element.classList.remove('nav-active');
  });
  var activeNav = document.getElementById('nav-' + pageList[currentPage]);
  activeNav.classList.add('nav-active');
  totalCount = pageList.length;
  arrowUpElement.href = '#' + pageList[(currentPage - 1 + totalCount) % totalCount] ;
  arrowDownElement.href = '#' + pageList[(currentPage + 1) % totalCount];
  mainPanelNav.innerHTML = '~/' + capFirstLetter(hash);
  sidePanelNav.innerHTML = '$ cd ./' + capFirstLetter(hash) + ' ';
  htmx.ajax('GET', '/content/' + pageList[currentPage] + '/index.html', '#main-panel-content');
}

window.addEventListener('load', handleHashChange);
window.addEventListener('hashchange', handleHashChange);
