class Example extends Phaser.Scene {
  constructor() {
    super()
  }

  preload() {
    this.load.setBaseURL('https://cdn.phaserfiles.com/v385')
    return this.load.image('ball', 'assets/sprites/shinyball.png')
  }

  create() {
    this.groups = []
    const radii = [200, 160, 120, 80]

    for (const i in radii) {const radius = radii[i];
      const group = this.add.group({ key: 'ball', frameQuantity: 16 })
      Phaser.Actions.PlaceOnCircle(group.getChildren(), { x: 400, y: 300, radius })
      this.groups.push([ group, radius ])
    }
    
    return console.log(this.groups)
  }

  update() {
    // for [ group, radius ] in @groups
    // console.log @groups
    //for i, loup  in @groups
    // console.log loup
    let ref;const results=[];for (const i in ref = this.groups) {const [ group, radius ] = ref[i];
      results.push(Phaser.Actions.RotateAroundDistance(group.getChildren(), { x: 400, y: 300 }, 0.02, radius))
    };return results;
  }
}

config = {
  type: Phaser.AUTO,
  width: 800,
  height: 600,
  backgroundColor: '#2d2d2d',
  parent: 'phaser-example',
  scene: Example,
}

game = new Phaser.Game(config)

