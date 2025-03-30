# packages
library(sf)
library(terra)
library(tmap)
library(whitebox)
library(tidyverse)
library(viridisLite)

terrain_colors <- colorRampPalette(c("#dcfffc", "#c5e3be", "#e3ff00", "#ffcc78", "#fff8eb"))

# data
dem_tile_N <- rast("data/dem/ASTGTMV003N.tif")
dem_tile_S <- rast("data/dem/ASTGTMV003S.tif")

# get crs
prj_text <- readLines("data/WGS_1984_Lambert_Azimuthal_Equal_Area.prj")
crs <- crs(prj_text) # Convert WKT to an sf CRS object

# mosaic dem
dem_mosaic <- project(mosaic(dem_tile_N, dem_tile_S, fun="last"), crs, res = 250)

# Plot DEM Tile North
# Hillshading
slope <- terrain(dem_tile_N, "slope", unit="radians")
aspect <- terrain(dem_tile_N, "aspect", unit="radians")
hill <- shade(slope, aspect, angle = c(45, 45, 45, 80), direction = c(225, 270, 315, 135))
hill <- Reduce(mean, hill)

png(file = "figures/dem_tile_N.png", width = 2000, height = 2000)
tm_shape(hill) +
  tm_raster(
    col.scale = tm_scale_continuous(
      values = gray(0:100 / 100)
    ), 
    col.legend = tm_legend_hide()
  )  +
tmap::tm_shape(dem_tile_N) +
  tmap::tm_raster(
    col.scale = tmap::tm_scale_continuous(
      values = terrain_colors(100),
      midpoint = NA),
    col.legend = tmap::tm_legend(
      title = "Height [m]",
      title.size = 1,
      text.size = 1,
      bg.color = "white",
      bg.alpha = 1,
      position = tmap::tm_pos_in("left", "bottom"),
      frame = TRUE,
      reverse = TRUE
    ),
    col_alpha = 0.5
  ) +
  tmap::tm_graticules() +
  tmap::tm_layout(
    scale = 3.0
  ) +
  tm_title("DEM Tile North", fontface = "bold", position = tm_pos_out(cell.h = "center", cell.v = "top", pos.h = "center"))
dev.off()

# Plot DEM Tile South
# Hillshading
slope <- terrain(dem_tile_S, "slope", unit="radians")
aspect <- terrain(dem_tile_S, "aspect", unit="radians")
hill <- shade(slope, aspect, angle = c(45, 45, 45, 80), direction = c(225, 270, 315, 135))
hill <- Reduce(mean, hill)

png(file = "figures/dem_tile_S.png", width = 2000, height = 2000)
tm_shape(hill) +
  tm_raster(
    col.scale = tm_scale_continuous(
      values = gray(0:100 / 100)
    ), 
    col.legend = tm_legend_hide()
  )  +
tmap::tm_shape(dem_tile_S) +
  tmap::tm_raster(
    col.scale = tmap::tm_scale_continuous(
      values = terrain_colors(100),
      midpoint = NA),
    col.legend = tmap::tm_legend(
      title = "Height [m]",
      title.size = 1,
      text.size = 1,
      bg.color = "white",
      bg.alpha = 1,
      position = tmap::tm_pos_in("left", "bottom"),
      frame = TRUE,
      reverse = TRUE
    ),
    col_alpha = 0.5
  ) +
  tmap::tm_graticules() +
  tmap::tm_layout(
    scale = 3.0
  ) +
  tm_title("DEM Tile South", fontface = "bold", position = tm_pos_out(cell.h = "center", cell.v = "top", pos.h = "center"))
dev.off()

# Plot DEM Mosaic
# Hillshading
slope <- terrain(dem_mosaic, "slope", unit="radians")
aspect <- terrain(dem_mosaic, "aspect", unit="radians")
hill <- shade(slope, aspect, angle = c(45, 45, 45, 80), direction = c(225, 270, 315, 135))
hill <- Reduce(mean, hill)

png(file = "figures/dem_mosaic.png", width = 2000, height = 2000)
tm_shape(hill) +
  tm_raster(
    col.scale = tm_scale_continuous(
      values = gray(0:100 / 100)
    ), 
    col.legend = tm_legend_hide()
  )  +
