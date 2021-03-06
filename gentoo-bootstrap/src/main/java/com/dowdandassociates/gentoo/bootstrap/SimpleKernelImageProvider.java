/*
 *
 * SimpleKernelImageProvider.java
 *
 *-----------------------------------------------------------------------------
 * Copyright 2013 Dowd and Associates
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *-----------------------------------------------------------------------------
 *
 */

package com.dowdandassociates.gentoo.bootstrap;

import com.amazonaws.services.ec2.AmazonEC2;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

import com.google.inject.Inject;

import com.netflix.governator.annotations.Configuration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SimpleKernelImageProvider extends SimpleImageProvider
{
    private static Logger log = LoggerFactory.getLogger(SimpleKernelImageProvider.class);

    @Configuration("com.dowdandassociates.gentoo.bootstrap.KernelImage.imageId")
    private Supplier<String> imageId = Suppliers.ofInstance(null);

    @Inject
    public SimpleKernelImageProvider(AmazonEC2 ec2Client)
    {
        super(ec2Client);
    }

    @Override
    protected String getImageId()
    {
        return imageId.get();
    }
}

