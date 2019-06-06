# Instructions to set up mujoco and torch on your hpc 
This is a guide on setting up mujoco environments for hpc (can also use for set up on personal ubuntu machines.)

*Please pay special attention to places with the word **NOTE**, that's where things can go wrong easily.*  
Last updated June 4, 2019.  

# Python package version notice
Currently support: pytorch 0.4.1, gym 0.12.0, mujoco-py 1.50.1.68.
For gym and mujoco-py use git's checkout command to get currect versions.

First log in to your hpc account (After you applied for one)  
```
ssh netid@hpc.shanghai.nyu.edu  
```
**NOTE**: by default compute nodes don't have Internet access, so you should set up your environment in your login node. The login node doesn't have correct dependencies installed. So when you test your mujoco_py (test means doing sth like running python and then import mujoco_py), you should do that in a compute node (see step 8).


0. 
load conda first  
`module load anaconda3`  

**NOTE** on hpc there are certain system packages that might not loaded by default, if you want to use them you should load them using `module load`.
```
module load glfw/3.3
module load gcc/7.3
```

set up a virtual environment with the command (call it 'rl' or whatever, and use 3.6 for less trouble), if you never used virtualenv, try spend 10 min search for what that is  
```
conda create -n rl python=3.6
source activate rl 
```
Note that in some machines you might need to use `conda activate rl` instead. If your source activate doesn't work. 

**NOTE**: For all of the following, you should be inside your rl virtualenv. (you want to install python libraries into your rl virtualenv, not somewhere else.)

**NOTE** for mac you might run into issues related to gcc, install brew then install gcc might solve that. For windows esiest way is to use Anaconda prompt. 

1.
Install gym related dependencies: 
https://github.com/openai/gym

Install gym, download gym github repo and install minimum, according to gym doc. Use git checkout to get correct version. 
```
git clone https://github.com/openai/gym.git
cd gym
git checkout a4adef2
pip install -e .
```

2. 
Install mujoco-py, with the correct way. **NOTE**: other ways of installing mujoco-py often fail, please use this method. 
```
git clone https://github.com/openai/mujoco-py
cd mujoco-py
git checkout 498b451
pip install -e . --no-cache
```

Enter the mujoco-py folder and install mujoco-py dependencies. Or refer to mujoco-py repo for details. https://github.com/openai/mujoco-py
```
cd mujoco-py
pip install -r requirements.txt
pip install -r requirements.dev.txt
```

3. 
create .mujoco folder under your home:
```
cd ~ 
mkdir .mujoco
```
and put mjpro150 folder into this folder also put in your liscense.  
**NOTE**: THE HPC IS RUNNING LINUX SYSTEM, MEANING IF YOU USE MAC/WINDOWS, YOU CANNOT JUST COPY YOUR MUJOCO BINARY (MAC/WINDOWS VERSION) INTO THE HPC MACHINES. Instead, you should download the linux version of mujoco binary from the mujoco website on your machine and then transfer to hpc using Filezella, or download it from mujoco website to hpc directly, using sth like wget.  


4. 
add additional library path line to .bashrc,
you can just run the following command to do this (or you can just try import mujoco_py in python and follow the mujoco_py error message.):  
`echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/gpfsnyu/home/NETID/.mujoco/mjpro150/bin' >> ~/.bashrc`  
**NOTE**: `NETID` should be your netid, please change that part. **NOTE** that you should use single quotation marks `'`, don't use double quotation, otherwise the line added to your .bashrc will be different. 

5. 
now you want to get back to the gym folder and install mujoco (after you set up mujoco files and stuff)
```
cd gym
pip install -e '.[mujoco]'
```
note here in windows you might want to use `pip install -e .[mujoco]` instead. 

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

9. Testing with hpc script

Try to sbatch a script. **NOTE** not sure why but when you activated a conda env in login node, then activate it again in your sbatch script, you will get an error. Simply deactivate your conda env in login node then it will be fixed. Probably activate twice will cause problems. 

**Other problems**
Make sure you don't have package conflicts... you can for example use the command `conda list -n rl` to see what packages you have under the virtualenv rl. For instance if you found multiple numpy packages in your virtualenv (possibly one is install via pip, and the other is installed via conda), you might want to remove one of them (for instance, remove the one installed via conda). In this way it's less likely to get into problems with package conflict. Otherwise your program might don't know which one to use, and you can get into really funny errors.

