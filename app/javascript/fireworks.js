export function startFireworks() {
    const element = document.getElementById('effects-animation-container');
    if (!element) return;

    const width = window.innerWidth;
    const height = window.innerHeight;

    const canvas = document.createElement('canvas');
    canvas.width = width;
    canvas.height = height;
    element.appendChild(canvas);

    const ctx = canvas.getContext('2d');

    function randomInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    function randomFloat(min, max) {
        return Math.random() * (max - min) + min;
    }

    class Firework {
        constructor() {
            this.x = randomInt(0, width);
            this.y = height;
            this.targetY = randomInt(height / 4, height / 2);
            this.speed = randomFloat(2, 5);
            this.exploded = false;
            this.particles = [];
        }

        update() {
            if (!this.exploded) {   
                this.y -= this.speed;
                if (this.y <= this.targetY) {
                    this.exploded = true;
                    this.createParticles();
                }
            } else {
                this.particles.forEach(p => p.update());
                this.particles = this.particles.filter(p => !p.isFaded());
            }
        }

        createParticles() {
            const particleCount = randomInt(20, 50);
            for (let i = 0; i < particleCount; i++) {
                this.particles.push(new Particle(this.x, this.y));
            }
        }

        draw(ctx) {
            if (!this.exploded) {
                ctx.fillStyle = 'white';
                ctx.fillRect(this.x, this.y, 2, 10);
            } else {
                this.particles.forEach(p => p.draw(ctx));
            }
        }
    }

    class Particle {
        constructor(x, y) {
            this.x = x;
            this.y = y;
            this.vx = randomFloat(-2, 2);
            this.vy = randomFloat(-2, 2);
            this.alpha = 1;
            this.size = randomInt(2, 4);
        }

        update() {
            this.x += this.vx;
            this.y += this.vy;
            this.alpha -= 0.02;
        }

        isFaded() {
            return this.alpha <= 0;
        }

        draw(ctx) {
            if (!this.color) {
                const r = randomInt(0, 255);
                const g = randomInt(0, 255);
                const b = randomInt(0, 255);
                this.color = `rgba(${r}, ${g}, ${b},`;
            }
            ctx.fillStyle = `${this.color} ${this.alpha})`;
            ctx.beginPath();
            ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
            ctx.fill();
        }
    }

    const fireworks = [];
    let frameCount = 0;

    function animate() {
        ctx.fillStyle = 'rgba(0, 0, 0, 0.1)';
        ctx.fillRect(0, 0, width, height);

        if (frameCount % 20 === 0) {
            fireworks.push(new Firework());
        }

        fireworks.forEach(firework => {
            firework.update();
            firework.particles = firework.particles.filter(p => p.alpha > 0);
            firework.draw(ctx);
        });

        frameCount++;
        requestAnimationFrame(animate);
    }

    animate();
}