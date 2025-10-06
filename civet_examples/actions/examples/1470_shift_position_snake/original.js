class Example extends Phaser.Scene
{
    constructor ()
    {
        super();
    }

    preload ()
    {
        this.load.setBaseURL('https://cdn.phaserfiles.com/v385');
        this.load.image('sky', 'assets/skies/pixelsky.png');
        this.load.spritesheet('blocks', 'assets/sprites/heartstar32.png', { frameWidth: 32, frameHeight: 32 });
    }

    create ()
    {
        this.add.image(400, 300, 'sky');

        //  Create a series of sprites, with a block as the 'head'

        let head;
        const snake = [];

        for (let i = 0; i  {

            let x = head.x;
            let y = head.y;

            if (direction === 0)
            {
                x = Phaser.Math.Wrap(x - 32, 0, 800);
            }
            else if (direction === 1)
            {
                x = Phaser.Math.Wrap(x + 32, 0, 800);
            }
            else if (direction === 2)
            {
                y = Phaser.Math.Wrap(y - 32, 0, 576);
            }
            else if (direction === 3)
            {
                y = Phaser.Math.Wrap(y + 32, 0, 576);
            }

            Phaser.Actions.ShiftPosition(snake, x, y);

            distance--;

            if (distance === 0)
            {
                if (direction 
                        
                                                                                                         Copy
                            
                                
                                    
                                        
                                    
                                Expand
                        
                    