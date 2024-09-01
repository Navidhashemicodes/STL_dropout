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





def estimate_lipschitz_constant(controller, d_state, num_samples=1000, norm_type=2, device='cpu'):

    max_ratio = 0.0

    for _ in range(num_samples):

        x1 = torch.rand(1,d_state).to(device)
        x2 = torch.rand(1,d_state).to(device)
        
        time_ratio = torch.rand(1,1)
        y1 = controller(x1,time_ratio)
        y2 = controller(x2,time_ratio)
        
        
        input_norm = torch.norm(x1 - x2, p=norm_type)
        output_norm = torch.norm(y1 - y2, p=norm_type)

        if input_norm.item() != 0:  # Avoid division by zero
            ratio = output_norm / input_norm
            max_ratio = max(max_ratio, ratio.item())

    return max_ratio



def load_model_from_pth(file_path):
    """
    Load a model from a .pth file without prior knowledge of its architecture.

    Args:
        file_path (str): Path to the .pth file.

    Returns:
        nn.Module: The model with weights loaded.
    """
    # Load the state dictionary
    state_dict = torch.load(file_path)

    class AutoNN(nn.Module):
        def __init__(self, state_dict):
            super(AutoNN, self).__init__()
            self.layers = nn.ModuleList()
            self.layer_shapes = {}
            
            # Extract layers from state_dict keys
            for key in state_dict.keys():
                if 'weight' in key:
                    # Attempt to extract layer index and dimensions
                    match = re.match(r'(\d+)\.', key)
                    if match:
                        layer_index = int(match.group(1))
                        in_features, out_features = state_dict[key].shape
                        
                        # Create a new layer if necessary
                        while len(self.layers) <= layer_index:
                            # Assume fully connected layers by default
                            self.layers.append(nn.Linear(in_features, out_features))
                        
                        # Store layer shapes for later use
                        self.layer_shapes[layer_index] = (in_features, out_features)
                        
            self._initialize_layers(state_dict)

        def _initialize_layers(self, state_dict):
            for key, value in state_dict.items():
                if 'weight' in key or 'bias' in key:
                    match = re.match(r'(\d+)\.', key)
                    if match:
                        layer_index = int(match.group(1))
                        name = 'weight' if 'weight' in key else 'bias'
                        
                        # Set weights or biases for the layer
                        if hasattr(self.layers[layer_index], name):
                            setattr(self.layers[layer_index], name, value)
                    else:
                        print(f"Warning: Key '{key}' did not match expected pattern and was ignored.")

        def forward(self, x):
            for layer in self.layers:
                x = layer(x)
            return x

    # Instantiate the model
    model = AutoNN(state_dict)
    
    # Set the model to evaluation mode
    model.eval()
    
    return model



def save_params(controller, controller_name):
    torch.save(controller.state_dict(), controller_name)
    
    
def load_controller(controller_name):
    controller = Controller(d_state, d_action).to(device)
    controller.load_state_dict(torch.load(controller_name))
    controller.eval()
    return controller
    
def load_controller_inv(controller_name):
    inv_controller = Controller_inv(d_state, d_action).to(device)
    inv_controller.load_state_dict(torch.load(controller_name))
    inv_controller.eval()
    return inv_controller

def load_dynamic(dyna_name):
    dyna = Dynamic(d_state, d_action, controller_inv).to(device)
    dyna.load_state_dict(torch.load(dyna_name))
    dyna.eval()
    return dyna


def get_trajectory(controller, X0, H):
    X0 = X0.to(device)
    X_oracle = X0
    X_oracles = []

    with torch.no_grad():
        for t in range(H):
            X_oracles.append(X_oracle.cpu())

            vectorized_t = torch.ones(X0.shape[0], 1) * t / H
            vectorized_t = vectorized_t.to(device)
            A = controller(X_oracle, vectorized_t)
            
            X_oracle = env.step(X_oracle, A)

    X_oracles.append(X_oracle.cpu())
    X_oracles = torch.stack(X_oracles, dim=1)

    return X_oracles

