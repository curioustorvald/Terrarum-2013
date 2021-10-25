w = love.graphics.getWidth()
h = love.graphics.getHeight()

gameversion = "Render test"
-------------------
-- physics stuff --
-------------------
blockBody = {}
blockShape = {}
blockFixture = {}

--gravitationalAcceleration = 9.8
frictionDefault = 14

accelWalk = 8
accelRun = 16

maxspeedWalk = 6
maxspeedRun = 9
maxspeedFall = 14

jumpForce = 16
jumpForceAdd = 2 --player's speed add by jumpForceAdd when jumping
headforce = 2 --player's sent-back speed when hit something while jumping

passiveSpeed = 4 --speed that player sent back when block is placed to the player
-----------------
-- World stuff --
-----------------
world = {}
world.phys = {}
--gameWorld: world created by love.physics.newWorld()
world.geometry = {}
world.tileEntities = {}
-----------------
-- Debug stuff --
-----------------
playerPosX = 800
playerPosY = 960
