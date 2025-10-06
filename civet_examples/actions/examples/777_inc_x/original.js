class Example extends Phaser.Scene
{
    constructor ()
    {
        super();

        this.donuts = [];
    }

    preload ()
    {   //https://labs.phaser.io/
        this.load.setBaseURL('https://cdn.phaserfiles.com/v385');
        this.load.image('bg', 'assets/skies/grid.png');
        this.load.image('donut', 'assets/sprites/donut.png');
    }

    create ()
    {
        this.add.image(400, 600, 'bg').setOrigin(0.5, 1);

        this.cameras.main.setBounds(0, 0, 800, 600);

        for (let i = 0; i 
                        
                                                                                                         Copy
                            
                                
                                    
                                        
                                    
                                Expand
                        
                    