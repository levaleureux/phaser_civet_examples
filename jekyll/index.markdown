---
layout: default
title: Home
---

<section class="hero">
    <div class="container">
        <div class="hero-content">
            <h1>Making HTML5 Games Even Easier</h1>
            <p class="hero-subtitle">
                Discover the power of Phaser.js combined with the simplicity of CivetScript.
                Build your web games with modern and intuitive syntax.
            </p>
            <a href="#examples" class="cta-button">Explore Examples</a>
        </div>
    </div>
</section>

<section class="features">
    <div class="container">
        <h2>Why Phaser + Civet?</h2>
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">🎮</div>
                <h3>Simplified Phaser.js</h3>
                <p>All official Phaser.js examples translated to CivetScript for clearer, more modern syntax. Get all the power of Phaser with less code.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">⚡</div>
                <h3>CivetScript Syntax</h3>
                <p>CivetScript offers more concise and expressive syntax than JavaScript, while compiling to standard JS. Write less, create more.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🚀</div>
                <h3>Accelerated Learning</h3>
                <p>Learn HTML5 game development faster with clear examples and simplified syntax. Perfect for beginners and experts alike.</p>
            </div>
        </div>
    </div>
</section>

<section class="examples-preview" id="examples">
    <div class="container">
        <h2>Available Examples</h2>
        <p class="examples-subtitle">
            Discover all Phaser.js examples translated to CivetScript
        </p>
        <div class="examples-grid">
            {% for example in site.data.examples %}
            <div class="example-item">
                <h4>{{ example.name }}</h4>
                <p>{{ example.description | default: "Phaser example in CivetScript" }}</p>
            </div>
            {% endfor %}
        </div>
        <div class="view-all-examples">
            <a href="https://github.com/levaleureux/phaser_civet_examples" target="_blank">
                View all examples on GitHub
            </a>
        </div>
    </div>
</section>