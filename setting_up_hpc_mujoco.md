Instructions to set up mujoco and torch on your hpc 

ssh into netid@hpc.shanghai.nyu.edu
#run the following command to get an interactive shell. your login shell doesn't have updated version of glibc, so you should set up env here
Note that you should use aquila as your partition
srun -p aquila --gres=gpu:1 --pty --mem  500 -t 0-01:00 bash
srun -p aquila --pty --mem  500 -t 0-01:00 bash

This will let you enter a new shell, on a compute node in the aquila partition

0. 
load conda first
module load anaconda3
set up a virtual environment with the command (call it 'rl' or whatever, and use 3.6 for less trouble)
if you never used virtualenv, try spend 10 min search for what that is
conda create -n rl python=3.6
activate env
source activate rl

1.
Install gym
download gym github repo and install minimum, according to gym doc
`git clone https://github.com/openai/gym.git
cd gym
pip install -e .`

2.
Install mujoco-py, with the correct way
`git clone https://github.com/openai/mujoco-py
cd mujoco-py
pip install -e . --no-cache`

3. 
create .mujoco folder under your home:
`cd ~ 
mkdir .mujoco`
and put mjpro150 folder into this folder also put in your liscense, you can use filezilla

4. 
add additional library path line to .bashrc,
you can just run the following command to do this:
`echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/gpfsnyu/home/<your user name>/.mujoco/mjpro150/bin" >> ~/.bashrc`

5. 
now you want to get back to the gym folder and install mujoco (after you set up mujoco files and stuff)
`cd gym
pip install -e '.[mujoco]'`

other dependencies should be there already, thanks to help from Zhiguo
test mujoco by running python and import mujoco_py, and then try make a InvertedPendulum-v2 env
if everything works, then mujoco is good to go

6. 
install torch into your rl virtualenv, according to pytorch website
`module load cuda/9.0
conda install pytorch torchvision cuda90 -c pytorch`


7. 
install any other python libraries you want to use (for example seaborn)
