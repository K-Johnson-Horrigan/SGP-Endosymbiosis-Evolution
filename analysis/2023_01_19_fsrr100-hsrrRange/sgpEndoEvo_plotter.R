library(ggplot2)  # plots
library(viridis)    # colors 
library(scales)
library(plyr)
library(ggh4x)

standard_theme <-  theme(panel.background = element_rect(fill='white', colour='black')) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

##################
## load in data ##
##################
donate_count_data <- read.table("data/donate_count_munged_data.dat", h=T)

#################
## format data ##
#################
donate_count_data$vt <- as.factor(donate_count_data$vt)
donate_count_data$ecto <- ifelse((donate_count_data$ecto==1),"Ectosymbiosis on","Ectosymbiosis off")
donate_count_data$endo <- ifelse((donate_count_data$endo==1),"Endosymbiosis on","Endosymbiosis off")
donate_count_data$shtr <- paste0("SHTR", donate_count_data$shtr)
donate_count_data$shtr <- factor(donate_count_data$shtr, levels = c("SHTR100", "SHTR250", "SHTR500", "SHTR750","SHTR1000"))

#####################################
## plot hosted sym count over time ##
#####################################
over_time_subset <- subset(donate_count_data, (update %% 100) == 0)
ggplot(data=subset(over_time_subset,endo=="Endosymbiosis on"), aes(x=update, y=h_sym_count, group=vt, colour=vt)) + 
  ylab("Hosted symbiont count") + xlab("Time") + 
  stat_summary(aes(color=vt, fill=vt),fun.data="mean_cl_boot", geom=c("smooth"), se=TRUE) + 
  standard_theme + 
  guides(fill="none") +  
  scale_colour_manual(name="VT", values=viridis(7)) + 
  scale_fill_manual(values=viridis(7)) +
  facet_nested(shtr ~ ecto)  

#########################################################
## plot (endo) sym points donated vs sym points stolen ##
#########################################################
endo_end_subset <- subset(donate_count_data,update  == 60000 & endo=="Endosymbiosis on")
endo_end_subset$point_ratio <- endo_end_subset$h_sym_points_stolen/endo_end_subset$h_sym_points_donated
  
ggplot(data=endo_end_subset, 
                aes(x=vt, y=point_ratio, color=shtr)) +   
    geom_boxplot() +
    geom_point(shape=19, position=position_jitterdodge(), alpha=0.2) +
    ylab("Endosymbiont points stolen per points donate") + xlab("Vertical transmission rate") + 
    scale_y_continuous(labels = comma) +
    standard_theme + 
    scale_colour_manual(name="Points required\nfor endosymbiont\nhorizontal\ntransmission", values=plasma(6)) + scale_fill_manual(values=plasma(6)) + 
    facet_wrap(~ecto) + 
    geom_hline(yintercept=1,linetype=2)


#################################################################
## calculations (endo) sym points donated vs sym points stolen ##
#################################################################
nrow(endo_end_subset)
nrow(subset(endo_end_subset, point_ratio < 1))

ecto_min <- min(subset(endo_end_subset,ecto=="Ectosymbiosis on")$point_ratio)
nrow(subset(endo_end_subset,ecto=="Ectosymbiosis off" & point_ratio > ecto_min))

nrow(subset(endo_end_subset,ecto=="Ectosymbiosis off"))