tmap::tm_shape(dem_mosaic) +
  tmap::tm_raster(
    col.scale = tmap::tm_scale_continuous(
      values = terrain_colors(100),
      midpoint = NA),
    col.legend = tmap::tm_legend(
      title = "Height [m]",
      title.size = 1,
      text.size = 1,
      bg.color = "white",
      bg.alpha = 1,
      position = tmap::tm_pos_in("left", "bottom"),
      frame = TRUE,
      reverse = TRUE
    ),
    col_alpha = 0.5
  ) +
  tmap::tm_grid() +
  tmap::tm_layout(
    scale = 3.5
  ) +
  tm_title("DEM Mosaic (projected)", fontface = "bold", position = tm_pos_out(cell.h = "center", cell.v = "top", pos.h = "center"))
dev.off()

# crop mosaic_dem
# v <- project(vect("data/shapefiles/kenia_rusle_ext.shp"), crs)
# ext <- ext(v)
ext <- ext(1545000, 1846000, -700000, -380000)
dem <- crop(dem_mosaic, ext)
ext(dem) <- ext

# mask waterbodies in filled DEM
waterbodies <- 
  rast("data/dem/ASTWBD_ATTNC.001_ASTWBD_att_doy2000061_aid0001.tif") %>%
  project(., crs, res = 250)
waterbodies_mask <- ifel(waterbodies == 0 | is.na(waterbodies), 1, NA) %>% crop(., ext)
ext(waterbodies_mask) <- ext

dem <- mask(dem, waterbodies_mask)

# Hillshading
slope <- terrain(dem, "slope", unit="radians")
aspect <- terrain(dem, "aspect", unit="radians")
hill <- shade(slope, aspect, angle = c(45, 45, 45, 80), direction = c(225, 270, 315, 135))
hill <- Reduce(mean, hill)

png(file = "figures/dem.png", width = 2000, height = 2000)
tm_shape(hill) +
  tm_raster(
    col.scale = tm_scale_continuous(
      values = gray(0:100 / 100)
      ), 
    col.legend = tm_legend_hide()
    )  +
tmap::tm_shape(dem) +
  tmap::tm_raster(
    col.scale = tmap::tm_scale_continuous(
      values = terrain_colors(100),
      midpoint = NA,
      value.na = "#3892c6",
      label.na = "Waterbodies"
      ),
    col.legend = tmap::tm_legend(
      title = "Height [m]",
      title.size = 1,
      text.size = 1,
      bg.color = "white",
      bg.alpha = 1,
      position = tmap::tm_pos_in("left", "bottom"),
      frame = TRUE,
      reverse = TRUE,
      show = TRUE
    ),
    col_alpha = 0.5
  ) +
  tmap::tm_grid() +
  tmap::tm_layout(
    scale = 3.5
  ) +
  tm_title("Final DEM (cropped)", position = tm_pos_out(cell.h = "center", cell.v = "top", pos.h = "center"))
dev.off()

writeRaster(dem, filename = "data/R/dem.tif", overwrite = TRUE)


# Depressionless DEM
wbt_fill_depressions("data/R/dem.tif", "data/R/filled_dem.tif")


dem_filled <- rast("data/R/filled_dem.tif")
values(dem_filled) <- values(dem_filled)

# Hillshading
slope <- terrain(dem_filled, "slope", unit="radians")
aspect <- terrain(dem_filled, "aspect", unit="radians")
hill <- shade(slope, aspect, angle = c(45, 45, 45, 80), direction = c(225, 270, 315, 135))
hill <- Reduce(mean, hill)

png(file = "figures/dem_filled.png", width = 2000, height = 2000)
tm_shape(hill) +
  tm_raster(
    col.scale = tm_scale_continuous(
      values = gray(0:100 / 100)
    ), 
    col.legend = tm_legend_hide()
  )  +
tmap::tm_shape(dem_filled) +
  tmap::tm_raster(
    col.scale = tmap::tm_scale_continuous(
      values = terrain_colors(100),
      midpoint = NA,
      value.na = "#3892c6",
      label.na = "Waterbodies"
    ),
    col.legend = tmap::tm_legend(
      title = "Height [m]",
      title.size = 1,
      text.size = 1,
      bg.color = "white",
      bg.alpha = 1,
      position = tmap::tm_pos_in("left", "bottom"),
      frame = TRUE,
      reverse = TRUE,
      show = TRUE
    ),
    col_alpha = 0.5
  ) +
  tmap::tm_grid() +
  tmap::tm_layout(
    scale = 3.5
  ) +
  tm_title("Depressionless DEM", fontface = "bold", position = tm_pos_out(cell.h = "center", cell.v = "top", pos.h = "center"))
