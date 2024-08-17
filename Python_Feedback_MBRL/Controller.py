import torch

class Controller(torch.nn.Module):
    def __init__(self, d_state, d_action):
        super(Controller, self).__init__()
        self.fc1 = torch.nn.Linear(d_state + 1, 32) # 1 for time
        self.fc2 = torch.nn.Linear(32, 32)
        self.fc3 = torch.nn.Linear(32, d_action)

    def forward(self, X, T):
        XT = torch.cat([X, T], dim=1)
        XT = torch.relu(self.fc1(XT))
        XT = torch.relu(self.fc2(XT))
        A = self.fc3(XT)
        return A * 10
