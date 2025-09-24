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
                let jackolanternElement = document.createElement("img");
                let candleElement = document.createElement("div");
                candleElement.className = "candle-light flicker";
                const footer = document.querySelector("footer");
                const jackolanternSrc = footer.dataset.jackolanternSrc;
                jackolanternElement.src = jackolanternSrc;
                jackolanternElement.alt = "JackOLantern";
                jackolanternElement.className = "jackolantern";

                footer.appendChild(jackolanternElement);
                footer.appendChild(candleElement);
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