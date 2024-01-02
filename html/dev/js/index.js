// Set Global Vars
let projectsLatestJson;
let projectsTotalNumPages;
var projectsCurrentPage = 1;
let projectsLatestPageID;
let projectsPageID;

let blogLatestJson;
let blogTotalNumPages;
var blogCurrentPage = 1;
let blogLatestPageID;
let blogPageID;

var isFirstHashCheck = true;

// Fetch CloudWatch Data from API Gateway
function fetchData() {
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

// Load json files

async function initialize() {
    try {
        const response = await fetch('projects/latest.json', {
            cache: 'no-cache'
        });
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }
        projectsLatestJson = await response.json();
        console.log(projectsLatestJson);
        // Additional check for the structure of projectsLatestJson
        if (!projectsLatestJson || !Array.isArray(projectsLatestJson.pages) || projectsLatestJson.pages.length === 0) {
            throw new Error('Invalid or empty JSON structure');
        }

        projectsTotalNumPages = projectsLatestJson.pages.length;
        projectsLatestPageID = projectsLatestJson.pages[0];
    } catch (error) {
        console.error(null, error);
    }

    try {
        const response = await fetch('blog/latest.json', {
            cache: 'no-cache'
        });
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }
        blogLatestJson = await response.json();
        console.log(blogLatestJson);
        // Additional check for the structure of projectsLatestJson
        if (!blogLatestJson || !Array.isArray(blogLatestJson.pages) || blogLatestJson.pages.length === 0) {
            throw new Error('Invalid or empty JSON structure');
        }

        blogTotalNumPages = blogLatestJson.pages.length;
        blogLatestPageID = blogLatestJson.pages[0];
    } catch (error) {
        console.error(null, error);
    }

    try {
        window.addEventListener('hashchange', handleHashChange);
        handleHashChange(); // call it once to handle the initial load

        // Define a mapping of section IDs to their corresponding markdown files
        const sections = {
            'contact': 'markdown/contact.md'
        };


        // Load markdown content for each section when the document content has been loaded
        document.addEventListener('DOMContentLoaded', () => {
            Object.entries(sections).forEach(([elementId, markdownFile]) => {
                loadMarkdownIntoSection(markdownFile, document.getElementById(elementId));
            });
            fetchData();
            updateShadingDimensionsAndPosition();
        });

        // After the DOM and all dependent resources such as stylesheets are fully loaded
        window.onload = () => {
            // No Scroll While Loading
            document.body.classList.add('no-scroll');
            // Add Shading
            setTimeout(updateShadingDimensionsAndPosition, 200);
            // Adjust card shadows on window resize
            window.addEventListener('resize', updateShadingDimensionsAndPosition);

            setButtonActions();
        };

    } catch (error) {
        console.error(null, error);
    }
}

initialize();
fetchData();


// Set Button Actions

function setButtonActions() {
    // Page Navigation Buttons
    document.getElementById("btn-view-resume").addEventListener("click", function() {
        window.open('resume.pdf', '_blank');
    });

    // Open/Close popup windows
    document.getElementById("openMetricsBtn").onclick = function() {
        document.getElementById("popup-metrics").style.display = "block";
    };

    document.getElementById("closeMetricsBtn").onclick = function() {
        document.getElementById("popup-metrics").style.display = "none";
    };

    document.getElementById("openDiagramBtn").onclick = function() {
        document.getElementById("popup-diagram").style.display = "block";
    };

    document.getElementById("closeDiagramBtn").onclick = function() {
        document.getElementById("popup-diagram").style.display = "none";
    };

    // Projects Page Nav
    document.getElementById("projects-page-nav-btn-left").onclick = function() {
        if ((projectsCurrentPage - 1) === 0) {
            projectsCurrentPage = projectsLatestJson.pages.length;
        } else {
            projectsCurrentPage--;
        }
        projectsPageID = projectsLatestJson.pages[projectsCurrentPage - 1];
        console.log("Set PageID to: " + projectsPageID);
        window.location.hash = 'projects?projectID=' + projectsPageID;
        handleHashChange();
    };
    document.getElementById("projects-page-nav-btn-right").onclick = function() {
        if ((projectsCurrentPage + 1) > projectsLatestJson.pages.length) {
            projectsCurrentPage = 1;
        } else {
            projectsCurrentPage++;
        }
        projectsPageID = projectsLatestJson.pages[projectsCurrentPage - 1];
        console.log("Set PageID to: " + projectsPageID);
        window.location.hash = 'projects?projectID=' + projectsPageID;
        handleHashChange();
    };

    // Blog Page Nav
    document.getElementById("blog-page-nav-btn-left").onclick = function() {
        if ((blogCurrentPage - 1) === 0) {
            blogCurrentPage = blogLatestJson.pages.length;
        } else {
            blogCurrentPage--;
        }
        blogPageID = blogLatestJson.pages[blogCurrentPage - 1];
        console.log("Set PageID to: " + blogPageID);
        window.location.hash = 'blog?blogID=' + blogPageID;
        handleHashChange();
    };
    document.getElementById("blog-page-nav-btn-right").onclick = function() {
        if ((blogCurrentPage + 1) > blogLatestJson.pages.length) {
            blogCurrentPage = 1;
        } else {
            blogCurrentPage++;
        }
        blogPageID = blogLatestJson.pages[blogCurrentPage - 1];
        console.log("Set PageID to: " + blogPageID);
        window.location.hash = 'blog?blogID=' + blogPageID;
        handleHashChange();
    };
}

