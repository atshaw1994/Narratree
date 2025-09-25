import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    connect() {
        this.maxFallingElements = 50;
        this.stopped = false;
        switch (this.getSeason()) {
            case "fall":
                this.maxFallingElements = 30;
                this.stopped = false;
                this.createElements("leaf");
                break;
            case "spooky":
                // Add jack-o-lantern and candle
                const footer = document.querySelector("footer");
                if (footer) {
                    if (!footer.querySelector(".jackolantern")) {
                        const jackolanternElement = document.createElement("img");
                        jackolanternElement.src = footer.dataset.jackolanternSrc;
                        jackolanternElement.alt = "JackOLantern";
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

                // Theme icon and body class
                const themeBtnIcon = document.querySelector('.header-btn[data-controller~="theme"] .material-symbols-rounded');
                if (themeBtnIcon) themeBtnIcon.textContent = 'skull';
                document.body.classList.add("spooky-mode");
                document.body.classList.remove("dark-mode");

                // Falling elements
                this.maxFallingElements = 30;
                this.stopped = false;
                this.createElements("falling-skull");
                break;
            case "christmas":
                this.maxFallingElements = 30;
                this.stopped = false;
                this.createElements("snowflake");
                break;
            default:
                // No seasonal effects
                break;
        }
    }

    async createElements(elementClass) {
        const count = this.maxFallingElements;

        for (let i = 0; i < count; i++) {
            if (this.stopped) break;
            this.spawnElement(elementClass);
            await new Promise(r => setTimeout(r, 500)); // Stagger the spawning
        }
    }

    spawnElement(className) {
        const element = document.createElement("div");
        const animationName = Math.random() < 0.5 ? "fall" : "fallreverse";
        element.style.animation = `${animationName} linear infinite`;
        element.className = `falling-element ${className}`;
        element.style.left = `${(Math.random() * 100)}vw`;
        element.style.width = `${Math.random() * 32 + 32}px`;
        element.style.height = element.style.width; // Keep it square
        element.style.animationDuration = `${Math.random() * 8 + 5}s`;
        this.element.appendChild(element);
    }

    decorateHeaders(season) {
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

    getSeason() {
        const month = new Date().getMonth();
        const day = new Date().getDate();
        if (month === 8 || month === 10) {
            return "fall";
        } else if (month === 9) {
            return "spooky";
        }
        else if (month === 11) {
            return "christmas";
        }
        return "unknown";
    }
}