###
# Initial Import Script ##########
###

library(EcotaxaTools)
library(ggplot2)
library(dplyr)



raw_dat <- raw_dat_import('F:/uvp5_sn209_ofpapril2021')
raw_bru <- raw_bru_import('F:/uvp5_sn209_ofpapril2021')

# |- Generate descent plots -----

descent_plots <- raw_dat |> 
  lapply(descent_plot)

pdf('./output/descent_profiles.pdf')
for(i in 1:length(descent_plots)) {
  print(descent_plots[[i]] + labs(title = names(descent_plots)[i]))
}
dev.off()

## Caculate particle bins from raw data #####

# |- Filter out by timestamp to just hovers -------------
raw_part <- raw_merge_brudat(raw_bru, raw_dat)

unk1_starttime <- as.POSIXct('2021-04-14 21:56:07', tz = 'UTC')
unk1_endtime <- as.POSIXct('2021-04-14 22:56:25', tz = 'UTC')

unk1_hover <- raw_part$unk1 |> 
  filter(timestamp > unk1_starttime & timestamp < unk1_endtime)

unk4_starttime <- as.POSIXct('2021-04-16 08:52:43', tz = 'UTC')
unk4_hover <- raw_part$unk4 |> 
  filter(timestamp > unk4_starttime)

# |- Create Size Bins -------------------------

unk1_hover$esd <- unk1_hover$area_px |> 
  area_to_esd(pixel_mm = 0.092)

unk4_hover$esd <- unk4_hover$area_px |> 
  area_to_esd(pixel_mm = 0.092)

unk1_hover$size_class <- unk1_hover$esd |> 
  assign_spectra_bins(method = 'width', width = .050)



unk4_hover$size_class <- unk4_hover$esd |> 
  assign_spectra_bins(method = 'width', width = 0.050)



# |- Calculate summed groups ---------------
unk1_num_images <- unk1_hover$img_index |> 
  unique() |> 
  length()
unk1_vol <- unk1_num_images * 1.1

unk4_num_images <- unk4_hover$img_index |> 
  unique() |> 
  length()
unk4_vol <- unk4_num_images * 1.1


unk1_counts <- unk1_hover |> 
  count_size_classes() |> 
  numeric_spectra(unk1_vol, needs_format = T)

unk4_counts <- unk4_hover |> 
  count_size_classes() |> 
  numeric_spectra(unk4_vol, needs_format = T)

# ggplot(unk4_counts) +
#   geom_point(aes(x = mp_size_class, y = n_s))+
#   scale_x_log10(
#     breaks = scales::trans_breaks("log10", function(x) 10^x),
#     labels = scales::trans_format("log10", scales::math_format(10^.x))
#   ) +
#   scale_y_log10(
#     breaks = scales::trans_breaks("log10", function(x) 10^x),
#     labels = scales::trans_format("log10", scales::math_format(10^.x))
#   )+
#   labs(x = 'ESD [mm]', y = 'Numeric Spectra [#/Lmm]')+
#   theme_bw()


write.csv(unk1_counts, './data/00_raw-unk1-spectrum.csv',row.names = F)
write.csv(unk4_counts, './data/00_raw-unk4-spectrum.csv',row.names = F)
