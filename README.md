# Training RL Agents (PPO) in CartPole-v1
This trains a PPO agent in CartPole-v1, saves the agent, evaluates the
agent for `--num_eval_eps` number of episodes and prints the evaluation
results.

## Installation
Run the following in a terminal: 
```
chmod +x setup.sh && ./setup.sh
```

## Running
Ex:
```
python train_ppo_cpole.py --max_steps 500
```