dev.off()

###############
## LS-Factor ##
###############

# Calculating L: Upphill Area
ls_flow <- terrain(dem_filled, "flowdir")
ls_uparea <- flowAccumulation(ls_flow)
ls_uparea[is.na(waterbodies_mask)] <- NA

flowdir_colors <- colorRampPalette(c("transparent", "red", "deepskyblue","darkslateblue","mediumseagreen","orange","brown","darkgray","mediumvioletred"))
png(file = "figures/ls_flow.png", width = 2000, height = 2000)
tmap::tm_shape(ls_flow) +
  tmap::tm_raster(
    col.scale = tmap::tm_scale_ordinal(
      values = flowdir_colors(9),
      # levels = levels(ls_flow),
      value.na = "#3892c6",
      label.na = "Waterbodies"
    ),
    col.legend = tmap::tm_legend(
      title = "Direction [°]",
      title.size = 1,
      text.size = 1,
      bg.color = "white",
      bg.alpha = 0.7,
      position = tmap::tm_pos_in("left", "bottom"),
      frame = TRUE,
      reverse = FALSE,
      show = TRUE
    ),
    col_alpha = 1
  ) +
  tmap::tm_graticules(
    lines = F
  ) +
  tmap::tm_layout(
    scale = 3.5
  ) +
  tm_title("Flow Direction", fontface = "bold", position = tm_pos_out(cell.h = "center", cell.v = "top", pos.h = "center"))
dev.off()

flowacc_colors <- colorRampPalette(c("transparent", "#e0f3b2", "#97d6b9", "#41b6c4", "#1e80b8", "#23429b", "#091c58"))
labels <- c("≤ 2", "2 - 10", "10 - 50", "50 - 200", "200 - 800", "800 - 2000", "> 2000")
breaks <- c(0, 2, 10, 50, 200, 800, 2000, 121492)
png(file = "figures/ls_uparea.png", width = 2000, height = 2000)
tmap::tm_shape(ls_uparea) +
  tmap::tm_raster(
    col.scale = tmap::tm_scale_intervals(
      breaks = breaks,
      values = flowacc_colors(8),
      labels = labels,
      value.na = "#3892c6",
      label.na = "Waterbodies"
    ),
    col.legend = tmap::tm_legend(
      title = "Accumulation [#cells]",
      title.size = 1,
      text.size = 1,
      bg.color = "white",
      bg.alpha = 0.7,
      position = tmap::tm_pos_in("left", "bottom"),
      frame = TRUE,
      reverse = TRUE,
      show = TRUE
    ),
    col_alpha = 1
  ) +
  tmap::tm_graticules(
    lines = F
  ) +
  tmap::tm_layout(
    scale = 3.5
  ) +
  tm_title("Flow Accumulation", fontface = "bold", position = tm_pos_out(cell.h = "center", cell.v = "top", pos.h = "center"))
dev.off()

# Calculating S: Slope
ls_slope <- terrain(dem_filled, "slope", unit = "degrees")
white_to_saddle_brown <- colorRampPalette(c("beige","darkgoldenrod2", "darkgoldenrod4"))
png(file = "figures/ls_slope.png", width = 2000, height = 2000)
tmap::tm_shape(ls_slope) +
  tmap::tm_raster(
    col.scale = tmap::tm_scale_continuous(
      values = white_to_saddle_brown(100),
      midpoint = NA,
      value.na = "#3892c6",
      label.na = "Waterbodies"
    ),
    col.legend = tmap::tm_legend(
      title = "Slope [°]",
      title.size = 1,
      text.size = 1,
      bg.color = "white",
      bg.alpha = 0.7,
      position = tmap::tm_pos_in("left", "bottom"),
      frame = TRUE,
      reverse = TRUE,
      show = TRUE
    ),
    col_alpha = 1
  ) +
  tmap::tm_graticules(
    lines = F
  ) +
  tmap::tm_layout(
    scale = 3.5
  ) +
  tm_title("Slope", fontface = "bold", position = tm_pos_out(cell.h = "center", cell.v = "top", pos.h = "center"))
