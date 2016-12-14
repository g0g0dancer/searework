unitDef = {
  unitname                = [[rocksink]],
  name                    = [[Rocking Damage Sink thing]],
  description             = [[Rocks when you shoot at it.]],
  acceleration            = 0,
  autoHeal                = 500000,
  buildCostEnergy         = 10,
  buildCostMetal          = 10,
  builder                 = false,
  buildingGroundDecalType = [[zenith_aoplane.dds]],
  buildPic                = [[zenith.png]],
  buildTime               = 10,
  canstop                 = [[1]],
  category                = [[SINK GUNSHIP]],
  energyUse               = 0,
  footprintX              = 2,
  footprintZ              = 2,
  iconType                = [[mahlazer]],
  idleAutoHeal            = 5,
  idleTime                = 1800,
  maxDamage               = 500000,
  maxSlope                = 18,
  maxVelocity             = 0,
  maxWaterDepth           = 0,
  minCloakDistance        = 150,
  objectName              = [[zenith.s3o]],
  script                  = [[nullrock.lua]],
  seismicSignature        = 4,
  sightDistance           = 660,
  turnRate                = 0,
  useBuildingGroundDecal  = true,
  workerTime              = 0,
  yardMap                 = [[yyyy]],
}

return lowerkeys({ rocksink = unitDef })
