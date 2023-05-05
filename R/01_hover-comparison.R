## Comparison of the two hover methods
rm(list = ls())
library(dplyr)


unk1_processed <- read.csv('./data/00_unk1_par-spectrum.csv')
unk1_raw <- read.csv('./data/00_raw-unk1-spectrum.csv')
unk4_processed <- read.csv('./data/00_unk4_par-spectrum.csv')
unk4_raw <- read.csv('./data/00_raw-unk4-spectrum.csv')


unk1_processed <- unk1_processed |> 
  filter(mp == 600)

unk1_plot <- ggplot()+
  geom_point(data = unk1_processed, 
             aes(x = mp_size_class, y = n_s),
             col = 'black',
             shape = 17)+
  geom_point(data = unk1_raw,
             aes(x = mp_size_class, y = n_s),
             col = 'red',
             shape = 19)+
  scale_x_log10(
    breaks = scales::trans_breaks("log10", function(x) 10^x),
    labels = scales::trans_format("log10", scales::math_format(10^.x))
  ) +
  scale_y_log10(
    breaks = scales::trans_breaks("log10", function(x) 10^x),
    labels = scales::trans_format("log10", scales::math_format(10^.x))
  )+
  labs(x = 'ESD [mm]', y = 'Numeric Spectra [#/Lmm]',
       title = 'unk1')+
  theme_bw()

unk4_processed <- unk4_processed |> 
  filter(mp == 600)

unk4_plot <- ggplot()+
  geom_point(data = unk4_processed, 
             aes(x = mp_size_class, y = n_s),
             col = 'black',
             shape = 17)+
  geom_point(data = unk4_raw,
             aes(x = mp_size_class, y = n_s),
             col = 'red',
             shape = 19)+
  scale_x_log10(
    breaks = scales::trans_breaks("log10", function(x) 10^x),
    labels = scales::trans_format("log10", scales::math_format(10^.x))
  ) +
  scale_y_log10(
    breaks = scales::trans_breaks("log10", function(x) 10^x),
    labels = scales::trans_format("log10", scales::math_format(10^.x))
  )+
  labs(x = 'ESD [mm]', y = 'Numeric Spectra [#/Lmm]',
       title = 'unk4')+
  theme_bw()

pdf('./output/600m_hover-comparison.pdf')
unk1_plot
unk4_plot
dev.off()