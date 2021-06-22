library(tidyverse)
library(rgdal)
library(viridis)

welfare <- readstata13::read.dta13(file = 'output/welfare.dta')

welfare$welfare <- welfare$welfare - 1

USmap_state <- readOGR(dsn = 'assets/shape_file/49_states', layer = 'USmap_state')

# checking if merging ids are the same
df_names <- welfare$state
USmap_names <- USmap_state@data$NAME 
df_names[!df_names %in% USmap_names]

# Setting up mapping data
USmap_state@data <- left_join(USmap_state@data, welfare, by = c("NAME" = "state"))
USmap_state@data$id <- as.character(0:(length(USmap_state@data$NAME)-1))
USmap_state_df <- broom::tidy(USmap_state)
USmap_state_df <- left_join(USmap_state_df,USmap_state@data, by = 'id')
USmap_state_df <- USmap_state_df %>% 
  select(long, lat, group, NAME, welfare)

USmap_state_df$welfare[USmap_state_df$NAME == "California"] <- NA
USmap_state_df$welfare[USmap_state_df$NAME == "Nevada"] <- NA
USmap_state_df$welfare[USmap_state_df$NAME == "New Mexico"] <- NA
USmap_state_df$welfare[USmap_state_df$NAME == "Utah"] <- NA
USmap_state_df$welfare[USmap_state_df$NAME == "Arizona"] <- NA

# Map creation:
ggplot(USmap_state_df, 
       aes(x = long, 
           y = lat, 
           group = group)) + 
  geom_polygon(aes(fill = welfare), 
               color = "black", 
               size = 0.1) +
  scale_fill_viridis(limits = c(-0.05, .05), 
                     option="cividis", 
                     #begin = 1, end = 0,
                     breaks = seq(-0.05,0.05,.02),
                     guide = guide_colorbar(
                       direction = "horizontal",
                       barheight = unit(2, units = "mm"),
                       barwidth = unit(65, units = "mm"),
                       title.position = "top"),
                     na.value = "white") + 
  labs( x = "Longtitude", 
        y = "Latitiude", 
        fill = "Welfare change") +
  ggtitle("Food Security Distribution of Impacts from the US Western Drought") +
  theme_bw() + theme(legend.position = c(0.2, 0.1)) + coord_fixed(1.3)

ggsave('output/welfare.png', width = 12, height = 5)
