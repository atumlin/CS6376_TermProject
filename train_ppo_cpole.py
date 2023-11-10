"""
Train agent with PPO using action masking in the CartPole-v0 environment.

Tuned Hyperparameters From : https://github.com/ray-project/ray/blob/master/rllib/tuned_examples/ppo/cartpole-ppo.yaml
"""
import ray
from ray.tune.logger import pretty_print
from ray.rllib.models import ModelCatalog
import ray.rllib.algorithms.ppo as ppo
from ray.rllib.utils.filter import MeanStdFilter
from ray import tune
import numpy as np
import argparse
import pickle
import os
from os.path import isdir, join, isfile
import gymnasium as gym
from utils import min_print


def get_args():
    """
    Parse the command arguments
    """
    # create the parser
    parser = argparse.ArgumentParser()
    # Add the arguments to be parsed
    parser.add_argument("--stop_reward", type=int, default=490, help="Stopping reward criteria for training")
    parser.add_argument("--num_eval_eps", type=int, default=20, help="Number of episodes to evaluate the trained agent on after training")
    parser.add_argument("--max_steps", type=int, default=1000, help="Max number of training steps during the training process")
    parser.add_argument("--seed", type=int, default=12, help="Training seed to set randomization for training")
    args = parser.parse_args()

    return args


def get_ppo_trainer(args= None):
    """ 
    Configure the ppo trainer based on training strategy
    """
    config = ppo.PPOConfig()
    config["env"] = "CartPole-v1"
    
    if args: 
        config['seed'] = args.seed
    
    trainer = ppo.PPO(config=config)
    return trainer, config["env_config"]


def final_evaluation(trainer, n_final_eval):
    """
    Evaluate a trained policy
    """
    env = gym.make("CartPole-v1")
    eval_rewards = []
    eval_time = []
    #
    # Evalute for n_final_eval episodes
    #
    for _ in range(n_final_eval):
        obs, _ = env.reset()
        r = 0
        steps = 0
        while True:
            action = trainer.compute_single_action(obs)
            obs, reward, terminated, truncated, _ = env.step(action)
            r += reward
            steps += 1
            if terminated or truncated:
                eval_rewards.append(r)
                eval_time.append(steps)
                break
    
    return np.mean(eval_rewards), np.mean(eval_time)


def main():
    #
    # Setup and seeds
    #
    args = get_args()
    ray.shutdown()
    ray.init()
    #
    # Set up trainer
    #
    trainer, env_config = get_ppo_trainer(args)
    #
    # Train
    #
    training_steps = 0      # tracks number of training steps
    ep_reward = []          # reward per episode
    avg_ep_reward = []      # average reward per episode for past 30 episodes
    while True:
        results = trainer.train()
        if (training_steps)%10 == 0:
            print("Training Step {} Results --------------".format(training_steps))
            print(min_print(results))
        ep_reward.append(results["episode_reward_mean"])
        avg_ep_reward.append(np.mean(ep_reward[-30:]))
        training_steps += 1
        if (avg_ep_reward[-1] >= args.stop_reward and training_steps >=30) or training_steps > args.max_steps:
            break
    #
    # save the trained agent
    #
    name = f"cartpole_ppo_masking_seed-{args.seed}"
    train_time = results["time_total_s"]
    checkpoint= trainer.save("./trained_agents/"+name)
    #
    # Evaluate 
    #
    print("Training Complete. Testing the trained agent ...\n")
    eval_reward, eval_time = final_evaluation(trainer, args.num_eval_eps)
    #
    # Print Values
    #
    print("Time to Train: ", train_time)
    print("\n-----Evaluation -------")
    print("Average Evaluation Reward: ", eval_reward)
    print("Average Rollout Episode Length: ", eval_time)
    print("\n\n\n\n")
    #
    # Save Training Data and Agent
    #
    data = {
        "train_time": train_time,
        "eval_reward": eval_reward,
        "eval_time": eval_time,
        "ep_reward": ep_reward,
        "avg_ep_reward": avg_ep_reward,
    }
    os.makedirs("results", exist_ok=True)
    with open('results/cpole_ppo_results.pkl', 'wb') as f:
        pickle.dump(data, f)
        

if __name__ == "__main__":
    main()
    
    
