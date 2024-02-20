blogPanelToLoad = 0;
panelsPerSection = 5;

listView = document.getElementById('blog-list-view');
listWrapper = document.getElementById('blog-list-wrapper');
postView = document.getElementById('blog-post-view');
postMDinject = document.getElementById('blog-post-md-inject');
postTitle = document.getElementById('blog-post-title');
postDate = document.getElementById('blog-post-date');
postLeft = document.getElementById('blog-post-arrow-left');
postRight = document.getElementById('blog-post-arrow-right');
loadMoreButton = document.getElementById('blog-list-load-btn');

fetch("blog/latest.json")
.then(response => response.json())
.then(data => {
  blogCount = data.count;

  window.addEventListener('hashchange', handleHashChange);
  loadMoreButton.addEventListener('click', loadPanelListWrapper);
  loadPanelListWrapper();
  handleHashChange();
});

function handleHashChange() {
  if (!window.location.hash.includes('?blogID=')) {
    listView.style.display = 'flex';
    postView.style.display = 'none';
    postMDinject.innerHTML = '';
  } else {
    const blogID = window.location.hash.substring(1).split('?')[1].split('blogID=')[1];
    listView.style.display = 'none';
    postView.style.display = 'flex';
    loadBlogPage(parseInt(blogID));
  }
}

function loadPanelListWrapper() {
  loadMoreButton.style.display = 'none';
  const panelListWrapper = document.createElement('div');
  panelListWrapper.className = 'blog-panel-list-wrapper';
  listWrapper.appendChild(panelListWrapper);

  for (let i = 0; i < panelsPerSection && blogPanelToLoad < blogCount; i++) {
    const domBlogID = 'blog-panel-' + blogPanelToLoad;
    const panelWrapper = document.createElement('div');
    panelWrapper.className = 'blog-panel-wrapper';
    panelWrapper.id = domBlogID;
    panelListWrapper.appendChild(panelWrapper);
    loadBlogPanel(panelWrapper, blogPanelToLoad);
    blogPanelToLoad += 1;
  }
  if (blogPanelToLoad < blogCount) {
    listWrapper.appendChild(loadMoreButton);
    loadMoreButton.style.display = 'flex';
  } else {
    loadMoreButton.remove();
  }
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
  fetch ('blog/posts/' + blogID + '/info.json')
  .then(response => response.json())
  .then(data => {
      postTitle.innerHTML = data.title;
      postDate.innerHTML = data.date;
  })
  postLeft.href = '#blog?blogID=' + ((blogID - 1 + blogCount) % blogCount);
  postRight.href = '#blog?blogID=' + ((blogID + 1) % blogCount);
}
