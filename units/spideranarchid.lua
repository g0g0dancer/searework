unitDef = {
  unitname               = [[spideranarchid]],
  name                   = [[Anarchid]],
  description            = [[Riot EMP Spider]],
  acceleration           = 0.26,
  brakeRate              = 0.26,
  buildCostEnergy        = 250,
  buildCostMetal         = 250,
  buildPic               = [[arm_venom.png]],
  buildTime              = 250,
  canAttack              = true,
  canGuard               = true,
  canMove                = true,
  canPatrol              = true,
  canstop                = [[1]],
  category               = [[LAND]],
  collisionVolumeOffsets = [[0 0 0]],
  collisionVolumeScales  = [[40 30 40]],
  collisionVolumeType    = [[ellipsoid]],
  corpse                 = [[DEAD]],

  customParams           = {

    helptext       = [[The Anarchid is like a Starlight, but a Spider]],
  },

  explodeAs              = [[BIG_UNITEX]],
  footprintX             = 3,
  footprintZ             = 3,
  iconType               = [[spiderriot]],
  idleAutoHeal           = 5,
  idleTime               = 1800,
  leaveTracks            = true,
  maxDamage              = 600,
  maxSlope               = 72,
  maxVelocity            = 1.6,
  maxWaterDepth          = 22,
  minCloakDistance       = 75,
  movementClass          = [[TKBOT3]],
  noChaseCategory        = [[TERRAFORM FIXEDWING SATELLITE SUB]],
  objectName             = [[spideranarchid.s3o]],
  script                 = [[spideranarchid.lua]],
  seismicSignature       = 4,
  selfDestructAs         = [[BIG_UNITEX]],

  sfxtypes               = {

    explosiongenerators = {
      [[custom:YELLOW_LIGHTNING_MUZZLE]],
      [[custom:YELLOW_LIGHTNING_GROUNDFLASH]],
    },

  },

  sightDistance          = 440,
  trackOffset            = 0,
  trackStrength          = 10,
  trackStretch           = 1,
  trackType              = [[ChickenTrackPointyShort]],
  trackWidth             = 54,
  turnRate               = 1600,

  weapons                       = {

    {
      def                = [[LASER]],
      badTargetCategory  = [[FIXEDWING]],
      onlyTargetCategory = [[FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER]],
    },

  },


  weaponDefs                    = {

    LASER = {
      name                    = [[Laserbeam]],
      areaOfEffect            = 8,
      beamTime                = 0.1,
      coreThickness           = 0.4,
      craterBoost             = 0,
      craterMult              = 0,

      damage                  = {
        default = 5,
        subs    = 0.25,
      },

      explosionGenerator      = [[custom:FLASH1blue]],
      fireStarter             = 30,
      impactOnly              = true,
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      interceptedByShieldType = 1,
      largeBeamLaser          = true,
      laserFlareSize          = 2,
      minIntensity            = 1,
      noSelfDamage            = true,
      range                   = 270,
      reloadtime              = 0.1,
      rgbColor                = [[0 1 1]],
      soundStart              = [[weapon/laser/laser_burn8]],
      soundTrigger            = true,
      sweepfire               = false,
      texture1                = [[largelaser]],
      texture2                = [[flare]],
      texture3                = [[flare]],
      texture4                = [[smallflare]],
      thickness               = 2,
      tolerance               = 5000,
      turret                  = true,
      weaponType              = [[BeamLaser]],
      weaponVelocity          = 500,
    },

  },


  featureDefs            = {

    DEAD  = {
      blocking         = false,
      featureDead      = [[HEAP]],
      footprintX       = 2,
      footprintZ       = 2,
      object           = [[venom_wreck.s3o]],
    },
    HEAP  = {
      blocking         = false,
      footprintX       = 2,
      footprintZ       = 2,
      object           = [[debris2x2a.s3o]],
    },

  },

}

return lowerkeys({ spideranarchid = unitDef })
