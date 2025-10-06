class Example extends Phaser.Scene
{
    constructor ()
    {
        super();
    }

    preload ()
    {
        this.load.setBaseURL('https://cdn.phaserfiles.com/v385');
        this.load.spritesheet('diamonds', 'assets/sprites/diamonds32x5.png', { frameWidth: 64, frameHeight: 64 });
    }

    create ()
    {
        const gems = [];

        for (let i = 1; i  {

            //  Get the first sprite with a scale of 1 that is using the Red frame
            const red = Phaser.Actions.GetFirst(gems, { scaleX: 1, frame: redFrame });

            if (red)
            {
                this.children.bringToTop(red);

                this.tweens.chain({
                    targets: red,
                    tweens: [
                        {
                            scale: 2,
                            duration: 400,
                            ease: 'Bounce.easeOut'
                        },
                        {
                            delay: 500,
                            scale: 0,
                            duration: 1000
                        }
                    ]
                });
            }

        });
    }
}

const config = {
    type: Phaser.AUTO,
    width: 800,
    height: 600,
    backgroundColor: '#2d2d2d',
    parent: 'phaser-example',
    scene: Example
};

const game = new Phaser.Game(config);