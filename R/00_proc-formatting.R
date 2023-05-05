rm(list = ls())
library(EcotaxaTools)


data_path <- 'C:/Users/Chironex/Documents/Data/BATS_UVP/ofp_export'
ofp_processed <- ecopart_import(data_path)

depth_breaks <- c(seq(0,550, 50),c(595,605,650), 
                  seq(750,1000,50), 
                  seq(1100,4000, 100))

par_spectra <- ofp_processed |> uvp_par_spectra(depth_breaks,
                                                method = 'width',
                                                width = 0.05)

for(i in 1:length(par_spectra)) {
  file_name <- paste0('./data/00_',names(par_spectra)[i], '_par-spectrum.csv')
  write.csv(par_spectra[[i]], file_name, row.names = F)
}

write.csv(ofp_processed$meta,'./data/00_meta.csv', row.names = F)

# ggplot(par_spectra$unk4)+
#   geom_point(aes(x = mp_size_class, y = n_s, col = mp)) +
#   scale_x_log10(
#     breaks = scales::trans_breaks("log10", function(x) 10^x),
#     labels = scales::trans_format("log10", scales::math_format(10^.x))
#   ) +
#   scale_y_log10(
#     breaks = scales::trans_breaks("log10", function(x) 10^x),
#     labels = scales::trans_format("log10", scales::math_format(10^.x))
#   )+
#   theme_bw()

  