
theme_set(theme_test(base_size = 14, base_family = "serif"))
theme_update(plot.margin = margin(0.2, 0.6, 0.1, 0.1, "cm"),
             panel.grid.major.y = element_line(colour = "grey80", linewidth = 0.3, linetype = "dotted"),
             panel.grid.major.x = element_line(colour = "grey80", linewidth = 0.3, linetype = "dotted"),
             panel.grid.minor.x = element_blank(),
             panel.grid.minor.y = element_blank(),
             legend.background = element_rect(fill = "white", colour = "white"),
             legend.title = element_text(face = "bold"),
             axis.title.x = element_text(face = "bold", size = 14),
             legend.position = "bottom",
             axis.title.y = element_text(face = "bold", size = 14),
             plot.title = element_text(hjust = 0.5),
             title = element_text(face = "bold")
             
)