function switchMode(li, contentsection) {
    var sections = document.getElementsByClassName('content-section');
    for (var i = 0; i < sections.length; i++) {
        sections[i].style.display = 'none';
    }
    // Select all elements with the class 'nav-li'
    const navElements = document.querySelectorAll('.nav-li');

    // Remove the 'nav-active' class from all these elements
    navElements.forEach(element => {
        element.classList.remove('nav-active');
    });

    // Add the 'nav-active' class to the specified element by ID
    const targetElement = document.getElementById(li);
    if (targetElement) {
        targetElement.classList.add('nav-active');
    } else {
        console.error('Element with ID ' + li + ' not found.');
        document.getElementById(contentsection).style.display = 'block';
    }
    document.getElementById(contentsection).style.display = 'block';
    updateShadingDimensionsAndPosition();
}

function handleHashChange(isFirstHashCheck) {
    const hash = window.location.hash.substring(1); // Remove the '#'
    const parts = hash.split('?'); // Split the hash into the section and parameters

    let section = parts[0];
    var params = parts[1];
    console.log(section);
    console.log(params);

    let sectionValidList = ['contact', 'projects', 'home', 'blog'];
    if (section == '') {
        window.location.hash = 'home';
        section = 'home';
    }
    if (sectionValidList.includes(section)) {
        switchMode('li-view-' + section, 'content-' + section);
    } else {
        document.getElementById("error-page-title").innerText = "Error 404: Not Found";
        document.getElementById("error-page-body").innerText = "The provided URL was invalid.";
        switchMode('li-view-error', 'content-error');
    }

    if (params) {
        if (params === "latest") {
            switch (section) {
                case 'projects':
                    console.log("section was projects and param latest");
                    projectsCurrentPage = 1;
                    params = "projectID=" + projectsLatestPageID;
                    window.location.hash = "projects?projectID=" + projectsLatestPageID;
                    break;
                case 'blog':
                    console.log("section was blog and param latest");
                    blogCurrentPage = 1;
                    params = "blogID=" + blogLatestPageID;
                    window.location.hash = "blog?blogID=" + blogLatestPageID;
                    break;
                default:
                    break;
            }
        }
    }

    if (isFirstHashCheck && (params !== null)) {
        var paramsParts = params.split('=');
        isFirstHashCheck = false;
        switch (section) {
            case 'projects':
                projectsCurrentPage = 1 + projectsLatestJson.pages.indexOf(paramsParts[1]);
                break;
            case 'blog':
                blogCurrentPage = 1 + blogLatestJson.pages.indexOf(paramsParts[1]);
                break;
            default:
                break;
        }
    }

    if (params) {
        // Handle the additional parameters:
        var paramsParts = params.split('=');
        if (paramsParts[1] === null || paramsParts[1] === "") {
            paramsParts[1] = projectsLatestJson.pages[projectsCurrentPage - 1];
        }
        if (paramsParts[0] === 'projectID') {
            loadProjectsPage(paramsParts[1], projectsCurrentPage, projectsTotalNumPages);
        }
        if (paramsParts[0] === 'blogID') {
            loadBlogPage(paramsParts[1], blogCurrentPage, blogTotalNumPages);
        }
    }
}

/**
 * Loads markdown content from a given file and inserts it into a specified section of the page.
 * @param {string} markdownFile - The path to the markdown file to load.
 * @param {string} elementId - The ID of the HTML element to populate with content.
 */
