# Instructions to set up mujoco and torch on your hpc 
First log in to your hpc account (After you applied for one)  
```
ssh netid@hpc.shanghai.nyu.edu  
```
NOTE: by default compute nodes don't have Internet access, so you should set up your environment in your login node. The login node doesn't have correct dependencies installed. So when you test your mujoco_py, you should do that in a compute node (see step 8).

NOTE: download stuff 

0. 
load conda first  
`module load anaconda3`  
set up a virtual environment with the command (call it 'rl' or whatever, and use 3.6 for less trouble), if you never used virtualenv, try spend 10 min search for what that is  
```
conda create -n rl python=3.6
source activate rl 
```

For all of the following, you should be inside your rl virtualenv.

1.
Install gym, download gym github repo and install minimum, according to gym doc.  
```
git clone https://github.com/openai/gym.git
cd gym
pip install -e .
```
2.
Install mujoco-py, with the correct way
```
git clone https://github.com/openai/mujoco-py
cd mujoco-py
pip install -e . --no-cache
```
3. 
create .mujoco folder under your home:
```
cd ~ 
mkdir .mujoco
```
and put mjpro150 folder into this folder also put in your liscense, you can use filezilla

4. 
add additional library path line to .bashrc,
you can just run the following command to do this (or you can just try import mujoco_py in python and follow the mujoco_py error message.):  
`echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/gpfsnyu/home/<YOUR USER NAME>/.mujoco/mjpro150/bin' >> ~/.bashrc`  
NOTE: `<YOUR USER NAME>` should be your netid, please change that part. Note that you should use single quotation marks '', don't use double quotation, otherwise the line added to your .bashrc will be different.     


5. 
now you want to get back to the gym folder and install mujoco (after you set up mujoco files and stuff)
```
cd gym
pip install -e '.[mujoco]'
```

other dependencies should be there already, thanks to help from our hpc admin Zhiguo.

6. 
install torch into your rl virtualenv, according to pytorch website
```
module load cuda/9.0
conda install pytorch torchvision cuda90 -c pytorch
```

7. 
install any other python libraries you want to use (for example seaborn)

8. Testing

You want to do this part in an interactive shell on a compute node. NOTE: PLEASE USE THE **aquila** partition for your testing, **don't use** your **login** node or **debug** partition, the login and debug partition don't have correct versions of the dependencies.
 
run the following command to get an interactive shell with cpu. 
```
srun -p aquila --pty --mem  500 -t 0-01:00 bash
```
This will let you enter a new shell, on a compute node in the aquila partition  

Test your mujoco_py in this interactive shell. Load anaconda3, test mujoco by running python and import mujoco_py, and then try make a InvertedPendulum-v2 env. If everything works, then mujoco is good to go.
