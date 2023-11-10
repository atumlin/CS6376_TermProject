conda create -n rl_expr python=3.8 pip -y
conda activate rl_expr
pip install gymnasium
pip install 'gymnasium[classic-control]'
pip install ray
pip install "ray[tune]"
pip install dm_tree
pip install scikit-image
pip install matplotlib
pip install torch
pip install lz4