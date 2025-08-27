ls -A *.Rmd | xargs sed -i "s/EVAL_DEFAULT <- TRUE/EVAL_DEFAULT <- FALSE/"
