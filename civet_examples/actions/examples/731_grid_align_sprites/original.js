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
        this.load.atlas('cards', 'assets/atlas/cards.png', 'assets/atlas/cards.json');
    }

    create ()
    {
        this.add.image(400, 300, 'bg');

        const frames = this.textures.get('cards').getFrameNames();

        const cards = [];

        //  Create 8 cards and push them into an array

        for (var i = 0; i 
                        
                                                                                                         Copy
                            
                                
                                    
                                        
                                    
                                Expand
                        
                    