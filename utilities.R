library(tidyverse)
library(fs)
library(quarto)

# FUNCTION ----------------------------------------------------------------


render_move <- function(qmd_file, 
                        folderpath_output = "../usaid-oha-si.github.io/reference"){
  
  #section
  section <- gsub("\\.qmd", "", basename(qmd_file))
  
  #create a folder path in on the blog repo (delete if it already exists)
  path_out <- file.path(folderpath_output, section)
  if(dir.exists(path_out))
    dir_delete(path_out)
  dir_create(path_out)
  
  #render qmd
  quarto_render(qmd_file)
  
  #identify files to move (non-qmd)
  output_files <- list.files(pattern = section, full.names = TRUE) 
  output_files <- output_files[str_detect(output_files, 'qmd$', negate = TRUE)]
  
  #move files to blog repo
  file_move(output_files, path_out)
  
  #create a folder path in on the blog repo for images
  path_img_out <- file.path(path_out, "images")
  
  #move related images
  dir_create(path_img_out)
  
  #identify images
  img <- list.files("images", section, full.names = TRUE)
  
  #copy files
  file_copy(img, path_img_out)
  
}


# RENDER + MOVE FILES TO BLOG ---------------------------------------------

  #identify qmd files to render and move
  files_input <- list.files(pattern = "qmd", full.names = TRUE)
  
  #render + move
  walk(files_input, render_move)
    