def get_trajectory_surrogate(dynamic, controller, X0, H):
    
    X0 = X0.to(device)
    X_pred = X0
    X_preds = []

    with torch.no_grad():
        for t in range(H):
            X_preds.append(X_pred.cpu())

            vectorized_t = torch.ones(X0.shape[0], 1) * t / H
            vectorized_t = vectorized_t.to(device)
            A = controller(X_pred, vectorized_t)
            
            X_pred = dynamic(X_pred, A, vectorized_t)

    X_preds.append(X_pred.cpu())
    X_preds = torch.stack(X_preds, dim=1)

    return X_preds


def plot_example(controller, X_init, H, num_episodes):
    
    Traj = []
    episode_idx = 1
    X_orc = X_init
    with torch.no_grad():
        for t in range(H):

            Traj.append(X_orc[episode_idx].cpu().numpy())
        
            vectorized_t = torch.ones(num_episodes, 1) * t / H
            vectorized_t = vectorized_t.to(device)
            A = controller(X_orc, vectorized_t)
        
            X_orc = env.step(X_orc, A)
        
        
    Traj = np.array(Traj);
    
    plt.plot(Traj[:,0], Traj[:,1])
    # plt.ylim(0, 10)
    # plt.xlim(0, 10)
    plt.legend()
    plt.show()

def train_controller_inv(controller_inv, controller, lam, N, num_episodes, epochs):
    
    
    X0 = 0.1*torch.rand(num_episodes, d_state)
    X0 = X0.to(device)
    X_oracles = X0
    Traj = []
    As = []
    Times = []
    
    for t in range(H):
        Traj.append(X_oracles)
        vectorized_t = torch.ones(num_episodes, 1) * t / H
        vectorized_t = vectorized_t.to(device)
        Times.append( vectorized_t )
        A = controller(X_oracles, vectorized_t)
        As.append( A )
        X_oracles = env.step(X_oracles, A)
    Traj.append(X_oracles)
    
    # accumulate a trajectory and train the dynamic model using backpropagation through time
    optimizer = torch.optim.Adam(controller_inv.parameters(), lr=1e-3)
    
    
    for e in tqdm(range(epochs)):
        
        X_pred = Traj[0]
        loss = 0
        
        controller_inv.train()

        t_samples = torch.randperm(H)[:N]
        t_samples = torch.sort(t_samples)[0]
        for t in t_samples:
        
            vectorized_t = Times[t]
            A = As[t]
            X_oracle  = Traj[t]
            
            with torch.no_grad():
                X_oracle_before = X_oracle.clone()
                AA = A.clone()
            X_pred = controller_inv(AA,vectorized_t)
            loss += torch.nn.functional.mse_loss(X_pred, X_oracle_before)
                
        
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        
        
        ##### bound the Lipstchitz constant 
        
        for layer in controller_inv.children():
            scale = max(1,np.linalg.norm(layer.weight.data,2)/lam)
            layer.weight.data = layer.weight.data/scale

        ###################################
        
        # Report the loss every 50 epochs
        if (e + 1) % 50 == 0:
            print(f"Epoch [{e + 1}/{epochs}], Loss: {loss.item()/N:.6f}")





