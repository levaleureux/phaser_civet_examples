class Example extends Phaser.Scene
{
    isKeyDown = false;
    isMouseDown = false;
    graphicsPath = [];
    graphics;
    snapHistory = [];
    time = 0;
    div = document.createElement('div');

    preload ()
    {
        this.load.setBaseURL('https://cdn.phaserfiles.com/v385');
        this.load.image('myImage', 'assets/sprites/phaser1.png');
        this.load.glsl('shader0', 'assets/shaders/shader0.frag');
    }

    create ()
    {
        this.div.innerHTML = 'PRESS SPACE TO TAKE SNAPSHOT';
        document.body.appendChild(this.div);

        for (let i = 0; i 
        {
            this.isMouseDown = true;
            this.graphics.clear();
            this.graphicsPath.length = 0;
        };
        game.canvas.onmouseup = e =>
        {
            this.isMouseDown = false;
        };
        game.canvas.onmousemove = e =>
        {
            const mouseX = e.clientX - game.canvas.offsetLeft;
            const mouseY = e.clientY - game.canvas.offsetTop;
            if (this.isMouseDown)
            { this.graphicsPath.push({x: mouseX, y: mouseY}); }
        };
        window.onkeydown = e =>
        {
            if (e.keyCode === 32 && !this.isKeyDown)
            {
                game.renderer.snapshot(image =>
                {
                    image.style.width = '160px';
                    image.style.height = '120px';
                    image.style.paddingLeft = '2px';
                    this.snapHistory.push(image);
                    console.log('snap!');
                    document.body.appendChild(image);
                });
                this.isKeyDown = true;
            }
        };
        window.onkeyup = e =>
        {
            if (e.keyCode === 32)
            {
                this.isKeyDown = false;
            }
        };
    }

    update ()
    {
        const length = this.graphicsPath.length;

        this.graphics.clear();
        this.graphics.lineStyle(10.0, 0xFFFF00, 1.0);
        this.graphics.beginPath();
        for (let i = 0; i 
                        
                                                                                                         Copy
                            
                                
                                    
                                        
                                    
                                Expand
                        
                    