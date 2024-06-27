# vehFuncs MTA SA

- [✔] Pop-up Headlights Function
- [✔] Gear - Spinning Function
- [✔] Shake Function
- [❌] Variable Wheels


This is a ongoing project for a open-source resource for MTA:SA wherein it exports realistic functions for vehicles, this is a port of [vehFuncs GTA SA](https://github.com/JuniorDjjr/VehFuncs/tree/master) to MTA SA.
The existing functions from the vehFuncs of GTA SA will be reused on this resource, the repository is public so you can contribute if you wanted to!

## Component Name Conflicts
MTA uses the component name as a key, which means that no two components can share the same name. This can cause issues with many models available on the web.

### How to Fix It?
This can be resolved by renaming the components adding a number at the beginning of each name.

For example, if you have two components named f_gear_mu_3.5, you should rename them as follows:
- 0f_gear_mu_3.5
- 1f_gear_mu_3.5

By making this change, we ensure that MTA correctly detects all components.

### Tool for Renaming
To streamline this process, you can use [RW Analyze](http://steve-m.com/downloads/tools/rwanalyze/), a tool that helps to make these changes effectively.