def train_dynamic_model(dynamic, controller, lam, num_episodes = 128, epochs = 500):

        
    X0 = 0.1*torch.rand(num_episodes, d_state)
    X0 = X0.to(device)
    X_oracles = X0
    Traj = []
    As = []
    Times = []
    
    for t in range(H):
        Traj.append(X_oracles)
        vectorized_t = torch.ones(num_episodes, 1) * t / H
        vectorized_t = vectorized_t.to(device)
        Times.append( vectorized_t )
        A = controller(X_oracles, vectorized_t)
        As.append( A )
        X_oracles = env.step(X_oracles, A)
    Traj.append(X_oracles)
    
    
    for param in dynamic.pi_inv.parameters():
        param.requires_grad = False
        
    optimizer = torch.optim.Adam(dynamic.sequential.parameters(), lr=1e-3)
    
    
    for e in tqdm(range(epochs)):

        X_pred = Traj[0]
        loss = 0
        
        dynamic.train()
            
        for t in range(H):
        
            
            vectorized_t = Times[t]
            A = As[t]
            X_oracle = Traj[t+1]            
            
            with torch.no_grad():
                AA = A.clone()
                

            X_pred = dynamic(X_pred, AA, vectorized_t)
            
            loss += torch.nn.functional.mse_loss(X_pred, X_oracle)
           
            
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()   
        
        ##### bound the Lipstchitz constant 

        num_layers = int((len(dynamic.sequential)-1)/2)
        for c in range(num_layers+1):
            scale = max(1,np.linalg.norm(dynamic.sequential[2*c].weight.data,2)/lam)
            dynamic.sequential[2*c].weight.data = dynamic.sequential[2*c].weight.data/scale
        ###################################
        
        
        # Report the loss every 50 epochs
        if (e + 1) % 50 == 0:
            print(f"Epoch [{e + 1}/{epochs}], Loss: {loss.item()/H:.6f}")


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
  
    
def get_robustness(X_preds, neural_net, return_critical_indices = False):
    if return_critical_indices:
        X_preds.requires_grad = True
        X_preds.grad = None
    # start = time.time()
    robustness = neural_net(X_preds)
    
    if not return_critical_indices:
        return robustness
    
    robustness.mean().backward()
    X_grad = X_preds.grad
    indices = X_grad.nonzero()
    assert indices.shape[0] == X_preds.shape[0]
    indices = indices[:, 1]
    X_preds.requires_grad = False
    my_grad  = X_grad[:,indices]
    return robustness, indices, my_grad


def get_derivative_soft(X_preds, neural_net_soft):
    
    X_preds.requires_grad = True
    X_preds.grad = None
    robustness = neural_net_soft(X_preds)
        
    robustness.mean().backward()
    X_grad = X_preds.grad
    X_preds.requires_grad = False
    return X_grad

    
