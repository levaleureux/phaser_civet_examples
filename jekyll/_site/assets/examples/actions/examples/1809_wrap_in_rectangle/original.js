class Example extends Phaser.Scene
{
    constructor ()
    {
        super();

        this.wrapRect;
        this.aliens = [];
    }

    preload ()
    {
        this.load.setBaseURL('https://cdn.phaserfiles.com/v385');
        this.load.image('monitor', 'assets/pics/monitor.png');
        this.load.image('alien', 'assets/sprites/space-baddie.png');
    }

    create ()
    {
        //  This is our 'wrapping rectangle'
        //  When a sprite leaves this, it'll be wrapped around
        this.wrapRect = new Phaser.Geom.Rectangle(214, 132, 367, 239);

        this.add.rectangle(this.wrapRect.x, this.wrapRect.y, this.wrapRect.width, this.wrapRect.height, 0x0094bf).setOrigin(0, 0);

        for (let i = 0; i 
                        
                                                                                                         Copy
                            
                                
                                    
                                        
                                    
                                Expand
                        
                    