blogCount = 6;
blogPanelToLoad = 0;
panelsPerSection = 5;

listView = document.getElementById('blog-list-view');
listWrapper = document.getElementById('blog-list-wrapper');
postView = document.getElementById('blog-post-view');
postMDinject = document.getElementById('blog-post-md-inject');
loadMoreButton = document.getElementById('blog-list-load-btn');

function handleHashChange() {
  if (!window.location.hash.includes('?blogID=')) {
    listView.style.display = 'flex';
    postView.style.display = 'none';
    postMDinject.innerHTML = '';
  } else {
    const blogID = window.location.hash.substring(1).split('?')[1].split('blogID=')[1];
    listView.style.display = 'none';
    postView.style.display = 'flex';
    loadBlogPage(blogID);
    console.log('yep');
  }
}

function loadPanelListWrapper() {
  loadMoreButton.style.display = 'none';
  const panelListWrapper = document.createElement('div');
  panelListWrapper.className = 'blog-panel-list-wrapper';
  listWrapper.appendChild(panelListWrapper);
  for (let i = 0; i < panelsPerSection; i++) {
    if (blogPanelToLoad >= blogCount) { break; }
    console.log(blogPanelToLoad);
    const domBlogID = 'blog-panel-' + blogPanelToLoad;
    const panelWrapper = document.createElement('div');
    panelWrapper.className = 'blog-panel-wrapper';
    panelWrapper.id = domBlogID;
    panelListWrapper.appendChild(panelWrapper);
    loadBlogPanel(panelWrapper, blogPanelToLoad);
    blogPanelToLoad += 1;
  }
  listWrapper.appendChild(loadMoreButton);
  loadMoreButton.style.display = 'flex';
}

function loadBlogPanel(panelWrapper, blogID) {
  const panelTitle = document.createElement('a');
  panelTitle.className = "blog-post-title border--round-10"
  panelWrapper.appendChild(panelTitle);

  const panelDate = document.createElement('h2');
  panelDate.className = "blog-post-date";
  panelWrapper.appendChild(panelDate);

  fetch('blog/posts/' + blogID + '/info.json')
  .then(response => {
    if (!response.ok) {
      throw new Error('HTTP Error: ' + response.status);
    }
    return response.json();
  })
  .then(data => {
    panelTitle.innerHTML = data.title;
    panelTitle.href = '#blog?blogID=' + blogID;
    panelDate.innerHTML = data.date;
  })
  .catch(function () {
    this.dataError = true;
  })
}

function loadBlogPage(blogID) {
  fetch ('blog/posts/' + blogID + '/index.md')
  .then(response => response.text())
  .then(result => postMDinject.innerHTML = marked.parse(result));
}

window.addEventListener('hashchange', handleHashChange);

loadPanelListWrapper();
handleHashChange();

loadMoreButton.addEventListener('click', loadPanelListWrapper);
