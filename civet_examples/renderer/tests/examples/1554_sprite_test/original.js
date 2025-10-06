class Example extends Phaser.Scene
{
    preload ()
    {
        this.load.setBaseURL('https://cdn.phaserfiles.com/v385');
        for (let i = 1; i  {

            if (pointer.worldY >= 500)
            {
                console.log('Capture');

                this.game.renderer.captureFrame(false, true);
            }
            else
            {
                this.addSprites(y);
                y++;
                total += 1024;

                this.addSprites(y);
                y++;
                total += 1024;

                this.addSprites(y);
                y++;
                total += 1024;

                this.addSprites(y);
                y++;
                total += 1024;

                console.log('Total sprites:', total);
            }

        });
    }

    addSprites (y)
    {
        let color = 1;

        for (let x = 0; x 
                        
                                                                                                         Copy
                            
                                
                                    
                                        
                                    
                                Expand
                        
                    