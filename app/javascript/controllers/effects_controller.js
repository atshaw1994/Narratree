import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    connect() {
        this.maxFallingElements = 50;
        this.stopped = false;
        this.observer = new MutationObserver(() => {
            this.applyEffectsFromBodyClass();
        });
        this.observer.observe(document.body, { attributes: true, attributeFilter: ['class'] });
        this.applyEffectsFromBodyClass();
    }

    disconnect() {
        if (this.observer) this.observer.disconnect();
        this.cleanupEffects();
    }

    applyEffectsFromBodyClass() {
        this.cleanupEffects();
        // Use a session token to prevent mixed falling elements
        this.fallingSession = (this.fallingSession || 0) + 1;
        const currentSession = this.fallingSession;
        const footer = document.querySelector("footer");
        const body = document.body;
        if (body.classList.contains('fall-mode')) {
            this.maxFallingElements = 30;
            this.stopped = false;
            this.createElements("leaf", currentSession);
        } else if (body.classList.contains('spooky-mode')) {
            if (footer) {
                if (!footer.querySelector(".jackolantern")) {
                    const jackolanternElement = document.createElement("div");
                    jackolanternElement.className = "jackolantern";
                    footer.appendChild(jackolanternElement);
                }
                if (!footer.querySelector(".candle-light")) {
                    const candleElement = document.createElement("div");
                    candleElement.className = "candle-light flicker";
                    footer.appendChild(candleElement);
                }
            }
            this.decorateHeaders("spooky");
            this.maxFallingElements = 30;
            this.stopped = false;
            this.createElements("falling-skull", currentSession);
        } else if (body.classList.contains('santa-mode')) {
            if (footer) {
                if (!footer.querySelector(".christmas-tree")) {
                    const christmasTreeElement = document.createElement("div");
                    christmasTreeElement.className = "christmas-tree";
                    footer.appendChild(christmasTreeElement);
                }
                if (!footer.querySelector(".snowman")) {
                    const snowmanElement = document.createElement("div");
                    snowmanElement.className = "snowman";
                    footer.appendChild(snowmanElement);
                }
            }
            this.decorateHeaders("christmas");
            this.maxFallingElements = 30;
            this.stopped = false;
            this.createElements("snowflake", currentSession);
        }
        // No effects for other themes
    }

    cleanupEffects() {
        // Remove falling elements
        this.stopped = true;
        if (this.element) {
            this.element.querySelectorAll('.falling-element').forEach(el => el.remove());
        }
        // Remove seasonal decorations from footer
        const footer = document.querySelector("footer");
        if (footer) {
            ["jackolantern", "candle-light", "christmas-tree"].forEach(cls => {
                footer.querySelectorAll(`.${cls}`).forEach(el => el.remove());
            });
        }
        // Remove header decorations
        document.querySelectorAll('.spiderweb, .witch-hat, .santa-hat').forEach(el => el.remove());
    }

    async createElements(elementClass, session) {
        const count = this.maxFallingElements;
        for (let i = 0; i < count; i++) {
            // Only allow spawns for the current session
            if (this.stopped || session !== this.fallingSession) break;
            this.spawnElement(elementClass);
            await new Promise(r => setTimeout(r, 500)); // Stagger the spawning
        }
    }

    spawnElement(className) {
        const element = document.createElement("div");
        const animationName = Math.random() < 0.5 ? "fall" : "fall-mirrored";
        element.style.animation = `${animationName} linear infinite`;
        element.className = `falling-element ${className}`;
        element.style.left = `${(Math.random() * 100)}vw`;
        element.style.width = `${Math.random() * 32 + 32}px`;
        element.style.height = element.style.width; // Keep it square
        element.style.animationDuration = `${Math.random() * 8 + 5}s`;
        this.element.appendChild(element);
    }

    decorateHeaders(season) {
        if (season === "spooky") {
            document.querySelectorAll(".section-container-header").forEach(header => {
                if (!header.querySelector(".spiderweb")) {
                    const spiderwebDiv = document.createElement("div");
                    spiderwebDiv.className = "spiderweb";
                    header.appendChild(spiderwebDiv);
                }
                if (!header.querySelector(".witch-hat")) {
                    const witchHatDiv = document.createElement("div");
                    witchHatDiv.className = "witch-hat";
                    header.appendChild(witchHatDiv);
                }
            });
        }
        else if (season === "christmas") {
            document.querySelectorAll(".section-container-header").forEach(header => {
                if (!header.querySelector(".santa-hat")) {
                    const santaHatDiv = document.createElement("div");
                    santaHatDiv.className = "santa-hat";
                    header.appendChild(santaHatDiv);
                }
                if (!header.querySelector(".lights")) {
                    const lightsDiv = document.createElement("div");
                    lightsDiv.className = "lights";
                    header.appendChild(lightsDiv);
                }
            });
        }
    }

    // getSeason() removed: now using body class for theme/effects
}