dev.off()


# UPSED Calculation of the LS-factor
# 1) Calculate L
ls_l <- ((ls_uparea*250/22.1)^(0.4)) * (0.4+1)

# 2) Calculate S
ls_s <- ((sin(ls_slope*0.01745))/0.09)^(1.4)

# 3) Multiply L and S
ls_fac <- ls_l * ls_s



ls_fac_colors <- colorRampPalette(c("#3a7d4e", "#50975f", "#9bd597", "#ddeeaa", "#eee2bb", "#bc9dca", "#854894", "#5e006e"))
labels <- c("0 - 0.1", "0.1 - 0.5", "0.5 - 1", "1 - 3", "3 - 8", "8 - 15", "15 - 30", "> 30")
breaks <- c(0, 0.1, 0.5, 1, 3, 8, 15, 30, 993)
png(file = "figures/ls_fac.png", width = 2000, height = 2000)
tmap::tm_shape(ls_fac) +
  tmap::tm_raster(
    col.scale = tmap::tm_scale_intervals(
      breaks = breaks,
      values = ls_fac_colors(8),
      labels = labels,
      # levels = levels(ls_flow),
      value.na = "#3892c6",
      label.na = "Waterbodies"
    ),
    col.legend = tmap::tm_legend(
      title = "LS-Factor",
      title.size = 1,
      text.size = 1,
      bg.color = "white",
      bg.alpha = 0.7,
      position = tmap::tm_pos_in("left", "bottom"),
      frame = TRUE,
      reverse = TRUE,
      show = TRUE
    ),
    col_alpha = 1
  ) +
  tmap::tm_graticules(
    lines = F
  ) +
  tmap::tm_layout(
    scale = 3.5
  ) +
  tm_title("LS-Factor", fontface = "bold", position = tm_pos_out(cell.h = "center", cell.v = "top", pos.h = "center"))
dev.off()


# Composite visualization
composite <- c(ls_l, ls_s)
png(file = "figures/ls_composite.png", width = 2000, height = 2000)
plotRGB(composite, r = 2, g = 1, b = 1, a = NULL, alpha = 1, stretch = "lin", colNA = "#3892c6")
dev.off()




##############
## C-Factor ##
##############


ndvi_stack <- rast(
  list(
    rast("data/modis/modis_means/MOD13Q1.mean.001.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.017.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.033.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.049.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.065.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.081.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.097.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.113.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.129.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.145.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.161.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.177.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.193.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.209.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.225.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.241.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.257.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.273.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.289.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.305.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.321.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.337.tif"),
    rast("data/modis/modis_means/MOD13Q1.mean.353.tif")
  )
)

names(ndvi_stack) = names(ndvi_stack) |> str_remove(pattern = "MOD13Q1.mean.")
length(names(ndvi_stack))

# Calculate the mean over all 23 NDVI images and scale the values from -1 to +1
ndvi_mean <- sum(ndvi_stack)/nlyr(ndvi_stack) * 0.0001
ndvi_mean <- project(ndvi_mean, crs, res = 250) %>% crop(., ext)
ext(ndvi_mean) <- ext

ndvi_mean <- mask(ndvi_mean, waterbodies_mask)

png(file = "figures/c_ndvi.png", width = 2000, height = 2000)
tmap::tm_shape(ndvi_mean) +
  tmap::tm_raster(
    col.scale = tmap::tm_scale_continuous(
      values = RdYlGn(100),
      limits = c(0,1),
      midpoint = NA,
      value.na = "#3892c6",
      label.na = "Waterbodies"
    ),
    col.legend = tmap::tm_legend(
      title = "NDVI",
      title.size = 1,
      text.size = 1,
      bg.color = "white",
      bg.alpha = 0.7,
      position = tmap::tm_pos_in("left", "bottom"),
      frame = TRUE,
      reverse = TRUE,
      show = TRUE
    ),
    col_alpha = 1
  ) +
  tmap::tm_graticules(
    lines = F
  ) +
  tmap::tm_layout(
    scale = 3.5
  ) +
  tm_title("NDVI (mean)", fontface = "bold", position = tm_pos_out(cell.h = "center", cell.v = "top", pos.h = "center"))
