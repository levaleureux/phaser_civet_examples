class Example extends Phaser.Scene
{
    constructor ()
    {
        super();
    }

    preload ()
    {
        this.load.setBaseURL('https://cdn.phaserfiles.com/v385');
        this.load.image('bg', 'assets/skies/darkstone.png');
        this.load.image('tree', 'assets/sprites/skullcandle.png');
        this.load.image('cave', 'assets/sprites/cave.png');
    }

    create ()
    {
        this.add.image(400, 300, 'bg');

        const circle = new Phaser.Geom.Circle(400, 300, 220);

        const trees = [];

        for (let i = 0; i  {
            tree.setDepth(tree.y);
        });

        this.add.image(400, 300, 'cave');
    }
}

const config = {
    type: Phaser.AUTO,
    width: 800,
    height: 600,
    backgroundColor: '#000000',
    parent: 'phaser-example',
    roundPixels: true,
    scene: Example
};

const game = new Phaser.Game(config);