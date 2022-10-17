# Elemento Power Meter
EPM is a set of utilities and routines to estimate the power draw of linux systems.
Typically the set of dependencies is intended to be as small as possible.
We are trying to stick as much as possible to built in tols and routines.


## CPU power
We pursued two approaches which are equivalent.
Both are aimed at getting the CPU energy integral in two moments spread by 0.5s.
The power is computed via the following pseudocode:

```
t0_energy=read_energy()
wait for 0.5s
t1_energy=read_energy()

power=(t1_energy - t0_energy)/0.5
```

> **Warning**
> EPM currently supports only single-socket systems

### Via `lm_sensors`
It requires installing the `lm_sensors` package [link](https://wiki.archlinux.org/title/lm_sensors).

After installation a sensors detection is required through `sensors detect`.
The values are returned in Joules and handled accordingly.

See [the implementation here](./cpu-power.sh).

### Via `sysfs` and `intel-rapl`
It uses `intel-rapl` intefraces through `sysfs` [link](https://web.eece.maine.edu/~vweaver/projects/rapl/).

It works out of the box, returning values in uJoules.

See [the implementation here](./cpu-rapl-power.sh).


## RAM power
RAM power consumption is not depending on the RAM load, but rather on the techology.
As a reference, here are the typical consumptions for RAM modules on different DDR versions:

<center>
| **Type** | **Voltage** | **Power draw** |
|----------|-------------|----------------|
| DDR1     | 2.5V        | 5.5W           |
| DDR2     | 1.8V        | 4.5W           |
| DDR3     | 1.5V        | 3W             |
| DDR4     | 1.2V        | 3W             |
| DDR5     | 1.1V        | 2.4W           |
</center>

(from [link](https://www.buildcomputers.net/power-consumption-of-pc-components.html))

Since every stick of ECC memory has an additional memory chip for parity every 8 chips, we sum and additional 12.5% to the reference value for ECC sticks.

The RAM power draw is fixed and is not changing in time in our approach.

We use a mix of `strace` and `dmidecode` routines to detect the number of RAM sticks and the presence of ECC technologies.
See [the implementation here](./ram-power.sh).

## NVMe power
NVMe power consuption is mainly dependant on the NVMe device power state.
According to [the NVMexpress consortium](https://nvmexpress.org/resources/nvm-express-technology-features/nvme-technology-power-features/) the reference rating for different power states are:

<center>
| **Power state** | **Max power draw** |
|-----------------|--------------------|
| 0               | 25W                |
| 1               | 18W                |
| 2               | 18W                |
| 3               | 15W                |
| 4               | 10W                |
| 5               | 8W                 |
| 6               | 5W                 |
</center>

The enumeration of NVMe devices is obtained using the `nvme` command line utility.
The detection of the power state a device is in can be done using the same utility via `nvme get-feature <device_path_or_id> -f 2`.

The power state can cahnge over time, therefore this module must be considered time-variable.
