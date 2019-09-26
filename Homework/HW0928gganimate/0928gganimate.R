library(tidyverse, ggplot2)
library(gganimate)
library(nycflights13)
ggplot(iris, aes(x = Petal.Width, y = Petal.Length)) + 
  geom_point(aes(colour = Species, group = 1L)) +
  transition_states(Species, transition_length = 1, state_length = 1) +
  ease_aes("cubic-in-out") +
  ggtitle('Now showing {closest_state}',
          subtitle = 'Frame {frame} of {nframes}')

ggplot(iris, aes(x = Petal.Width, y = Petal.Length)) + 
  geom_point(aes(colour = Species), size = 2) + 
  transition_states(Species, transition_length = 2, state_length = 1) +
  enter_fade() + 
  exit_shrink()

ggplot(mpg, aes(x = displ, y = carrier)) +
  geom_point(aes(color =  class, group = 1L)) +
  transition_states(carrier, transition_length = 1, state_length = 1) +
  ease_aes("cubic-in-out") +
  ggtitle("Now showing {closest_state}")
