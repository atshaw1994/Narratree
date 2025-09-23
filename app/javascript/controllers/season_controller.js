import { Controller } from "@hotwired/stimulus";

console.log("Season Controller Loaded");

export default class extends Controller {
    connect() {
        console.log("Season Controller Connected");
        this.maxLeaves = 50;
        this.stopped = false;
        if (this.isChristmasSeason()) {
            this.createElements();
        }
        else if (this.isFallSeason()) {
            this.maxLeaves = 30;
            this.stopped = false;
            this.createElements();
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
        }
    }

    async createElements() {
        const count = this.maxLeaves;
        let elementClass = "leaf";
        if (this.isChristmasSeason()) {
            elementClass = "snowflake";
        }
        else if (this.isFallSeason()) {
            elementClass = "leaf";
        }

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

    isChristmasSeason() {
        const month = new Date().getMonth();
        return month === 11; // December
    }

    isFallSeason() {
        const month = new Date().getMonth();
        return month === 8 || month === 9 || month === 10; // September, October, November
    }
}