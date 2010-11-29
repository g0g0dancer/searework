unitDef = {
  unitname                      = [[armanni]],
  name                          = [[Annihilator]],
  description                   = [[Tachyon Accelerator (Counter-Artillery/Anti-Armor)]],
  acceleration                  = 0,
  activateWhenBuilt             = true,
  bmcode                        = [[0]],
  brakeRate                     = 0,
  buildAngle                    = 4096,
  buildCostEnergy               = 2200,
  buildCostMetal                = 2200,
  builder                       = false,
  buildingGroundDecalDecaySpeed = 30,
  buildingGroundDecalSizeX      = 6,
  buildingGroundDecalSizeY      = 6,
  buildingGroundDecalType       = [[armanni_aoplane.dds]],
  buildPic                      = [[ARMANNI.png]],
  buildTime                     = 2200,
  canAttack                     = true,
  canstop                       = [[1]],
  category                      = [[SINK]],
  collisionVolumeTest           = 1,
  corpse                        = [[DEAD]],

  customParams                  = {
    description_fr = [[Acc?lerateur Tachyon]],
    description_pl = [[Akcelerator Tachyonów]],
    helptext       = [[Inside the heavily armored shell of the Annihilator lies the devastating Tachyon Accelerator. This fearsome weapon is capable of delivering pinpoint damage at extreme ranges, provided you have plenty of energy reserves. Remember that the Annihilator is strictly a support weapon; leave it unguarded and it will be swamped with raiders.]],
    helptext_fr    = [[Protégé derri?re le blindage lourd de l'Annihilator se trouve le terrible Canon Accélerateur de Tachyon. Cette arme terrifiante est capable d'envoyer des quantités colossales d'énergie sur un point précis, percant tous les blindages aisément, le tout ? une distance terrifiante. Son co?t et sa consommation d'énergie la rendent cependant difficile ? employer.]],
    helptext_pl    = [[Pod ci??kim pancerzem Annihilatora znajduje si? niszczycielski Akcelerator Tachyonów. Ta straszliwa bro? pozwala na zadawanie wysokich obra?e? oddalonym celom, zak?adaj?c ?e masz do?? energii by j? zasili?.]],
  },

  damageModifier                = 0.25,
  defaultmissiontype            = [[GUARD_NOMOVE]],
  explodeAs                     = [[CRAWL_BLASTSML]],
  footprintX                    = 4,
  footprintZ                    = 4,
  iconType                      = [[fixedtachyon]],
  idleAutoHeal                  = 5,
  idleTime                      = 1800,
  mass                          = 556,
  maxDamage                     = 7000,
  maxSlope                      = 18,
  maxVelocity                   = 0,
  maxWaterDepth                 = 0,
  minCloakDistance              = 150,
  noChaseCategory               = [[FIXEDWING LAND SHIP SATELLITE SWIM GUNSHIP SUB HOVER]],
  objectName                    = [[arm_annihilator.s3o]],
  onoffable                     = true,
  seismicSignature              = 4,
  selfDestructAs                = [[CRAWL_BLASTSML]],
  side                          = [[ARM]],
  sightDistance                 = 780,
  smoothAnim                    = true,
  TEDClass                      = [[FORT]],
  turnRate                      = 0,
  useBuildingGroundDecal        = true,
  workerTime                    = 0,
  yardMap                       = [[oooooooooooooooo]],

  weapons                       = {

    {
      def                = [[ATA]],
      badTargetCategory  = [[FIXEDWING GUNSHIP]],
      onlyTargetCategory = [[SWIM LAND SHIP SINK FLOAT GUNSHIP HOVER]],
    },

  },


  weaponDefs                    = {

    ATA = {
      name                    = [[Tachyon Accelerator]],
      areaOfEffect            = 20,
      avoidFeature            = false,
      avoidNeutral            = false,
      beamlaser               = 1,
      beamTime                = 1,
      coreThickness           = 0.5,
      craterBoost             = 0,
      craterMult              = 0,

      damage                  = {
        default = 3000,
        planes  = 3000,
        subs    = 150,
      },

      explosionGenerator      = [[custom:ataalaser]],
      impactOnly              = true,
      impulseBoost            = 0,
      impulseFactor           = 0.4,
      interceptedByShieldType = 1,
      largeBeamLaser          = true,
      laserFlareSize          = 16.94,
      lineOfSight             = true,
      minIntensity            = 1,
      noSelfDamage            = true,
      range                   = 1250,
      reloadtime              = 8,
      renderType              = 0,
      rgbColor                = [[0.25 0 1]],
      soundStart              = [[weapon/laser/heavy_laser6]],
      targetMoveError         = 0.3,
      texture1                = [[largelaser]],
      texture2                = [[flare]],
      texture3                = [[flare]],
      texture4                = [[smallflare]],
      thickness               = 16.9373846859543,
      tolerance               = 10000,
      turret                  = true,
      weaponType              = [[BeamLaser]],
      weaponVelocity          = 1400,
    },

  },


  featureDefs                   = {

    DEAD  = {
      description      = [[Wreckage - Annihilator]],
      blocking         = true,
      category         = [[corpses]],
      damage           = 7000,
      energy           = 0,
      featureDead      = [[DEAD2]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 3,
      footprintZ       = 3,
      height           = [[20]],
      hitdensity       = [[100]],
      metal            = 880,
      object           = [[arm_annihilator_dead.s3o]],
      reclaimable      = true,
      reclaimTime      = 880,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },


    DEAD2 = {
      description      = [[Debris - Annihilator]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 7000,
      energy           = 0,
      featureDead      = [[HEAP]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 3,
      footprintZ       = 3,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 880,
      object           = [[debris3x3a.s3o]],
      reclaimable      = true,
      reclaimTime      = 880,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },


    HEAP  = {
      description      = [[Debris - Annihilator]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 7000,
      energy           = 0,
      featurereclamate = [[SMUDGE01]],
      footprintX       = 3,
      footprintZ       = 3,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 880,
      object           = [[debris3x3a.s3o]],
      reclaimable      = true,
      reclaimTime      = 880,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

  },

}

return lowerkeys({ armanni = unitDef })
