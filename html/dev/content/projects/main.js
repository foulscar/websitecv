projectsWrapper = document.getElementById('projects-wrapper');
projectsLoadMoreButton = document.getElementById('projects-load-btn');
projectsPanelsPerSection = 4;

if (mediaQuery.matches) {
  projectPanelWidth = 0.2 * vw;
} else {
  projectPanelWidth = 0.8 *vw;
}

fetch('projects/latest.json')
.then(response => response.json())
.then(data => {
  projectsJSON = data;
  projectsCount = projectsJSON.repos.length;
  projectToLoad = projectsCount - 1;
  loadProjectsPanelWrapper();
})

function loadProjectsPanel(panelWrapper) {
  const repo = projectsJSON.user + '/' + projectsJSON.repos[projectToLoad];
  const panel = document.createElement('div');
  panel.className = 'github-card';
  panel.setAttribute('data-github', repo);
  panel.setAttribute('data-width', projectPanelWidth);
  panelWrapper.appendChild(panel);
}

function loadProjectsPanelWrapper() {
  const panelWrapper = document.createElement('div');
  panelWrapper.className = 'projects-list-wrapper';
  projectsLoadMoreButton.style.display = 'none';
  for (let i = 0; i < projectsPanelsPerSection; i++) {
    if (projectToLoad < 0) {
      projectsLoadMoreButton.remove();
      break;
    }
    loadProjectsPanel(panelWrapper);
    projectToLoad--;
  }
  projectsWrapper.appendChild(panelWrapper);
  if (projectToLoad >= 0) {
    projectsWrapper.appendChild(projectsLoadMoreButton);
    projectsLoadMoreButton.style.display = 'flex';
  }
  if (githubCardsScript) {githubCardsScript.remove()}
  githubCardsScript = document.createElement('script');
  githubCardsScript.src = '3p/github-cards.js';
  document.head.prepend(githubCardsScript);
}

projectsLoadMoreButton.addEventListener('click', loadProjectsPanelWrapper);
