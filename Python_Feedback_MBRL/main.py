import torch
import numpy as np
from tqdm.auto import tqdm

from Dynamic import Dynamic
from Controller import Controller
from Env import Env

dt = 0.1
H = 100 # horizon
d_state = 2
d_action = 2

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

env = Env(torch.tensor([0, 0], dtype=torch.float32).unsqueeze(0), dt, H)
dynamic = Dynamic(d_state, d_action).to(device)
controller = Controller(d_state, d_action).to(device)

Dataset = []

# Phase 1: Pure exploration

num_episodes = 20000
# Generate random X_random with size num_episodes * d_state from uniform distribution
X_random = torch.rand(num_episodes, d_state) * 20 - 10

V_random = torch.rand(num_episodes, 1) * 4 - 2
theta_random = torch.rand(num_episodes, 1) * 2 * np.pi

A_random = torch.cat([V_random, theta_random], dim=1)
X_next = env.step(X_random, A_random)

Dataset = torch.cat([X_random, A_random, X_next], dim=1)

# train dynamic using Dataset

train_data, test_data = Dataset[:int(0.8 * num_episodes)], Dataset[int(0.8 * num_episodes):]

train_loader = torch.utils.data.DataLoader(train_data, batch_size=64, shuffle=True)
test_loader = torch.utils.data.DataLoader(test_data, batch_size=64, shuffle=False)

optimizer = torch.optim.Adam(dynamic.parameters(), lr=1e-3)



losses_train = []
losses_test = []

for epoch in tqdm (range(100)):
    loss_train = 0
    size_train = 0

    for i, data in enumerate(train_loader):
        X, A, X_next = data[:,:d_state], data[:,d_state:d_state+d_action], data[:,d_state+d_action:]
        X, A, X_next = X.to(device), A.to(device), X_next.to(device)

        optimizer.zero_grad()
        X_next_pred = dynamic(X, A)
        loss = torch.nn.functional.mse_loss(X_next_pred, X_next)
        loss.backward()
        optimizer.step()
        loss_train += loss.item()
        size_train += len(X)

    loss_test = 0
    size_test = 0
    with torch.no_grad():
        for i, data in enumerate(test_loader):
            X, A, X_next = data[:,:d_state], data[:,d_state:d_state+d_action], data[:,d_state+d_action:]
            X, A, X_next = X.to(device), A.to(device), X_next.to(device)
            X_next_pred = dynamic(X, A)
            loss = torch.nn.functional.mse_loss(X_next_pred, X_next)
            loss_test += loss.item()
            size_test += len(X)

    print(f"Epoch {epoch}, loss_train: {loss_train/size_train}, loss_test: {loss_test/size_test}")
    losses_train.append(loss_train/size_train)
    losses_test.append(loss_test/size_test)

import matplotlib.pyplot as plt
plt.plot(losses_train, label="train")
plt.plot(losses_test, label="test")
plt.legend()
plt.show()

# Checking compounding error

num_episodes = 1000
X0 = torch.rand(num_episodes, d_state) * 0.1

X_pred = X0
X_oracle = X0

error = []

with torch.no_grad():
    for t in range(H):
        vectorized_t = torch.ones(num_episodes, 1) * t / H
        A = controller(X_oracle, vectorized_t)

        X_oracle = env.step(X_oracle, A)
        X_pred = dynamic(X_pred, A)

        error.append(torch.nn.functional.mse_loss(X_pred, X_oracle).item())


plt.plot(error)
plt.show()
