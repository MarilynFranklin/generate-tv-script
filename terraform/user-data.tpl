#!/bin/bash

set -x
set -v

su - udacity -c "$( cat <<'EOF'
  source /home/carnd/anaconda3/bin/activate dl
  jupyter notebook &
EOF
)"
