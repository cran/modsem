grep -lr "EVAL_DEFAULT <- FALSE" | xargs sed -i "s/EVAL_DEFAULT <- TRUE/EVAL_DEFAULT <- FALSE/"
