# Verilog Arbiter

The original arbiter was written as part of a larger project. I thought that the code would be useful to me in the future for other projects so placed it here to more easily keep track of it.

The purpose behind the code is not to provide an arbiter that can be parametrized for use in any situation. Instead it is to have a simple but useful arbiter that can be easily read, understood and then rewritten to fit as needed.

## Description

A look ahead, round-robing parametrized arbiter. Each actor requesting the ownership of a shared resource will be granted that ownership in turn and in order. The time between the current actor releasing ownership (lowering its 'request' bit) and another actor being given that ownership should be one cycle (two at the most). This time between grants should not change even if the old 'current' and new 'current' actors are not in sequential order.

An optional timer module is also included so that each actors connection to the shared resource can be time limited.

## Signals

### request
Each bit is controlled by an actor and each actor can 'request' ownership of the shared resource by bring high its request bit.

### grant
When an actor has been given ownership of shared resource its 'grant' bit is driven high

### active
Is brought high by the arbiter when (any) actor has been given ownership of shared resource.