dev.off()

# Calculate the C Factor
c_fac <- exp(-2.0 * (ndvi_mean/(1.0 - ndvi_mean)))

breaks <- c(0, 0.01, 0.02, 0.05, 0.1, 0.2, 0.4, 0.5, 0.6, 0.7, 0.8, 1)
c_fac_colors <- colorRampPalette(c("#0070a8", "#398d9e", "#50b4b7", "#61c5a3", "#99e200", "#4ddc00", "#c8ed80", "#ffd37f", "#ffaa00", "#a87000", "sienna4"))
labels <- c("0 - 0.01", "0.01 - 0.02", "0.02 - 0.05", "0.05 - 0.1", "0.1 - 0.2", "0.2 - 0.4", "0.4 - 0.5", "0.5 - 0.6", "0.6 - 0.7", "0.7 - 0.8", "0.8 - 1")
png(file = "figures/c_fac.png", width = 2000, height = 2000)
tmap::tm_shape(c_fac) +
  tmap::tm_raster(
    col.scale = tmap::tm_scale_intervals(
      breaks = breaks,
      values = c_fac_colors(11),
      labels = labels,
      # levels = levels(ls_flow),
      value.na = "#3892c6",
      label.na = "Waterbodies"
    ),
    col.legend = tmap::tm_legend(
      title = "C-Factor",
      title.size = 1,
      text.size = 1,
      bg.color = "white",
      bg.alpha = 0.7,
      position = tmap::tm_pos_in("left", "bottom"),
      frame = TRUE,
      reverse = TRUE,
      show = TRUE
    ),
    col_alpha = 1
  ) +
  tmap::tm_graticules(
    lines = F
  ) +
  tmap::tm_layout(
    scale = 3.5
  ) +
  tm_title("C-Factor", fontface = "bold", position = tm_pos_out(cell.h = "center", cell.v = "top", pos.h = "center"))
dev.off()


##############
## K-Factor ##
##############

silt <- rast("data/k_factor/af_SLTPPT_T__M_agg.tif")
sand <- rast("data/k_factor/af_SNDPPT_T__M_agg.tif")
clay <- rast("data/k_factor/af_CLYPPT_T__M_agg.tif")
organic <- rast("data/k_factor/orgm_agg.tif")

soil_stack <- c(silt, sand, clay, organic)
names(soil_stack) <- c("silt", "sand", "clay", "organic")
soil_stack <- crop(soil_stack, ext)
ext(soil_stack) <- ext

M_sand <- (soil_stack$silt + soil_stack$sand) * (100 - soil_stack$clay)
M_vfs <- (soil_stack$silt + soil_stack$sand/5) * (100 - soil_stack$clay)

k_fac_sand = ((0.00021*(M_sand**1.14)) * (12 - soil_stack$organic) + 2.875)* 0.001317
k_fac_vfs = ((0.00021*(M_vfs**1.14)) * (12 - soil_stack$organic) + 2.875)* 0.001317

breaks <- c(min(values(k_fac_sand, na.rm = T)), 0, 0.005, 0.01, 0.0125, 0.015, 0.0175, 0.02, 0.025, 0.08)
k_fac_colors <- colorRampPalette(c("#458970", "#ffffbe", "#fff700", "#ffe800", "#ffc44a", "#ff9200", "#ff003f", "#ea00af", "#a700de"))
labels <- c("≤ 0", "0 - 0.005", "0.005 - 0.01", "0.01 - 0.0125", "0.0125 - 0.015", "0.015 - 0.0175", "0.0175 - 0.2", "0.2 - 0.025", "0.025 - 0.4")
png(file = "figures/k_fac_sand.png", width = 2000, height = 2000)
tmap::tm_shape(k_fac_sand) +
  tmap::tm_raster(
    col.scale = tmap::tm_scale_intervals(
      breaks = breaks,
      values = k_fac_colors(9),
      labels = labels,
      value.na = "#3892c6",
      label.na = "Waterbodies",
      value.neutral = "transparent"
    ),
    col.legend = tmap::tm_legend(
      title = "K-Factor",
      title.size = 1,
      text.size = 1,
      bg.color = "white",
      bg.alpha = 0.7,
      position = tmap::tm_pos_in("left", "bottom"),
      frame = TRUE,
      reverse = TRUE,
      show = TRUE
    ),
    col_alpha = 1
  ) +
  tmap::tm_graticules(
    lines = F
  ) +
  tmap::tm_layout(
    scale = 3.5
  ) +
  tm_title("K-Factor (sand)", fontface = "bold", position = tm_pos_out(cell.h = "center", cell.v = "top", pos.h = "center"))
