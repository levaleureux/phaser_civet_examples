class Example extends Phaser.Scene
{
    constructor ()
    {
        super();
    }

    preload ()
    {
        this.load.setBaseURL('https://cdn.phaserfiles.com/v385');
        this.load.image('bg', 'assets/pics/neoncircle.png');
        this.load.image('particle', 'assets/sprites/particle1.png');
    }

    create ()
    {
        this.add.image(400, 300, 'bg');

        //  Create our sprites to place within the circle
        const particles = [];

        for (let i = 0; i 
                        
                                                                                                         Copy
                            
                                
                                    
                                        
                                    
                                Expand
                        
                    