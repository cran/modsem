ls -A *.Rmd | xargs sed -i "s/EVAL_DEFAULT <- FALSE/EVAL_DEFAULT <- TRUE/"
