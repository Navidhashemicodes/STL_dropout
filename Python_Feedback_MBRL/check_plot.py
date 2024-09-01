import torch
import numpy as np
from tqdm.auto import tqdm

# Assuming you have the following imports
from Dynamic import Dynamic
from Controller import Controller
from Controller_inv import Controller_inv
from Env import Env
import matplotlib.pyplot as plt


from formula_factory import FormulaFactory

from networks.neural_net_generator import generate_network

import pathlib

import torch.nn as nn
import re

import random



def evaluate_dynamic(dynamic, controller, oracle = True):
    # Checking compounding error
    if oracle:
        num_episodes = 10000
        episode_idx = random.randint(0, num_episodes)
    else:
        num_episodes = 1
        episode_idx = 0 
        
    X0 = 0.1*torch.rand(num_episodes, d_state)
    X0 = X0.to(device)
    
    
    
    X_pred = X0
    if oracle:
        X_oracle = X0
        X_oracles = []
        error = []
    
    
    X_preds = []
    
    
    dynamic.eval()
    with torch.no_grad():
        for t in range(H):
    
            X_preds.append(X_pred[episode_idx].cpu().numpy())
            vectorized_t = torch.ones(num_episodes, 1) * t / H
            vectorized_t = vectorized_t.to(device)
            if oracle:
                X_oracles.append(X_oracle[episode_idx].cpu().numpy())
                A1 = controller(X_oracle, vectorized_t)
                X_oracle = env.step(X_oracle, A1)
                X_pred = dynamic(X_pred, A1, vectorized_t)
                        
                error.append(torch.nn.functional.mse_loss(X_pred, X_oracle).item())
            else:
                A1 = controller(X_pred, vectorized_t)
                X_pred = dynamic(X_pred, A1, vectorized_t)
    
    if oracle:
        plt.plot(error)
        plt.show()
        X_oracles = np.array(X_oracles)
        plt.plot(X_oracles[:,0], X_oracles[:,1], label="oracle")
    
    # plot both trajectories
    X_preds = np.array(X_preds)
    plt.plot(X_preds[:,0], X_preds[:,1], label="pred")
    
    
    plt.plot([17, 19, 19, 17, 17], [16, 16, 17, 17, 16], 'r')  # First rectangle (red)
    plt.plot([3, 9, 9, 3, 3], [10, 10, 16, 16, 10], 'g')  # Second rectangle (green)
    plt.plot([15, 21, 21, 15, 15], [0, 0, 13, 13, 0], 'b')
    
    
    plt.legend()
    plt.show()
    
    if oracle:
        print("trajectory error: ", np.mean(error), "last step error: ", error[-1])
 
def load_controller(controller_name):
    controller = Controller(d_state, d_action).to(device)
    controller.load_state_dict(torch.load(controller_name))
    controller.eval()
    return controller

def load_dynamic(dyna_name):
    dyna = Dynamic(d_state, d_action, controller_inv).to(device)
    dyna.load_state_dict(torch.load(dyna_name))
    dyna.eval()
    return dyna

def load_controller_inv(controller_name):
    inv_controller = Controller_inv(d_state, d_action).to(device)
    inv_controller.load_state_dict(torch.load(controller_name))
    inv_controller.eval()
    return inv_controller




H = 1000  # horizon
d_state = 2
d_action = 2
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
env = Env(torch.tensor([0, 0], dtype=torch.float32).unsqueeze(0), H)
controller_inv = load_controller_inv("controller_inv.pth")
dynamic = load_dynamic("dynamic.pth")
controller = load_controller("satisficing_controller.pth") 
evaluate_dynamic(dynamic, controller, oracle = False)