unitDef = {
  unitname              = [[armorco]],
  name                  = [[Detriment]],
  description           = [[Ultimate Assault Strider]],
  acceleration          = 0.1092,
  bmcode                = [[1]],
  brakeRate             = 0.2392,
  buildCostEnergy       = 28000,
  buildCostMetal        = 28000,
  builder               = false,
  buildPic              = [[ARMORCO.png]],
  buildTime             = 28000,
  canAttack             = true,
  canGuard              = true,
  canMove               = true,
  canPatrol             = true,
  canstop               = [[1]],
  category              = [[LAND]],
  corpse                = [[DEAD]],

  customParams          = {
    description_fr = [[Walker Éxperimental d'Assaut Lourd]],
    helptext       = [[The ultimate in Nova bots, the Detriment derives its spirit from a legendary Nova commander. It can defend itself against air attacks or use its rockets to hit distant targets, but the real meat lies in the massive gauss guns designed for one purpose - to kill other heavy units quickly and efficiently. Remember - the wise commander sends his Detriment out with adequate escorts against light unit swarms and air assaults.]],
    helptext_fr    = [[Le Detriment est le summum de la technologie. Assez solide pour résister r plusieurs missiles nucléaires, capable de repérer des unités camouflées il fait passer le Bantha pour un caniche. Son armement fait pâlir une armée enticre, et sa relative lenteur est son seul défaut. Son prix est exorbitant et éxige des sacrifices, mais une fois construit rien ne l'arrete.]],
  },

  damageModifier        = 1,
  defaultmissiontype    = [[Standby]],
  explodeAs             = [[NUCLEAR_MISSILE]],
  footprintX            = 6,
  footprintZ            = 6,
  iconType              = [[krogoth]],
  idleAutoHeal          = 30,
  idleTime              = 0,
  immunetoparalyzer     = [[1]],
  maneuverleashlength   = [[640]],
  mass                  = 2233,
  maxDamage             = 85800,
  maxSlope              = 37,
  maxVelocity           = 1.626,
  maxWaterDepth         = 5000,
  minCloakDistance      = 75,
  movementClass         = [[AKBOT6]],
  noAutoFire            = false,
  noChaseCategory       = [[TERRAFORM SATELLITE SUB]],
  objectName            = [[ARMORCO]],
  seismicSignature      = 4,
  selfDestructAs        = [[NUCLEAR_MISSILE]],
  selfDestructCountdown = 10,
  shootme               = [[1]],
  side                  = [[ARM]],
  sightDistance         = 910,
  smoothAnim            = true,
  steeringmode          = [[2]],
  TEDClass              = [[KBOT]],
  turnRate              = 482,
  unitnumber            = [[263]],
  upright               = true,
  workerTime            = 0,

  weapons               = {

    {
      def                = [[GAUSS]],
      badTargetCategory  = [[FIXEDWING]],
      onlyTargetCategory = [[FIXEDWING LAND SINK SHIP SWIM FLOAT GUNSHIP HOVER]],
    },


    {
      def                = [[LASER]],
      badTargetCategory  = [[GUNSHIP]],
      onlyTargetCategory = [[FIXEDWING GUNSHIP]],
    },


    {
      def                = [[ORCONE_ROCKET]],
      badTargetCategory  = [[SWIM LAND SHIP HOVER]],
      onlyTargetCategory = [[SWIM LAND SINK FLOAT SHIP HOVER]],
    },

  },


  weaponDefs            = {

    GAUSS         = {
      name                    = [[Gauss Battery]],
      alphaDecay              = 0.12,
      areaOfEffect            = 16,
      bouncerebound           = 0.15,
      bounceslip              = 1,
      burst                   = 3,
      burstrate               = 0.2,
      cegTag                  = [[gauss_tag_h]],
      craterBoost             = 0,
      craterMult              = 0,

      damage                  = {
        default = 200,
        planes  = 200,
        subs    = 10,
      },

      explosionGenerator      = [[custom:gauss_hit_h]],
      groundbounce            = 1,
      impactOnly              = true,
      impulseBoost            = 0,
      impulseFactor           = 0,
      interceptedByShieldType = 1,
      lineOfSight             = true,
      minbarrelangle          = [[-15]],
      noExplode               = true,
      noSelfDamage            = true,
      numbounce               = 40,
      range                   = 600,
      reloadtime              = 1.2,
      renderType              = 4,
      rgbColor                = [[0.5 1 1]],
      separation              = 0.5,
      size                    = 0.8,
      sizeDecay               = -0.1,
      soundHit                = [[weapon/gauss_hit]],
      soundStart              = [[weapon/gauss_fire]],
      sprayangle              = 800,
      stages                  = 32,
      startsmoke              = [[1]],
      tolerance               = 4096,
      turret                  = true,
      waterbounce             = 1,
      weaponType              = [[Cannon]],
      weaponVelocity          = 900,
    },


    LASER         = {
      name                    = [[Anti-Air Laser Battery]],
      areaOfEffect            = 12,
      beamDecay               = 0.736,
      beamlaser               = 1,
      beamTime                = 0.01,
      beamttl                 = 15,
      canattackground         = false,
      coreThickness           = 0.5,
      craterBoost             = 0,
      craterMult              = 0,
      cylinderTargetting      = 1,

      damage                  = {
        default = 2,
        planes  = 20,
        subs    = 1,
      },

      explosionGenerator      = [[custom:flash_teal7]],
      fireStarter             = 100,
      impactOnly              = true,
      impulseFactor           = 0,
      interceptedByShieldType = 1,
      laserFlareSize          = 3.75,
      lineOfSight             = true,
      minIntensity            = 1,
      noSelfDamage            = true,
      pitchtolerance          = 8192,
      range                   = 820,
      reloadtime              = 0.1,
      renderType              = 0,
      rgbColor                = [[0 1 1]],
      soundStart              = [[weapon/laser/rapid_laser]],
      thickness               = 2.5,
      tolerance               = 8192,
      turret                  = true,
      weaponType              = [[BeamLaser]],
      weaponVelocity          = 2200,
    },


    ORCONE_ROCKET = {
      name                    = [[Riot Rockets]],
      areaOfEffect            = 160,
      collideFriendly         = false,
      craterBoost             = 1,
      craterMult              = 2,

      damage                  = {
        default = 850,
        planes  = 850,
        subs    = 11,
      },

      edgeEffectiveness       = 0.75,
      explosionGenerator      = [[custom:STARFIRE]],
      fireStarter             = 55,
      guidance                = true,
      impulseBoost            = 0,
      impulseFactor           = 0.8,
      interceptedByShieldType = 2,
      lineOfSight             = true,
      metalpershot            = 0,
      model                   = [[exphvyrock]],
      noautorange             = [[1]],
      noSelfDamage            = true,
      range                   = 925,
      reloadtime              = 1.55,
      renderType              = 1,
      selfprop                = true,
      smokedelay              = [[0.1]],
      smokeTrail              = true,
      soundHit                = [[weapon/missile/vlaunch_hit]],
      soundStart              = [[weapon/missile/missile_launch]],
      startsmoke              = [[1]],
      twoPhase                = true,
      vlaunch                 = true,
      weaponAcceleration      = 245,
      weaponTimer             = 2,
      weaponType              = [[StarburstLauncher]],
      weaponVelocity          = 10000,
    },

  },


  featureDefs           = {

    DEAD  = {
      description      = [[Wreckage - Detriment]],
      blocking         = true,
      category         = [[arm_corpses]],
      damage           = 85800,
      featureDead      = [[DEAD2]],
      featurereclamate = [[smudge01]],
      footprintX       = 4,
      footprintZ       = 4,
      height           = [[60]],
      hitdensity       = [[150]],
      metal            = 11200,
      object           = [[Armorco_dead]],
      reclaimable      = true,
      reclaimTime      = 11200,
      world            = [[All Worlds]],
    },


    DEAD2 = {
      description      = [[Debris - Detriment]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 85800,
      featureDead      = [[HEAP]],
      featurereclamate = [[smudge01]],
      footprintX       = 3,
      footprintZ       = 3,
      height           = [[2]],
      hitdensity       = [[105]],
      metal            = 11200,
      object           = [[debris4x4b.s3o]],
      reclaimable      = true,
      reclaimTime      = 11200,
      seqnamereclamate = [[tree1reclamate]],
      world            = [[All Worlds]],
    },


    HEAP  = {
      description      = [[Debris - Detriment]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 85800,
      featurereclamate = [[smudge01]],
      footprintX       = 3,
      footprintZ       = 3,
      height           = [[2]],
      hitdensity       = [[105]],
      metal            = 5600,
      object           = [[debris4x4b.s3o]],
      reclaimable      = true,
      reclaimTime      = 5600,
      seqnamereclamate = [[tree1reclamate]],
      world            = [[All Worlds]],
    },

  },

}

return lowerkeys({ armorco = unitDef })
