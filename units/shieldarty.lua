unitDef = {
  unitname               = [[shieldarty]],
  name                   = [[Racketeer]],
  description            = [[EMP Artillery]],
  acceleration           = 0.25,
  brakeRate              = 0.25,
  buildCostEnergy        = 350,
  buildCostMetal         = 350,
  builder                = false,
  buildPic               = [[SHIELDARTY.png]],
  buildTime              = 350,
  canAttack              = true,
  canGuard               = true,
  canMove                = true,
  canPatrol              = true,
  canstop                = [[1]],
  category               = [[LAND]],
  collisionVolumeOffsets = [[0 0 0]],
  collisionVolumeScales  = [[40 56 40]],
  collisionVolumeTest    = 1,
  collisionVolumeType    = [[ellipsoid]],
  corpse                 = [[DEAD]],

  customParams           = {
    helptext       = [[The Racketeer launches long range EMP missiles that can stun key enemy defenses before assaulting them. Since its missiles do not track or even lead, it is only useful against enemy units that are standing still. Only one Racketeer is needed to keep a target stunned, so pick a different target for each Racketeer. It is excellent at depleting the energy of enemy shields.]],

  },

  explodeAs              = [[BIG_UNITEX]],
  footprintX             = 2,
  footprintZ             = 2,
  iconType               = [[walkerlrarty]],
  idleAutoHeal           = 5,
  idleTime               = 1800,
  leaveTracks            = true,
  mass                   = 248,
  maxDamage              = 950,
  maxSlope               = 36,
  maxVelocity            = 1.8,
  maxWaterDepth          = 22,
  minCloakDistance       = 75,
  modelCenterOffset      = [[0 0 0]],
  movementClass          = [[KBOT2]],
  moveState              = 0,
  noAutoFire             = false,
  noChaseCategory        = [[TERRAFORM FIXEDWING SATELLITE GUNSHIP]],
  objectName             = [[dominator.s3o]],
  script                 = [[shieldarty.lua]],
  seismicSignature       = 4,
  selfDestructAs         = [[BIG_UNITEX]],

  sfxtypes               = {

    explosiongenerators = {
      [[custom:STORMMUZZLE]],
      [[custom:STORMBACK]],
    },

  },

  side                   = [[ARM]],
  sightDistance          = 325,
  smoothAnim             = true,
  trackOffset            = 0,
  trackStrength          = 8,
  trackStretch           = 1,
  trackType              = [[ComTrack]],
  trackWidth             = 22,
  turnRate               = 1800,
  upright                = true,
  workerTime             = 0,

  weapons                = {

    {
      def                = [[EMP_ROCKET]],
      badTargetCategory  = [[SWIM LAND SHIP HOVER]],
      onlyTargetCategory = [[SWIM LAND SINK TURRET FLOAT SHIP HOVER]],
    },

  },


  weaponDefs             = {
	EMP_ROCKET = {
      name                    = [[EMP Cruise Missile]],
      areaOfEffect            = 96,
      cegTag                  = [[emptrail]],
      collideFriendly         = false,
      craterBoost             = 0,
      craterMult              = 0,

      damage                  = {
        default        = 1500,
        empresistant75 = 375,
        empresistant99 = 15,
        planes         = 1500,
      },

      edgeEffectiveness       = 0.4,
      explosionGenerator      = [[custom:YELLOW_LIGHTNINGPLOSION]],
      fireStarter             = 0,
      flighttime              = 10,
      impulseBoost            = 0,
      impulseFactor           = 0,
      interceptedByShieldType = 2,
      lineOfSight             = true,
      metalpershot            = 0,
      model                   = [[wep_merl.s3o]],
      noautorange             = [[1]],
      noSelfDamage            = true,
	  paralyzer               = true,
      paralyzeTime            = 8,
      range                   = 940,
      reloadtime              = 5,
      renderType              = 1,
      selfprop                = true,
      smokedelay              = [[0.1]],
      smokeTrail              = false,
      soundHit                = [[weapon/missile/vlaunch_emp_hit]],
      soundStart              = [[weapon/missile/missile_launch_high]],
      startsmoke              = [[1]],
      tolerance               = 4000,
      weaponAcceleration      = 300,
      weaponTimer             = 1.6,
      weaponType              = [[StarburstLauncher]],
      weaponVelocity          = 7000,
    },
  },


  featureDefs            = {

    DEAD  = {
      description      = [[Wreckage - Racketeer]],
      blocking         = true,
      category         = [[corpses]],
      damage           = 950,
      energy           = 0,
      featureDead      = [[HEAP]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 2,
      footprintZ       = 2,
      height           = [[20]],
      hitdensity       = [[100]],
      metal            = 140,
      object           = [[wreck2x2b.s3o]],
      reclaimable      = true,
      reclaimTime      = 140,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

    HEAP  = {
      description      = [[Debris - Racketeer]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 950,
      energy           = 0,
      featurereclamate = [[SMUDGE01]],
      footprintX       = 2,
      footprintZ       = 2,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 70,
      object           = [[debris2x2c.s3o]],
      reclaimable      = true,
      reclaimTime      = 70,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

  },

}

return lowerkeys({ shieldarty = unitDef })
