from google.adk.agents import Agent
from .utils import load_env, load_config, load_prompt
load_env()

config = load_config()
agent_config = config['agents']['schema_designer']
instruction = load_prompt(agent_config['prompt_file'])

root_agent = Agent(
    name=agent_config['name'],
    description=agent_config['description'],
    tools=agent_config['tools'],
    model=agent_config['model'],
    instruction=instruction
)