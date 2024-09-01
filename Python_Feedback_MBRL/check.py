import torch
from Dynamic import Dynamic
from Controller import Controller
from Controller_inv import Controller_inv
from formula_factory import FormulaFactory
from networks.neural_net_generator import generate_network



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
    print(X_grad)
    indices = X_grad.nonzero()
    print(indices)
    assert indices.shape[0] == X_preds.shape[0]
    indices = indices[:, 1]
    print(indices)
    X_preds.requires_grad = False
    my_grad  = X_grad[:,indices]
    print(my_grad)
    return robustness, indices, my_grad


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


H = 50
d_state = 2
d_action = 2
B = 1
approximation_beta = 200
detailed_str_mode = False

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

args = {'T': H+1, 'd_state': d_state, 'Batch': B, 'approximation_beta': approximation_beta, 'device': device, 'detailed_str_mode': detailed_str_mode}

FF = FormulaFactory(args)

p1 = FF.LinearPredicate(torch.tensor([1, 0]), -17)
p2 = FF.LinearPredicate(torch.tensor([-1, 0]), +19)
p3 = FF.LinearPredicate(torch.tensor([0, 1]), -16)
p4 = FF.LinearPredicate(torch.tensor([0, -1]), +17)

p5 = FF.LinearPredicate(torch.tensor([1, 0]), -3)
p6 = FF.LinearPredicate(torch.tensor([-1, 0]), +9)
p7 = FF.LinearPredicate(torch.tensor([0, 1]), -10)
p8 = FF.LinearPredicate(torch.tensor([0, -1]), +16)

p9 = FF.LinearPredicate(torch.tensor([1, 0]), -15)
p10 = FF.LinearPredicate(torch.tensor([-1, 0]), +21)
p11 = FF.LinearPredicate(torch.tensor([0, 1]), 0)
p12 = FF.LinearPredicate(torch.tensor([0, -1]), +13)

formula = FF.And([
    FF.F(
        FF.And([
            p1, p2, p3, p4
        ])
    , H-10, H),
    FF.G(
        FF.Or([
            p5, p6, p7, p8
        ])
    , 0, H),
    FF.G(
    FF.Or([
        p9, p10, p11, p12
    ])
    , 0, H)
])

neural_net = generate_network(formula, approximate = False)

controller = load_controller("controller.pth")

X0 = 0.1*torch.rand(B, d_state)
X0 = X0.to(device)

controller_inv = load_controller_inv("controller_inv.pth")


dynamic = Dynamic(d_state, d_action, controller_inv).to(device)

X_preds = get_trajectory_surrogate(dynamic, controller, X0, H)
robustness, indices = get_robustness(X_preds, neural_net, return_critical_indices = True)

print(indices)