def train_controller(controller, dynamic, STL_Neural_Net_acc, STL_Neural_Net_soft, N = 10, sample_size = 1000, num_episodes = 500, epochs = 500, N1 = 20, N2 = 3, epsilon = 1e-5, epsilon_smooth = 1e-5):
    
    optimizer = torch.optim.Adam(controller.parameters(), lr=1e-1)
    
    X0s = torch.rand(sample_size, d_state)
    X0s = X0s.to(device)
    
    s = 0

    for e in range(epochs):
        
        indices = torch.randint(0, sample_size, (num_episodes,))
        
        X0 = X0s[indices]
        
        with torch.no_grad():
            X_preds = get_trajectory_surrogate(dynamic, controller, X0, H)
        
        robustness = get_robustness(X_preds, STL_Neural_Net_acc, return_critical_indices = False)
        
        # find min and argmin of robustness
        min_robustness, index = torch.min(robustness, dim=0)
        print(min_robustness)


        if min_robustness > 0:
            s = s + 1
            if s > 5:
                break
        else:
            s = 0

        
        X0 = X0[index].unsqueeze(0)
        
        params_1 = controller.state_dict()
        
        for i in range(N1):
            
            with torch.no_grad():
                X_preds = get_trajectory_surrogate(dynamic, controller, X0, H)
            
            robustness, indices, my_grad = get_robustness(X_preds, STL_Neural_Net_acc, return_critical_indices = True)
            index = indices[0]
            
            lower_bound = int(N * 0.8)
            upper_bound = int(N * 1.2)

            N_rand = torch.randint(lower_bound, upper_bound + 1, (1,)).item()
            
            #### you need to take care of one time-step before, because it will use the controller and give us the state that we are targetting
            if N_rand >= index-1:
                t_samples = torch.arange(0, index)
            else:
                t_samples = torch.randperm(index-1)[:N_rand].sort().values

                t_samples = t_samples[(t_samples != index-1)]

                t_samples = torch.cat([t_samples, torch.tensor([index-1])])
        
            
            X = X0.clone()
            Xgs = []
            #### make it certain 0 is included in trajectory even if it is not in t_samples
            Xgs.append(X)
            for t in range(index):
                vectorized_t = torch.ones(1, 1) * t / H
                vectorized_t = vectorized_t.to(device)
                
                A = controller(X, vectorized_t)
                if t in t_samples:
                    X = dynamic(X, A, vectorized_t)
                    
                else:
                    with torch.no_grad():
                        AA = A.clone()
                    X = dynamic(X, AA, vectorized_t)
                                
            my_state = X.squeeze(0)
            with torch.no_grad():
                my_grad = my_grad.clone()
            the_grad = my_grad.squeeze(0)
            robi = - torch.matmul( the_grad , my_state) 
            
            optimizer.zero_grad()
            robi.backward()
            optimizer.step()
        
        if robustness < min_robustness:
            scale = 1
            continue_ = True
            
            params_2 = controller.state_dict()
            
            params_1_list = list(params_1.values())
            params_2_list = list(params_2.values())
            diff_list = [  (s - j).view(1,-1)   for s,j  in zip(params_1_list , params_2_list)]
            diff_val = torch.cat(diff_list, dim=1)
            
            while(continue_):
                # inf norm
                norm_diff = torch.norm( diff_val, p = float('inf')) / scale
                if norm_diff > epsilon:
                    scale = scale * 2
                    theparams = params_1 + (params_2 - params_1) / scale
                    controller.load_state_dict(theparams)
                    
                    with torch.no_grad():
                        X_preds = get_trajectory_surrogate(dynamic, controller, X0, H)
                        robustness = get_robustness(X_preds, STL_Neural_Net_acc, return_critical_indices = False)     
                    
                    if robustness > min_robustness:
                        continue_ = False
                else:
                    print("soft robustness utilization started")
                    
                    for i in range(N1):
                        
                        Traj = get_trajectory_surrogate(dynamic, controller, X0, H)
                        X_grads = get_derivative_soft(Traj, STL_Neural_Net_soft)
                        X_grads.requires_grad = False
                        l2_norms = torch.norm(X_grads, dim=-1)
                        mask = l2_norms > epsilon_smooth
                        indices = mask.nonzero(as_tuple=False)
                        indices = indices[:,1]
                        robi = 0
                        
                        t_samples = torch.randperm(indices[-1])[:N_rand].sort().values

                        t_samples = t_samples[~torch.isin(t_samples, indices)]

                        t_samples = torch.cat([t_samples, indices]).sort().values
                        
                        
                        X = X0.clone()
                        for t in range(t_samples[-1]):
                            
                            vectorized_t = torch.ones(1, 1) * t / H
                            vectorized_t = vectorized_t.to(device)
                            
                            A = controller(X, vectorized_t)
                            if t in t_samples:
                                X = dynamic(X, A, vectorized_t)
                                
                            else:
                                with torch.no_grad():
                                    AA = A.clone()
                                X = dynamic(X, AA, vectorized_t)
                                            
                            if t in t_samples :
                                my_state = X.squeeze(0)
                                my_grad = X_grads[:,t].squeeze(0)                                
                                robi = robi - torch.matmul( my_grad , my_state ) 
                        optimizer.zero_grad()
                        robi.backward()
                        optimizer.step()
                    
                    continue_ = False
                    print("soft robusteness utilization done!!")
                    
                    
                   
def generate_time_samples(H, K):

    TH = torch.arange(1, H + 1)  # Exclude 0
    th = []
    
    while True:
        if K>= len(TH):
            th.append( TH  )
            break
        else:
            selected_indices = torch.randperm(len(TH))[:K]
            th_i = TH[selected_indices].sort().values
            th.append(  th_i )  
            TH = TH[~torch.isin(TH, th_i)]
            
    return th


def generate_index_samples(TH, K):

    th = []
    
    while True:
        if K>= len(TH):
            th.append(TH)
            break
        else:
            selected_indices = torch.randperm(len(TH))[:K]
            th_i = TH[selected_indices].sort().values
            th.append(   th_i   )
            TH = TH[~torch.isin(TH, th_i)]
            
    return th




H = 1000  # horizon
d_state = 2
d_action = 2

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")


env = Env(torch.tensor([0, 0], dtype=torch.float32).unsqueeze(0), H)
# controller = Controller(d_state, d_action).to(device)
# save_params(controller, "controller.pth")
controller = load_controller("controller.pth")



