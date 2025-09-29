class Example extends Phaser.Scene
{
    constructor ()
    {
        super();

        this.y = 0;
        this.gems = [];
    }

    preload ()
    {
        this.load.setBaseURL('https://cdn.phaserfiles.com/v385');
        this.load.image('red', 'assets/sprites/gem.png');
        this.load.image('blue', 'assets/sprites/columns-blue.png');
    }

    create ()
    {
        //  This is our 'lead' Sprite, the first one in the array
        this.gems.push(this.add.sprite(200, 300, 'red'));

        for (let i = 0; i 
                        
                                                                                                         Copy
                            
                                
                                    
                                        
                                    
                                Expand
                        
                    