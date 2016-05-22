# amd-ds: Data Science using AMD GPU Deep Learning: Setup Python + Caffe/XGBoost + OpenCL + 1.7x RAM #

If you are here I guess it is because you wanted to do deep learning using OpenCL and you searched/tried for days/weeks/months/years to have a working setup.

I spent time to find all the correct pre-requirements and all the needed stuff for Deep Learning on a hybrid AMD GPU: 150 hours or so (spread over 1 year).

The easiest solution was using DeepCL (installs on Windows, installs on Linux without issues... very nice interface overall), but clearly the OpenCL Caffe version is about 50x(?) faster for convolutions, which is what we usually need overall.

Why not using R? Because if you are here for using the best of your computer, R is a (massive) disaster when it comes to speed/computing. You should prefer Python, but you can install R+XGBoost if needed. Compilation of XGBoost for R is not working for unknown reasons, don't ask me why I tried about 700 automated different configurations to get it (still) not working.

What's a convolution? Example, I assume you got it how optimizations are required for such thing:

```

for (i in 1:n) {

  for (j in 1:n) {
  
    for (k in 1:n) {
    
      for (l in 1:n) {
      
        for (m in 1:n) {
        
          ...
          
        }
        
      }
      
    }
    
  }
  
}

```

Confirmed working on:
* Ubuntu 14.04 flavors
* Elementary OS 0.32 (Ubuntu 14.04)

Do not use Ubuntu 16.04 flavors, not working appropriately.

Compilation problems? Set ~/.bashrc according to the end of this page.

Installation prompts when creating .deb packages so you can reinstall QUICKLY...? Answer the following in order:
  
* Documentation: n
* Changes: Enter
* Install: Enter
* Stuff out of place: n
* Ignore stuff out of place: y

Installation works but using the library/package fails? Use the command provided after checkinstall to uninstall properly!

* Do not try with Python 3.5, it causes errors
* Do NOT install Anaconda before, it causes compilation issues that are barely solvable
* Do NOT install anything else before compiling Caffe, it causes errors randomly
* ALWAYS use a fresh machine
* It is not super optimized for maximum speed (e.g OpenCV pre-compiled for OpenCL<2, etc.)
* Change all "laurae-linux" to $HOME or to your user username in Linux
* Something not working? Reboot and retry, it takes only 20 seconds. Still not working? Check missing dependencies with the error messages.
* Want to apply .bashrc immediately without rebooting/relaunching a terminal? Use the following: source ~/.bashrc
* Got a permission error? Prepend the command with the following: sudo
* Wanna use R for xgboost? You are out of luck, I never managed to compile it correctly:
* error: unable to load shared object '/usr/local/lib/R/site-library/xgboost/libs/xgboost.so': /usr/local/lib/R/site-library/xgboost/libs/xgboost.so: undefined symbol: _ZN7xgboost4data10SparsePage6Writer5AllocEPSt10unique_ptrIS1_St14default_deleteIS1_EE
* Not happy without the bleeding edge xgboost R? Use Windows because it works perfectly there...
* If you really need xgboost in Linux+R, use the typical online R package on CRAN
* DO NOT CLEAN UP ALL THE FOLDERS AFTER, OR YOU WILL KILL REQUIRED DEPENDENCIES. ADJUST THE SCRIPT IF YOU WANT TO PUT THE FILES ELSEWHERE.
* REMEMBER TO SWITCH YOUR GPU TO AMD (if you use hybrid graphics) IF YOU INTEND TO RUN Caffe ON GPU: YOU WILL RUN ON CPU OTHERWISE!!!

# There are manual steps!!! Check out all the comments every time #
