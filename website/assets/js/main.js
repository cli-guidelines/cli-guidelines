window.addEventListener('DOMContentLoaded', () => {

    convertToNestedSections(document.querySelector('main'));
    startNavObservation();

});

function convertToNestedSections(rootElement) {
    const children = Array.from(rootElement.children);

    children.forEach(element => rootElement.removeChild(element));

    let currentSection = rootElement;
    let currentLevel = 0;

    children.forEach(element => {
        const headingMatch = element.tagName.match(/^h(\d)$/i);

        if (headingMatch) {
            const newLevel = parseInt(headingMatch[1]);

            while (currentLevel + 1 < newLevel) {
                const section = document.createElement('section');
                currentSection.appendChild(section);
                currentSection = section;
                currentLevel++;
            }

            while (currentLevel + 1 > newLevel) {
                currentSection = currentSection.parentNode;
                currentLevel--;
            }

            const newSection = document.createElement('section');
            newSection.setAttribute('id', element.getAttribute('id'));
            element.removeAttribute('id');

            currentSection.appendChild(newSection);

            currentSection = newSection;
            currentLevel = newLevel;
        }

        currentSection.appendChild(element);
    });
}

// https://www.bram.us/2020/01/10/smooth-scrolling-sticky-scrollspy-navigation/
function startNavObservation() {

    const observer = new IntersectionObserver(entries => {
        entries.forEach(entry => {
            const id = entry.target.getAttribute('id');
            const link = document.querySelector(`nav li a[href="#${id}"]`);
            if (link) {
                if (entry.intersectionRatio > 0) {
                    link.parentElement.classList.add('active');
                } else {
                    link.parentElement.classList.remove('active');
                }
            }
        });
    });

    // Track all sections that have an `id` applied
    document.querySelectorAll('section[id]').forEach((section) => {
        observer.observe(section);
    });

}