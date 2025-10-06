class Example extends Phaser.Scene
{
    constructor ()
    {
        super();

        this.wrapRect;
        this.robots = [];
    }

    preload ()
    {
        this.load.setBaseURL('https://cdn.phaserfiles.com/v385');
        this.load.image('floor', 'assets/demoscene/checker-floor.png');
        this.load.atlas('robot', 'assets/animations/robo.png', 'assets/animations/robo.json');
    }

    create ()
    {
        this.add.image(400, 600, 'floor').setScale(1.25).setOrigin(0.5, 1);

        //  Create an animation
        this.anims.create({
            key: 'run',
            frames: this.anims.generateFrameNames('robot', { prefix: 'Running_', start: 0, end: 14, zeroPad: 3 }),
            frameRate: 18,
            repeat: -1
        });

        //  Create 6 sprites, spaced out horizontally
        for (let i = 0; i 
                        
                                                                                                         Copy
                            
                                
                                    
                                        
                                    
                                Expand
                        
                    