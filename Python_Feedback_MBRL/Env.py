import numpy as np
import torch

class Env:
    def __init__(self, X_init, dt, H):
        self.X = X_init
        self.dt = dt
        self.H = H

    def step(self, X, A):

        # X : [B, 2]
        # A : [B, 2]
        # X_next : [B, 2]

        dy = A[:,0] * torch.sin(A[:,1]) * self.dt
        dx = A[:,0] * torch.cos(A[:,1]) * self.dt

        dX = torch.stack([dx, dy], dim=1)

        X_next = X + dX

        return X_next

    def reset(self):
        return torch.tensor([0, 0], dtype=torch.float32).unsqueeze(0)


if __name__ == "__main__":
    dt = 0.1
    H = 100 # horizon
    X0 = torch.tensor([0, 0], dtype=torch.float32).unsqueeze(0)
    env = Env(X0, dt, H)
    X_init = env.X

    for i in range(H):

        theta = np.pi/3
        V = 2

        A = torch.tensor([[V, theta]], dtype=torch.float32)
        X_next = env.step(env.X, A)
        env.X = X_next