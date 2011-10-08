unitDef = {
  unitname               = [[corsub]],
  name                   = [[Snake]],
  description            = [[Submarine]],
  acceleration           = 0.039,
  activateWhenBuilt      = true,
  brakeRate              = 0.25,
  buildCostEnergy        = 600,
  buildCostMetal         = 600,
  builder                = false,
  buildPic               = [[CORSUB.png]],
  buildTime              = 600,
  canAttack              = true,
  canGuard               = true,
  canMove                = true,
  canPatrol              = true,
  canstop                = true,
  category               = [[SUB FIREPROOF]],
  collisionVolumeOffsets = [[0 3 0]],
  collisionVolumeScales  = [[28 15 89]],
  collisionVolumeTest    = 1,
  collisionVolumeType    = [[cylZ]],
  corpse                 = [[DEAD]],

  customParams           = {
    description_fr = [[Sous-Marin]],
	description_de = [[Unterseeboot]],
    fireproof      = [[1]],
    helptext       = [[Expensive, stealthy, and fragile, this Submarine can quickly sink anything it can hit. The Submarine cannot shoot behind itself, and its turn rate is poor, so positioning is key. Watch out for anything with anti-sub weaponry, especially Hunters.]],
    helptext_fr    = [[Le Snake est discret, cher et fragile, mais il peut couler trcs rapidement la plupart de ses ennemis. De plus il peut torpiller r de grande distance. Ne pouvant tirer derricre lui et tournant rapidement, son positionnement initial est la clef de l'éfficacité.]],
	helptext_de    = [[Teuer, versteckt und gebrechlich ist dieses U-Boot. Es kann nicht nach hinten schießen und seine Ausrichtung dauert lange. Daher lieber gleich richtig positionieren. Achte auf alles mit Anti-U-Boot Ausrüstung, besonders 'Hunter' - Torpedofregatten.]],
  },

  explodeAs              = [[SMALL_UNITEX]],
  footprintX             = 3,
  footprintZ             = 3,
  iconType               = [[submarine]],
  idleAutoHeal           = 5,
  idleTime               = 1800,
  mass                   = 240,
  maxDamage              = 1100,
  maxVelocity            = 2.9,
  minCloakDistance       = 75,
  minWaterDepth          = 25,
  modelCenterOffset      = [[0 0 -4]],
  movementClass          = [[UBOAT3]],
  noAutoFire             = false,
  noChaseCategory        = [[TERRAFORM FIXEDWING SATELLITE GUNSHIP HOVER]],
  objectName             = [[sub.s3o]],
  script                 = [[corsub.lua]],
  seismicSignature       = 4,
  selfDestructAs         = [[SMALL_UNITEX]],
  side                   = [[CORE]],
  sightDistance          = 550,
  smoothAnim             = true,
  sonarDistance          = 450,
  TEDClass               = [[SHIP]],
  turninplace            = 0,
  turnRate               = 352,
  upright                = true,
  waterline              = 15,
  workerTime             = 0,

  weapons                = {

    {
      def                = [[FAKEWEAPON]],
      badTargetCategory  = [[FIXEDWING]],
      mainDir            = [[0 0 1]],
      maxAngleDif        = 90,
      onlyTargetCategory = [[SWIM LAND SUB SINK FLOAT SHIP]],
    },


    {
      def                = [[ARM_TORPEDO]],
      badTargetCategory  = [[FIXEDWING]],
      mainDir            = [[0 0 1]],
      maxAngleDif        = 180,
      onlyTargetCategory = [[SWIM LAND SUB SINK FLOAT SHIP]],
    },

  },


  weaponDefs             = {

    ARM_TORPEDO = {
      name                    = [[Torpedo]],
      areaOfEffect            = 16,
      avoidFriendly           = false,
      burnblow                = true,
      collideFriendly         = false,
      craterBoost             = 0,
      craterMult              = 0,

      damage                  = {
        default = 410,
        subs    = 410,
      },

      explosionGenerator      = [[custom:TORPEDO_HIT]],
      fixedLauncher           = true,
      flightTime              = 6,
      impactOnly              = true,
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      interceptedByShieldType = 1,
      lineOfSight             = true,
      model                   = [[wep_t_longbolt.s3o]],
      noSelfDamage            = true,
      propeller               = true,
      range                   = 500,
      reloadtime              = 3,
      renderType              = 1,
      soundHit                = [[explosion/ex_underwater]],
      soundStart              = [[weapon/torpedo]],
      startVelocity           = 90,
      tolerance               = 31999,
      tracks                  = true,
      turnRate                = 10000,
      turret                  = true,
      waterWeapon             = true,
      weaponAcceleration      = 25,
      weaponType              = [[TorpedoLauncher]],
      weaponVelocity          = 140,
    },


    FAKEWEAPON  = {
      name                    = [[Fake Torpedo - Points me in the right direction]],
      areaOfEffect            = 16,
      avoidFriendly           = false,
      burnblow                = true,
      collideFriendly         = false,
      craterBoost             = 0,
      craterMult              = 0,

      damage                  = {
        default = 0.1,
        planes  = 0.1,
        subs    = 0.1,
      },

      explosionGenerator      = [[custom:TORPEDO_HIT]],
      fixedLauncher           = true,
      flightTime              = 6,
      impactOnly              = true,
      impulseBoost            = 0,
      impulseFactor           = 0,
      interceptedByShieldType = 0,
      lineOfSight             = true,
      model                   = [[wep_t_longbolt.s3o]],
      propeller               = true,
      range                   = 500,
      reloadtime              = 1,
      renderType              = 1,
      startVelocity           = 90,
      tolerance               = 10000,
      tracks                  = true,
      turnRate                = 10000,
      turret                  = true,
      waterWeapon             = true,
      weaponAcceleration      = 25,
      weaponType              = [[TorpedoLauncher]],
      weaponVelocity          = 140,
    },

  },


  featureDefs            = {

    DEAD = {
      description      = [[Wreckage - Snake]],
      blocking         = false,
      category         = [[corpses]],
      damage           = 950,
      energy           = 0,
      featureDead      = [[HEAP]],
      footprintX       = 4,
      footprintZ       = 4,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 240,
      object           = [[sub_dead.s3o]],
      reclaimable      = true,
      reclaimTime      = 240,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },


    HEAP = {
      description      = [[Debris - Snake]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 900,
      energy           = 0,
      featurereclamate = [[SMUDGE01]],
      footprintX       = 4,
      footprintZ       = 4,
      hitdensity       = [[100]],
      metal            = 120,
      object           = [[debris4x4c.s3o]],
      reclaimable      = true,
      reclaimTime      = 120,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

  },

}

return lowerkeys({ corsub = unitDef })
