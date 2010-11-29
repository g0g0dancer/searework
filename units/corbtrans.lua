unitDef = {
  unitname            = [[corbtrans]],
  name                = [[Vindicator]],
  description         = [[Armed Heavy Air Transport]],
  acceleration        = 0.2,
  amphibious          = true,
  antiweapons         = [[1]],
  bankscale           = [[1]],
  bmcode              = [[1]],
  brakeRate           = 6.25,
  buildCostEnergy     = 500,
  buildCostMetal      = 500,
  builder             = false,
  buildPic            = [[corbtrans.png]],
  buildTime           = 500,
  canAttack           = true,
  canFly              = true,
  canGuard            = true,
  canload             = [[1]],
  canMove             = true,
  canPatrol           = true,
  canstop             = [[1]],
  canSubmerge         = false,
  category            = [[GUNSHIP]],
  collide             = false,
  corpse              = [[HEAP]],
  cruiseAlt           = 250,

  customParams        = {
    description_bp = [[Transporte aéreo pesado armado]],
    description_fr = [[Transport Aerien Arm? Lourd]],
    helptext       = [[The Vindicator can haul any land unit in the game. Its twin laser guns and automated cargo ejection system make it ideal for drops into hot LZs.]],
    helptext_bp    = [[Essa aeronave de transporte é resistente o suficiente para aguentar algum fogo anti-aéreo e vem armada com canh?es laser que dispara contra aquilo que a ataca. Se for destruída durante o voo sua carga é ejetada e com sorte pousa em segurança. ]],
    helptext_fr    = [[Le Vindicator est le summum du transport aerien. Rapide et puissant il peut transporter toutes vos unit?s sur le champ de bataille, il riposte aux tirs gr?ce ? ses multiples canons laser, et s'il est abattu, il ejecte sa livraison au sol avant d'exploser.]],
  },

  defaultmissiontype  = [[VTOL_standby]],
  designation         = [[AFD-T4]],
  downloadable        = [[1]],
  explodeAs           = [[GUNSHIPEX]],
  floater             = true,
  footprintX          = 4,
  footprintZ          = 4,
  frenchdescription   = [[Avion de transport lourd]],
  frenchname          = [[Vindicator]],
  germandescription   = [[Schwerer Lufttransporter]],
  germanname          = [[Vindicator]],
  iconType            = [[airtransport]],
  idleAutoHeal        = 5,
  idleTime            = 3000,
  maneuverleashlength = [[1280]],
  mass                = 230,
  maxDamage           = 1100,
  maxVelocity         = 8,
  minCloakDistance    = 75,
  noChaseCategory     = [[TERRAFORM FIXEDWING SATELLITE SUB]],
  objectName          = [[CORBTRANS]],
  releaseHeld         = true,
  scale               = [[0.8]],
  seismicSignature    = 0,
  selfDestructAs      = [[GUNSHIPEX]],

  sfxtypes            = {

    explosiongenerators = {
      [[custom:VINDIMUZZLE]],
      [[custom:VINDIBACK]],
      [[custom:BEAMWEAPON_MUZZLE_RED]],
    },

  },

  shootme             = [[1]],
  side                = [[CORE]],
  sightDistance       = 660,
  smoothAnim          = true,
  steeringmode        = [[1]],
  TEDClass            = [[VTOL]],
  transportCapacity   = 1,
  transportSize       = 25,
  turnInPlace         = 0,
  turnRate            = 420,
  unitnumber          = [[2345]],
  version             = [[1]],
  verticalSpeed       = 30,
  workerTime          = 0,

  weapons             = {

    {
      def                = [[LASER]],
      badTargetCategory  = [[FIXEDWING]],
      onlyTargetCategory = [[FIXEDWING LAND SINK SHIP SWIM FLOAT GUNSHIP HOVER]],
    },


    {
      def                = [[LASER]],
      badTargetCategory  = [[FIXEDWING]],
      onlyTargetCategory = [[FIXEDWING LAND SINK SHIP SWIM FLOAT GUNSHIP HOVER]],
    },

  },


  weaponDefs          = {

    LASER = {
      name                    = [[Light Laser Blaster]],
      areaOfEffect            = 8,
      avoidFeature            = false,
      beamWeapon              = true,
      collideFriendly         = false,
      coreThickness           = 0.5,
      craterBoost             = 0,
      craterMult              = 0,

      damage                  = {
        default = 7,
        subs    = 0.35,
      },

      duration                = 0.02,
      explosionGenerator      = [[custom:BEAMWEAPON_HIT_RED]],
      fireStarter             = 50,
      impactOnly              = true,
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      interceptedByShieldType = 1,
      lineOfSight             = true,
      noSelfDamage            = true,
      range                   = 350,
      reloadtime              = 0.2,
      renderType              = 0,
      rgbColor                = [[1 0 0]],
      soundHit                = [[weapon/laser/lasercannon_hit]],
      soundStart              = [[weapon/laser/lasercannon_fire]],
      soundTrigger            = true,
      targetMoveError         = 0.15,
      thickness               = 2.38484800354236,
      tolerance               = 10000,
      turret                  = true,
      weaponType              = [[LaserCannon]],
      weaponVelocity          = 2400,
    },

  },


  featureDefs         = {

    DEAD  = {
      description      = [[Wreckage - Vindicator]],
      blocking         = true,
      category         = [[corpses]],
      damage           = 1100,
      energy           = 0,
      featureDead      = [[DEAD2]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 2,
      footprintZ       = 2,
      height           = [[40]],
      hitdensity       = [[100]],
      metal            = 200,
      object           = [[wreck4x4c.s3o]],
      reclaimable      = true,
      reclaimTime      = 200,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },


    DEAD2 = {
      description      = [[Debris - Vindicator]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 1100,
      energy           = 0,
      featureDead      = [[HEAP]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 2,
      footprintZ       = 2,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 200,
      object           = [[debris3x3c.s3o]],
      reclaimable      = true,
      reclaimTime      = 200,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },


    HEAP  = {
      description      = [[Debris - Vindicator]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 1100,
      energy           = 0,
      featurereclamate = [[SMUDGE01]],
      footprintX       = 2,
      footprintZ       = 2,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 100,
      object           = [[debris3x3c.s3o]],
      reclaimable      = true,
      reclaimTime      = 100,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

  },

}

return lowerkeys({ corbtrans = unitDef })