function loadMarkdownIntoSection(markdownFile, element) {
    fetch(markdownFile)
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.text();
        })
        .then(markdown => {
            console.log("marked: Loading file at " + markdownFile + " into " + element);
            const htmlContent = marked.parse(markdown);
            element.innerHTML = htmlContent;
        })
        .catch(error => {
            console.error('Error loading markdown:', error);
        });
}

function loadProjectsPage(pageID, pageNum, totalNumPages) {
    var DOMpageNavH1 = document.getElementById('projects-page-nav');

    DOMpageNavH1.innerText = 'Page ' + pageNum + ' of ' + totalNumPages;
    fetch('projects/pages/' + pageID + '/info.json')
        .then(response => response.json())
        .then(data => {
            var cardWrapper = document.getElementById('projects-card-wrapper');
            while (cardWrapper.firstChild) {
                cardWrapper.removeChild(cardWrapper.firstChild);
            }
            for (let i = 0; i < data.length; i++) {
                // Init projects-card-wrapper, shading div, and cardData
                let cardData = data[i];
                console.log("Projects Page Loader: Creating " + cardData.comment);
                let cardWrapper = document.getElementById('projects-card-wrapper');
                const shadingDiv = document.createElement('div');
                shadingDiv.className = 'addshading';

                // Create main card div
                const card = document.createElement('div');
                card.className = 'card';

                // Create title wrapper div
                const cardTitleWrapper = document.createElement('div');
                cardTitleWrapper.className = 'card-title-wrapper';

                // Create Date and Title elements
                const titles = [cardData.date, cardData.title]

                titles.forEach(title => {
                    const titleDivElement = document.createElement('div');
                    titleDivElement.className = 'card-child card-title';

                    titleH1Element = document.createElement('h1');
                    titleH1Element.innerText = title;

                    titleDivElement.appendChild(titleH1Element);
                    cardTitleWrapper.appendChild(titleDivElement);
                })

                // Create Docs element (github,etc.)
                const docsElement = document.createElement('div');
                docsElement.className = 'card-child card-title';

                const docsElementAnchor = document.createElement('a');
                docsElementAnchor.target = '_blank';

                const docsElementAnchorH1 = document.createElement('h1');
                const docsElementAnchorH1Text = document.createElement('text');
                docsElementAnchorH1Icon = document.createElement('i');

                docsElement.appendChild(docsElementAnchor);
                docsElementAnchor.appendChild(docsElementAnchorH1);
                docsElementAnchorH1.appendChild(docsElementAnchorH1Text);
                docsElementAnchorH1.appendChild(docsElementAnchorH1Icon);
                cardTitleWrapper.appendChild(docsElement);

                switch (cardData.docs_source) {
                    case "github":
                        docsElementAnchor.href = cardData.docs_link;
                        docsElementAnchor.className = "github-icon";

                        docsElementAnchorH1Text.innerText = "GitHub ";
                        docsElementAnchorH1Icon.className = "fab fa-github";
                        break;
                    default:
                        docsElementAnchorH1Text.innerText = "No Docs";
                }

                // Appending the title wrapper to the card
                card.appendChild(cardTitleWrapper);

                // Create Card Bodies
                cardData.bodies.forEach(bodyFile => {
                    const cardBody = document.createElement('div');
                    cardBody.className = 'card-child card-body';

                    mdFilePath = "projects/pages/" + pageID + "/" + bodyFile;
                    loadMarkdownIntoSection(mdFilePath, cardBody);

                    card.appendChild(cardBody);
                })

                // Append card to cardWrapper
                cardWrapper.appendChild(card);
            }
        })
        .catch(error => {
            console.error('Error Fetching Project Page File:', error);
            document.getElementById("error-page-title").innerText = "Error 404: Not Found";
            document.getElementById("error-page-body").innerText = "The provided Projects Page ID was invalid";
            switchMode('li-view-error', 'content-error');
        })

    // Update shading dimensions and position
    setTimeout(updateShadingDimensionsAndPosition, 200);
}