# c_lam = estimate_lipschitz_constant(controller, d_state = d_state, num_samples=10000, norm_type=2, device='cpu')
# print(c_lam)

num_episodes = 10
X0 = 0.1*torch.rand(num_episodes, d_state)
X0 = X0.to(device)
plot_example(controller , X0 , H, num_episodes)

# controller_inv = Controller_inv(d_state, d_action).to(device)

for param in controller.parameters():
    param.requires_grad = False

# train_controller_inv(controller_inv, controller, lam = 1.5/c_lam, N = 20, num_episodes = 500, epochs = 10000)
# save_params(controller_inv, "controller_inv.pth")
controller_inv = load_controller_inv("controller_inv.pth")


for param in controller_inv.parameters():
    param.requires_grad = False
# dynamic = Dynamic(d_state, d_action, controller_inv).to(device)

# train_dynamic_model(dynamic, controller, lam =4, num_episodes = 500, epochs = 1000)

# save_params(dynamic, "dynamic.pth")
dynamic = load_dynamic("dynamic.pth")


evaluate_dynamic(dynamic, controller, oracle = True)


for param in controller.parameters():
    param.requires_grad = True


# num_episodes = 1
# beta = 15
# detailed_str_mode = False

# args = {'T': H+1, 'd_state': d_state, 'Batch': num_episodes, 'approximation_beta': beta, 'device': device, 'detailed_str_mode': detailed_str_mode}

# FF = FormulaFactory(args)

# p1 = FF.LinearPredicate(torch.tensor([1, 0]), -17)
# p2 = FF.LinearPredicate(torch.tensor([-1, 0]), +19)
# p3 = FF.LinearPredicate(torch.tensor([0, 1]), -16)
# p4 = FF.LinearPredicate(torch.tensor([0, -1]), +17)

# p5 = FF.LinearPredicate(torch.tensor([1, 0]), -3)
# p6 = FF.LinearPredicate(torch.tensor([-1, 0]), +9)
# p7 = FF.LinearPredicate(torch.tensor([0, 1]), -10)
# p8 = FF.LinearPredicate(torch.tensor([0, -1]), +16)

# p9 = FF.LinearPredicate(torch.tensor([1, 0]), -15)
# p10 = FF.LinearPredicate(torch.tensor([-1, 0]), +21)
# p11 = FF.LinearPredicate(torch.tensor([0, 1]), 0)
# p12 = FF.LinearPredicate(torch.tensor([0, -1]), +13)



# formula = FF.And([
#     FF.F(
#         FF.And([
#             p1, p2, p3, p4
#         ])
#     , H-10, H),
#     FF.G(
#         FF.Or([
#             p5, p6, p7, p8
#         ])
#     , 0, H),
#     FF.G(
#     FF.Or([
#         p9, p10, p11, p12
#     ])
#     , 0, H)
# ])

# neural_net_acc = generate_network(formula, approximate=False)
# neural_net_soft = generate_network(formula, approximate=True , beta=15)

# RP_dir = str (pathlib.Path().resolve())

# # save_params(neural_net_acc, "acc.pth")
# Path = RP_dir + '\\acc.pth'
# neural_net_acc = load_model_from_pth(Path)
# # save_params(neural_net_soft, "soft.pth")
# Path = RP_dir + '\\soft.pth'
# neural_net_soft = load_model_from_pth(Path)

# freeze the network
# for param in neural_net_acc.parameters():
#     param.requires_grad = False
# for param in neural_net_soft.parameters():
#     param.requires_grad = False

# train_controller(controller, dynamic, neural_net_acc, neural_net_soft, N = 10, sample_size = 1000, num_episodes = 50, epochs = 500, N1 = 20, N2 = 3, epsilon = 1e-5, epsilon_smooth = 1e-5)

# save_params(controller, "satisficing_controller.pth")
controller = load_controller("satisficing_controller.pth")

evaluate_dynamic(dynamic, controller, oracle = False)
evaluate_dynamic(dynamic, controller, oracle = True)