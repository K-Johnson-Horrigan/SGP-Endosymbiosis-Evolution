install.packages("ggplot2")
install.packages("viridis")
install.packages("scales")
install.packages("plyr")
install.packages("ggh4x")

library(ggplot2)  # plots
library(viridis)    # colors 
library(scales)
library(plyr)
library(ggh4x)

standard_theme <-  ggplot2::theme(panel.background = element_rect(fill='white', colour='black')) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())


####  load in data ####

## if using data produced from running the experiment
donate_count_data <- read.table("donate_count_munged_data.dat", h=T)

# if using data file from the supplementary materials
# this is a subset of experiment data, constrained to VT==0.4 & endosymbiosis on
donate_count_data <- read.table("donate_data_endo_on.dat", h=T)

# for either data source
donate_count_data$vt <- as.factor(donate_count_data$vt)
donate_count_data$ecto <- ifelse((donate_count_data$ecto==1),"Ectosymbiosis on","Ectosymbiosis off")
donate_count_data <- subset(donate_count_data, donate_count_data$endo==1)
donate_count_data <- subset(donate_count_data, donate_count_data$vt==0.4)
donate_count_data$shtr <- paste0("SHTR", donate_count_data$shtr)
donate_count_data$shtr <- factor(donate_count_data$shtr, levels = c("SHTR100", "SHTR250", "SHTR500", "SHTR750","SHTR1000"))


####  plot hosted sym count over time####

over_time_subset <- subset(donate_count_data, donate_count_data$vt == 0.4)
over_time_subset <- subset(over_time_subset,  (over_time_subset$shtr == "SHTR100" | over_time_subset$shtr == "SHTR250"))
ggplot(over_time_subset, aes(x=update, y=h_sym_count, group=shtr, colour=shtr)) + 
  ylab("Endosymbiont count") + xlab("Time") + 
  stat_summary(aes(color=shtr, fill=shtr),fun.data="mean_cl_boot", geom=c("smooth"), se=TRUE) + 
  standard_theme + 
  guides(fill="none") +  
  scale_colour_manual(name="Points required\nfor endosymbiont\nhorizontal\ntransmission", values=plasma(6)) + 
  scale_fill_manual(values=plasma(6)) +
  facet_nested( ~ ecto) 



####  code for counts of endosymbionts at timepoint ####  

# difference by horizontal transmission resource threshold
# only look at 2 shtr values
partway <- subset(donate_count_data, donate_count_data$update == 5000 & 
                 (donate_count_data$shtr=="SHTR100" | donate_count_data$shtr=="SHTR250") &
                 (donate_count_data$vt == 0.4) &
                   donate_count_data$ecto=="Ectosymbiosis off")
mean(subset(partway, partway$shtr=="SHTR250")$h_sym_count)
mean(subset(partway, partway$shtr=="SHTR100")$h_sym_count)
wilcox.test(h_sym_count ~ shtr, data = partway)


# difference by horizontal transmission resource threshold
# include all VTs and all SHTR
partway <- subset(donate_count_data, donate_count_data$update == 5000 & 
                    (donate_count_data$shtr=="SHTR250") &
                    (donate_count_data$vt == 0.4))
mean(subset(partway, partway$ecto=="Ectosymbiosis on")$h_sym_count)
mean(subset(partway, partway$ecto=="Ectosymbiosis off")$h_sym_count)
wilcox.test(h_sym_count ~ ecto, data = partway)


#### plot (endo) sym points stolen vs sym points donated #### 

endo_end_subset <- subset(donate_count_data, update  == 60000 & vt==0.4)
endo_end_subset$point_ratio <- endo_end_subset$h_sym_points_stolen/endo_end_subset$h_sym_points_donated
  
ggplot(data=endo_end_subset, 
                aes(x=vt, y=point_ratio, color=shtr)) +   
    geom_boxplot() +
    geom_point(shape=19, position=position_jitterdodge(), alpha=0.2) +
    ylab("Endosymbiont points stolen per points donated") + xlab("Vertical transmission rate") + 
    scale_y_continuous(labels = comma) +
    standard_theme + 
    scale_colour_manual(name="Points required\nfor endosymbiont\nhorizontal\ntransmission", values=plasma(6)) + scale_fill_manual(values=plasma(6)) + 
    facet_wrap(~ecto) + 
    geom_hline(yintercept=1,linetype=2)



#### code for (endo) sym points stolen vs sym points donated####

nrow(endo_end_subset)
nrow(subset(endo_end_subset, point_ratio > 1))

# By ectosymbiosis
shtr100 <- subset(endo_end_subset, endo_end_subset$shtr=="SHTR1000")
mean(subset(shtr100, ecto=="Ectosymbiosis on")$point_ratio)
mean(subset(shtr100, ecto=="Ectosymbiosis off")$point_ratio)

wilcox.test(point_ratio ~ ecto, data = shtr100)

# Only ectosymbiosis off, by SHTR
ecto_off <- subset(endo_end_subset, endo_end_subset$ecto=="Ectosymbiosis off" & 
                     (endo_end_subset$shtr=="SHTR100" | endo_end_subset$shtr=="SHTR1000"))
mean(subset(ecto_off, ecto_off$shtr=="SHTR100")$point_ratio) # 2.171647
mean(subset(ecto_off, ecto_off$shtr=="SHTR1000")$point_ratio) # 1.316859

wilcox.test(point_ratio ~ shtr, data = ecto_off)