function loadBlogPage(pageID, pageNum, totalNumPages) {
    var DOMpageNavH1 = document.getElementById('blog-page-nav');

    DOMpageNavH1.innerText = 'Page ' + pageNum + ' of ' + totalNumPages;
    fetch('blog/pages/' + pageID + '/info.json')
        .then(response => response.json())
        .then(data => {
            var cardWrapper = document.getElementById('blog-card-wrapper');
            while (cardWrapper.firstChild) {
                cardWrapper.removeChild(cardWrapper.firstChild);
            }
            for (let i = 0; i < data.length; i++) {
                // Init projects-card-wrapper, shading div, and cardData
                let cardData = data[i];
                console.log("Blog Page Loader: Creating " + cardData.comment);
                let cardWrapper = document.getElementById('blog-card-wrapper');
                const shadingDiv = document.createElement('div');
                shadingDiv.className = 'addshading';

                // Create main card div
                const card = document.createElement('div');
                card.className = 'card';
                card.style.width = "50%";

                // Create title wrapper div
                const cardTitleWrapper = document.createElement('div');
                cardTitleWrapper.className = 'card-title-wrapper';

                // Create Date and Title elements
                const titles = [cardData.date]

                titles.forEach(title => {
                    const titleDivElement = document.createElement('div');
                    titleDivElement.className = 'card-child card-title';

                    titleH1Element = document.createElement('h1');
                    titleH1Element.innerText = title;

                    titleDivElement.appendChild(titleH1Element);
                    cardTitleWrapper.appendChild(titleDivElement);
                })

                // Create Docs element (github,etc.)
                const docsElement = document.createElement('div');
                docsElement.className = 'card-child card-title';

                const docsElementAnchor = document.createElement('a');
                docsElementAnchor.target = '_blank';

                const docsElementAnchorH1 = document.createElement('h1');
                const docsElementAnchorH1Text = document.createElement('text');
                docsElementAnchorH1Icon = document.createElement('i');

                docsElement.appendChild(docsElementAnchor);
                docsElementAnchor.appendChild(docsElementAnchorH1);
                docsElementAnchorH1.appendChild(docsElementAnchorH1Text);
                docsElementAnchorH1.appendChild(docsElementAnchorH1Icon);
                cardTitleWrapper.appendChild(docsElement);

                switch (cardData.docs_source) {
                    case "github":
                        docsElementAnchor.href = cardData.docs_link;
                        docsElementAnchor.className = "github-icon";

                        docsElementAnchorH1Text.innerText = "GitHub ";
                        docsElementAnchorH1Icon.className = "fab fa-github";
                        break;
                    case "linkedin":
                        docsElementAnchor.href = cardData.docs_link;
                        docsElementAnchor.className = "linkedin-button";

                        docsElementAnchorH1Text.innerText = "Linkedin ";
                        docsElementAnchorH1Icon.className = "fab fa-linkedin";
                        break;
                    default:
                        docsElementAnchorH1Text.innerText = "No Docs";
                }

                // Appending the title wrapper to the card
                card.appendChild(cardTitleWrapper);

                // Create Card Bodies
                const cardBody = document.createElement('div');
                cardBody.className = 'card-child card-body';
                card.appendChild(cardBody);

                // Create iframe
                const cardiframe = document.createElement('iframe');
                cardiframe.className = "card-iframe";
                cardiframe.src = cardData.embed_link;
                cardBody.appendChild(cardiframe);
                cardiframe.onload = () => {
                  cardiframe.style.height = cardData.height;
                }

                // Append card to cardWrapper
                cardWrapper.appendChild(card);
            }
        })
        .catch(error => {
            console.error('Error Fetching Blog Page File:', error);
            document.getElementById("error-page-title").innerText = "Error 404: Not Found";
            document.getElementById("error-page-body").innerText = "The provided Projects Page ID was invalid";
            switchMode('li-view-error', 'content-error');
        })

    // Update shading dimensions and position
    setTimeout(updateShadingDimensionsAndPosition, 200);
}


function updateShadingDimensionsAndPosition() {
    // Delay the update until the next frame to allow styles to be calculated
    requestAnimationFrame((step) => {
        const shadingElements = document.querySelectorAll('.addshading');

        shadingElements.forEach((shading) => {
            const nextSibling = shading.nextElementSibling;
            if (nextSibling) {
                // Calculate 1vw and 1vh in pixels to add a slight offset
                const oneVW = 5;
                const oneVH = 5;

                // Match the shadow element's size and position to its sibling
                shading.style.width = `${nextSibling.offsetWidth}px`;
                shading.style.height = `${nextSibling.offsetHeight}px`;
                shading.style.top = `${nextSibling.offsetTop + oneVH}px`;
                shading.style.left = `${nextSibling.offsetLeft + oneVW}px`;
            }
        });
    });
}
