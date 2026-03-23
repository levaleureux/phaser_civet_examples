class Example extends Phaser.Scene
{
    lastFired = 0;
    cursors;
    stats;
    speed;
    info;
    ship;
    bullets;

    preload ()
    {
        this.load.setBaseURL('https://cdn.phaserfiles.com/v385');
        this.load.image('ship', 'assets/sprites/ship.png');
        this.load.image('bullet', 'assets/sprites/bullet.png');
    }

    create ()
    {
        //  A sample custom class with its own 'update' and 'fire' methods
        class Bullet extends Phaser.GameObjects.Image
        {
            constructor (scene)
            {
                super(scene, 0, 0, 'bullet');

                this.speed = Phaser.Math.GetSpeed(500, 1);
            }

            fire (x, y)
            {
                this.setPosition(x, y - 50);

                this.setActive(true);
                this.setVisible(true);
            }

            update (time, delta)
            {
                this.y -= this.speed * delta;

                if (this.y  this.lastFired)
        {
            const bullet = this.bullets.get();
            
            if (bullet)
            {
                bullet.fire(this.ship.x, this.ship.y);

                this.lastFired = time + 50;
            }
        }

        this.info.setText([
            `Used: ${this.bullets.getTotalUsed()}`,
            `Free: ${this.bullets.getTotalFree()}`
        ]);
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