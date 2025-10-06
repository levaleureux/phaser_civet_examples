class Example extends Phaser.Scene
{
    constructor ()
    {
        super();
    }

    preload ()
    {
        this.load.setBaseURL('https://cdn.phaserfiles.com/v385');
        this.load.image('bg', 'assets/skies/deepblue.png');
        this.load.spritesheet('sotb', 'assets/animations/sotb-64x112x11.png', { frameWidth: 64, frameHeight: 112 });
    }

    create ()
    {
        this.add.image(400, 300, 'bg');

        this.anims.create({
            key: 'walk',
            frames: this.anims.generateFrameNumbers('sotb'),
            frameRate: 16,
            repeat: -1
        });

        const sprites = [];

        for (var i = 0; i 
                        
                                                                                                         Copy
                            
                                
                                    
                                        
                                    
                                Expand
                        
                    