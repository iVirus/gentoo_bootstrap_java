
package com.dowdandassociates.gentoo.bootstrap;

import com.amazonaws.services.ec2.model.Instance;
import com.amazonaws.services.ec2.model.Volume;

import com.google.common.base.Optional;

public class BootstrapInstanceInformation
{
    private Optional<Instance> instance;
    private Optional<Volume> volume;
    private Optional<String> device;

    public BootstrapInstanceInformation()
    {
        instance = Optional.absent();
        volume = Optional.absent();
        device = Optional.absent();
    }

    public Optional<Instance> getInstance()
    {
        return instance;
    }

    public void setInstance(Optional<Instance> instance)
    {
        if (null != instance)
        {
            this.instance = instance;
        }
        else
        {
            this.instance = Optional.absent();
        }
    }

    public BootstrapInstanceInformation withInstance(Optional<Instance> instance)
    {
        setInstance(instance);
        return this;
    }

    public Optional<Volume> getVolume()
    {
        return volume;
    }

    public void setVolume(Optional<Volume> volume)
    {
        if (null != volume)
        {
            this.volume = volume;
        }
        else
        {
            this.volume = Optional.absent();
        }
    }

    public BootstrapInstanceInformation withVolume(Optional<Volume> volume)
    {
        setVolume(volume);
        return this;
    }

    public Optional<String> getDevice()
    {
        return device;
    }

    public void setDevice(Optional<String> device)
    {
        if (null != device)
        {
            this.device = device;
        }
        else
        {
            this.device = Optional.absent();
        }
    }

    public BootstrapInstanceInformation withDevice(Optional<String> device)
    {
        setDevice(device);
        return this;
    }
}

