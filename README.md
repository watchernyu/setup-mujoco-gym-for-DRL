# This is a repo made specifically to help NYU Shanghai DRL group students to set up hpc environments.

To set up mujoco environment on the hpc cluster, simply follow the instructions here. The procedure here is also very useful for setting up mujoco on your personal machine. This guide has been tested extensively on our hpc (centOS), ubuntu, and mac, and a few windows. (Still lacking windows support)

If you are in NYU NY, the procedure should still be very similar. Our current supported version is not the newest version. But you still might find useful debugging info here. 

To submit a job on hpc, check out
sample_hpc_script.sh

# Instructions to set up mujoco and torch on your hpc 
This is a guide on setting up mujoco environments for hpc (can also use for set up on personal ubuntu machines, just ignore the hpc related things.)

*Please pay special attention to places with the word **NOTE**, that's where things can go wrong easily.*  
Last updated Sep 28, 2019. The installation can take anywhere from 2 hours to 2 weeks. If you get stuck try ask people in the group.

# Python package version notice
Currently support: pytorch 1.2(stable), do not use 0.4, please update your pytorch, gym 0.12.0, mujoco-py 1.50.1.68.
For gym and mujoco-py use git's checkout command to get currect versions. 

**NOTE** if you don't know git, virtualenv, how to use a terminal, you should first have a quick search for these to have some basic ideas, before you proceed. 

