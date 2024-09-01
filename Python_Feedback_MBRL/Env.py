# import numpy as np
import torch

class Env:
    def __init__(self, X_init, H):
        self.X = X_init
        self.H = H

    def step(self, X, A):
        x_now = X[:, 0]
        y_now = X[:, 1]
        
        u1 = A[:, 0]
        u2 = A[:, 1]
        
        k = 0.0001
        x_next = x_now + 0.1*(u1 *y_now* torch.exp( -k* (x_now**2 + y_now**2)  )   )
        y_next = y_now + 0.1*(u2 *x_now* torch.exp( -k* (x_now**2 + y_now**2)  )   )

        X_next = torch.stack([x_next, y_next], dim=1)

        return X_next

    def reset(self):
        return torch.tensor([0, 0], dtype=torch.float32).unsqueeze(0)

