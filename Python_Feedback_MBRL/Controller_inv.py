import torch

class Controller_inv(torch.nn.Module):
    def __init__(self, d_state, d_action):
        super(Controller_inv, self).__init__()
        self.fc1 = torch.nn.Linear(d_action+1, 32) # 1 for time
        self.fc2 = torch.nn.Linear(32, 32)
        self.fc3 = torch.nn.Linear(32, 32)
        self.fc4 = torch.nn.Linear(32, 32)
        self.fc5 = torch.nn.Linear(32, d_state)

    def forward(self, A,T):
        AT = torch.cat([A, T], dim=1)
        A1 = torch.relu(self.fc1(AT))
        A2 = torch.relu(self.fc2(A1))
        A3 = torch.relu(self.fc3(A2))
        A4 = torch.relu(self.fc4(A3))
        X = self.fc5(A4)
        return X
    