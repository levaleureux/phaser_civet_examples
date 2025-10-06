class Example extends Phaser.Scene
{
    constructor ()
    {
        super();

        this.planes = [];
    }

    preload ()
    {
        this.load.setBaseURL('https://cdn.phaserfiles.com/v385');
        this.load.image('bg', 'assets/skies/deepblue.png');
        this.load.image('plane', 'assets/sprites/ww2plane.png');
    }

    create ()
    {
        this.add.image(400, 300, 'bg');

        this.cameras.main.setBounds(0, 0, 800, 600);

        for (let i = 0; i 
                        
                                                                                                         Copy
                            
                                
                                    
                                        
                                    
                                Expand
                        
                    