"""
Utils for training RL agent
"""

import json
import yaml
from ray.tune.utils.util import SafeFallbackEncoder

def min_print(result):
    """ 
    Print results for each training step.
    """
    result = result.copy()
    info_keys = [
        'episode_len_mean', 
        'episode_reward_max', 
        'episode_reward_mean',
        'episode_reward_min'
            ]
    out = {}
    for k, v in result.items():
        if k in info_keys:
            out[k] = v

    cleaned = json.dumps(out, cls=SafeFallbackEncoder)
    return yaml.safe_dump(json.loads(cleaned), default_flow_style=False)