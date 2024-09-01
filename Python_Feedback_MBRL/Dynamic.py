import torch

class Dynamic(torch.nn.Module):
    def __init__(self, d_state, d_action, pi_inv):
        super(Dynamic, self).__init__()
        self.pi_inv = pi_inv
        self.sequential = torch.nn.Sequential(
            torch.nn.Linear(d_state + d_action, 32),
            torch.nn.ReLU(),
            torch.nn.Linear(32, 32),
            torch.nn.ReLU(),
            torch.nn.Linear(32, 32),
            torch.nn.ReLU(),
            torch.nn.Linear(32, 32),
            torch.nn.ReLU(),
            torch.nn.Linear(32, d_state)
        )

    def forward(self, X, A, T):
        A_transformed = self.pi_inv(A,T)
        XA = torch.cat([A_transformed, A], dim=1)
        dX = self.sequential(XA)
        return dX + X