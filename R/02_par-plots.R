rm(list = ls())
library(ggplot2)

files <- dir('./data') |>
  grep(pattern = 'unk[0-9]_par',value = T,)
files <- paste0('./data/',files)


par_files <- vector('list', length(files))
names(par_files) <- paste0('unk',c(1:4))

for(i in 1:length(files)) {
  par_files[[i]] <- read.csv(files[i])
}

par_spectra_plot <- function(df, title) {
  ggplot(df) +
    geom_point(aes(x = mp_size_class, y = n_s, col = mp))+
    scale_x_log10(
      breaks = scales::trans_breaks("log10", function(x) 10^x),
      labels = scales::trans_format("log10", scales::math_format(10^.x))
    ) +
    scale_y_log10(
      breaks = scales::trans_breaks("log10", function(x) 10^x),
      labels = scales::trans_format("log10", scales::math_format(10^.x))
    )+
    scale_color_gradient(low = 'grey', high = 'black')+
    labs(x = 'ESD [mm]', y = 'Numeric Spectra [#/Lmm]',
         title = title, col = 'Depth')+
    theme_bw()
}

pdf("./output/par_prelim_plots.pdf")
for(i in 1:length(par_files)) {
  par_spectra_plot(par_files[[i]], names(par_files)[i]) |> 
    print()
}
dev.off()