dev.off()


breaks <- c(min(values(k_fac_vfs, na.rm = T)), 0, 0.005, 0.01, 0.0125, 0.015, 0.0175, 0.02, 0.025, 0.04)
k_fac_colors <- colorRampPalette(c("#458970", "#ffffbe", "#fff700", "#ffe800", "#ffc44a", "#ff9200", "#ff003f", "#ea00af", "#a700de"))
labels <- c("≤ 0", "0 - 0.005", "0.005 - 0.01", "0.01 - 0.0125", "0.0125 - 0.015", "0.015 - 0.0175", "0.0175 - 0.2", "0.2 - 0.025", "0.025 - 0.4")
png(file = "figures/k_fac_vfs.png", width = 2000, height = 2000)
tmap::tm_shape(k_fac_vfs) +
  tmap::tm_raster(
    col.scale = tmap::tm_scale_intervals(
      breaks = breaks,
      values = k_fac_colors(9),
      labels = labels,
      value.na = "#3892c6",
      label.na = "Waterbodies",
      value.neutral = "transparent"
    ),
    col.legend = tmap::tm_legend(
      title = "K-Factor",
      title.size = 1,
      text.size = 1,
      bg.color = "white",
      bg.alpha = 0.7,
      position = tmap::tm_pos_in("left", "bottom"),
      frame = TRUE,
      reverse = TRUE,
      show = TRUE
    ),
    col_alpha = 1
  ) +
  tmap::tm_graticules(
    lines = F
  ) +
  tmap::tm_layout(
    scale = 3.5
  ) +
  tm_title("K-Factor (very fine sand)", fontface = "bold", position = tm_pos_out(cell.h = "center", cell.v = "top", pos.h = "center"))
dev.off()

##############
## R-Factor ##
##############

r_fac <- rast("data/r_factor/r_fac.tif")
r_fac <- project(r_fac, crs, res = 250) %>% crop(., ext)
ext(r_fac) <- ext
r_fac <- mask(r_fac, waterbodies_mask)

breaks <- c(0, 100, 200, 400, 700, 1150, 1700, 3100, 5200, 7400, 10293)
r_fac_colors <- colorRampPalette(c("#c2523c", "#d97528", "#eda814", "#f7d706", "#c6f700", "#35e300", "#0fc441", "#1e9e84", "#166d8a", "#0c2f7a"))
labels <- c("0 - 100", "100 - 200", "200 - 400", "400 - 700", "700 - 1150", "1150 - 1700", "1700 - 3100", "3100 - 5200", "5200 - 7400", "> 7400")
png(file = "figures/r_fac_intervals.png", width = 2000, height = 2000)
tmap::tm_shape(r_fac) +
  tmap::tm_raster(
    col.scale = tmap::tm_scale_intervals(
      breaks = breaks,
      values = r_fac_colors(10),
      labels = labels,
      value.na = "#3892c6",
      label.na = "Waterbodies",
      value.neutral = "transparent"
    ),
    col.legend = tmap::tm_legend(
      title = "R-Factor",
      title.size = 1,
      text.size = 1,
      bg.color = "white",
      bg.alpha = 0.7,
      position = tmap::tm_pos_in("left", "bottom"),
      frame = TRUE,
      reverse = TRUE,
      show = TRUE
    ),
    col_alpha = 1
  ) +
  tmap::tm_graticules(
    lines = F
  ) +
  tmap::tm_layout(
    scale = 3.5
  ) +
  tm_title("R-Factor", fontface = "bold", position = tm_pos_out(cell.h = "center", cell.v = "top", pos.h = "center"))
dev.off()

