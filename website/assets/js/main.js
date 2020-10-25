window.addEventListener('DOMContentLoaded', () => {

    const navLinks = document.querySelectorAll('nav li a');
    const elements = document.querySelectorAll('main > *');
    startNavObservation(elements, navLinks);

});

function startNavObservation(elements, navLinks) {
    const headingMap = buildHeadingMap(elements);

    const visibleElements = new Set();

    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => {
            if (e.isIntersecting) {
                visibleElements.add(e.target);
            } else {
                visibleElements.delete(e.target);
            }
        });

        const topmostElement = getTopmostElement(visibleElements);
        if (!topmostElement) {
            return;
        }

        const closestHeading = headingMap.get(topmostElement);

        updateNavigation(navLinks, closestHeading);
    });

    elements.forEach(e => observer.observe(e));
}

function buildHeadingMap(elements) {
    const map = new Map();
    let lastHeading = null;

    elements.forEach(element => {
        if (element.matches('h2,h3,h4,h5,h6') && element.hasAttribute('id')) {
            lastHeading = element;
        }

        map.set(element, lastHeading);
    });

    return map;
}

function getTopmostElement(elements) {
    const elementsArray = Array.from(elements);

    elementsArray.sort((a, b) => {
        if (a === b) {
            return 0;
        }
        if (a.compareDocumentPosition(b) & Node.DOCUMENT_POSITION_PRECEDING) {
            return 1;
        }
        return -1;
    });

    return elementsArray[0];
}

function updateNavigation(navLinks, currentHeading) {
    navLinks.forEach(a => {
        if (currentHeading && a.getAttribute('href') === `#${currentHeading.id}`) {
            a.parentNode.classList.add('active');
        } else {
            a.parentNode.classList.remove('active');
        }
    });
}
