library(tidyverse)
library(fs)
library(quarto)

# FUNCTION ----------------------------------------------------------------


render_move <- function(qmd_file, 
                        folderpath_input = "sections",
                        folderpath_output = "../usaid-oha-si.github.io/reference"){
  
  #create a folder in on the blog repo
  path_out <- file.path(folderpath_output, sub("\\.qmd", "", basename(qmd_file)))
  dir_create(path_out)
  
  #render qmd
  quarto_render(qmd_file)
  
  #identify files to move (non-qmd)
  output_files <- list.files(folderpath_input, full.names = TRUE) 
  output_files <- output_files[str_detect(output_files, 'qmd$', negate = TRUE)]
  
  #move files to blog repo
  file_move(output_files, path_out)
}


# RENDER + MOVE FILES TO BLOG ---------------------------------------------

  #identify qmd files to render and move
  files_input <- list.files("sections", "qmd", full.names = TRUE)
  
  #render + move
  walk(files_input, render_move)
    


# MOVE IMAGES TO BLOG -----------------------------------------------------

  #create directory if it doens't already exist
  img_dir_out <- dir_create("../usaid-oha-si.github.io/assets/img/manuals/")      
  
  #identify images to move
  files_img <- list.files("assets/img/manuals/", full.names = TRUE)
  
  #move files
  walk(files_img, ~file_copy(.x, img_dir_out))
