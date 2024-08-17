grep -lr "EVAL_DEFAULT <- FALSE" | xargs sed -i "s/EVAL_DEFAULT <- FALSE/EVAL_DEFAULT <- TRUE/"