png(file = "figures/r_fac_stretch.png", width = 2000, height = 2000)
tmap::tm_shape(r_fac) +
  tmap::tm_raster(
    col.scale = tmap::tm_scale_continuous(
      values = mako(100, direction = -1),
      midpoint = NA,
      value.na = "#3892c6",
      label.na = "Waterbodies"
    ),
    col.legend = tmap::tm_legend(
      title = "R-Factor",
      title.size = 1,
      text.size = 1,
      bg.color = "white",
      bg.alpha = 0.7,
      position = tmap::tm_pos_in("left", "bottom"),
      frame = TRUE,
      reverse = TRUE,
      show = TRUE
    ),
    col_alpha = 1
  ) +
  tmap::tm_graticules(
    lines = F
  ) +
  tmap::tm_layout(
    scale = 3.5
  ) +
  tm_title("R-Factor", fontface = "bold", position = tm_pos_out(cell.h = "center", cell.v = "top", pos.h = "center"))
dev.off()

###########
## RUSLE ##
###########

rusle <- ls_fac * c_fac * k_fac_vfs * r_fac

rusle <- project(rusle, crs, res = 250) %>% crop(., ext)
ext(rusle) <- ext
rusle <- mask(rusle, waterbodies_mask)

breaks <- c(min(values(rusle, na.rm = T)), 0.2, 0.5, 1.25, 2, 5, 10, 20, 50, 100, 200, max(values(rusle, na.rm = T)))
rusle_colors <- colorRampPalette(c("#147218", "#35911c", "#6fb00f", "#a4cf22", "#d8ef22", "#f7ed22", "#fdc820", "#ffa112", "#fe7718", "#fe3c18", "red"))
labels <- c("≤ 0.2", "0.2 - 0.5", "0.5 - 1.25", "1.25 - 2", "2 - 5", "5 - 10", "10 - 20", "20 - 50", "50 - 100", "100 - 200", "> 200")
png(file = "figures/rusle_intervals.png", width = 2000, height = 2000)
tmap::tm_shape(rusle) +
  tmap::tm_raster(
    col.scale = tmap::tm_scale_intervals(
      breaks = breaks,
      values = rusle_colors(11),
      labels = labels,
      value.na = "#3892c6",
      label.na = "Waterbodies",
      value.neutral = "transparent",
      midpoint = NA
    ),
    col.legend = tmap::tm_legend(
      title = "RUSLE",
      title.size = 1,
      text.size = 1,
      bg.color = "white",
      bg.alpha = 0.7,
      position = tmap::tm_pos_in("left", "bottom"),
      frame = TRUE,
      reverse = TRUE,
      show = TRUE
    ),
    col_alpha = 1
  ) +
  tmap::tm_graticules(
    lines = F
  ) +
  tmap::tm_layout(
    scale = 3.5
  ) +
  tm_title("RUSLE", fontface = "bold", position = tm_pos_out(cell.h = "center", cell.v = "top", pos.h = "center"))
dev.off()


GnYlRd <- colorRampPalette(c("#147218", "#35911c", "#6fb00f", "#a4cf22", "#d8ef22", "#f7ed22", "#fdc820", "#ffa112", "#fe7718", "#fe3c18", "red"))
png(file = "figures/rusle_stretch.png", width = 2000, height = 2000)
tmap::tm_shape(rusle) +
  tmap::tm_raster(
    col.scale = tmap::tm_scale_continuous_pseudo_log(
      values = GnYlRd(100),
      limits = c(0,200),
      outliers.trunc = c(TRUE, TRUE),
      midpoint = NA,
      value.na = "#3892c6",
      label.na = "Waterbodies",
      # base = exp(1),
      # sigma = 1
    ),
    col.legend = tmap::tm_legend(
      title = "RUSLE",
      title.size = 1,
      text.size = 1,
      bg.color = "white",
      bg.alpha = 0.7,
      position = tmap::tm_pos_in("left", "bottom"),
      frame = TRUE,
      reverse = TRUE,
      show = TRUE
    ),
    col_alpha = 1
  ) +
  tmap::tm_graticules(
    lines = F
  ) +
  tmap::tm_layout(
    scale = 3.5
  ) +
  tm_title("RUSLE", fontface = "bold", position = tm_pos_out(cell.h = "center", cell.v = "top", pos.h = "center"))
dev.off()