**NOTE** for the hpc part, if you already have your own anaconda (miniconda) installed in hpc, it will likely cause a path conflict with the anaconda module of hpc. If you encountered such weird problem, you can try fix it... or (if you can't fix it) just delete everything you have with your own miniconda and start use the anaconda hpc module. 

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
module load cuda/9.0 glfw/3.3 gcc/7.3 mesa/19.0.5 llvm/7.0.1
```

set up a virtual environment with the command (call it 'rl' or whatever, and use 3.6 for less trouble), if you never used virtualenv, try spend 10 min search for what that is  
```
conda create -n rl python=3.6
source activate rl 
```
Note that in some machines you might need to use `conda activate rl` instead. If your source activate doesn't work. 

**NOTE**: For all of the following, you should be inside your rl virtualenv. (you want to install python libraries into your rl virtualenv, not somewhere else.)

**NOTE** for mac you might run into issues related to gcc, install brew then install gcc might solve that. For windows esiest way is to use Anaconda prompt. 

1.Install gym
1.1 Install gym related dependencies: (here I mean you need to go and read the gym requirements in this page and install them, if you skip this step there is no guarantee you will succeed in the next steps.)
https://github.com/openai/gym

1.2 Install gym, download gym github repo and install minimum, according to gym doc. Use git checkout to get correct version. 
```
git clone https://github.com/openai/gym.git
cd gym
git checkout a4adef2
pip install -e .
```

2. Install mujoco-py
2.1 Install mujoco-py, with the correct way. **NOTE**: other ways of installing mujoco-py often fail, please use this method. First download the repo and install (remember to install in your virtualenv):
```
git clone https://github.com/openai/mujoco-py
cd mujoco-py
git checkout 498b451
pip install -e . --no-cache
```

2.2 Enter the mujoco-py folder and install mujoco-py dependencies. Or refer to mujoco-py repo for details. (you need to actually go the repo and read stuff, dependencies won't install themselves for you.) https://github.com/openai/mujoco-py
```
cd mujoco-py
pip install -r requirements.txt
pip install -r requirements.dev.txt
```

2.3 test if mujoco-py installed correctly, first enter `python`:
```
python
```
inside python, simply run:
```
import mujoco_py
```

2.4 Some **mac** users will run into gcc error. First check your gcc version: `gcc --version`. gcc-6 is the version that works. gcc-4 and gcc-7 seem to fail (not sure why gcc 7 works on linux but fails on mac??). Now check if you have a gcc-6, if not you need to install via brew. Even if you have one, it might not be your default gcc. Now you want to make that your default gcc. Create a symbolic link so that your gcc points to gcc-6. Here is a tutorial on how symbolic link works: https://www.youtube.com/watch?v=-edTHKZdkjo start from 4:25. Basically the command is something similar to:  
```
cd /usr/local/bin
ln -s gcc-6 gcc
```
There are other fixes but this one seems to be easy.

2.5 sometimes you get module not found error while the package is there, or other weird python error, refer to last part of this page on multiple package installation conflict.

3. Get mujoco
3.1 create .mujoco folder under your home:
```
cd ~ 
mkdir .mujoco
```
and put mjpro150 folder (download it from their website) into this folder also put in your liscense (use school liscence).  
**NOTE**: THE HPC IS RUNNING LINUX SYSTEM, MEANING IF YOU USE MAC/WINDOWS, YOU CANNOT JUST COPY YOUR MUJOCO BINARY (MAC/WINDOWS VERSION) INTO THE HPC MACHINES. Instead, you should download the linux version of mujoco binary from the mujoco website on your machine and then transfer to hpc using Filezella, or download it from mujoco website to hpc directly, using sth like wget.  


4. 
add additional library path line to .bashrc, (if it's on your own computer this step will be different, your path will not be the hpc path, you can just try create a mujoco env in python, then it will give an error, follow the instrustion with the error to add path. In that case you can do step 5 first, then do step 4.)
you can just run the following command to do this (or you can just try import mujoco_py in python and follow the mujoco_py error message.):  
`echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/gpfsnyu/home/NETID/.mujoco/mjpro150/bin' >> ~/.bashrc`  
**NOTE**: `NETID` should be your netid, please change that part. **NOTE** that you should use single quotation marks `'`, don't use double quotation, otherwise the line added to your .bashrc will be different. 

5. 
now you want to get back to the gym folder and install mujoco (after you set up mujoco files and stuff)
```
cd gym
pip install -e '.[mujoco]'
```
note in windows you might want to use `pip install -e .[mujoco]` instead. 

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
 
run the following command to get an interactive shell with cpu. **NOTE** Before you do it **deactivate** the rl environment (for some reason if you are in a virtualenv and then you enter a new node there will be problem.) After you `source deactive`, run the following command:
```
srun -p aquila --pty --mem  500 -t 0-01:00 bash
```
This will let you enter a new shell, on a compute node in the aquila partition  

Test your mujoco_py in this interactive shell. Load anaconda3, test mujoco by running python and import mujoco_py, and then try make a InvertedPendulum-v2 env. If everything works, then mujoco is good to go. If you miss any system packages use `module avail` to see if hpc has that, then use `module load` to load it. 

9. Testing with hpc script

Try to sbatch a script. **NOTE** not sure why but when you activated a conda env in login node, then activate it again in your sbatch script, you will get an error. Simply deactivate your conda env in login node then it will be fixed. Probably activate twice will cause problems. **NOTE** So before you `sbatch` a hpc script, make sure you **deactivate** the rl environment. When you submit a job you are starting a new process. If you look at the sample hpc script you can see that once it starts to run, it will load modules and activate the virtual env. 

**Other problems**
python package conflict (common for those who install things into existing virtual env): 

Make sure you don't have package conflicts... you can for example use the command `conda list -n rl` to see what packages you have under the virtualenv rl. For instance if you found multiple numpy packages in your virtualenv (possibly one is install via pip, and the other is installed via conda), you might want to remove one of them (for instance, remove the one installed via conda). In this way it's less likely to get into problems with package conflict. Otherwise your program might don't know which one to use, and you can get into really funny errors. Now sometimes the virtual env is really messed up, you might want to do **multiple** pip uninstall and conda uninstall for a certain package (uninstall for once might not work), after several uninstallations, you should see a message saying skipping uninstall because package not found. That's when you can install the package again. 

In rare cases, package conflict can lead to weird errors such as not being able to import many packages, or segment fault in submitting job to hpc. Upon such bugs, systematically try to find where the problem is, for example, first try run python, do hello world, or import some library, and submit hpc job with your base environment, then try the same thing but with your virtualenv. After locating the problem, for example if the problem only occurs in your virtual env, try find potential package conflict, or remove your env and install again. 

cached package problems, sometimes you cannot install a package, or find a weird not zip error when doing pip install. Try install with the `--no-cache` flag. This will disable cached package files, and will fix your install if you happen to cached some corrupted files before. 

If you spell things wrong, they won't work. 
