# Learning dynamic of environment

import torch

class Dynamic(torch.nn.Module):
    def __init__(self, d_state, d_action):
        super(Dynamic, self).__init__()
        self.fc1 = torch.nn.Linear(d_state + d_action, 32)
        self.fc2 = torch.nn.Linear(32, d_state)

    def forward(self, X, A):
        XA = torch.cat([X, A], dim=1)
        XA = torch.relu(self.fc1(XA))
        dX = self.fc2(XA)
        return dX + X