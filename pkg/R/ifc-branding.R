#' IFC palette
#' 
#' Official palette for use for the International Finance Corporation of the World Bank Group
#' @export
#' @examples
#' plot(1:9, 1:9, pch = 19, col = ifc_pal$hex, cex = 8)
ifc_pal <- data.frame(
  hex = c("#00ADE4", "#808080", "#002345", 
          "#006446", "#87189D", "#A4123F", "#BCD19B", "#485CC7", "#C69214"), 
  R = c(127, 0, 0, 0, 135, 164, 188, 72, 198) / 255,
  G = c(127, 173, 35, 100, 24, 18, 209, 92, 146) / 255,
  B = c(127, 228, 69, 70, 157, 63, 155, 199, 20) / 255,
  type = rep(c("primary", "secondary"), c(3, 6)),
  use  = rep(c("general", "reports & fact sheets"), c(3, 6)),
  stringsAsFactors = FALSE,
  name = c("process cyan", "corporate grey", "dark blue", "green", "purple", "red", "light grey", "blue", "brown")
 )
row.names(ifc_pal) <- ifc_pal$name





#' tint
#' 
#' Make a colour paler by "tinting" it
#' 
#' @importFrom grDevices rgb
#' @export
#' @param col A vector of hex colors, or other format readable by grDevices::col2rgb
#' @param x number from 0 to 1 for tint.  1 returns the original, and 0 is so pale as to be white
#' @return A vector of hext colors
tint <- function(col, x){
  # applying https://stackoverflow.com/questions/6615002/given-an-rgb-value-how-do-i-create-a-tint-or-shade
  y <- 1 - x
  col_rgb <- t(grDevices::col2rgb(col))
  R <- (255 - col_rgb[ ,"red"]) * y + col_rgb[ ,"red"]
  G <- (255 - col_rgb[ ,"green"]) * y + col_rgb[ ,"green"]
  B <- (255 - col_rgb[ ,"blue"]) * y + col_rgb[ ,"blue"]
  return(rgb(R / 255, G / 255, B / 255))
}



# bar charts are green bars if a single colour
# If there is more than one fill of bars, they go green, purple, brown (not exactly as in guide but cloe), 
# red, orange (not in guide at all), bluer  purple (not in guide), dark green)...
# bar charts gridlines for horizontal, and they and axis text is blue.  No vertical axis
# chart title is 14 point Arial, blue (a bit darker than IFC primary light blue, more like the blue in ther report), not bold
# legend text and axis text is same blue as title, 9 point
# axis title is blue, not bold, 10 point



#' IFC theme
#' 
#' A ggplot2 theme for the International Finance Corporation
#' @param base_size base size
#' @param base_family typeface
#' @export
theme_ifc <- function(base_size= 12, base_family = "Arial"){
  # tc <- ifc_pal["blue", "hex"] # text colour
  tc <- "black"
  theme_classic(base_size = base_size, base_family = base_family) +
    theme(legend.position = "bottom",
          plot.title = element_text(hjust = 0.5, size = base_size + 2, colour = tc, face = "plain"),
          plot.subtitle = element_text(hjust = 0.5, size = base_size-2, colour = tc, face = "plain"),
          
          axis.title = element_text(size = base_size - 2, face = "plain", colour = tc),
          legend.title = element_text(size = base_size - 2, face = "plain", colour = tc),
          
          plot.caption = element_text(size = base_size, colour = "grey50", hjust = 0),
          
          strip.background = element_rect(fill = "grey95", colour = NA),
          panel.spacing = unit(7, "mm"),
          
          panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.minor.y = element_blank(),
          # panel.grid.major.y = element_line(size = 0.05, color = tint(ifc_pal["process cyan", "hex"], 0.2)),
          
          # axis.line = element_blank(),
          # axis.ticks = element_blank(),
          
          axis.text = element_text(size = base_size - 3, colour = tc),
          legend.text = element_text(size = base_size - 3, colour = tc),
          
          plot.background = element_rect(fill = "transparent")
          )
    }

#' Fill scale for the IFC
#' @import scales
#' @param ... parameters to be passed to \code{scale_fill_manual()}
#' @param sequence sequence of colors from \code{ifc_pal} to use
#' @seealso \code{\link{ifc_pal}}
#' @export
scale_fill_ifc <- function(..., sequence = c(4, 5, 9, 6, 7, 8)){
  
  structure(list(
    scale_fill_manual(..., values = ifc_pal[sequence, "hex"])
  ))
}

#' Discrete color scale for the IFC
#' @param ... parameters to be passed to \code{scale_color_manual()}
#' @param sequence sequence of colors from \code{ifc_pal} to use
#' @seealso \code{\link{ifc_pal}}
#' @export
scale_color_discrete_ifc <- function(..., sequence = c(4, 5, 9, 6, 7, 8)){
  
  structure(list(
    scale_color_manual(..., values = ifc_pal[sequence, "hex"])
  ))
}

#' Continuous color scale for the IFC
#' @export
#' @param ... parameters to be passed to \code{scale_fill_manual()}
#' @param type sequential (eg pale to dark) or diverging (eg color1, white, color2) scale
#' @param first_col name of first color to use (using names of \code{ifc_pal})
#' @param second_col name of second color to use (using names of \code{ifc_pal}).  Only needed if scale is diverging.
#' @seealso \code{\link{ifc_pal}}
#' @examples
#' \dontrun{
#' ggplot(mtcars, aes(x = vs, weight = mpg, fill = as.factor(cyl))) + 
#'  geom_bar() + 
#'  theme_ifc() +
#'  ggtitle("CHART TITLE", "SUBTITLE") +
#'  labs(caption = "Footer") +
#'  scale_fill_ifc()
#' 
#' ggplot(mtcars, aes(x = disp, y = mpg, color = mpg)) + 
#'  geom_point(size = 5) + 
#'  theme_ifc() +
#'  ggtitle("CHART TITLE", "SUBTITLE") +
#'  labs(caption = "Footer") +
#'  scale_color_continuous_ifc("diverging", second_col = 9)}
scale_color_continuous_ifc <- function(..., type = c("sequential", "diverging"), 
                                       first_col = "red", second_col = "blue"){
  type <- match.arg(type, c("sequential", "diverging"))
  if(type == "sequential") {
    cols <- tint(ifc_pal[first_col, "hex"], c(1:5) / 5)
  } else {
    cols <- c(tint(ifc_pal[first_col, "hex"], c(5:3) / 5),
              tint(ifc_pal[second_col, "hex"], c(3:5) / 5))
  }
  
  structure(list(
    scale_color_gradientn(..., colours = cols)
  ))
}



