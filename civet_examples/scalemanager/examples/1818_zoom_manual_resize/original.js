class Example extends Phaser.Scene
{
    preload ()
    {
        this.load.setBaseURL('https://cdn.phaserfiles.com/v385');
        this.load.image('pic', 'assets/tests/zoom/title.png');
    }

    create ()
    {
        this.add.image(0, 0, 'pic').setOrigin(0);

        this.input.on('pointerdown', function ()
        {

            const currentZoom = this.scale.zoom;

            if (currentZoom 
                        
                                                                                                         Copy
                            
                                
                                    
                                        
                                    
                                Expand
                        
                    